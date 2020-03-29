import sympy
from sympy import Symbol, diff, evalf
import matplotlib.pyplot as plt
import numpy as np

# Define function
x = Symbol('x')
delta_x = Symbol('delta_x')
y = sympy.sin(x)/(x**3)

# Define range and location
delta_x_range = np.linspace(10*10**-5, 1, 1000)
delta_y_range = np.linspace(10*10**-13, 0.1, 1000)
x_pos = 4

# Define first, second, and fourth order error
er1_ = []
er2_ = []
er4_ = []
for del_x in delta_x_range:
    i_2 = x_pos - del_x*2
    i_1 = x_pos - del_x
    i = x_pos
    i1 = x_pos + del_x
    i2 = x_pos + 2*del_x
    er1 = (diff(diff(y)).subs(x, i)) - ((1/del_x) * (0.5*y.subs(x, i_1) + -1*y.subs(x, i) + 0.5*y.subs(x, i1)))
    er2 = (diff(y)).subs(x, i) - ((1 / del_x) * (1.5 * y.subs(x, i) + -2 * y.subs(x, i_1) + 0.5 * y.subs(x, i_2)))
    er4 = (diff(y)).subs(x, i) - ((1 / (12*del_x)) * (1 * y.subs(x, i_2) + -8 * y.subs(x, i_1) + 8 * y.subs(x, i1) + -1 * y.subs(x, i2)))

    er1_.append(abs(er1.evalf()))
    er2_.append(abs(er2.evalf()))
    er4_.append(abs(er4.evalf()))

error = plt.figure(figsize=(12, 6))
error.subplots_adjust(hspace=.35)
error.tight_layout()
er = error.add_subplot(1, 1, 1)
er.set_ylabel('Truncation Error', fontdict={'fontsize': 13})
er.set_xlabel('$\Delta$x', fontdict={'fontsize': 13})
er.set_yscale('log')
er.set_xscale('log')
er.set_xlim([10*10**-5, 1])
er.set_ylim([10*10**-13, 0.1])
er.plot(delta_x_range, er1_, 'b', lw=1.5, label='first order error')
er.plot(delta_x_range, er2_, 'k', lw=1.5, ls='dotted', label='second order error')
er.plot(delta_x_range, er4_, 'r', lw=1.5, ls='dashed', label='fourth order error')
er.grid(ls='--', c='grey', lw=0.5)
er.legend(loc='lower left', fontsize=12)
plt.draw()
plt.show()