% These are the constants that the fminsearch obtained for model A
% consts_best = [
%    -0.5325   -2.5792   -0.0055   -3.2922;
%    -0.5556   -2.5075    0.0058   -3.0378;
%    -0.5543   -2.5309    0.0989   -3.3068;
%    -0.5447   -2.4971    0.0587   -2.8965
%    ];

% These are the constants that the fminsearch obtained for model A prime
consts_best = [
%    -0.3276   -3.1554   -0.5306   -0.4209;
%  -0.2820   -3.4087   -0.6809   -0.0069  -10  -10    % These are good for 6 const model with both phi_i 3 const
%  -2.5235    4.5813    7.7687   -0.1497   -4.1443   -6.7319
%    -0.3130   -3.2270   -0.4296   -0.8964;
% %    -6   -3   -2;
%    -0.3604   -3.0505   -0.4528   -0.3630; % set as baseline
%    -5.3743   -2.9336   -0.3579   -0.5430
-4.1512   -3.8247;
-4.1512   -3.8247;
-5.8114    2.5150;
   ];

% These constants are doctored by hand 
% consts_best = [
%    -0.5325   -2.5792   -0.0055   -3.2922;
%    -0.5556   -2.5075    0.0058   -3.0378;
%    -0.5543   -2.5309    0.0389   -3.0068;
%    -0.5447   -2.4971    0.0587   -2.8965
%    ];

GDL_conc = [
%     5.007;
    10.009;
    25.1;
    50.1;
    ]; 

GDL_mm = 178.14;
GDL_conc = GDL_conc(:,1)/GDL_mm/1;       % in mol/L

% Plot fits for ODE forward
for i = 3
    ODE_forward_func(GDL_conc(i), consts_best(i,:))
end

% for GDL_conc2 = 1/GDL_mm
%     ODE_forward_func(GDL_conc2, consts_best(1,1:4))
% end

% legend('0.1wt%','0.5wt%','1wt%','2.5wt%','5wt%')
% xlabel('time (s)')
% ylabel('Hydrogen conc');
% Plot consts as a function of L0
% hold on

% Now get the constants as a linear function of L conc, since graphically
% this is what it seems zlike.

% a1_func = polyfit(GDL_conc,consts_best(:,1), 1);
% b1_func = polyfit(GDL_conc,consts_best(:,2), 1);
% a2_func = polyfit(GDL_conc,consts_best(:,3), 1);
% b2_func = polyfit(GDL_conc,consts_best(:,4), 1);

% conc = linspace(1,200);
% plot(GDL_conc(:,1)*GDL_mm, consts_best)
% legend('a1','b1','a2','b2')
% % % hold on
% plot(conc, polyval(a1_func, conc/GDL_mm))
% plot(conc, polyval(a2_func, conc/GDL_mm))
% plot(conc, polyval(b1_func, conc/GDL_mm))
% plot(conc, polyval(b2_func, conc/GDL_mm))


