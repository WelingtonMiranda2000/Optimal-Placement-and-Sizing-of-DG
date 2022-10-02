% Load base case parameters 
clc;
clear;
params;
define_constants;
nBus=mpc.bus(end,1);


%  Runs power flow to get initial power losses and voltage profile
iniResults=runpf(mpc,mpoption('verbose',0,'pf.alg','PQSUM','out.all',0));

iniLoss=sum(real(get_losses(iniResults)));

fprintf(" x1 | x2 | y1 | y2 | Losses(kW) | VDI | FO\n");
%Setup PSO parameters
nvars=nDg*2; %Num of Variables(2*num DG).. Optimize both location and size
lb=zeros(1,nvars); %Define lower bound
lb(1:nDg)=2; %Lower bound of location is 2, 1 is feederbus
lb(nDg+1:2*nDg)=dgMin; %Lower bound of Size defined by user
ub=zeros(1,nvars); %%Define upper bound
ub(1:nDg)=nBus; %Upper bound of location is the last bus (33 or 69)
ub(nDg+1:2*nDg)=dgMax; %Upper bound of Size defined by user
% PSO Settings
% Visit <https://www.mathworks.com/help/gads/particleswarm.html> for more info
options = optimoptions('particleswarm','PlotFcn',@pswplotbestf);
obj_func=@(x)objectives(x,mpc,iniLoss,lossWeight,voltageWeight,PD,QD,VM,dgPf); %Chama FO 
rng default  % For reproducibility
[x,fval,exitflag,output] = particleswarm(obj_func,nvars,lb,ub,options);
x(1:nDg)=round(x(1:nDg)); % Apply integer condition for location


%Place the DG with optimal size and location into the system 
for i=1:nDg
    mpc.bus(x(i),PD)=mpc.bus(i,PD)-x(nDg+i)*dgPf/1000; 
    mpc.bus(x(i),QD)=mpc.bus(i,QD)-x(nDg+i)*(sqrt(1-dgPf*dgPf))/1000;
end

% Runs power flow after optimal DG sizing and placement 
results=runpf(mpc,mpoption('verbose',0,'pf.alg','PQSUM','out.all',0));

%Display results ********************************************************
display("Resultados ótimos encontrados : ");
display('Bus No     Size(kVA)');
display([x(1:nDg)', x(nDg+1:nvars)']);
fprintf("\n Losses before DG placement (KW): %f",iniLoss*1000);
fprintf("\n Losses after DG placement (KW): %f",sum(real(get_losses(results)))*1000);

%Plot results ********************************************************
figure(2);
plot(iniResults.bus(:,VM),'red');
hold on;
plot(results.bus(:,VM),'blue');
hold off;
title('Perfil de tensão do sistema');
xlabel('Barras') ;
ylabel('Tensão [p.u]') ;
legend('Perfil de tensão inicial','Após alocação de GDs');

figure(3);
losses=[sum(real(get_losses(iniResults))); sum(real(get_losses(results)))]*1000;
legends=categorical({'Perdas iniciais', 'Após alocação de GDs'});
legends = reordercats(legends,{'Perdas iniciais', 'Após alocação de GDs'});
bar(legends,losses);
title('Perdas totais de potência ativa (kW)');

figure(4);
losses=[sum(imag(get_losses(iniResults))),sum(imag(get_losses(results)))]*1000;
legends=categorical({'Perdas iniciais', 'Após alocação de GDs'});
legends = reordercats(legends,{'Perdas iniciais', 'Após alocação de GDs'});
bar(legends,losses,'g');
title('Perdas totais de potência reativa (kVAR)');

% Optional plot...........
% figure(4)
% iniLoss= real(get_losses(iniResults))*1000;
% loss = real(get_losses(results));
% losses=[iniLoss,loss];
% bar(losses);
% title('Perdas por linha (KW)');
% legend("Sem GDs","Após alocação de GDs");