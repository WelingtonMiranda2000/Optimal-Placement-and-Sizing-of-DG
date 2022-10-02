
function y = objectives(x,mpc,iniLoss,lossWeight,voltageWeight,PD,QD,VM,dgPf)  
    nDg=numel(x)/2;
    x(1:nDg)=round(x(1:nDg)); %Apply integer condition for DG placement
    % Place the DG with optimal size and location into the system
    for i=1:nDg
        mpc.bus(x(i),PD)=mpc.bus(i,PD)-x(nDg+i)*dgPf/1000; 
        mpc.bus(x(i),QD)=mpc.bus(i,QD)-x(nDg+i)*(sqrt(1-dgPf*dgPf))/1000;   
    end

    % Runs power flow after optimal DG sizing and placement
    results=runpf(mpc,mpoption('verbose',0,'pf.alg','PQSUM','out.all',0));

    % Objective Function
  
    %Calculate mean squared error to 1 pu magnitude
    vmag=results.bus(:,VM);%Voltage magnitude of all bars 
    vmag=vmag-1; %Calculate error for all bars 
    vmag=vmag.*vmag; %Square the error 
    vobjective=sum(vmag)/numel(vmag);%Obtain mean squared error (Voltage Deviation Index)

    %Calculate active power losses
    loss=sum(real(get_losses(results)));
    lobjective=loss/iniLoss; %Ratio of losses with DG/ Losses without DG(Losses index)
    
    %Calculate Objective Function combining voltage deviation and losses index 
    y=lossWeight*lobjective+voltageWeight*vobjective;
    fprintf("%f |",x); 
    fprintf("%f |", lobjective*iniLoss*1000);
    fprintf("%f |", vobjective);
    fprintf("%f\n", y);
    
end
