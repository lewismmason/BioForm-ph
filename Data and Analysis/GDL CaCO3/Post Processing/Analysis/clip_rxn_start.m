function [t_clip, pH_clip, t, pH] = clip_rxn_start(csv_name, fpass, start_t)
%PH_CLIP_START clips the start of the experiment based on the gradient of
%the pH

%Inputs:
%   csv_name: name of the CSV file with pH data and timestamps. 
%   fpass: scalar pass-band frequency for low pass filtering. Only used if
%   start_t == false
%   start_t: put false if you would like auto index finding (not perfect).
%   Otherwise, put the value of time you would like to use for the start
%   index.

X = readtable(csv_name);
t = table2array(X(:,1));        % Hardcoded
pH = table2array(X(:,4));       % Hardcoded

if start_t == false
    % Filtering and data cleanup
    fs = 1/(t(2) - t(1)); % Note, since the code does not have a constant sample rate this may cause issues
    
    % Determine a good starting point by checking peak gradients
    dpHdt = gradient(pH,1/fs);
    d2pHdt2 = gradient(dpHdt,1/fs);
    d2pHdt2_lp = lowpass(d2pHdt2, fpass, fs);
    
    % Uncomment this to plot the derivatives for error checking
    % yyaxis right
    % plot(t, d2pHdt2_lp,'-')
    % hold on
    
    [min_accel, min_accel_i] = min(d2pHdt2_lp);
    
    % end_i = find(t>end_t,1)+min_accel_i; % add min accel i to offset from rxn start 
    
    % Create new set of data with good starting point as the t=0 start
    t_clip = t(min_accel_i:end) - t(min_accel_i);
    pH_clip = pH(min_accel_i:end);
else 
    start_i = find(t>start_t,1);
    t_clip = t(start_i:end) - t(start_i);
    pH_clip = pH(start_i:end);
end
   
% yyaxis left
% plot(t, pH,'-')
% hold on
% 
% yyaxis right
% plot(t_clip, pH_clip,'-');
% hold on
end

