function dH_dt_ = GDL_ODE_MODELA_simple(t_, H_, L0, kstar, consts)
% This model is equivalent to model B but has extra factors of L0 and
% different constants.

    M_H2O = 55.5/L0;    % standard water concentration
    K_W = 1E-14;    % Equilibrium const for water
    K_W_tilde = K_W/55.5^2;
    K_tilde = 2.35E-6; % Equilibrium const for GDL with H2O concentrations

    % Determine non-dimensional reaction rate coefficients, functions of pH
    pH = -log10(H_(1)*L0);
    phi_0 = (10^(consts(1) * pH + consts(2)))/kstar;          % Non-dimensionalized reaction coeff = k0/kstar
    phi_1 = (10^(consts(3) * pH + consts(4)))/kstar;          % Non-dimensionalized reaction coeff = k1/kstar
    phi_W = 1E-2; %1E-3 is best
   
    %OH-
    dH_dt_(2) = phi_W * L0*(M_H2O^2 - H_(1)*H_(2)/K_W_tilde);
    
    %H3O+
    dH_dt_(1) = phi_1*( ...
        (1 - exp(-phi_0 * t_) - H_(1) + sqrt(K_W)/L0)*L0*M_H2O ...
        - H_(1)*(L0*H_(1) - sqrt(K_W))/K_tilde ...
        ) + dH_dt_(2);
     
    dH_dt_ = dH_dt_';
end
