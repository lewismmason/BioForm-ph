% Loading data
data_dir = 'C:\Work\Bioform\Data and Analysis\GDL CaCO3\Post Processing\Analysis\Big System Data\';

data_2_5 = [
    'GDL_02_5_CaCO3_0_00_tc_0000';
%     'GDL_02_5_CaCO3_0_05_tc_0100';
%     'GDL_02_5_CaCO3_0_05_tc_1500';
%     'GDL_02_5_CaCO3_0_10_tc_0100';
%     'GDL_02_5_CaCO3_0_10_tc_1500';
%     'GDL_02_5_CaCO3_0_20_tc_0100';
%     'GDL_02_5_CaCO3_0_20_tc_1500';
%     'GDL_02_5_CaCO3_0_50_tc_0100';
%     'GDL_02_5_CaCO3_0_50_tc_1500';
%     'GDL_02_5_CaCO3_1_00_tc_0100';
];

data_5_0 = [
    'GDL_05_0_CaCO3_0_00_tc_0000';
%     'GDL_05_0_CaCO3_0_05_tc_0100';
%     'GDL_05_0_CaCO3_0_05_tc_1500';
%     'GDL_05_0_CaCO3_0_10_tc_0100';
%     'GDL_05_0_CaCO3_0_10_tc_1500';
%     'GDL_05_0_CaCO3_0_20_tc_0100';
%     'GDL_05_0_CaCO3_0_20_tc_1500';
%     'GDL_05_0_CaCO3_0_50_tc_0100';
%     'GDL_05_0_CaCO3_0_50_tc_1500';
%     'GDL_05_0_CaCO3_1_00_tc_0100';
];

% This one is the nicest fro prov
data_7_5 = [
    'GDL_07_5_CaCO3_0_00_tc_0000';
%     'GDL_07_5_CaCO3_0_05_tc_0100';
%     'GDL_07_5_CaCO3_0_05_tc_1500';
%     'GDL_07_5_CaCO3_0_10_tc_0100';
%     'GDL_07_5_CaCO3_0_10_tc_1500';
%     'GDL_07_5_CaCO3_0_20_tc_0100';
%     'GDL_07_5_CaCO3_0_20_tc_1500';
%     'GDL_07_5_CaCO3_0_50_tc_0100'; % Omit this for prov
%     'GDL_07_5_CaCO3_0_50_tc_1500';
%     'GDL_07_5_CaCO3_1_00_tc_0100';
];

data_10_0 = [
    'GDL_10_0_CaCO3_0_00_tc_0000';
%     'GDL_10_0_CaCO3_0_05_tc_0100';
%     'GDL_10_0_CaCO3_0_05_tc_1500';
%     'GDL_10_0_CaCO3_0_10_tc_0100';
%     'GDL_10_0_CaCO3_0_10_tc_1500';
%     'GDL_10_0_CaCO3_0_20_tc_0100';
%     'GDL_10_0_CaCO3_0_20_tc_1500';
%     'GDL_10_0_CaCO3_0_50_tc_0100';
%     'GDL_10_0_CaCO3_0_50_tc_1500';
%     'GDL_10_0_CaCO3_1_00_tc_0100';
];

data_all = [data_2_5; data_5_0; data_7_5; data_10_0];

%Choose what data is plotted
show = data_all;
[t, pH, i_CaCO3] = pre_process(show, data_dir);

for i = 1:size(show,1)
%     plot(t(i,:), pH(i,:));
    plot(t(i,:), 10.^-(pH(i,:)));
    hold on
end

grid on
xlabel('time (s)')
ylabel('Hydrogen Ion Concentration [H^+]')

