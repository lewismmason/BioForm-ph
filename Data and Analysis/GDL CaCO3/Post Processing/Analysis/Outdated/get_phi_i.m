% Get phi_i, requires correct clipping of the reaction.
K_W = 1E-14;
GDL_mm = 178.14;
fpass   = 1E-20;
kstar = 1;

to_show = [
%     'GDLwt0_1';
%     'GDLwt0_5';
%     'GDLwt1_0';
%     'GDLwt2_5';
    'GDLwt5_0';
    ];

% Mass of GDL in grams
GDL_conc_rsq_tol = [
%     1.01,
%     5.007;
%     10.009;
%     25.1;
    50.1;
    ]; 

% Determined by plotting the pH curves and hand-picking starting times
start_times = [
%    87.3492;
%    54.3202;
%    164.955;
%    180.036;
   84.0151;
    ];

% This section of the graphs has an increased weighting for the fitting, to
% get the inflection point correctly
weight_times = [
%     [738.95, 945.356];
%     [129, 500];
%     [84, 140];
%     [30, 100];
    [18, 40];
];

consts_best = [
%     -0.6401    0.1303    0.0665   -6.6785;
%    -0.3196   -3.1842   -0.5157   -0.5712;
%     -0.3277   -3.1638 -0.4555   -0.5166;
%      -0.2820   -3.4087   -0.6809   -0.0069;
%      -2.5235    -4.5813    -7.7687   -0.1497   -4.1443  +6.7319
%    -0.3277   -3.1638   -0.4555   -0.5166;
   -7   4   %-0.3579   -0.5430
   ];

GDL_conc = GDL_conc_rsq_tol(:,1)/GDL_mm/1;       % in mol/L

for j = 1:size(to_show,1)
    [t_clip, pH_clip, t, pH ] = pH_clip_start(to_show(j,:), fpass, start_times(j));

    L0 = GDL_conc(j);

    exp_H_ = 10.^-pH_clip / L0;     % Hbar
    exp_t_ = t_clip * kstar;        % tbar

    weight_start_index  = find(t>weight_times(j,1),1);
    weight_end_index    = find(t>weight_times(j,2),1);

    iterations = 100;
    err_best(j,1) = 100;
    
    for i = 1:iterations

        consts0 = consts_best(j,:) + (1-2*rand(1,2))*2;
%         consts0 = consts_best(j,:) + (1-2*rand(1,4))*1;

        try 
            [consts_approx, err] = fminsearch(@(consts) ODE_fit(exp_t_, exp_H_, L0, kstar, consts, weight_start_index , weight_end_index), consts0);

            ODE_forward_func(L0, consts_approx); % Plot the result

            if err < err_best(j,1)
                err_best(j,1) = err
                consts_best(j,1:2) = consts_approx
%                 consts_best(j,1:4) = consts_approx
            end
        catch ME1
            disp(ME1)
            % Simply continue
        end

    end

end

disp('Done all searches')

function err = ODE_fit(exp_t_, exp_H_, L0, kstar, consts, weight_start_index, weight_end_index)

    K_W = 1E-14;

    ODE_ICs;
%     [t_, model_H_] = ode23t(@(t_,x_) GDL_ODE_MODELA_prime(t_, x_, x0_, L0, kstar, consts), exp_t_, x0_);
%     model_H_ = model_H_(:,1);

    mix_time = 2; % 2 second mixing time
    mix_index  = find(exp_t_>mix_time,1);

    mult_L0 = 1;

    x0_(3) = x0_(3)*mult_L0;

    % Mixing higher conc
    [t_, x_] = ode23t(@(t_,x_) GDL_ODE_MODELA_prime(t_, x_, x0_, L0, kstar, consts), exp_t_, x0_);

%     x0_ = x_1(end,:);
%     x0_(3) = x0_(3)/mult_L0; 

    % Done mixing, back to normal conc
%     [t_, x_2] = ode15s(@(t_,x_) GDL_ODE_MODELA_prime(t_, x_, x0_, L0, kstar, consts), exp_t_(mix_index:end), x0_);

    H_ = x_(:,1);

    % Determine the short timescale error, this is used for L1,4 vs L1,5
    short_t = 10;
    short_index = find(exp_t_>short_t,1);
    err = norm(exp_H_(1:short_index) - H_(1:short_index))...

%     err = norm(exp_H_ - H_)...
%         + 50*norm(exp_H_(1:weight_end_index) - H_(1:weight_end_index))
%         + 50*norm((exp_H_(weight_start_index:weight_end_index)-offset) - H_2(weight_start_index-mix_index:weight_end_index-mix_index))


%     err = norm((exp_H_(1:end)-offset) - model_H_(1:end)) ...
%         + 50*norm((exp_H_(weight_start_index:weight_end_index)-offset) - model_H_(weight_start_index:weight_end_index))
end



