# This script is used to compare various csv files on a singular graph
# Note: this code is @$$ use my matlab stuff instead
import csv
import matplotlib.pyplot as plt



# Hardcoded list of csv files to display

# June 7th
# data = ['GDLwt0_4-RPMX_X.csv','GDLwt0_7-RPMX_X.csv']
# data_dir = '.\\Data\\June 7 initial tests\\'
# data_dir = '' # temporary used if in cwd

# June 8th
# data = ['GDLwt0_5-SPD4_0.csv','GDLwt0_5-SPD3_5.csv','GDLwt0_5-SPD4_5.csv']
# data_dir = '' # temporary used if in cwd

# # June 8th water graph
# data = ['GDLwt1_0-RPM500_']
data = ['GDLwt2_5-CaCO3wt0_1.csv']
data_dir = '' # temporary used if in cwd

# # June 8th 1 wt%
# data = ['GDLwt1_0-SPD4_5.csv']
# data_dir = '' # temporary used if in cwd

# multiple different wt%
# data = ['GDLwt0_4-RPMX_X.csv','GDLwt0_7-RPMX_X.csv','GDLwt1_0-SPD4_5.csv']
# data_dir = '' # temporary used if in cwd


data = [data_dir + i for i in data]
num_files = len(data)

all_times   = [] # list of lists of data
all_pHs     = [] # list of lists of data

for i in range(num_files):
    time_array  = []
    pH_array    = []

    with open(data[i], 'r', newline='') as csvfile:
        plots = csv.reader(csvfile, delimiter=',')

        for row in plots:
            try:
                time_array.append(float(row[0]))
                pH_array.append(float(row[3]))
            except:
                pass

    all_times.append(time_array)
    all_pHs.append(pH_array)

# print(all_pHs)

# x = [i/all_pHs[0] for i in all_pHs]

for i in range(num_files):
    plt.plot(all_times[i], all_pHs[i])
    # plt.semilogy(all_times[i], all_pHs[i])

plt.xlabel('time (s)')
plt.ylabel('pH')
plt.grid()
plt.title('pH versus time')
plt.show()
