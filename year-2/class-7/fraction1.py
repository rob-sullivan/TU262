class Fraction():

    def __init__(self, num, denom=1):
        self._num = num
        self._denom = denom

    def __str__(self):
        return str(self._num) + '/' + str(self._denom)

    def _gcd(self, bigger, smaller):
        """Calculate the greatest common divisor of two positive integers . """
        if not bigger > smaller:
            # swap If necessary so bigger > smaller
            bigger, smaller = smaller, bigger

        while smaller != 0:    # 1. if smaller == 0, halt
            # 2. find remainder
            remainder = bigger % smaller
            bigger, smaller = smaller, remainder

        return bigger

    def _lcm(self, a, b):
        """Calculate the lowest common 	multiple of two positive integers . """

        # From the previous equation,
        # // ensures an int is returned
        return (a*b) // self._gcd(a,b)

    def __add__(self, fract):

        if type(fract) == int:
            fract = Fraction(fract)

        if type(fract) == Fraction:
            # find a common denominator (lcm)
            the_lcm = self._lcm(self._denom, fract._denom)

            # multiply each by the lcm, then add
            numerator_sum = (the_lcm * self._num / self._denom) + (the_lcm * fract._num / fract._denom)

            return Fraction(int(numerator_sum), the_lcm)
        else:
            #for any other type the + is not defined
            print("Unknown type of parameter for +")
            raise TypeError

    def __radd__(self, fract):
        return self.__add__(fract)

    def __sub__(self, fract):
        """ Subtract two fractions """

        # subtract is the same but with '−' instead of '+'
        the_lcm = self._lcm(self._denom, fract._denom)
        numerator_diff = (the_lcm * self._num / self._denom) - (the_lcm * fract._num / fract._denom)

        return Fraction(int(numerator_diff), the_lcm)

    def _reduce_fraction(self):
        """ Return the reduced fractional value as a Fraction object """

        # find the gcd and then divide numerator and
        # denominator by gcd
        the_gcd = self._gcd(self._num, self._denom)
        return Fraction(self._num // the_gcd, self._denom // the_gcd)

    def __eq__(self, fract):
        """ Compare two Fractions for equality , return Boolean"""

        # reduce both; then check that numerators and
        # denominators are equal

        reduced_self = self._reduce_fraction()
        reduced_param = fract._reduce_fraction()

        return reduced_self._num == reduced_param._num and reduced_self._denom == reduced_param._denom



if __name__ == "__main__":
    # f1 = Fraction(1, 2)
    # f2 = Fraction(2, 3)
    #
    # f3 = f1 + f2
    # print(f1, '+', f2, '=', f3)
    #
    # f4 = f2 - f1
    # print(f2, '-', f1, '=', f4)
    #
    # print('1/2 == 2/4', Fraction(1, 2) == Fraction(2, 4))
    # print(Fraction(1, 3) == Fraction(2, 4))
    #
    # print('test adding int', Fraction(1, 2) + 1)

    # f5 = Fraction(5)
    # print(f5)

    print('test adding int swapped', 1 + Fraction(1, 3))

