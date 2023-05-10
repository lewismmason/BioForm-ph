The contents of this folder are used to gather data using a pH meter. 

As a user you only have to use two python scripts: pH_calibration and pH_data_collector

Ex:

pH_calibration -n june20model

pH_data_collector -l june20model -n data_im_collecting

The first creates a calibration curve for the pH meter and the second loads that model to begin collecting data, putting it in a csv
LinearFit is a class I made to create this calibration model 