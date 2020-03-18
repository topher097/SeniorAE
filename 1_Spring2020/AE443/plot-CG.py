import matplotlib.pyplot as plt
import numpy as np

fig = plt.figure(figsize=(10, 8))
a1 = fig.add_subplot(111)
#a1.set_title('CG Envelope', fontsize=20)
a1.set_xlabel('Percent MAC (%)', fontsize=16)
a1.set_ylabel('Weight (lb)', fontsize=16)
a1.set_xlim([0, 50])
a1.set_ylim([200000, 450000])
start, end = a1.get_ylim()
a1.yaxis.set_ticks(np.arange(start, end, 25000))
start, end = a1.get_xlim()
a1.xaxis.set_ticks(np.arange(start, end, 5))
a1.grid(ls='--',c='grey',lw='.5')
fig.savefig('CG_blank.png')
plt.draw()
plt.show()
