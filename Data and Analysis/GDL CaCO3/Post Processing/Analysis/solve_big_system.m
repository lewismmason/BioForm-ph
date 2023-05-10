data_dir = 'C:\Work\Bioform\Data and Analysis\GDL CaCO3\Post Processing\Analysis\Big System Data\';

% Loading data, this data must match with the C_real order
data_dir = 'C:\Work\Bioform\Data and Analysis\GDL CaCO3\Post Processing\Analysis\Big System Data\';

data_2_5 = [
    'GDL_02_5_CaCO3_0_00_tc_0000';
    'GDL_02_5_CaCO3_0_05_tc_0100';
    'GDL_02_5_CaCO3_0_05_tc_1500';
    'GDL_02_5_CaCO3_0_10_tc_0100';
    'GDL_02_5_CaCO3_0_10_tc_1500';
    'GDL_02_5_CaCO3_0_20_tc_0100';
    'GDL_02_5_CaCO3_0_20_tc_1500';
    'GDL_02_5_CaCO3_0_50_tc_0100';
    'GDL_02_5_CaCO3_0_50_tc_1500';
    'GDL_02_5_CaCO3_1_00_tc_0100';
];

data_5_0 = [
    'GDL_05_0_CaCO3_0_00_tc_0000';
    'GDL_05_0_CaCO3_0_05_tc_0100';
    'GDL_05_0_CaCO3_0_05_tc_1500';
    'GDL_05_0_CaCO3_0_10_tc_0100';
    'GDL_05_0_CaCO3_0_10_tc_1500';
    'GDL_05_0_CaCO3_0_20_tc_0100';
    'GDL_05_0_CaCO3_0_20_tc_1500';
    'GDL_05_0_CaCO3_0_50_tc_0100';
    'GDL_05_0_CaCO3_0_50_tc_1500';
    'GDL_05_0_CaCO3_1_00_tc_0100';
];

data_7_5 = [
    'GDL_07_5_CaCO3_0_00_tc_0000';
    'GDL_07_5_CaCO3_0_05_tc_0100';
    'GDL_07_5_CaCO3_0_05_tc_1500';
    'GDL_07_5_CaCO3_0_10_tc_0100';
    'GDL_07_5_CaCO3_0_10_tc_1500';
    'GDL_07_5_CaCO3_0_20_tc_0100';
    'GDL_07_5_CaCO3_0_20_tc_1500';
    'GDL_07_5_CaCO3_0_50_tc_0100';
    'GDL_07_5_CaCO3_0_50_tc_1500';
    'GDL_07_5_CaCO3_1_00_tc_0100';
];

data_10_0 = [
    'GDL_10_0_CaCO3_0_00_tc_0000';
    'GDL_10_0_CaCO3_0_05_tc_0100';
    'GDL_10_0_CaCO3_0_05_tc_1500';
    'GDL_10_0_CaCO3_0_10_tc_0100';
    'GDL_10_0_CaCO3_0_10_tc_1500';
    'GDL_10_0_CaCO3_0_20_tc_0100';
    'GDL_10_0_CaCO3_0_20_tc_1500';
    'GDL_10_0_CaCO3_0_50_tc_0100';
    'GDL_10_0_CaCO3_0_50_tc_1500';
    'GDL_10_0_CaCO3_1_00_tc_0100';
];

data_all = [data_2_5; data_5_0; data_7_5; data_10_0];

%Choose what data is plotted
show = data_all;

% Load data
experiment_concs;   % Gives mol/mol concentrations in C_real(i, [4,5,6]) for GDL, CaCO3 at t_CaCO3, H2O ISSUE, CaCO3 IS NOT VALID SINCE MOLES NOT CONSERVED, NEED TO DETERMINE INSTANTANEOUS 
% wtmol_GDL0   = C_real(:,4);   % not valid since moles not conserved
wtmol_CaCO30 = C_real(:,5);
wtmol_H2O0   = C_real(:,6);
[t, pH, i_CaCO3] = pre_process(data_names, data_dir);





