% SET THE PARAMETERS YOU WANT TO OPTIMIZE.
nDg=3; % Num of DG to be placed in the system 
mpc=loadcase('case33');% matpower case file for power flow ('case33' for 33 bus system 'case69' for 69 bus system)
dgMax= 5000  %Maximum power of DG to be placed in the system (kVA)
dgMin= 100  %Minimum power of DG to be placed in the system (kVA)
dgPf=.85; % Power Factor of DGs


% %PSO Parameters (If you want to specify a certain number of particles)
%swarmSize=500; % Num of particles in the swarm; 'SwarmSize',swarmSize

%Objective Function Parameters
voltageWeight=0.5; % Voltage weight  
lossWeight=0.5; % Loss weight (Sum of weights must be 1)