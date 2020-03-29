from scipy.special import factorial as fact

def probFour():
    n = 11
    k = 7
    p = 0.75
    t = []
    for i in range(0, k):
        f = (fact(n)/(fact(i)*fact(n-i))) * p**i * (1-p)**(n-i)
        print(f)
        t.append(f)

    print(sum(t))

probFour()