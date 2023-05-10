CaCO3mm = 100.089;

% Initial conditions for ODE, this is just called so I only have to change
% IC's in one spot
x0_ = zeros(1,9);
H3O0_experimental = 1.57E-8;
K_W = 1E-14;
x0_(1) = H3O0_experimental/L0;  % Initial H_0 given by experiments
x0_(3) = L0/L0;
x0_(8) = K_W/H3O0_experimental/L0;
x0_(6) = 0/1000000;         % Set initial AH to a very small value
% x0_(e) = 50/(CaCO3mm)/VH2O/L0;