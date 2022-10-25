# Optimal-Placement-and-Sizing-of-DG
MatLab code using PSO (Particle Swarm Optimization) to minimize power losses and voltage deviation by optimally placing and sizing DG

This project used particleswarm package https://www.mathworks.com/help/gads/particleswarm.html for PSO implementation
and MATPOWER https://matpower.org/ for Power Flow implementation

In order to use this code, please cite: 

ABNT ( Brazilian Association of Technical Standards)

MIRANDA, Welington. Alocação e dimensionamento ótimos de unidades de geração distribuída utilizando otimização por enxame de partículas para redução de perdas técnicas e manutenção dos níveis de tensões adequados em redes de distribuição. 2022. 75 f. Trabalho Final de Graduação-Instituto de Sistemas Elétricos e Energia, Universidade Federal de Itajubá, Itajubá, 2022.

*** INSTRUCTIONS
1 -  params.m is where the inputs are defined in order to run the code (this step is necessary);
2 - objectives.m includes the objective function which is to minimize power loss and voltage deviation by optimally placing the DGs;
3- main.m is the main file, it contains functions to call out the PSO (Global Optimization ToolBox) and the POWER SUMMATION POWER FLOW METHOD (MATPOWER);
