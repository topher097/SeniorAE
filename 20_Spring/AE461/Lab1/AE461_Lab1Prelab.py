import matplotlib.pyplot as plt
import numpy as np

def probTwo():
    plot_colors = ['r', 'b', 'g', 'k']
    v_f = [0.35, 0.45, 0.55, 0.65]

    rho_f = 1.84        # g/cm^3
    rho_v = 1.15        # g/cm^3

    density_plot = plt.figure(figsize=[12, 8])
    rho_plot = density_plot.add_subplot(1, 1, 1)
    rho_plot.set_title('Christopher Endres, AE461: Prelab 1.2', fontsize=16)
    rho_plot.set_xlabel('$V_{v}$ * 100%', fontsize=14)
    rho_plot.set_ylabel('Composite $\\rho$ (g/$cm^{3}$)', fontsize=14)
    rho_plot.grid(c='grey', ls='dashed', lw=0.5)
    vf = '$V_{f}$'

    for i in v_f:
        index = v_f.index(i)
        v_v = np.linspace(0, 1-i, 1000)
        density = [rho_f*i + rho_v*j for j in v_v]
        rho_plot.plot(v_v*100, density, c=plot_colors[index], label=f'{vf} = {i} g/$cm^{3}$')
    plt.legend(loc='upper right', fontsize=10)
    plt.show()

probTwo()