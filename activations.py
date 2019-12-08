import numpy as np


class Sigmoid:
    def __init__(self):
        self.params = []

    def forward(self, x):
        return 1 / (1 + np.exp(-x))


if __name__ == '__main__':
    x = np.random.randn(10, 2)
    W1 = np.random.randn(2, 4)
    b1 = np.random.randn(4)
    W2 = np.random.randn(4, 3)
    b2 = np.random.randn(3)

    h = np.dot(x, W1) + b1 # (10, 4)
    a = sigmoid(h) # (10, 4)
    s = np.dot(a, W2) + b2 # (10, 3)
    print(s)
