% These are the constants that the fminsearch obtained for model A
% consts_best = [
%    -0.5325   -2.5792   -0.0055   -3.2922;
%    -0.5556   -2.5075    0.0058   -3.0378;
%    -0.5543   -2.5309    0.0989   -3.3068;
%    -0.5447   -2.4971    0.0587   -2.8965
%    ];

% These are the constants that the fminsearch obtained for model A prime
consts_best = [
-0.3774   -0.4426    0.0001    4.3021    1.4665    0.2539;
-0.3774   -0.4426    0.0001    4.3021    1.4665    0.2539;
-0.3774   -0.4426    0.0001    4.3021    1.4665    0.2539;
   ];

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
    ODE_forward_func_MV(GDL_conc(i), consts_best(i,:))
end

% for GDL_conc2 =(1:1:30)/GDL_mm
%     ODE_forward_func_MV(GDL_conc2, consts_best(1,:))
% end


