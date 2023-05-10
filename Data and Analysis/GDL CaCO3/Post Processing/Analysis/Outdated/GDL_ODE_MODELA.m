function dx_dt_ = GDL_ODE_MODELA(t_, x_, x0_, L0, kstar, consts)
% Full model A

% x_(1), x_(2), x_(3), x_(4), x_(5), x_(6), x_(7), x_(8), x_(9)
% H3O_ , Ca_  , L_   ,CaCO3_, AH_  , A_   , OH_  , CO2_ , H2O_
% ODE  , ODE  , expr , expr , expr , ODE  , ODE  , expr , expr  -> refers
% to whether there is an ODE or an algebraiec expression for the given
% variable

    a1_polyvals = [-0.014733476385289,-0.544909619813664];
    a2_polyvals = [0.251854595006216,-0.007411878498766];
    b1_polyvals = [0.214980521597120,-2.555893315280687];
    b2_polyvals = [1.221119504088706,-3.212928846947438];

    % This is used for determining the consts values, overwrite if un-needed
    a1 = consts(1);
    b1 = consts(2);
    a2 = consts(3);
    b2 = consts(4);

    a1 = polyval(a1_polyvals, L0);
    b1 = polyval(b1_polyvals, L0);
    a2 = polyval(a2_polyvals, L0);
    b2 = polyval(b2_polyvals, L0);

    K_W = 1E-14;        % Equilibrium const for water
    K_tilde = 2.35E-6; % Equilibrium const for GDL with H2O concentrations considered
    K_W_tilde = K_W/55.5^2;

    % Determine non-dimensional reaction rate coefficients, functions of pH
    pH = -log10(x_(1)*L0);
    phi_0 = (10^(a1 * pH + b1))/kstar;          % Non-dimensionalized reaction coeff = k0/kstar
    phi_1 = (10^(a2 * pH + b2))/kstar;          % Non-dimensionalized reaction coeff = k1/kstar
    phi_3 = 0.068/kstar;
    phi_W = 1E-2; %Just needs to be much larger than O(1E-5)
 
    % Algebraiec expressions
    dx_dt_(3) = 0;  % L_
    x_(3)     = exp(-phi_0 * t_);

    dx_dt_(5) = 0;  % AH_
    x_(5)     = 1 - x_(3) - x_(6) + x0_(5);

    dx_dt_(8) = 0;  % CO2
    x_(8)     = x_(2) - x0_(2);

    dx_dt_(4) = 0;  % CaCO3
    x_(4)     = x0_(4) + x0_(2) - x_(2);

%     if t_ > 100 
%         val = 30/100/L0
%         x_(4) = val;
%         x0_(4) = val;
%     end

    dx_dt_(9) = 0;  % H2O
    x_(9)     = x0_(9) + x0_(1) - x_(1) + x0_(7) - x_(7) + x0_(2) - x_(2) + x_(3) - 1;

    % ODE's
    dx_dt_(7) = phi_W * L0*(x_(9)^2 - x_(1)*x_(7)/K_W_tilde);         % OH
    dx_dt_(2) = L0^2*phi_3*x_(4)*x_(1)^2;                      % Ca
    dx_dt_(6) = phi_1 * L0 *(x_(5)*x_(9) - x_(1)*x_(6)/K_tilde); % A
    dx_dt_(1) = dx_dt_(6) + dx_dt_(7) - 2*dx_dt_(2);              %H3O

    dx_dt_ = dx_dt_'; % flip into the correct form
end
