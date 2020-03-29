import numpy as np
from scipy.linalg import expm, inv



def probFour():
    A = np.array([[4.0, -8.0, 5.0], [9.0, 7.0, -6.0], [-9.0, -4.0, 0.0]])
    B = np.array([[7.0], [6.0], [-2.0]])
    C = np.array([[-5.0, -1.0, -8.0]])
    D = np.array([[0.0]])
    K = np.array([[-8.0, 1.0, -1.0]])
    V = np.array([[8.0, -6.0, 1.0], [0.0, 5.0, 7.0], [-9.0, -5.0, 4.0]])

    F = np.linalg.multi_dot([inv(V), (A - np.dot(B, K)), V])
    G = np.dot(C - np.dot(D, K), V)

    print(F.tolist())
    print(G.tolist())

def probFive():
    A = np.array([[0.1, -0.2], [0.6, -0.7]])
    B = np.array([[-0.8], [-0.3]])
    C = np.array([[5.0, -8.0]])
    D = np.array([[0.0]])
    K = np.array([[-0.9, -0.3]])

    [V, F] = np.linalg.eig((A-np.dot(B, K)))
    F2 = []
    V2 = []
    for item in F:
        F2.append(item)
    for item in V:
        V2.append(item)
    print(F)
    print(V)

def probSix():
    A = np.array([[-4.0, -3.0, -6.0], [3.0, -3.0, 9.0], [-6.0, -8.0, 9.0]])

    [V, F] = np.linalg.eig(A)
    F2 = []
    V2 = []
    for item in F:
        F2.append(item)
    for item in V:
        V2.append(item)
    print(str(F.tolist()).replace('(', '').replace(')', ''))
    print(str(V.tolist()).replace('(', '').replace(')', ''))


if __name__ == '__main__':
    #probFour()
    #probFive()
    probSix()