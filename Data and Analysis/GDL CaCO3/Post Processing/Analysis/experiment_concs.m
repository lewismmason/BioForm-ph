% This script is used to determine the masses of GDL, CaCO3, and H2O
% required for the dataset I want, real values will then be recorded and
% the true data will be shown. The permutations is that every GDL conc has
% all of the CaCO3 concs added at either 50s or 100s. Total of 28
% permuations. 


% Determine the expected data values for the experiments

T_exp = 15; % Temperature that all experiments began at, deviation 1 degree

% These wt%'s are based on mass ratios
wt_GDL = [1,2.5, 5, 7.5, 10]/100;       % List of GDL wt%'s, chosen based on a wide range
wt_CaCO3 = [0,0.05,0.1,0.2, 0.5,1]/100;   % List of CaCO3 wt%'s, chosen based on previous data
tc = [50, 100];             % Time at which CaCO3 is introduced

m_batch = 1200; % Mass of a batch, this is the sum of GDL and water

exp_conc_data = zeros(28, 7); % each row is an experiment. In the second dimension 1 = GDL mass, 2 = CaCO3 mass, 3 = H2O mass, 4 = wt%GDL, 5 = wt%CaCO3, 6 = wt%H2O, 7 = tc
z = 1; % z 

for i=1:length(wt_GDL)
    for j=1:length(wt_CaCO3)
        wt_GDL_i = wt_GDL(i);
        wt_CaCO3_j = wt_CaCO3(j);
        
        % Determine the H2O and GDL mass that give the correct concs
        syms m_GDL m_H2O m_CaCO3;
        eq1 = wt_GDL_i == m_GDL/m_batch;
        eq2 = m_GDL + m_H2O == m_batch;
        eq3 = wt_CaCO3_j == m_CaCO3/(m_batch + m_CaCO3);
        
        sol = solve([eq1, eq2, eq3], [m_GDL, m_H2O, m_CaCO3]);

        if wt_CaCO3_j == 0
            num_times = 1;
        else
            num_times = length(tc);
        end

        for zz = 1:num_times
            exp_conc_data(z,1) = sol.m_GDL;
            exp_conc_data(z,2) = sol.m_CaCO3;
            exp_conc_data(z,3) = sol.m_H2O;
            exp_conc_data(z,4) = wt_GDL_i*100;
            exp_conc_data(z,5) = wt_CaCO3_j*100;
            exp_conc_data(z,6) = sol.m_H2O/m_batch*100;
            if num_times == 1
                exp_conc_data(z,7) = 0;
            else
                exp_conc_data(z,7) = tc(zz);
            end
            z = z + 1;
        end

    end
end
% True experimental data, back out the true wt%'s, this is done manually
% and in order of the other experiments
C_real = [];

% User data here, do not touch otherwise, NOTE THAT WATER MASS INCLUDES
% BEAKER, WHICH IS REMOVED BELOW
% 1 = GDL mass, 2 = CaCO3 mass, 3 = H2O mass, 4 = wtMol%GDL, 5 = wtMol%CaCO3, 6 = wtMol%H2O, 7 = tc
% Measurements were done at 1350 RPM for mixing and then 700RPM once mixed with a plastic impeller (higher and it
% spills, this does introduce air bubbles though)
% temperatures were all cold water temp, consistently
% Measurements started after leaving the probe to reach 7.7pH alone with
% mixing on
g_per_mol_H2O = 18.0151;
g_per_mol_GDL = 178.140;
g_per_mol_CaCO3 = 100.0869;

% note should fix the array indices*************

% Need to redo these first 4, or just not use, they are garbage, L0 is just
% not consistent it seems due to residual ions etc
% C_real(1,:) = [11.998, 0, 1726.4, 0, 0, 0, 0];  %bad one
% C_real(2,:) = [11.992, 1.20+6??, 1726.8, 0, 0, 0, 100]; % bad one
% C_real(3,:) = [11.98, 6.1, 1726.6, 0, 0, 0, 100]; % bad one
% C_real(4,:) = [11.99, 12.10, 1726.2, 0, 0, 0, 100]; % bad one

C_real(1,:) = [29.96, 0, 1708, 0, 0, 0, 000];
C_real(2,:) = [29.995, 0.615, 1708.6, 0, 0, 0, 100]; % CaCO3 may have been 1.33
C_real(3,:) = [30.02, 0.604, 1708, 0, 0, 0, 1500]; 
C_real(4,:) = [30.002, 1.23, 1708.2, 0, 0, 0, 100]; 
C_real(5,:) = [30.08, 1.239, 1708.0, 0, 0, 0, 1500];
C_real(6,:) = [30.009, 2.405, 1708.0, 0, 0, 0, 100];
C_real(7,:) = [30.008, 2.402, 1708.2, 0, 0, 0, 1500];
C_real(8,:) = [29.998, 6.032, 1708.2, 0, 0, 0, 100]; 
C_real(9,:) = [30.03, 6.037, 1708.2, 0, 0, 0, 1500]; 
C_real(10,:) = [30.003, 12.09, 1708.2, 0, 0, 0, 100];  

C_real(11,:) = [60.003, 0, 1678, 0, 0, 0, 0]; 
C_real(12,:) = [60.004, 0.605, 1678.6, 0, 0, 0, 100];
C_real(13,:) = [60.004, 0.609, 1678, 0, 0, 0, 1500]; 
C_real(14,:) = [59.98, 1.21, 1678.4, 0, 0, 0, 100]; 
C_real(15,:) = [59.98, 1.206, 1678.4, 0, 0, 0, 1500];
C_real(16,:) = [60.03, 2.409, 1678.6, 0, 0, 0, 100];
C_real(17,:) = [60.02, 2.402, 1678.2, 0, 0, 0, 1500];
C_real(18,:) = [60.01, 6.04, 1678.2, 0, 0, 0, 100];
C_real(19,:) = [59.95, 6.029, 1678.6, 0, 0, 0, 1500];
C_real(20,:) = [60.007, 12.12, 1678.4, 0, 0, 0, 100]; % May need to redo this one

%GDL now +-0.2
C_real(21,:) = [90.0, 0, 1648.4, 0, 0, 0, 0];
C_real(22,:) = [90.0, 0.605, 1648.4, 0, 0, 0, 100]; 
C_real(23,:) = [90.0, 0.603, 1648, 0, 0, 0, 1500]; 
C_real(24,:) = [90.0, 1.205, 1648.6, 0, 0, 0, 100]; 
C_real(25,:) = [90.0, 1.204, 1648.6, 0, 0, 0, 1500]; 
C_real(26,:) = [90.0, 2.401, 1648.0, 0, 0, 0, 100]; 
C_real(27,:) = [90.0, 2.404, 1648.2, 0, 0, 0, 1500];
C_real(28,:) = [90.0, 6.029, 1648.2, 0, 0, 0, 100]; 
C_real(29,:) = [90.0, 6.035, 1648.4, 0, 0, 0, 1500]; 
C_real(30,:) = [90.0, 12.07, 1648.2, 0, 0, 0, 100]; 

C_real(31,:) = [120.6, 0, 1618.4, 0, 0, 0, 0]; 
C_real(32,:) = [120.0, 0.610, 1618.6, 0, 0, 0, 100]; 
C_real(33,:) = [120.0, 0.602, 1618, 0, 0, 0, 1500]; 
C_real(34,:) = [120.0, 1.208, 1618.2, 0, 0, 0, 100]; 
C_real(35,:) = [120.0, 1.2102, 1618, 0, 0, 0, 1500]; 
C_real(36,:) = [120.0, 2.404, 1618.0, 0, 0, 0, 0100]; 
C_real(37,:) = [120.0, 2.409, 1618.0, 0, 0, 0, 1500]; 
C_real(38,:) = [120.0-1, 6.032, 1618.4, 0, 0, 0, 100]; % BAD, spilled GDL when pouring in :( (less gdl than expected, measured ~1g spilled)
C_real(39,:) = [120.0, 6.032, 1618, 0, 0, 0, 1500];
C_real(40,:) = [120.0, 12.2, 1618.0, 0, 0, 0, 100]; 

C_real(:,3) = C_real(:,3) - 538; % Remove the mass of the beaker from all of the measured beaker + H2O masses

% Determine the mol/mol ratios for stoichiometry concentrations NOT mass/mass
C_real(:,4) = C_real(:,1)/g_per_mol_GDL./...
    (C_real(:,1)/g_per_mol_GDL+C_real(:,3)/g_per_mol_H2O)*100;

C_real(:,5) = C_real(:,2)/g_per_mol_CaCO3./...
    (C_real(:,1)/g_per_mol_GDL+C_real(:,2)/g_per_mol_CaCO3+C_real(:,3)/g_per_mol_H2O)*100;

C_real(:,6) = C_real(:,3)/g_per_mol_H2O./...
    (C_real(:,1)/g_per_mol_GDL+C_real(:,3)/g_per_mol_H2O)*100;


