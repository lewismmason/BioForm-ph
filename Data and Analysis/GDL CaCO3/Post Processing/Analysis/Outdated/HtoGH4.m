function GH4 = HtoGH4(H, Ho, GH4o)
%HTOGH4 Converts the concentration of H+ ions [H+] to the corresponding
%concentration of GH4 in a PURE GDL solution. 

%INPUTS:
%   H: current concentration of hydrogen
%   Ho: Initial concentration of hydrogen
%   GH4o: Initial concentration of GH4

%RETURNS:
%   GH4: current concentration of H2O

GH4 = H - Ho - GH4o;
end

