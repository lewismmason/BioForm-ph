% Outdated. Does not use model b

% This script determines the concentration equilibrium constant for a GDL
% reaction.

% The data do determine K_L with
to_show = ['GDLwt5_0-CaCO3wt0_0-LONG'];
GDL_conc_rsq_tol = [[50, 0.995]];
start_times = [54.2392];

% Initial concentrations of L, H2O, and H
mLo = 50;
mH2Oo = 1000;

% Begin calculations
Lo = mLo/178.14;
H2Oo = mH2Oo/18.0151;

Ho = 0;
GH4o = 0;

GDL_conc_rsq_tol(:, 1) = GDL_conc_rsq_tol(:, 1)./1000;
GDL_conc = GDL_conc_rsq_tol(:,1);
rsq_tol  = GDL_conc_rsq_tol(:,2);       % un-used

fpass   = 1E-20;

% For loop un-necessary, was just copy pasted
for j = 1:size(to_show,1)
    [t_, pH_, t, pH ] = pH_clip_start(to_show(j,:), fpass, start_times(j));

    H_ = 10.^-pH_;
    [envHigh, envLow] = envelope(H_, 1000, 'peak');
    envMean = (envHigh + envLow)/2;

    H_inf = mean(envMean(end-1000:end));

    plot(t_, H_, t_, envMean, t_, ones(length(t_),1)*H_inf);
    hold on
end

% Using my equations solve for KL
syms KL;
syms H;

eqn1 = H == H_inf;
eqn2 = 0 == H^2*(1-1/KL)-H*(Lo + H2Oo + Ho*(2-1/KL)) + Lo*H2Oo + Ho*(Lo + H2Oo + Ho);

soln = solve(eqn1,eqn2, KL, H);
KL = eval(soln.KL(soln.KL > 0));
disp(KL)

title('GDL curves')
xlabel('t');
ylabel('[H+] in mol/L')
legend(to_show)

