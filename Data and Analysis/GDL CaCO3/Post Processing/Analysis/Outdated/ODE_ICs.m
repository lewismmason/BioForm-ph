CaCO3mm = 100.089;

% Model A IC's
x0_ = zeros(1,9);
H3O0_experimental = 1.57E-8;
x0_(1) = H3O0_experimental/L0;  % Initial H_0 given by experiments
x0_(3) = L0/L0;
x0_(7) = K_W/H3O0_experimental/L0;
x0_(5) = 0/1000000;         % Set initial AH to a very small value
x0_(9) = 55.5/L0;
% x0_(4) = 50/(CaCO3mm)/VH2O/L0;