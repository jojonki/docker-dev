import numpy as np

from affine import Affine
from activations import Sigmoid


class TwoLayerNet:
    def __init__(self, in_size, h_size, o_size):
        I, H, O = in_size, h_size, o_size

        W1 = np.random.randn(I, H)
        b1 = np.random.randn(H)
        W2 = np.random.randn(H, O)
        b2 = np.random.randn(O)

        self.layers = [
            Affine(W1, b1),
            Sigmoid(),
            Affine(W2, b2)
        ]

        self.params = []
        for layer in self.layers:
            self.params += layer.params


    def predict(self, x):
        for layer in self.layers:
            x = layer.forward(x)

        return x


def main():
    x = np.random.randn(10, 2)
    model = TwoLayerNet(2, 4, 3)
    s = model.predict(x)
    print('out:', s)


if __name__ == '__main__':
    main()
