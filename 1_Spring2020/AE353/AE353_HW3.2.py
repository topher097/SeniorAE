import numpy as np
from scipy.linalg import inv

def probOne():
    A = np.array([[-0.7, 0.2, -0.6, 0.9], [-0.6, 0.5, 0.0, -0.2], [0.3, -0.3, 0.8, 0.0], [0.3, 0.5, -0.9, 0.9]])
    B = np.array([[0.9], [0.3], [0.9], [0.0]])
    C = np.array([[0.1, -0.2, 0.8, 0.6]])
    D = np.array([[0.0]])
    K = np.array([[-6.1, 6.8, 11.5, -13.9]])

    E = A-np.dot(B, K)

    kRef = -1/(np.linalg.multi_dot([C, inv(E), B]))

    F1 = np.dot(B, kRef)
    F2 = B

    G = C - np.dot(D , K)
    H1 = np.dot(D, kRef)
    H2 = D

    print(E.tolist())
    print(F1.tolist())
    print(F2.tolist())
    print(G.tolist())
    print(H1.tolist())
    print(H2.tolist())

def probTwo():
    A = np.array([[0.9, 0.7, 0.9], [0.5, -0.3, 0.1], [-0.2, 0.7, -0.2]])
    B = np.array([[0.2], [-0.7], [0.0]])
    C = np.array([[0.2, 0.7, 0.6]])
    D = np.array([[0.0]])
    K = np.array([[-12.7, -8.2, -7.2]])


probOne()