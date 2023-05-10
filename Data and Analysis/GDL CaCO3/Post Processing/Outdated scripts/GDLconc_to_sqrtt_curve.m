function [H_sqrt_t_func] = GDLconc_to_sqrtt_curve(GDL_conc, f_slope_sqrt_t, A, f_sqrt_tau, B)
% Note: this code is outdated. Do not use this

%GDLCONC_TO_SQRTT_CURVE Takes a GDL concentration and returns a function
%that can be evaluated at any time, showing the hydrogen concentration
%change.

% INPUTS:
%   GDL_conc: scalar GDL concentration. Note that this should ideally be
%   within the maximum and minimum concentrations used to generate the
%   other inputs used in this function
%   f_slope_sqrt_t: function that gives the slope of reaction wrt sqrt(t)
%   for the hydrogen concentration. This is found using fminsearch
%   A: fminsearch parameters for f_slope_sqrt_t
%   f_sqrt_tau: function that gives the sqrt_tau offset for a GDL reaction
%   with a given concentration
%   B: fminsearch parameters for f_sqrt_tau

% OUTPUTS:
%   H_sqrt_t_func: piece wise function showing the hydrogen concentration
%   as a function of TIME (not sqrt time). 

slope = f_slope_sqrt_t(A, GDL_conc);
sqrt_tau = f_sqrt_tau(B, GDL_conc);

% This may cause issues, used because the sqrt_tau can be negative for too
% high concentrations. This is an issue with the functions being used to
% fit, need more high conc GDL data
if sqrt_tau < 0
    sqrt_tau = 0;
end

tau = sqrt_tau^2;
H_sqrt_t_func = @(t) (t >= tau).*slope.*(t.^(1/2) - sqrt_tau);

end

