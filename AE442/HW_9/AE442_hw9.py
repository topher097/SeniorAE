import matplotlib.pyplot as plt
import numpy as np
import os

trap = []
ellip = []
schrenk = []
v = []
m = []

b = 35.58*12    # in
L = 63180       # lb
y = np.linspace(0, b/2, 1000)
g = 0.56

for i in y:
    t = ((2*L)/(b*(1+g)))*(1-(2*i/b)*(1-g))
    e = ((4*L)/(np.pi*b))*np.sqrt(1-(2*i/b)**2)
    s = (t + e)/2
    trap.append(t)
    ellip.append(e)
    schrenk.append(s)

fig = plt.figure()
plt.ylabel('Lift [lb/in]')
plt.xlabel('y [in]')
plt.ylim(0, 200)
plt.xlim(0, 230)
plt.plot(y, trap, c='b', label='Trapezoidal')
plt.plot(y, ellip, c='r', label='Elliptical')
plt.plot(y, schrenk, c='k', label="Schrenk's")
plt.grid(color='grey', lw=0.5, ls='--')
plt.legend(loc='lower left', fontsize=12)
fig.savefig(os.path.join(os.getcwd(), 'plots\lift_dist'))

for i in range(y.size):
    pos = y[-i]
    v_int = 0
    m_int = 0
    L = 0
    for j in range(i, y.size-1):
        dy = y[i+1] - y[i]
        L += schrenk[j]*dy
    print(L)
    v.append(v_int*pos)
    m.append(m_int*pos**2/2)

v = list(reversed(v))
m = list(reversed(m))

fig2 = plt.figure()
plt.ylabel('$V_{ultimate}$ [lb]')
plt.xlabel('y [in]')
plt.plot(y, v, c='b')
plt.grid(color='grey', lw=0.5, ls='--')
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
fig2.savefig(os.path.join(os.getcwd(), 'plots\shear'))

fig3 = plt.figure()
plt.ylabel('$M_{ultimate}$ [lb-in]')
plt.xlabel('y [in]')
plt.plot(y, m, c='b')
plt.grid(color='grey', lw=0.5, ls='--')
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
fig3.savefig(os.path.join(os.getcwd(), 'plots\moment'))

m_ult, v_ult = 0, 0
for i in range(y.size):
    pos = y[i]
    if pos >= 31:
        m_ult = m[i]
        v_ult = v[i]
        break
print(f'M_ult = {m_ult}')
print(f'V_ult = {v_ult}')

plt.show()