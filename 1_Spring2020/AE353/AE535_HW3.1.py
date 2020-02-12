import numpy as np
from numpy.linalg import inv
import matplotlib.pyplot as plt


def probOne():
    A = np.array([[0.9, -0.4, -0.8], [0.5, 0.7, -0.3], [0.0, -0.4, 0.1]])
    B = np.array([[-0.6], [-0.9], [-0.1]])
    C = np.array([[0.0, -0.6, -0.8]])
    D = np.array([[0.0]])
    K = np.array([[-363.6, 187.9, 425.5]])

    F = A-np.dot(B, K)

    kRef = -1/(np.linalg.multi_dot([C, inv(F), B]))
    print(kRef.tolist())


def probThree():
    A = np.array([[-0.30000000, 0.20000000], [0.90000000, -0.50000000]])
    B = np.array([[-0.50000000], [-0.50000000]])
    C = np.array([[0.90000000, -0.70000000]])
    D = np.array([[0.00000000]])
    K = np.array([[-15.90000000, 8.50000000]])
    kRef = np.array([[3.60000000]])

    F = A - np.dot(B, K)
    G = C - np.dot(D, K)

    T = np.dot(D, kRef)
    print(T.tolist())

    print(F.tolist())
    print(G.tolist())

def probFour():
    A = np.array([[0.20000000, 0.70000000, 0.20000000, -0.30000000], [-0.40000000, 0.50000000, 0.80000000, 0.50000000],
                  [-0.40000000, 0.20000000, -0.80000000, -0.40000000],
                  [0.10000000, -0.70000000, 0.50000000, -0.80000000]])
    B = np.array([[0.70000000], [-0.20000000], [-0.40000000], [-0.50000000]])
    C = np.array([[-0.90000000, -0.70000000, -0.90000000, 0.00000000]])
    D = np.array([[0.00000000]])
    K = np.array([[3.10000000, -12.80000000, -5.30000000, 0.40000000]])
    kRef = np.array([[3.10104065]])

    E = A - np.dot(B, K)
    F = np.dot(B, kRef)
    G = C - np.dot(D, K)
    H = np.dot(D, kRef)

    print(E.tolist())
    print(F.tolist())
    print(G.tolist())
    print(H.tolist())

def probSix():
    A = np.array([[-0.06, 1.05], [0.07, -0.07]])
    B = np.array([[-0.03], [1.05]])
    C = np.array([[1.03, 0.02]])
    D = np.array([[0]])
    K = np.array([[2.17, 3.03]])
    tStep = 0.05
    t0 = 0
    t1 = 5
    t = np.arange(t0, t1, tStep)

    F = A - np.dot(B, K)
    G = C - np.dot(D, K)
    kRef = -1 / (np.linalg.multi_dot([C, inv(F), B]))
    r = np.array([[1]])


    y = []
    for time in t:
        x_t = 
        y = G*x + np.dot(B, kRef)*r
        print(time)




#probOne()
#probThree()
#probFour()
probSix()