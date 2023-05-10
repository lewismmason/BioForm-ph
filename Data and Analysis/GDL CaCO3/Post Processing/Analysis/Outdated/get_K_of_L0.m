% L m/mol
Lmm = 178.14;

% Initial GDL mass in grams
mL0  = [ 5.9949
        5.0053
        3.9974
        2.9949
        2.0014
        1.0023];

% in mL of water, or mass of water in grams
H2Of    = [ 76
            76
            76
            76
            76
            76]; % same for all samples

H2Of = H2Of / 1000;

L0 = mL0./H2Of/Lmm; % initial concentration in mol/L

% Final pH taken from 'transient_data_descending_order.csv'
pHf     = [ 2.13377
            2.1603
            2.2156
            2.26644
            2.34605
            2.50905
];

K_W = 10^-14;
Hf = 10.^(-pHf);
Hfbar = Hf./L0;

AH0_ = 2/1000000;

H0 = 1.57E-8;
% Model B equilibrium constant
KAH = Hfbar.*(L0 .* Hfbar - H0)./(1 - Hfbar + H0./L0);

% Model A equilibrium constant
M_H2O = 55.5./L0;
K_tilde = Hfbar.*(Hfbar - H0./L0)./((1 - Hfbar + H0./L0 + AH0_).*M_H2O);

% plot(mL0, KAH, mL0, K_tilde)
plot( mL0, K_tilde)
hold on
grid on
