import numpy as np


def problemSeven():
    A = np.array([[ 3,  1], [-8, -7]])
    B = np.array([[-5], [-1]])
    C = np.array([[7, 1]])
    D = np.array([[0]])
    K = np.array([[1, 6]])

    F = (A-(B*K)).tolist()
    G = (C-(D*K)).tolist()

    print(F)
    print(G)


def probEight():
    A = np.array(
        [[-0.90000000, -0.30000000, 0.30000000, 0.30000000], [-0.70000000, 0.20000000, 0.50000000, -0.90000000],
         [-0.50000000, 0.80000000, -0.70000000, 0.50000000], [-0.60000000, -0.60000000, -0.10000000, -0.40000000]])
    B = np.array([[0.30000000], [-0.30000000], [0.60000000], [0.70000000]])
    C = np.array([[0.20000000, 0.70000000, 0.50000000, 0.20000000]])
    D = np.array([[0.00000000]])
    K = np.array([[52.90000000, -0.50000000, -29.30000000, 14.50000000]])
    kRef = np.array([[-3.85997781]])

    E = (A-B*K).tolist()
    F = (B*kRef).tolist()
    G = (C-D*K).tolist()
    H = (D*kRef).tolist()
    print(E)
    print(F)
    print(G)
    print(H)

'''
def probNine():
    A = np.array(
        [[-0.20000000, -0.10000000, 0.50000000, -0.70000000], [0.80000000, -0.40000000, -0.40000000, -0.50000000],
         [0.80000000, 0.10000000, 0.40000000, 0.80000000], [0.70000000, 0.90000000, 0.80000000, 0.60000000]])
    B = np.array([[-0.80000000], [0.50000000], [0.10000000], [0.80000000]])
    C = np.array([[-0.90000000, -0.30000000, 0.30000000, -0.40000000]])
    D = np.array([[0.00000000]])
    K = np.array([[-99.10000000, -28.40000000, -96.50000000, -56.90000000]])
    kInt = 6.30000000
    kRef = np.array([[-9.50090307]])

    E = (A)
    F1 =
    F2 =
    G =
    H1 =
    H2 =

    print(E)
    print(F1)
    print(F2)
    print(G)
    print(H1)
    print(H2)
'''
def probTen():
    A = np.array([[0.70000000, -0.10000000], [-0.10000000, 0.90000000]])
    B = np.array([[0.50000000], [0.70000000]])
    C = np.array([[0.40000000, 0.60000000]])
    D = np.array([[0.00000000]])
    K = np.array([[-35.20000000, 31.40000000]])
    kRef = np.array([[-3.69924812]])

    E = (A-(B*K)).tolist()
    F1 = (B*kRef).tolist()
    F2 = (B).tolist()
    G = (C-(D*K)).tolist()
    H1 = (D*kRef).tolist()
    H2 = (D).tolist()

    print(E)
    print(F1)
    print(F2)
    print(G)
    print(H1)
    print(H2)

if __name__ == '__main__':
    # problemSeven()
    # probEight()
    #probNine()

    probTen()






