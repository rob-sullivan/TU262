class Shape:
    def __init__(self, sides):
        self._sides = sides
        self._shape = Point(sides)
    def __str__(self):
        return str(self._shape)

    def area(self):
        print("area here..")

class Point:
    def __init__(self, sides):
        self._sides = sides
        self._shape_name = ""
        if(self._sides == 1):
            self._shape_name = "Circle"
        elif(self._sides == 2):
            self._shape_name = "Line"
        elif(self._sides == 3):
            self._shape_name = "Triangle"
        elif(self._sides == 4):
            self._shape_name = "Square"
    
    def __str__(self):
      return "Shape: " + self._shape_name + ", Number of sides: " + str(self._sides) + "\n"

class Triangle(Point):
    def __init__(self, sides):
        self._sides = sides
        self._shape_name = ""
        if(self._sides == 1):
            self._shape_name = "Point"
        elif(self._sides == 2):
            self._shape_name = "Line"
        elif(self._sides == 3):
            self._shape_name = "Triangle"
        elif(self._sides == 4):
            self._shape_name = "Square"
    
    def __str__(self):
      return "Shape: " + self._shape_name + ", Number of sides: " + str(self._sides) + "\n"

shape1 = Shape(3)
shape2 = Shape(4)
shape3 = Shape(2)
shape4 = Shape(1)

print(shape1)
print(shape2)
print(shape3)
print(shape4)