class Rectangle:
    # Init function
    def __init__(self):
        # The only members are length and width
        self.length = 1
        self.width = 1

    def setWidth(self, width):
        self.width = width

    def setLength(self, length):
        self.length = length

    def area(self):
        return self.length * self.width

    def perimeter(self):
        return 2 * self.length + 2 * self.width

    def __str__(self):
        return 'length = {}, width = {}'.format(self.length, self.width)