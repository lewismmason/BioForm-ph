function L = HtoL(H, Ho, Lo)
%HTOL Converts the concentration of H+ ions [H+] to the corresponding
%concentration of GDL in a PURE GDL solution. Note that this does not
%necissarily take into account the second equilibrium reaction, and thus
%the "true" GDL amount is likely slightly less

%INPUTS:
%   H: current concentration of hydrogen
%   Ho: Initial concentration of hydrogen
%   Lo: Initial concentration of GDL

%RETURNS:
%   L: current concentration of GDL

L = Lo + Ho - H;


end

