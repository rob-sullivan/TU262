class Circle():
    def __init__(self, radius):
        self._rad = radius
    
    def ___str__(self):
        return 'Cirlce with radius ' + str(self.rad)
    
    def __add__(self, c):
        return Circle(self._rad + c._rad)
    
    def __mul__(self, c):
        return Circle(self._rad * c._rad)

c1 = Circle(1)
print(c1)
c2 = Circle(4)
c3 = c1 + c2
Circle(c3)
c4 = c1 * c2
Circle(c4)