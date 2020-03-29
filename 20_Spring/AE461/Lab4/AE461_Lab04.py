import numpy as np
import matplotlib.pyplot as plt
import pickle

# Define the data
s3d = [0.001, 0.010, 0.019, 0.029, 0.038, 0.059, 0.077, 0.097, 0.118, 0.138, 0.158, 0.177, 0.197, 0.217, 0.235]
s3load = [0, 450, 540, 590, 650, 760, 820, 840, 860, 890, 900, 930, 940, 950, 960]
s4d = [0.000, 0.010, 0.020, 0.029, 0.039, 0.058, 0.079, 0.098, 0.117, 0.139, 0.158, 0.177, 0.198, .210, 0.234]
s4load = [100, 275, 330, 370, 400, 450, 480, 500, 560, 625, 660, 690, 705, 725, 730]
s5d = [0.000, 0.010, 0.020, 0.029, 0.039, 0.058, 0.077, 0.099, .117, 0.138, 0.150, 0.177, 0.198, 0.216, 0.2365]
s5load = [120, 290, 460, 500, 580, 650, 680, 700, 720, 720, 690, 690, 690, 700, 720]
sz1d = [0.000, 0.010, 0.018, 0.029, 0.038, 0.060, 0.078, 0.098, 0.118]
sz1load = [0, 420, 610, 750, 825, 950, 1000, 1050, 1120]
sz2d = [0.005, 0.010, 0.020, 0.030, 0.039, 0.060, 0.079, 0.099, 0.118]
sz2load = [0, 75, 160, 240, 300, 400, 580, 740, 860]


# Question 1
question1 = plt.figure(figsize=(7, 4))
q1 = question1.add_subplot(111)
q1.plot(s3d, s3load, marker='o', mfc='none', mec='b', ms=5, ls='-', c='b', lw=1, label='S3')
q1.grid(c='grey', ls='--', lw=0.5)
q1.set_ylabel('Force [N]', fontsize=12)
q1.set_xlabel('Deflection [inches]', fontsize=12)
q1.legend(fontsize=10, loc='best')
question1.savefig('plots/Question1.png')
plt.draw()


# Question 2

# with open('S4.pkl', 'rb') as fin :
#     S4 = pickle.load(fin)
# with open('S6.pkl', 'rb') as fin :
#     S6 = pickle.load(fin)
# with open('S7.pkl', 'rb') as fin :
#     S7 = pickle.load(fin)

S4 = np.array([[0.0, 100.0], [0.01, 275.0], [0.02, 330.0], [0.029, 370.0], [0.039, 400.0], [0.058, 450.0], [0.079, 480.0], [0.098, 500.0], [0.117, 560.0], [0.139, 625.0], [0.158, 660.0], [0.177, 690.0], [0.198, 705.0], [0.21, 725.0], [0.234, 730.0]])
S6 = np.array([[0.0, 0.0], [0.01, 190.0], [0.02, 340.0], [0.03, 440.0], [0.039, 610.0], [0.058, 910.0], [0.077, 1125.0], [0.098, 1260.0], [0.118, 1370.0], [0.138, 1440.0], [0.158, 1475.0], [0.177, 1500.0], [0.197, 1525.0], [0.217, 1560.0], [0.236, 1600.0]])
S7 = np.array([[0.003, 160.0], [0.009, 940.0], [0.019, 1300.0], [0.029, 1480.0], [0.038, 1590.0], [0.058, 1730.0], [0.078, 1800.0], [0.097, 1850.0], [0.117, 1880.0], [0.137, 1900.0], [0.157, 1940.0], [0.176, 1940.0], [0.197, 1950.0], [0.216, 1960.0], [0.236, 1960.0]])
Fcrit1 = 720*np.ones(S4.size)
Fcrit2 = 1550*np.ones(S4.size)
Fcrit3 = 1950*np.ones(S4.size)
disp = np.linspace(0, 0.25, S4.size)
question2 = plt.figure(figsize=(9, 5))
q2 = question2.add_subplot(111)
q2.plot(S4[:, 0], S4[:, 1], marker='o', mfc='none', ms=5, ls='-', lw=1.5, label='S4 Deflection Data')
q2.plot(S6[:, 0], S6[:, 1], marker='o', mfc='none', ms=5, ls='-', lw=1.5, label='S6 Deflection Data')
q2.plot(S7[:, 0], S7[:, 1], marker='o', mfc='none', ms=5, ls='-', lw=1.5, label='S7 Deflection Data')
q2.plot(disp, Fcrit1, ls='--', c='k', lw=1, label='Critical Buckling Loads')
q2.plot(disp, Fcrit2, ls='--', c='k', lw=1)
q2.plot(disp, Fcrit3, ls='--', c='k', lw=1)
q2.grid(c='grey', ls='--', lw=0.5)
q2.set_ylabel('Force [N]', fontsize=12)
q2.set_xlabel('Deflection [inches]', fontsize=12)
q2.legend(fontsize=10, loc='best')
question2.savefig('plots/Question2.png')
plt.draw()


# Question 3
# theoretical values
s3loadt = 640.6*np.ones(len(s3load))
s3dt = s3d
s5loadt = 470.65*np.ones(len(s5load))
s5dt = s5d
# measured buckling values (max load during tests)
buck3 = max(s3load)*np.ones(len(s3load))
buck3d = s3d
buck5 = max(s5load)*np.ones(len(s3load))
buck5d = s5d
question3 = plt.figure(figsize=(9, 6))
q3 = question3.add_subplot(111)
q3.plot(s3dt, s3loadt, ls='--', lw=1, label='S3 Theoretical Buckling Load')
q3.plot(buck3d, buck3, ls='-.', lw=1, label='S3 Actual Buckling Load')
q3.plot(s3d, s3load, marker='o', mfc='none', ms=5, ls='-', lw=1.5, label='S3 Deflection Data')
q3.plot(s5dt, s5loadt, ls='--', lw=1, label='S5 Theoretical Buckling Load')
q3.plot(buck5d, buck5, ls='-.', lw=1, label='S5 Actual Buckling Load')
q3.plot(s5d, s5load, marker='o', mfc='none', ms=5, ls='-', lw=1.5, label='S5 Deflection Data')
q3.grid(c='grey', ls='--', lw=0.5)
q3.set_ylabel('Force [N]', fontsize=12)
q3.set_xlabel('Deflection [inches]', fontsize=12)
box = q3.get_position()
q3.set_position([box.x0, box.y0 + box.height * .2, box.width * 1, box.height * .8])
#q3.legend(fontsize=10, loc='center bottom', bbox_to_anchor=(1, 0.5))
q3.legend(fontsize=10, loc='lower center', bbox_to_anchor=(0.5, -0.3), ncol=3)
question3.savefig('plots/Question3.png')
plt.draw()


# Question 4
question4 = plt.figure(figsize=(7, 4))
q4 = question4.add_subplot(111)
q4.plot(sz1d, sz1load, marker='o', mfc='none', mec='b', ms=5, ls='-', c='b', lw=1, label='SZ1')
q4.plot(sz2d, sz2load, marker='o', mfc='none', mec='r', ms=5, ls='-', c='r', lw=1, label='SZ2')
q4.grid(c='grey', ls='--', lw=0.5)
q4.set_ylabel('Force [N]', fontsize=12)
q4.set_xlabel('Deflection [inches]', fontsize=12)
q4.legend(fontsize=10, loc='best')
question4.savefig('plots/Question4.png')
plt.draw()


# Question 5
deflection_mm = [0.00, 0.25, 0.45, 0.75, 1.00, 1.50, 2.05, 2.50, 3.05, 3.50, 4.00, 4.50, 5.00]
deflection_in = [i*0.0393701 for i in deflection_mm]
load = [0, 340, 530, 650, 720, 800, 860, 910, 960, 990, 990, 1030, 1040]
question5 = plt.figure(figsize=(7, 4))
q5 = question5.add_subplot(111)
q5.plot(deflection_in, load, marker='o', mfc='none', mec='b', ms=5, ls='-', c='b', lw=1, label='SZ1 with 10N Lateral Load')
q5.plot(sz1d, sz1load, marker='o', mfc='none', mec='r', ms=5, ls='-', c='r', lw=1, label='SZ1 with 0N Lateral Load')
q5.grid(c='grey', ls='--', lw=0.5)
q5.set_ylabel('Force [N]', fontsize=12)
q5.set_xlabel('Deflection [inches]', fontsize=12)
q5.legend(fontsize=10, loc='best')
question5.savefig('plots/Question5.png')
plt.draw()


plt.show()

