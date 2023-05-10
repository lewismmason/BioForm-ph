function [t_, pH_, i_CaCO3] = pre_process(dataset_names, data_dir)
% This function pre-processes the data to be put in a form for the big
% linear system, or other more general purposes such as plotting. Note that
% if i_CaCO3 is 0 that means there is no CaCO3 rxn, this is determined by
% the naming convention of the file WHICH MUST BE AS FOLLOWS

% file_names example:
% datasets = [
%     'GDL_01_0_CaCO3_0_0_tc_000';
%     'GDL_01_0_CaCO3_0_1_tc_100';
%     'GDL_01_0_CaCO3_0_5_tc_100';
%     'GDL_01_0_CaCO3_1_0_tc_100';
%     ];

num_datasets = size(dataset_names);
num_datasets = num_datasets(1);

min_length = 1000000000000; % set very high

% modify data and place into cell array
for i=1:num_datasets
    dataset_name = append(data_dir, dataset_names(i,:));
    X = readtable(dataset_name);
    t = table2array(X(:,1))';      
    pH = table2array(X(:,4))';

    fs = 1/(t(5)-t(4));
    
    % check second derivatives to get rxn start and CaCO3 times
    dpHdt = gradient(pH,1/fs);
    d2pHdt2 = gradient(dpHdt, 1/fs);
    fpass = 1E-1;   % arbitrary
    dpHdt_lp = lowpass(dpHdt, fpass, fs);
    d2pHdt2_lp = lowpass(d2pHdt2, fpass, fs);

    num_removed = 15;   % removes the first x values for finding max/mins (necessary since 0 counts as first value, so init peak)
    [local_maxes, loc_max] = findpeaks(d2pHdt2_lp(num_removed:end));
    [local_mins, loc_min] = findpeaks(-d2pHdt2_lp(num_removed:end)); % just use the negative since its zero centered
    local_mins = -local_mins;
    loc_max = loc_max + num_removed;
    loc_min = loc_min + num_removed;
   
    % k_max/k_min correspond to what element of local_maxes it is, then get
    % loc_max with the same k for true index
    [max_d2, k_max] = maxk(local_maxes, 2); 
    [min_d2, k_min] = mink(local_mins, 2);
 
%     plot(loc_max(k_max), max_d2,'o'); % Uncomment this if confused, shows
%     peaks
%     plot(loc_min(k_min), min_d2,'o');

    i_max_d2 = loc_max(k_max);
    i_min_d2 = loc_min(k_min);

    hardcoded_offset = 3;   % second deriv seems to be slightly off, hardcoded a 3 index shift

    i_rxn(i) = min(i_min_d2) - hardcoded_offset;   %rxn start corresponds to earliest min peak
    if dataset_name(16) ~= '0' || dataset_name(18) ~= '0'
        i_CaCO3(i) = max(i_max_d2) - i_rxn(i);  %CaCO3 start corresponds latest max peak
    else
        i_CaCO3(i) = 0;   % 0 is an edge case, ie does not exist for non CaCO3 experiments
    end
    
    if length(pH(i_rxn(i):end)) < min_length
        min_length = length(pH(i_rxn(i):end));
    end

    pH_cell{i,:} = pH(i_rxn(i):end);
    t_cell{i,:} = t(i_rxn(i):end);
end

% Make all cell arrays have the same length
for i=1:num_datasets
    pH_cell_temp = pH_cell{i};
    t_cell_temp = t_cell{i};
    pH_(i,:) = pH_cell_temp(1:min_length);
    t_(i,:) = t_cell_temp(1:min_length) - t_cell_temp(1);
end

end