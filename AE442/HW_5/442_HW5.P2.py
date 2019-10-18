# Calculate wetted area via cone-cylinder-cone estimation for Beechcraft Bonanza
from numpy import *


# SA of cone
def cone_sa(radius, height):
    sa = pi * radius * sqrt(height**2 + radius**2)
    return sa


# Dimensions
fuselage_length = 8.382                             # m [2]
empannage_length = (1/4) * fuselage_length          # Empannage is ~25% of overall length (estimate)
nose_length = (1/8) * fuselage_length               # Nose is ~12.5% of overall length (estimate)
remaining_length = fuselage_length - \
                   empannage_length - \
                   nose_length
fuselage_radius = 1.1 / 2                           # m, estimated from interior width [2]


# Wetted area calculations
wing_wet = 16.8                                    # m^2 [2], estimated from reference area
empannage_wet = cone_sa(fuselage_radius, empannage_length)
nose_wet = cone_sa(fuselage_radius, nose_length)
fuselage_wet = 2 * pi * fuselage_radius * remaining_length
total_wet_area = wing_wet  + empannage_wet + nose_wet + fuselage_wet

print(f'S_wet = {total_wet_area} m^2\n')            # 57.491877843462476 m^2
print(f'S_wet = {total_wet_area*10.7639} ft^2')     # 618.8368239192457 ft^2
