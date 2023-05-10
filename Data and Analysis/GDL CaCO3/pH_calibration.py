import matplotlib.pyplot as plt
from scipy import stats
import argparse
import json
from LinearFit import LinearFit
import time
import keyboard
import nidaqmx

from nidaqmx.constants import (
    TerminalConfiguration)


POLLRATE    = 1                    #poll rate for readings
DAQNAME     = "BioformDAQ1"     # The name of the DAQ as named on NI MAX software
PHPIN       = "ai0"             # Analog pin name for the pH measurements
SAMPLERATE  = 1                 # Number of seconds per sample


def read_analog_pin(pin):
    with nidaqmx.Task() as task:
        task.ai_channels.add_ai_voltage_chan(DAQNAME + "/" + pin,
                                    terminal_config=TerminalConfiguration.RSE)
        return task.read()


def main():
    parser = argparse.ArgumentParser(description = 'pH Meter Calibration')
    parser.add_argument('-n','--modelname', type = str, help='name of the model to save')
    args = parser.parse_args()

    LFit = LinearFit()

    while True:
        buffer_pH = input('Type the pH of the next buffer solution or type "n" to exit [pH/n]: ')
        if buffer_pH.lower() == 'n':
            print('User quit')
            return
        else: 
            buffer_pH = float(buffer_pH)

        print('Place the pH meter into the buffer solution')
        print('Now, the program will begin reading voltage values, when the values stabilize HOLD y to add the data or HOLD n to cancel [y/n]: ')

        while True:
            time.sleep(POLLRATE)
            voltage = read_analog_pin(PHPIN)
            print('Voltage = ' + str(voltage))

            if keyboard.is_pressed('y'):
                LFit.add_data(voltage, buffer_pH)
                print('User added voltage = ' + str(voltage) + ' mapped to pH = ' + str(buffer_pH))
                LFit.display_model()
                break
            elif keyboard.is_pressed('n'):
                print('User exiting data collection')
                break
        
        usr_inp = input('Would you like to add another set of data? [y/n]: ')
        if usr_inp.lower() == 'y':
            pass
        elif usr_inp.lower() == 'n':
            break
        else:
            print("Input " + str(usr_inp) + " not recognized")    

    print('Saving model as: ' + args.modelname + '.json')
    LFit.save_json_model(args.modelname)

if __name__ == "__main__":
    main()