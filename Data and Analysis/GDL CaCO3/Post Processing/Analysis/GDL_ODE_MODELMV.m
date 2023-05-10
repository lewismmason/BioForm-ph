function dx_dt_ = GDL_ODE_MODELMV(t_, x_, x0_, L0, kstar, consts)
% New model that includes the L1,4 component. This does not include H2O
% balance in the stoichiometry

% x_(1), x_(2), x_(3), x_(4), x_(5), x_(6), x_(7), x_(8), x_(9)
% H3O_ , Ca_  , L15_ , L14_ ,CaCO3_, AH_  , A_   , OH_  , CO2_ 

    K_W = 1E-14;        % Equilibrium const for water
    K12 = 0.93;     % from ROSS PARROTT 
    K13 = 3.92;     % ^
    K23 = 4.22;     % ^ 
    K34 = 3.98E-4;  % ^

    % This is used for determining the consts values, overwrite if un-needed
    a12 = consts(1);
    b12 = consts(2);
    a13 = consts(3);
    b13 = consts(4);
    a23 = consts(5);
    b23 = consts(6);

    % reaction rate between L14 and L15 given by takahashi 1969 in D2O
    pH = -log10(x_(1)*L0);

%     pH_star = (pH - 0.41)/0.929;        % pH_star is the pH reading in D2O using H2O calibrated pH meter. Required(?) for takahashi 1969  
%     phi12 = 10^(pH_star)*10^(-7.95)/kstar/60;   %L14 to L15, derived from takahashi 1969
%     phi13 = 10^(pH_star/1.3)*10^(-5.95)/kstar/60;
%     phi23 = 10^(-pH_star/4)*10^(-1.6)/kstar/60;

    phi12 = 10^(pH*a12)*10^(-b12)/kstar;
    phi13 = 10^(pH*a13)*10^(-b13)/kstar;
    phi23 = 10^(-pH*a23)*10^(-b23)/kstar;

    % pH independent constants, should also be determined numerically
    phi34 = 1E0;   % HA to H+ and G-
    phi45 = 1E6;   % H+ and CaCO3 to Ca2+
    phi_W = 1E2;  % Water dissociation rate

    % Rate equations, neglects H2O effects
    r23_ = phi23*(x_(3)-x_(6)/K23);
    r12_ = phi12*(x_(4)-x_(3)/K12);
    r13_ = phi13*(x_(4)-x_(6)/K13);
    r34_ = phi34*(x_(6)-L0*x_(1)*x_(7)/K34);
    r45_ = phi45*L0^2*x_(1)^2*x_(5);
    rw_   = phi_W/L0*(1-x_(1)*x_(8)*L0^2/K_W);

    % ODE's for other variables, neglects H2O effects
    dx_dt_(1) = r34_ - 2*r45_ + rw_;    %H3O
    dx_dt_(2) = r45_;                   % Ca
    dx_dt_(3) = -r23_ + r12_;           % L15_
    dx_dt_(4) = -r12_ - r13_;           % L14_
    dx_dt_(5) = -r45_;                  % CaCO3
    dx_dt_(6) = r23_ + r13_ - r34_;     % AH_
    dx_dt_(7) = r34_;                   % A
    dx_dt_(8) = rw_;                    % OH
    dx_dt_(9) = r45_;                   % CO2
    % dx_dt_(10) = ;                    % H2O

    dx_dt_ = dx_dt_'; % flip into the correct form
end
