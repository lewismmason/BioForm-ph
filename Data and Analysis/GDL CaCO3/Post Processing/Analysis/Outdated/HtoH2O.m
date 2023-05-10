function H2O = HtoH2O(H, Ho, H2Oo)
%HTOH2O Converts the concentration of H+ ions [H+] to the corresponding
%concentration of H2O in a PURE GDL solution. Note that this does not
%necissarily take into account the second equilibrium reaction, and thus
%the "true" H2O amount is likely slightly less

%INPUTS:
%   H: current concentration of hydrogen
%   Ho: Initial concentration of hydrogen
%   H2Oo: Initial concentration of H2O

%RETURNS:
%   H2O: current concentration of H2O

H2O = H2Oo + Ho - H;
end

