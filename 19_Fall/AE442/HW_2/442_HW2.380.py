<<<<<<< HEAD
# Calculate wetted area via cone-cylinder-cone estimation for A380
from numpy import *


# SA of cone
def cone_sa(radius, height):
    sa = pi * radius * sqrt(height**2 + radius**2)
    return sa


# Dimensions
fuselage_length = 73                                # m [13]
empannage_length = (1/4) * fuselage_length          # Empannage is ~25% of overall length (estimate)
nose_length = (1/8) * fuselage_length               # Nose is ~12.5% of overall length (estimate)
remaining_length = fuselage_length - \
                   empannage_length - \
                   nose_length
fuselage_radius = 7.14 / 2                          # m [13]
tail_height = 24.1                                  # m [13]

# Wetted area calculations
wing_wet = 850 * 2                                  # m^2 [10], estimated from reference area
tail_wet = (.5 * tail_height**2) * 2                # estimate tail is right triangle
empannage_wet = cone_sa(fuselage_radius,
                        empannage_length)
nose_wet = cone_sa(fuselage_radius, nose_length)
fuselage_wet = 2 * pi * fuselage_radius * remaining_length
total_wet_area = wing_wet + tail_wet + empannage_wet + \
                 nose_wet + fuselage_wet

print(f'S_wet = {total_wet_area} m^2')              # 3622.679992652374 m^2
=======
# Calculate wetted area via cone-cylinder-cone estimation for A380
from numpy import *


# SA of cone
def cone_sa(radius, height):
    sa = pi * radius * sqrt(height**2 + radius**2)
    return sa


# Dimensions
fuselage_length = 73                                # m [13]
empannage_length = (1/4) * fuselage_length          # Empannage is ~25% of overall length (estimate)
nose_length = (1/8) * fuselage_length               # Nose is ~12.5% of overall length (estimate)
remaining_length = fuselage_length - \
                   empannage_length - \
                   nose_length
fuselage_radius = 7.14 / 2                          # m [13]
tail_height = 24.1                                  # m [13]

# Wetted area calculations
wing_wet = 850 * 2                                  # m^2 [10], estimated from reference area
tail_wet = (.5 * tail_height**2) * 2                # estimate tail is right triangle
empannage_wet = cone_sa(fuselage_radius,
                        empannage_length)
nose_wet = cone_sa(fuselage_radius, nose_length)
fuselage_wet = 2 * pi * fuselage_radius * remaining_length
total_wet_area = wing_wet + tail_wet + empannage_wet + \
                 nose_wet + fuselage_wet

print(f'S_wet = {total_wet_area} m^2')              # 3622.679992652374 m^2
>>>>>>> origin/master
