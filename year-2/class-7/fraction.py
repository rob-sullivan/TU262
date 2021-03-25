class Fraction():
    def __init__(self, num, denom):
        self._num = num
        self._denom = denom
        
    def __str__(self):
        return str(self._num) + '/' + str(self._denom)

    def __gcd__(self, bigger, smaller):
        if not bigger > smaller:
            bigger, smaller = smaller, bigger

        while smaller != 0:
            remainder = bigger % smaller
            bigger, smaller = smaller, reminder
        return bigger

    def __lcm__(self, a, b):
        return (a*b) // self._gcd(a, b)

    def __add__(self, fraction):
        if type(fract) == int:
            fract = Fraction(fract)
        if type(fract) == Fraction:
            the_lcm = self._lcm(self._denom, fraction._denom)
            numerator_sum = (the_lcm * self._num / self._denom) + (the_lcm * fraction._num / fraction._denom)
            return Fraction(ini(numerator_sum), the_lcm)
        else:
            print("Unkown type of parameter for +")
            raise TypeError
