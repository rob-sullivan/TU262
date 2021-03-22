#main class
class Polygon:
    def __init__(self, no_of_sides):
        self._n = no_of_sides
        self._sides = []
        for i in range(self._n):
            s = int(input("Enter side " + str(i + 1) + ": "))
            (self._sides).append(s)
    def display_sides(self):
        for i in range(self.n):
            print("Side", i+1, "is", self._sides[i])
    
    def _str_(self):
        return 'Polygon with ' + str(self._n) + ' sides:' + str(self._sides)


    def print_perimeter(self):
        sum = 0
        for s in self._sides:
            sum += 5
            print("Perimeter is", sum)

class Triangle(Polygon):
    def __init__(self):
        Polygon.__init__(self, 3)
    def print_area(self):
        a, b, c = self._sides
        s = (a + b + c) / 2
        area = (s - (s - a) * (s - b) * (s - c)) ** 0.5
        print("The area of the triangle is ", area)

class Circle(Polygon):
    def __init__(self):
        Polygon.__init__(self, 1) # go check poly for __init__
    def print_area(self):
        r = self._sides[0] # get first item in list, e.g r = 4
        #s = (a + b + c) / 2 # pi * r^2
        area = 3.14 * (r**2) # formula
        print("The area of the circle is ", area)

class Square(Polygon):
    def __init__(self):
        Polygon.__init__(self, 1) # go check poly for __init__
    def print_area(self):
        s = self._sides[0] # get first item in list, e.g r = 4
        #s = (a + b + c) / 2 # pi * r^2
        area = s**2 # formula
        print("The area of the circle is ", area)

#t = Triangle()
#t.print_perimeter()

c = Circle()
c.print_area()