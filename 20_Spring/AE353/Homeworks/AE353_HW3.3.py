import numpy as np
from scipy.linalg import inv

def probOne():
    A = np.array([[0.8, -0.9, 0.4], [0.3, 0.8, 0.6], [-0.8, 0.9, 0.6]])
    B = np.array([[0.0], [0.8], [-0.4]])
    C = np.array([[0.8, 0.2, 0.3]])
    D = np.array([[0.0]])
    K = np.array([[-5.1, 24.9, 27.9]])
    kInt = 8.3

    E = A-np.dot(B, K)-np.dot(B, kInt)
    E = np.append([E], [[C.tolist(), 0]])

    kRef = -1/(np.linalg.multi_dot([C, inv(A-np.dot(B, K)), B]))

    F1 = np.array([np.dot(B, kRef), B])
    F2 = np.array([-1, 0])

    G = np.array([C.tolist(), 0])
    H1 = np.array([0])
    H2 = np.array([0])

    print(E.tolist())
    print(F1.tolist())
    print(F2.tolist())
    print(G.tolist())
    print(H1.tolist())
    print(H2.tolist())

    """
    v = Sybol('v')
    [x_dot, v_dot] = np.array([[E, B*-kInt], [C, 0]])*np.array([[x], [v]]) + \
                     np.array([[B*kRef, B], [-1, 0]])*np.array([[r], [d]])
    y = np.array([C, 0])*np.array([[x], [y]])
    """


probOne()