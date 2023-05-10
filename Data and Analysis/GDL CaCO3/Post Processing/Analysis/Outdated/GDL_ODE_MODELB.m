function dH_dt_ = GDL_ODE_MODELB(t_, H_, L0, kstar, consts)
% GDL_ODE_prime is the ODE forward stepper based on "model B". This model
% uses non-dimensionalized variables. Note that kstar is user chosen
% characteristic reaction rate constant

% Inputs:
%   t_: tbar is the non-dimenionalized time whose form and values are solved
%   using this= t*kstar
%   H_: Hbar is the non-dimensionalized hydrogen conc = H/L0
%   L0: initial GDL concentration
%   kstar: characteristic reaction rate constant
%   consts: constants defining phi_i, 

% Outputs:
%   dH_dt_: self explanatory.

    K_W = 1E-14;    % Equilibrium const for water
    K = 1.32E-4; % Equilibrium const for GDL

    % Determine non-dimensional reaction rate coefficients, functions of pH
    pH = -log10(H_(1)*L0);
    phi_0 = (10^(consts(1) * pH + consts(2)))/kstar;          % Non-dimensionalized reaction coeff = k0/kstar
    phi_1 = (10^(consts(3) * pH + consts(4)))/kstar;          % Non-dimensionalized reaction coeff = k1/kstar
    phi_W = 5E4;

    dH_dt_(2) = phi_W * (55.5 - H_(1)*H_(2)*L0/K_W);

    dH_dt_(1) = phi_1*( ...
        1 - exp(-phi_0 * t_) - H_(1) + sqrt(K_W)/L0 ...
        - H_(1)*(L0*H_(1) - sqrt(K_W))/K ...
        ) + dH_dt_(2);
     
    dH_dt_ = dH_dt_';
end
