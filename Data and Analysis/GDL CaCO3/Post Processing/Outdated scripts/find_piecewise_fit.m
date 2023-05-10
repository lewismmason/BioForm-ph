function [p, sqrt_tau] = find_piecewise_fit(t_, pH_, t_end,  fpass, rsq_tol)
% NOTE: outdated, this is useless code. There is no piecewise fit in the
% reaction we are considering

% NOTE: THIS IS WITH RESPECT TO sqrt(t), NOT t

%FIND_PIECEWISE_FIT determines the piecewise fit relationship between the
%production of hydronium ions and the square root of time. This relation
% involves the step function at offset tau and then a linear function
% related to the initial concentration of GDL

% fit = U(t-tau)*(m * sqrt(t-tau) + b)
% U(t-tau) is the step function

% INPUTS:
%   t_: output from pH_clip_start.m
%   pH_: output from pH_clip_start.m
%   t_end: cuts all data after this time, times with respect to t_ that has
%   a clipped start
%   fpass: passband frequency for low pass filter
%   rsq_tol: The r^2 tolerance to determine if a fit is good. This value
%   needs to played with until the user is satisfied (0.92 and above)

% OUTPUTS
%   p: linear fit output from polynomial fit. First index p(1) is the slope
%   sqrt_tau: peice-wise time offset corresponding to the zero intersection of p


% Determine the concentration of hydrogen and GDL used
H_conc = 10.^-pH_;              % has units mol/L
H_conc_lp = lowpass(H_conc, fpass,  1/(t_(2)-t_(1)) );    % this produces garbage for the final few values, hence why t_end_i is used to clip

% Case where t_end is too large for t_ values, use full set of values
if t_(end) > t_end
    t_end_i = find(t_ > t_end, 1);
else 
    t_end_i = size(t_,1);
end

% NOTE I made it not delta_H_conc, it is just magnitude
delta_H_conc = H_conc_lp(1:t_end_i);    % conc in mol/L
% delta_H_conc = H_conc_lp(1:t_end_i) - H_conc(1);    % conc in mol/L
sqrtt = sqrt(t_(1:t_end_i));

% Use linear regression until the result is good enough
i_start = 1; % starting index to fit
rsq = 0;

while rsq < rsq_tol

    % Error checking, if the poly fit tolerance is too strict
    if i_start >= size(sqrtt,1)
        disp('tolerance too high, ending process')
    end
    
    p = polyfit(sqrtt(i_start:end), delta_H_conc(i_start:end), 2);
    
    % check r^2 value, if not good enough increase starting index and try again
    yfit = polyval(p,sqrtt(i_start:end));
    yresid = delta_H_conc(i_start:end)-yfit;
    SSresid = sum(yresid.^2);
    SStotal = (length(delta_H_conc(i_start:end))-1)*var(delta_H_conc(i_start:end));
    rsq = 1-SSresid/SStotal;

    i_start = i_start + 1;
end

% yplot = polyval(p, sqrtt);
% yyaxis left

plot(sqrtt.^2, delta_H_conc)%, sqrtt, yplot)
% xlim([5,20])
% plot(sqrtt, delta_H_conc-yplot)
hold on
grid on


% Calculate the amount of GDL used to produce this much hydrogen
% m_CaCO3_consumed_max = delta_H_conc * 1 * 100/2; % hydrogen produced (mol/L) * 1L * (molar mass g/mol)
% yyaxis right
% plot(sqrtt, m_CaCO3_consumed_max);

sqrt_tau = -p(2)/p(1);   % Calculating the zero intercept
end

