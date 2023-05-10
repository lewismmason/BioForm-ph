import nidaqmx
from nidaqmx.constants import (
    TerminalConfiguration)
import numpy as np
import csv
import time
import matplotlib.pyplot as plt
from LinearFit import LinearFit
import argparse
import keyboard

DAQNAME     = "BioformDAQ1"     # The name of the DAQ as named on NI MAX software
PHPIN       = "ai0"             # Analog pin name for the pH measurements
SAMPLERATE  = 0.01               # Number of seconds per sample: note this is a lie ask lewis
            # I don't suggest going below 0.1 for sample rate: this is also a lie, ask lewis lol


# read_analog_pin() takes an analog measurement from the DAQ for a given pin
# Inputs:
#   pin: string name of the pin to read, defined as in the nidaqmx library
# Outputs:
#   the voltage reading from the analog pin
def read_analog_pin(pin):
    # Note this is slow and re-creates an object every time. Could make just one down the road
    # TODO since not necessary right now (speed doesn't matter so much)
    with nidaqmx.Task() as task:
        task.ai_channels.add_ai_voltage_chan(DAQNAME + "/" + pin,
                                    terminal_config=TerminalConfiguration.RSE)
        return task.read()


def main():
    
    parser = argparse.ArgumentParser(description = 'pH Meter Calibration')
    parser.add_argument('-l','--load', type = str, help='name of the json model to load')
    parser.add_argument('-n','--name', type = str, help='name of the csv file to save as')
    args = parser.parse_args()

    LFit = LinearFit()
    LFit.load_json_model(args.load)
    csv_name = args.name + '.csv'

    usr_str = input("Begin measurements? [y/n]: ")

    if usr_str.lower() != 'y':
        print("User entered: " + usr_str + ". Exiting process")
        return
    else:
        print('Beginning data recording process. When you would like to cancel, press ctrl+c')

    time_start = time.time()

    csvfile = open(csv_name,'w', newline = '')
    writer = csv.writer(csvfile)
    writer.writerow(['time_elapsed','voltage','temperature','pH_uncorrected'])
    
    # Running time and pH values for plotting
    t = []
    y = []
    #fig = plt.figure()

    try:
        while True:
            time.sleep(SAMPLERATE)

            time_elapsed    = time.time() - time_start
            voltage         = read_analog_pin(PHPIN)
            temperature     = 1 # TODO 
            pH_uncorrected  = LFit.eval(voltage)
            
            writer.writerow([time_elapsed, voltage, temperature, pH_uncorrected])

            # if keyboard.is_pressed('n'):
            #     print('User quit')
            #     break

            # Plotting
            t.append(time_elapsed)
            y.append(pH_uncorrected)

            plt.plot(t,y)
            plt.draw()
            plt.pause(0.00001)
            plt.clf()
            plt.xlabel('time (s)')
            plt.ylabel('pH')

    except KeyboardInterrupt:
        print("Something went wrong, caught an exception")

    csvfile.close()


if __name__ == "__main__":
    main()