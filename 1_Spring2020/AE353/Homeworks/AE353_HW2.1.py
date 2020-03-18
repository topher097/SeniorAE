import numpy as np
from scipy.linalg import expm
from sympy import Symbol

def probOne():
    M = np.array([[-0.2, -0.5, 0.1], [-0.1, 0.3, 0.1], [-0.4, -0.1, -0.4]])
    sum = expm(M)
    print(sum.tolist())

def probTwo():
    A = np.array(
        [[-1.00000000, 0.00000000, -0.60000000, 0.30000000], [0.70000000, -0.20000000, -0.40000000, 0.30000000],
         [0.50000000, 1.00000000, -0.90000000, -0.80000000], [0.30000000, 0.10000000, -0.90000000, 0.90000000]])
    M = np.array([[0.46289815, -0.09515580, -0.27673704, 0.31754791], [0.29824585, 0.77474975, -0.33654261, 0.42496180],
                  [0.24314941, 0.46834756, 0.55563057, -0.49373074],
                  [0.12058814, -0.13366117, -0.73255015, 2.12938305]])

    f = np.log(abs(M))/M
    print(f)

def probThree():
    A = np.array([[-4, -3, 5, 0], [-7, 7, 2, -3], [4, 3, -9, 4], [-7, 0, -3, -1]])
    B = np.array([[-3, -7], [-1, 1], [-1, 9], [-7, -1]])
    C = np.array([[7, 8, 5, 5], [-3, 3, -8, 8], [-2, 0, -3, 0], [9, 9, 6, -6]])
    D = np.array([[0, 0], [0, 0], [0, 0], [0, 0]])
    K = np.array([[-6, 5, 7, 5], [0, -5, 3, -9]])

    F = A - np.dot(B, K)
    G = C - np.dot(D, K)
    print(F.tolist())
    print(G.tolist())

def probFour():
    A = np.array([[-0.7, -0.8, -0.6, -0.3], [-0.9, 0.9, 0.6, -0.9], [0.2, -0.4, -0.1, 0.2], [0.0, 0.5, 0.7, -0.9]])
    B = np.array([[-0.3, -0.1, -0.8], [0.3, 0.3, 0.8], [-0.1, 0.4, -0.1], [0.5, -0.6, 0.8]])
    C = np.array([[-0.9, 0.8, -0.3, -0.2]])
    D = np.array([[0.0, 0.0, 0.0]])
    K = np.array([[0.1, 0.4, -0.3, 0.9], [-0.4, 0.1, -0.5, 0.7], [-0.3, 0.8, 0.4, -0.3]])
    t0 = 0.6
    x0 = np.array([[-0.9], [-0.9], [-0.3], [-0.9]])
    t1 = 0.8

    F = A - np.dot(B, K)
    G = C - np.dot(D, K)

    x = np.dot(expm(F*(t1-t0)), x0)
    y = np.dot(G, x)

    print(x.tolist())
    print(y.tolist())

def probFive():
    A = np.array([[0.70, 0.70], [-0.50, -0.90]])
    B = np.array([[0.00], [0.70]])
    C = np.array([[-0.50, 0.60]])
    D = np.array([[0.00]])
    K = np.array([[0.50, 0.40]])
    t0 = 0.00
    x0 = np.array([[0.30], [0.90]])
    t1 = 2.70
    h = 0.09

    F = A - np.dot(B, K)
    G = C - np.dot(D, K)

    times = np.arange(t0, t1, h).tolist()
    yt = []
    print(times)
    for time in times:
        x = np.dot(expm(F * (time - t0)), x0)
        y = np.dot(G, x)
        yt.append(y[0][0].tolist())
    yf = [yt]
    print(yf)

def probSix():
    A = np.array([[0, 1], [5, 8]])
    B = np.array([[0], [1]])
    C = np.array([[0, 1]])
    D = np.array([[0]])
    K = np.array([[30, 0]])
    x0 = np.array([[7], [2]])
    t0 = 0

    t1 = Symbol('t')

    F = A - np.dot(B, K)
    G = C - np.dot(D, K)
    x = np.dot(expm(F*(t1-t0)), x0)
    y = np.dot(G, x)


    print(y)



if __name__ == '__main__':
    #probOne()
    #probTwo()
    #probThree()
    #probFour()
    probFive()
    #probSix()