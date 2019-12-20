"""
Plot the emission spectra from the rest of the discharge tubes. Comment on the differences
in the spectra. For example, explain why the number of emission lines changes.
"""
import os
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick
import matplotlib.patches as patch
import numpy as np
import scipy.optimize

class dataParse:

    def __init__(self, files):
        self.files = files
        self.full_data_dict = {}
        self.parsed_data = {}
        self.file = ''
        self.bulbs = ['LED', 'CFL', 'Incandescent', 'Blacklight']
        self.tubes = ['Argon', 'Helium', 'Hydrogen', 'Mercury (Safety Glasses)', 'Mercury (Sunglasses)',
                      'Mercury (Unshielded)', 'Neon', 'Oxygen']
        self.bulb_type = ''
        self.legend_name = ''
        self.plot_color = ['y', 'g', 'm', 'r', 'b', 'k', 'orange', 'c']
        self.molw = {'Argon': 39.95, 'Helium': 4.003, 'Hydrogen': 1.008, 'Mercury (Safety Glasses)': 200.6,
                     'Mercury (Sunglasses)': 200.6, 'Mercury (Unshielded)': 200.6, 'Neon': 20.18, 'Oxygen': 15.99}
        self.emis = {'Argon': 20, 'Helium': 8, 'Hydrogen': 3, 'Mercury (Safety Glasses)': 31,
                     'Mercury (Sunglasses)':31, 'Mercury (Unshielded)': 31, 'Neon': 23, 'Oxygen': 2}
        self.total_csv = {}

    def run(self):
        for file in self.files:
            self.file = file
            # get data
            if any(name in file for name in self.bulbs):
                self.legend_name = os.path.basename(file).replace('.txt', '')
                self.bulb_type = 'bulb'
            else:
                self.legend_name = os.path.basename(file).replace('.txt', '')
                self.bulb_type = 'tube'
            dataParse.parseData(self)
        # plot data
        dataParse.plotData(self)
        # Create raw csv
        #dataParse.createRawDataCSV(self)

    # Parse the data from the files
    def parseData(self):
        self.parsed_data = pd.DataFrame(pd.read_csv(self.file,
                                                    delim_whitespace=True,
                                                    na_values='.',
                                                    header=None,
                                                    names=['wavelength (nm)', 'intensity']
                                                    ))
        self.full_data_dict[self.file] = [self.parsed_data, self.bulb_type, self.legend_name]

    # PLot all data
    def plotData(self):
        bulb_plot = plt.figure(figsize=(10, 8))
        bulb_plot.subplots_adjust(hspace=.5, wspace=.5, left=.07, right=.97, top=.93, bottom=.1)
        bulb_title_name = 'Intensity vs. Wavelength (Bulbs)'
        a1 = bulb_plot.add_subplot(1, 1, 1)
        #a1.set_title(bulb_title_name, fontsize=24)
        a1.set_xlabel('Wavelength [nm]', fontsize=18)
        a1.set_ylabel('Intensity $[\\frac{W}{m^2}]$', fontsize=18)
        a1.ticklabel_format(axis='y', style='sci', scilimits=(-2, 2))
        a1.set_xticks(np.arange(200, 1100, 100))
        a1.set_xticks(np.arange(200, 1100, 10), minor=True)
        a1.set_yticks(np.arange(0, 70000, 10000))
        a1.set_yticks(np.arange(0, 70000, 2500), minor=True)
        a1.grid(linewidth=.15, which='both')
        a1.set_xlim(300, 1050)
        #a1.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.2E'))
        bulb_patch = []

        tube_plot = plt.figure(figsize=(10, 8))
        tube_plot.subplots_adjust(hspace=.5, wspace=.5, left=.07, right=.97, top=.93, bottom=.1)
        tube_title_name = 'Intensity vs. Wavelength (Tubes)'
        a2 = tube_plot.add_subplot(1, 1, 1)
        #a2.set_title(tube_title_name, fontsize=24)
        a2.set_xlabel('Wavelength [nm]', fontsize=18)
        a2.set_ylabel('Intensity $[\\frac{W}{m^2}]$', fontsize=18)
        a2.ticklabel_format(axis='y', style='sci', scilimits=(-2, 2))
        a2.set_xticks(np.arange(200, 1000, 100))
        a2.set_xticks(np.arange(200, 1000, 10), minor=True)
        a2.set_yticks(np.arange(0, 70000, 10000))
        a2.set_yticks(np.arange(0, 70000, 2500), minor=True)
        a2.grid(linewidth=.15, which='both')
        a2.set_xlim(275, 1000)
        #a2.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.2E'))
        tube_patch = []

        mol_plot = plt.figure(figsize=(8, 8))
        #mol_plot.subplots_adjust(hspace=.5, wspace=.5, left=.07, right=.97, top=.93, bottom=.1)
        mol_title_name = 'Number of Emission Lines vs. Molecular Wight'
        a3 = mol_plot.add_subplot(1, 1, 1)
        #a3.set_title(mol_title_name, fontsize=18)
        a3.set_xlabel('Molecular Weight $[\\frac{g}{mol}]$', fontsize=18)
        a3.set_ylabel('Number of Emission Lines', fontsize=18)
        a3.ticklabel_format(axis='y', style='sci', scilimits=(-2, 2))
        #a3.grid()

        x = []
        y = []
        for file in self.full_data_dict.keys():
            parsed_data = self.full_data_dict[file][0]
            bulb_type = self.full_data_dict[file][1]
            legend_name = self.full_data_dict[file][2]

            # Save data to lists
            wave = parsed_data['wavelength (nm)'].tolist()
            intensity = parsed_data['intensity'].tolist()

            # Plot data
            if bulb_type == 'bulb': #and 'Bl' in legend_name:
                color = self.plot_color[self.bulbs.index(legend_name)]
                bulb_patch.append(patch.Patch(color=color, label=legend_name))
                a1.plot(wave, intensity, color, label=legend_name, linewidth=.75)

            if bulb_type == 'tube': # and 'Ar' in legend_name:
                color = self.plot_color[self.tubes.index(legend_name)]
                tube_patch.append(patch.Patch(color=color, label=legend_name, linewidth=.1))
                a2.plot(wave, intensity, color, label=legend_name, linewidth=.75)
                x.append(self.molw[legend_name])
                y.append(self.emis[legend_name])

        # Fit log curve to data

        x_new = np.linspace(-5, 205, 50)
        exp, idk = scipy.optimize.curve_fit(lambda t,a,b: a*np.log(b*t),  x,  y)
        y_new = exp[0] * np.log(exp[1] * x_new)
        legend_string = f'y = {round(exp[0], 4)} ln({round(exp[1], 4)}x)'
        a3.plot(x_new, y_new, color='r', label=legend_string)
        a3.scatter(x, y, color='b')



        a1.legend(loc='upper left', fontsize=12, handles=bulb_patch)
        a2.legend(loc='upper left', fontsize=12, handles=tube_patch)
        a3.legend(loc='upper left', fontsize=12)
        bulb_plot.savefig(os.path.join(os.getcwd(), 'bulbs_plot.png'))
        tube_plot.savefig(os.path.join(os.getcwd(), 'tubes_plot.png'))
        mol_plot.savefig(os.path.join(os.getcwd(), 'mol_emissions.png'))
        plt.draw()
        plt.show()

    def createRawDataCSV(self):
        for file in self.full_data_dict.keys():
            parsed_data = self.full_data_dict[file][0]
            legend_name = self.full_data_dict[file][2]

            # Save data to lists
            wave = parsed_data['wavelength (nm)'].tolist()[0::40]
            intensity = parsed_data['intensity'].tolist()[0::40]
            self.total_csv.update({'wavelength (nm)': wave, f'{legend_name} intensity': intensity})

        self.total_csv = pd.DataFrame(self.total_csv)
        self.total_csv.to_csv(os.path.join(os.getcwd(), 'raw_data.csv'), sep=',', index=False)
        print(self.total_csv)


if __name__ == '__main__':
    # Get list of files to parse
    files = []
    curdir = os.getcwd()
    data_dir = os.path.join(curdir, r'lab5_data')
    for file in os.listdir(r'lab5_data'):
        files.append(os.path.join(data_dir, file))

    # Initialize class
    data = dataParse(files)
    # parse and plot all data from the files
    data.run()
