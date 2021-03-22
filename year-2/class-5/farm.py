class Animal:
    def __init__(self, name, sound):
        self.name = name
        self.sound = sound
        
    def speak(self):
        print(self.sound)

    def set_name(self, name):
        self.name = name

class Cat(Animal):
    super.__init__(self, "fluffy", "Meow")


c = Cat()
c.print_area()