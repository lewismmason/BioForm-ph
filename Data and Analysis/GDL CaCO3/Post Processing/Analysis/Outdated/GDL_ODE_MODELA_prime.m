function dx_dt_ = GDL_ODE_MODELA_prime(t_, x_, x0_, L0, kstar, consts)
% Full model A, should be identical to GDL_ODE_MODELA but returns all
% concs.

% x_(1), x_(2), x_(3), x_(4), x_(5), x_(6), x_(7), x_(8), x_(9)
% H3O_ , Ca_  , L_   ,CaCO3_, AH_  , A_   , OH_  , CO2_ , H2O_

    K_W = 1E-14;        % Equilibrium const for water
    K_tilde = 2.7E-6; % Equilibrium const for GDL with H2O concentrations considered
    K_W_tilde = K_W/55.5^2;

    a1_polyvals = [-0.369462932823406,-0.298425420001217];
    a2_polyvals = [0.075094410304989,-0.445173203861528];
    b1_polyvals = [1.737066594407775,-3.313328059284631];
    b2_polyvals = [3.220722585614909,-0.977285155491300];

    % This is used for determining the consts values, overwrite if un-needed
    a1 = consts(1);
%     b1 = consts(2);
%     c1 = consts(3);
    a2 = consts(2);
%     b2 = consts(4);
%     c2 = consts(6);
%     a3 = consts(5);
%     b3 = consts(6);

%     a1 = polyval(a1_polyvals, L0);
%     b1 = polyval(b1_polyvals, L0);
%     a2 = polyval(a2_polyvals, L0);
%     b2 = polyval(b2_polyvals, L0);

    % Determine non-dimensional reaction rate coefficients, functions of pH
    pH = -log10(x_(1)*L0);
    pOH = -log10(x_(7)*L0);

%     phi_0 = (10^(a1*pH + b1))/kstar;          % Non-dimensionalized reaction coeff = k0/kstar
%     phi_0 = (10^(b1)*(x_(1)*L0)^(-a1) )/kstar;%+ 10^(b1)*(x_(7)*L0)^(-a1))/kstar;
%     phi_0 = (10^(a1*pH + b1) + 10^(c1) + 10^(a2*pOH + b2))/kstar;          % Non-dimensionalized reaction coeff = k0/kstar
%     phi_0 = 1E-4;
    phi_0 = 10^(a1)/kstar;
%     phi_1 = (10^(a2*pH + b2))/kstar;          % Non-dimensionalized reaction coeff = k1/kstar
%     phi_1 = (10^(b2)*(x_(1)*L0)^(-a2) )/kstar;          % Non-dimensionalized reaction coeff = k1/kstar
    phi_1 = 10^(a2)/kstar; % Made this intsantaneous 
%     phi_3 = 0.068/kstar;
    phi_3 = 1E9;
    phi_W = 1E-2; %Just needs to be much larger than O(1E-5)

    % Rate equations
    r0_     = phi_0 * x_(3);
    r1r2_   = phi_1*L0*(x_(5)*x_(9) - x_(1)*x_(6)/K_tilde);
    r3_     = phi_3*L0^2*x_(4)*x_(1)^2;         % not necessarily correct
%     r3_     = phi_3*L0*x_(4)*abs(x_(1));           % This is garbage
    rwprwm_ = phi_W*L0*(x_(9)^2 - x_(7)*x_(1)/K_W_tilde);

    % ODE's for other variables
    dx_dt_(1) = r1r2_ - 2*r3_ + rwprwm_;%H3O
    dx_dt_(2) = r3_;                    % Ca
    dx_dt_(3) = -r0_;                   % L_
    dx_dt_(4) = -r3_;                   % CaCO3
    dx_dt_(5) = r0_ - r1r2_;            % AH_
    dx_dt_(6) = r1r2_;                  % A
    dx_dt_(7) = rwprwm_;                % OH
    dx_dt_(8) = r3_;                    % CO2
    dx_dt_(9) = -r0_ - r1r2_ + 3*r3_ - 2*rwprwm_;  % H2O

    dx_dt_ = dx_dt_'; % flip into the correct form
end
