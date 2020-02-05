import numpy as np
from scipy.linalg import expm, eig

def probFive():
    A = np.array([[-0.1, -0.2], [0.0, -0.5]])
    B = np.array([[-0.9], [0.5]])
    C = np.array([[0.1, 0.1]])
    D = np.array([[0.0]])
    K1 = np.array([[-75.8, -113.6]])
    K2 = np.array([[-60.8, -130.6]])
    K3 = np.array([[-11.9, -12.8]])
    K4 = np.array([[36.4, 79.7]])
    K5 = np.array([[-2.9, -10.6]])

    Ks = [K1, K2, K3, K4, K5]
    counter = 1
    for K in Ks:
        Am = A - np.dot(B, K)
        [V, F] = eig(Am)
        if F[0][0] < 0 and F[-1][-1] < 0:
            print('K' + str(counter))
        counter += 1

probFive()