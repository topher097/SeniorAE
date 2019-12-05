import os
import shutil
import pandas as pd
import matplotlib.pyplot as plt

class parseData():
    def __init__(self, filename, counter):
        self.parsedData = {}
        self.file = filename
        self.counter = counter
        self.AR = []
        self.alpha1 = []
        self.cd1 = []
        self.cl1 = []
        self.alpha2 = []
        self.cd2 = []
        self.cl2 = []
        self.slope = []
        self.ideal_slope = []
        self.calc_cd = []

        # Parse data
        parseData.parse(self)

    # Parse the data from the CSV file from the ground station
    def parse(self):
        # Load CSV file into a DataFrame
        self.parsedData = pd.DataFrame(pd.read_csv(self.file,
                                                 delimiter=',',
                                                 na_values='.',
                                                 header=0,
                                                 names=['AR', 'AOA (deg) 1', 'CD_i 1', 'CL 1', 'AOA (deg) 2', 'CD_i 2',
                                                        'CL 2', 'Lift Curve Slope', 'Ideal Lift Curve', 'Calc CD']
                                                 ))
        self.AR = self.parsedData['AR'].tolist()
        self.alpha1 = self.parsedData['AOA (deg) 1'].tolist()
        self.cd1 = self.parsedData['CD_i 1'].tolist()
        self.cl1 = self.parsedData['CL 1'].tolist()
        self.alpha2 = self.parsedData['AOA (deg) 2'].tolist()
        self.cd2 = self.parsedData['CD_i 2'].tolist()
        self.cl2 = self.parsedData['CL 2'].tolist()
        self.slope = self.parsedData['Lift Curve Slope'].tolist()
        self.ideal_slope = self.parsedData['Ideal Lift Curve'].tolist()
        self.calc_cd = self.parsedData['Calc CD'].tolist()


class plotData():
    def __init__(self):
        self.filename = os.path.basename(parse.file).replace('.csv', '')
        self.counter = parse.counter
        self.AR = parse.AR
        self.alpha1 = parse.alpha1
        self.cd1 = parse.cd1
        self.cl1 = parse.cl1
        self.alpha2 = parse.alpha2
        self.cd2 = parse.cd2
        self.cl2 = parse.cl2
        self.slope = parse.slope
        self.ideal_slope = parse.ideal_slope
        self.calc_cd = parse.calc_cd

        # Plot data
        plotData.plot_cd(self)
        plotData.plot_slope(self)

    def plot_cd(self):
        cd.plot(self.AR, self.cd2, c=color[self.counter], label=self.filename)
        cd.plot(self.AR, self.calc_cd, c=color[self.counter], ls='--', label=f'{self.filename.replace(" Wing", "")} Empirical')
        plt.draw()

    def plot_slope(self):
        if self.counter == 0:
            slope.plot(self.AR, self.ideal_slope, c='grey', ls='--', label='Ideal Slope = 2$\pi$')
        slope.plot(self.AR, self.slope, c=color[self.counter], label=self.filename)
        plt.draw()


if __name__ == '__main__':
    # Initialize plot folder
    try:
        shutil.rmtree(os.path.join(os.getcwd(), 'plots\\'))
    except Exception as e:
        print(f'Could not remove plot folder, error: {str(e)}')
    try:
        os.mkdir(os.path.join(os.getcwd(), 'plots\\'))
    except Exception as e:
        print(f'Could not create plot folder, error: {str(e)}')

    # Initialize plots
    lslope = plt.figure(figsize=(12, 8))
    lslope.subplots_adjust(hspace=.18, left=.1, right=.97, top=.95, bottom=.08)
    slope = lslope.add_subplot(111)
    slope.grid(ls='--', c='grey', lw=0.5)
    slope.set_xlabel('AR', fontsize=20)
    slope.set_ylabel('Lift Slope', fontsize=20)
    slope.set_title('Lift Slope vs AR ($\\alpha=5^{\circ}$, $v_{inf}=50$, $c=2$)', fontsize=24)

    lcd = plt.figure(figsize=(12, 8))
    lcd.subplots_adjust(hspace=.18, left=.1, right=.97, top=.95, bottom=.08)
    cd = lcd.add_subplot(111)
    cd.grid(ls='--', c='grey', lw=0.5)
    cd.set_xlabel('AR', fontsize=20)
    cd.set_ylabel('$C_{D_i}$', fontsize=20)
    cd.set_title('$C_{D_i}$ vs AR ($\\alpha=5^{\circ}$, $v_{inf}=50$, $c=2$)', fontsize=24)

    # Get the filenames to parse and plot
    data_location = os.path.join(os.getcwd() + r'\Data')
    files = []
    for (dirpath, dirnames, filenames) in os.walk(data_location):
        files.extend(filenames)
        break
    files = [os.path.join(data_location, i) for i in files]

    # Initialize classes, let them run
    counter = 0
    color = ['r', 'b', 'g', 'y', 'orange']
    for filepath in files:
        parse = parseData(filepath, counter)
        plot = plotData()
        counter += 1
    slope.legend(loc='upper right', fontsize=16)
    cd.legend(loc='upper right', fontsize=16)
    # Save plots
    lslope.savefig(os.path.join(os.getcwd(), f'plots\\slope.png'))
    lcd.savefig(os.path.join(os.getcwd(), f'plots\\cd.png'))
    plt.show()