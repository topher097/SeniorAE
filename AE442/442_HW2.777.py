# Calculating the cruise L/D of 777-300

# Equations and numbers from [1]:
M1 = 0.55
M_cruise = 0.84
z = M_cruise - M1
Cd_o = 0.0123 - 0.0057*z**2 + 0.158*z**3 - 0.911*z**4 + 1.6178*z**5
K = 0.06056 - 0.0707*z**2 + 1.6097*z**3 - 4.843*z**4 + 6.4154*z**5
Cl_max = 1.8000 + 11.7*z**2 - 317*z**3 + 1432.7*z**4 - 2018.8*z**5

# Coefficient calculation
L = 217700*9.81                             # Dry weight, use as lift at cruise, [N] [1]
S = 427.8                                   # m^2 [3] (reference area)
v_cruise = 251.236                          # m/s [3]
rho = 0.379597                              # kg/m^3 [2]
Cl = L / (0.5 * rho * v_cruise**2 * S)
Cd = Cd_o + K*Cl**2

L_D = Cl/Cd

print(f'Cruise L/D = {L_D}')                # 16.544784895654033
