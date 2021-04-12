class ComplexNumber:

    def __init__(self, real, imaginary=0):
        self._real = real
        self._imag = imaginary

    def __str__(self):   # 5 + 3i
        return str(self._real) + " + " + str(self._imag) + "i"

    def __add__(self, c):

        # result_real = self._real + c._real
        # result_imag = self._imag + c._imag
        #
        # return ComplexNumber(result_real, result_imag)

        if type(c) == int:
            c = ComplexNumber(c)

        return ComplexNumber(self._real + c._real, self._imag + c._imag)

    def __radd__(self, c):
        return self.__add__(c)

if __name__ == "__main__":
    c1 = ComplexNumber(5,3)
    print(c1)
    #c2 = ComplexNumber(2,1)
    #print(c1+c2)
    print(c1 + 5)
    print(2 + c1)