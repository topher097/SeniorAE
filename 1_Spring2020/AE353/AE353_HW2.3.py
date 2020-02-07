import numpy as np
from scipy.linalg import expm, eig

def probFive():
    A = np.array([[0.2, 0.5, 0.3], [0.4, -0.8, -0.2], [-0.7, 0.7, -0.7]])
    B = np.array([[0.1], [0.5], [0.5]])
    C = np.array([[-0.6, -0.1, 0.0]])
    D = np.array([[0.0]])
    K1 = np.array([[-30.2, -16.7, 9.5]])
    K2 = np.array([[25.4, 6.3, -0.4]])
    K3 = np.array([[57.0, 11.9, -3.7]])
    K4 = np.array([[635.3, 432.1, -532.8]])
    K5 = np.array([[69.5, 15.5, -10.0]])

    Ks = [K1, K2, K3, K4, K5]
    counter = 1
    for K in Ks:
        Am = A - np.dot(B, K)
        [V, F] = eig(Am)
        n = np.sqrt(F.size)
        neg = False
        for i in np.linspace(0, n-1):
            if F[int(i)][int(i)] < 0:
                neg = True
            else:
                neg = False
        if neg:
            print('K' + str(counter))
        counter += 1

probFive()