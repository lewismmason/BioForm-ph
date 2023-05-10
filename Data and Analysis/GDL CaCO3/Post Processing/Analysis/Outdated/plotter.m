% General work script, no real purpose other than it is nice to work with
% for plotting etc

K_L = 2.4279E-06; % Determined from get_K_L.m
GDL_mm = 178.14;
H2O_mm = 18.0151;

H2Oo = 1000/H2O_mm;
GH4o = 0;

% List of files to plot, must be in CWD since I'm lazy


% Mass of GDL in grams
% delete this
GDL_conc_rsq_tol = [
    [1.01,     0.995];
    [5.007,     0.998];
    [10.009,     0.998];
    [25.1,     0.998];
    [50.1,     0.998];
    [25.1,     0.998];
    [50.1,     0.998];
    [25.1,     0.998];
    [50.1,     0.998];
    [25.1,     0.998];
    [50.1,     0.998];
    [25.1,     0.998];
    [50.1,     0.998];
    [25.1,     0.998];
    [50.1,     0.998];
    [25.1,     0.998];
    [50.1,     0.998];
    [25.1,     0.998];
    [50.1,     0.998];
    [25.1,     0.998];
    [50.1,     0.998];
    [25.1,     0.998];
    [50.1,     0.998];
    [25.1,     0.998];
    [50.1,     0.998];
    ]; 

% Determined by plotting the pH curves and hand-picking starting times

to_show = [
%     'GDL_01_0_CaCO3_0_0_tc_000';
%     'GDL_01_0_CaCO3_0_0_tc_100';
%     'GDL_01_0_CaCO3_0_1_tc_100';
%     'GDL_01_0_CaCO3_0_5_tc_100';
%     'GDL_01_0_CaCO3_1_0_tc_100';

%     'GDL_02_5_CaCO3_0_00_tc_000';
%     'GDL_02_5_CaCO3_0_05_tc_100';
%     'GDL_02_5_CaCO3_0_10_tc_100';
%     'GDL_02_5_CaCO3_0_50_tc_100';
%     'GDL_02_5_CaCO3_1_00_tc_100';
    
%     'GDL_05_0_CaCO3_0_00_tc_000';
%     'GDL_05_0_CaCO3_0_05_tc_100';
%     'GDL_05_0_CaCO3_0_10_tc_100';
%     'GDL_05_0_CaCO3_0_50_tc_100';
%     'GDL_05_0_CaCO3_1_00_tc_100';

%     'GDL_07_5_CaCO3_0_00_tc_0000';
%     'GDL_07_5_CaCO3_0_05_tc_0100';
%     'GDL_07_5_CaCO3_0_05_tc_1500';
%     'GDL_07_5_CaCO3_0_10_tc_0100';
%     'GDL_07_5_CaCO3_0_50_tc_0100';
%     'GDL_07_5_CaCO3_1_00_tc_0100';

    'GDL_10_0_CaCO3_0_00_tc_0000';
    'GDL_10_0_CaCO3_0_05_tc_0100';
    'GDL_10_0_CaCO3_0_10_tc_0100';
    'GDL_10_0_CaCO3_0_50_tc_0100';
    'GDL_10_0_CaCO3_0_50_tc_1500';
    'GDL_10_0_CaCO3_1_00_tc_0100';
    ];
start_times = [
%    13.6716;
%    94.0992;
%    72.8918;
%    11.094;
%    14.3885;
   0;
   0;
   0;
   0;
   0;
   0;
   0;
   0;
   0;
   0;
   0;
   0;
   0;
   0;
   0;
   0;
   0;
   0;
    ];

% % new thing
% to_show = [
%     'GDL_01_0_CaCO3_0_0_tc_000';
%     'GDL_01_0_CaCO3_0_1_tc_100';
%     'GDL_01_0_CaCO3_0_5_tc_100';
%     'GDL_01_0_CaCO3_1_0_tc_100';
%     ];


% to_show = ['GDLwt5_0_newcircuit'];
% GDL_conc_rsq_tol = [[50, 0.995]];
% start_times = [177.546];


GDL_conc = GDL_conc_rsq_tol(:,1);       % in mol/L NOTE NOT RIGHGT NOWWWWW
rsq_tol  = GDL_conc_rsq_tol(:,2);       % un-used

fpass   = 1E-20;    % currently un-used

% [t, pH, i_CaCO3] = pre_process(to_show);
% 
% for i=1:size(pH,1)
%     plot(t(i,:), pH(i,:))
%     hold on
% end
% 
% return

for j = 1:size(to_show,1)
    [t_, pH_, t, pH ] = clip_rxn_start(to_show(j,:), fpass, start_times(j));
    % [t_CaCO3, i_CaCO3] = get_t_CaCO3_index(....) % Determines the time, and index
    % that CaCO3 is added
%     Lo = GDL_conc(j);
    H = 10.^-pH_;
%     figure(1)
%     plot(t_, pH_)
%     hold on
%     figure(2)
    plot(t_, H)


    L0 = GDL_conc(j);

    H = H;
%     plot(t_, H);
    hold on
    % Envelope filtering, good for later portions, bad for initial
    [envHigh, envLow] = envelope(H, 4, 'peak');
    H_envMean = (envHigh + envLow)/2;
    H = H_envMean;
%     figure(1)
%     plot(t_, H);

    num = 100;
    B = 1/num*ones(num,1);
    H = filter(B,1,H);
    
%     figure(3)
%     plot(t_, gradient(H))
    
%     plot(t_, H);
%     plot(t_, pH_);
    grid on
    hold on
    drawnow;

    legend(to_show)

    % The below code checks the frequencies of the data
%     T = t(2) - t(1);
%     Fs = 1/T;
%     L = length(t);
% 
%     Y = fft(pH);
%     P2 = abs(Y/L);
%     P1 = P2(1:L/2 + 1);
%     P1(2:end-1) = 2*P1(2:end-1);
%     f = Fs*(0:(L/2))/L;

%     plot(f, P1);
%     xlabel('\f (Hz)')

    hold on

end

