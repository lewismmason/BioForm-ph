% This script will plot n different GDL pH experiments on the same plot
% with times of reaction starts lined up, provided they are in my format.
% (pH_data_collector.py for format). It then finds the equations for the
% production of hydrogen ions

% List of files to plot, must be in CWD since I'm lazy
to_show = [
    'GDLwt0_1-RPM500';
    %'GDLwt0_2-RPM500'; % This one seems to be causing some issues
    'GDLwt0_5-RPM500';
    'GDLwt1_0-RPM500';
    'GDLwt1_5-RPM500';
    'GDLwt2_0-RPM500';
    'GDLwt2_5-RPM500';
    'GDLwt3_0-RPM500';
%     'GDLwt3_5-RPM500';
%     'GDLwt3_7-RPM500';
%     'GDLwt4_5-RPM500';
%     'GDLwt5_0-RPM500'
    ]; 

% Conc in g/mL and rsq tolerance for linear regression
GDL_conc_rsq_tol = [
    [1,     0.995];
    %[2,     0.99];
    [5,     0.998];
    [10,    0.998];
    [15,    0.98];
    [20.6,  0.98];
    [25,    0.98];
    [30,    0.98];
%     [36.8,  0.98];
%     [37.6,  0.98];
%     [45,    0.98];
%     [50,    0.98]
    ]; 

% start_times = [
%     x;
%     x;
%     x;
%     x;
%     x;
%     x;
%     x
%     ];

% to_show = [
%   'GDLwt2_5-RPM500_____';
%   'GDLwt2_5-CaCO3wt0_1_';
%   'GDLwt2_5-CaCO3wt0_04';
%   'GDLwt2_5-CaCO3wt0_08';
%   'GDLwt2_5-CaCO3wt0_16'
% ];

% These are used for manually chosing the start times of the reactions.
% Automatic failed sometimes due to signal noise from the analog in
% discretization
% start_times = [
%     70.4953;
%     123.761;
%     44.2107;
%     74.466;
%     83.3605
% ];

% GDL_conc_rsq_tol = [
%         [25, 0.99]
%         [25, 0.99];
%         [25, 0.99];
%         [25, 0.99];
%         [25, 0.99];
%     ];

% to_show = [
%     'GDLwt2_5-RPM500__________';
%     'GDLwt5_0-CaCO3wt0_0-LONG_'
%     'GDLwt5_0-RPM500__________';
%     'GDLwt5_0-new-type________';
%     'GDLwt5_0-CaCO3wt0_04-LONG';
%     'GDLwt5_0-chinese_________'
% ];
% GDL_conc_rsq_tol = [
%         [50, 0.8];
%         [50, 0.8];
%         [50, 0.8];
%         [50, 0.8];
%         [50, 0.8];
%         [50, 0.8]
%     ];

GDL_conc_rsq_tol(:, 1) = GDL_conc_rsq_tol(:, 1)./1000;

GDL_conc = GDL_conc_rsq_tol(:,1);
rsq_tol  = GDL_conc_rsq_tol(:,2);

% Clip the beggining of each dataset to line them up and plot together
fpass   = 1E-20;  % low pass filter value, hardcoded, seems to produce good stuff for peak detection
fpass2  = 1E-20;

% Create empty arrays of data for obtaining fits as a function of conc
p = zeros(3, size(GDL_conc,1));
sqrt_tau = zeros(1, size(GDL_conc,1));

% Based on the collected data, generate piece-wise functions (the to design
% the model)
for j = 1:size(to_show,1)
%     [t_, pH_, t, pH ] = pH_clip_start(to_show(j,:), fpass, start_times(j));
    [t_, pH_, t, pH ] = pH_clip_start(to_show(j,:), fpass, false);
    [p(:,j), sqrt_tau(:,j)] = find_piecewise_fit(t_, pH_, 400, fpass2, rsq_tol(j)); 
end

title('GDL without vs with various concentrations of CaCO3')
xlabel('t');
ylabel('[H+] in mol/L')
legend(to_show)


return

% Generate the model (ie for a conc of GDL what happens in time)
f_slope_sqrt_t = @(a,x) a(1).*x.^(a(2));
A = fminsearch(@(a) norm(p(1,:)-f_slope_sqrt_t(a, GDL_conc)), [1,11]);

f_sqrt_tau = @(b,x) b(1)./x.^(1) + b(2);
% f_sqrt_tau = @(b,x) b(1).*exp(-b(2).*x) + b(3);
B = fminsearch(@(b) norm(sqrt_tau-f_sqrt_tau(b, GDL_conc)), [1, 1].*10E-2);

% This code below plots the fits for slope and time offset of the hydrogen
% production
if false
    plot_range = linspace(0,0.06);

    yyaxis left
    plot(GDL_conc, p(1,:),'o');
    hold on
    plot(plot_range, f_slope_sqrt_t(A,plot_range))
    ylabel('Hydrogen production slope (mol/L/sqrt(s))')
    
    yyaxis right
    plot(GDL_conc, sqrt_tau(1,:),'o')
    plot(plot_range, f_sqrt_tau(B,plot_range))
    ylabel('sqrt(tau)')
end

return


% This code below tests trial functions with the model parameters
to_eval = GDL_conc;
for j = 1:size(to_eval,1)
    disp(to_eval(j))
    test_func = GDLconc_to_sqrtt_curve(to_eval(j), f_slope_sqrt_t, A, f_sqrt_tau, B);
   
    plot(linspace(0, 20), test_func(linspace(0, 20).^2), '--')
    hold on
end
title('Model predictions for various GDL initial concentrations ')
xlabel('sqrt(t)')
ylabel('Hydrogen concentration (mol/L)')

hold off
