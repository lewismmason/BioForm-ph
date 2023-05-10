function out = ODE_forward_func(L0, consts)
% This script solves the GDL ODE for a given time frame with user specified
% initial conditions

K_W = 1E-14;
CaCO3_t = 103;
mix_t = 2;
t_end = 1000;

% User entered params
kstar = 1;
% tspanmix = [0 mix_t]*kstar;
tspan = [0 CaCO3_t]*kstar;
tspan2 = [CaCO3_t t_end]*kstar;
tspantotal = [0 t_end]*kstar;
VH2O = 1000; % volume in mL

Lmm = 178.14;
VH2O = VH2O/1000; % Initial L H2O


% Model A IC's
mult_L0 = 1;
% L0 = mult_L0*L0;
ODE_ICs;    % Initialize IC's
x0_(3) = x0_(3)*mult_L0;

% % mixing
% [tA_, x_] = ode15s(@(tA_,x_) GDL_ODE_MODELA_prime(tA_,x_, x0_, L0, kstar, consts), tspanmix, x0_);
% % dHdt = gradient(x_(:,1)) ./ gradient(tA_(:));
% % plot(tA_/kstar,dHdt(:,1)*L0)
% plot(tA_/kstar,x_(:,1)*L0)
% % plot(tA_/kstar,x_(:,1)*L0)%,tA_/kstar,x_(:,2)*L0)%, tA_/kstar, x_(:,3)*L0)
% % plot(tA_/kstar, x_(:,3)*L0)
% hold on
% grid on
% drawnow;

% L0 = L0/mult_L0;
% x0_ = x_(end,:);
% x0_(3) = L0/L0%x0_(3)/mult_L0; 

[tA_, x_] = ode15s(@(tA_,x_) GDL_ODE_MODELA_prime(tA_,x_, x0_, L0, kstar, consts), tspan, x0_);
% dHdt = gradient(x_(:,1)) ./ gradient(tA_(:));
% plot(tA_/kstar,dHdt(:,1)*L0)
plot(tA_/kstar,x_(:,1)*L0)
% plot(tA_/kstar,x_(:,1)*L0)%,tA_/kstar,x_(:,2)*L0)%, tA_/kstar, x_(:,3)*L0)
% plot(tA_/kstar, x_(:,3)*L0)
hold on
grid on
drawnow;

x0_ = x_(end,:);
CaCO3mm = 100.0869;
x0_(4) = 0/(CaCO3mm)/VH2O/L0;

[tA_, x_] = ode15s(@(tA_,x_) GDL_ODE_MODELA_prime(tA_,x_, x0_, L0, kstar, consts), tspan2, x0_);
plot(tA_/kstar,x_(:,1)*L0)
drawnow;
% plot(tA_/kstar,x_(:,1)*L0,tA_/kstar,x_(:,2)*L0)%, tA_/kstar, x_(:,3)*L0)
% plot(tA_/kstar, x_(:,3)*L0)
% hold on
% grid on
% drawnow;


end

