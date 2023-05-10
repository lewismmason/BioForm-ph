function [L, GH4, H2O, OH] = pure_GDL_get_vars(H3O, H3O0, L0, GH40, H2O0, OH0)
%PURE_GDL_GET_VARS gets the concentrations of all components in the pure
%GDL experiment by relating different mass conservation equations as well
%as charge conserveration. 

%INPUTS:
%   H3O:    current hydronium (H+) concentration in mol/L
%   H3O0:   initial hydronium (H+) concentration in mol/L
%   L0:     initial GDL concentration in mol/L
%   GH40:   initial GH4- concentration in mol/L
%   H2O0:   initial H2O concentration in mol/L
%   OH0:    initial OH- concentration in mol/L

%OUTPUTS:
%   L:      current GDL concentration in mol/L
%   GH4:    current GH4- concentration in mol/L
%   H2O:    current H2O concentration in mol/L
%   OH:     current OH- concentration in mol/L


syms L GH4 H2O OH H3O L0 GH40 H2O0 OH0 H3O0;

% eqn1 = H3O -H3O0 + L - L0 - OH + OH0 == 0;
% eqn2 = GH4 - GH40 + L - L0 == 0;
% eqn3 = H3O - H3O0 + H2O - H2O0 + OH - OH0 == 0;
% eqn4 = H3O - H3O0 - GH4 + GH40 - OH + OH0 == 0;

eqn1 = H3O - H3O0 + GH4 -GH40 + L - L0 + OH - OH0 + H2O - H2O0 == 0; % total mass conservation
eqn2 = GH4 - GH40 + L - L0 == 0;
eqn3 = H3O -H3O0 + L - L0 - OH + OH0 == 0;
eqn4 = H3O - H3O0 - GH4 + GH40 - OH + OH0 == 0; % charge conservation

S = solve([eqn1, eqn2, eqn3, eqn4], [L, GH4, H2O, OH]);

L     = eval(S.L);
GH4   = eval(S.GH4);
H2O   = eval(S.H2O);
OH    = eval(S.OH);
end

