class Person:
    def __init__(self, name, age, address):
        self.name = name
        self.age = age
        self.address = address
        
    def __str__(self):
        return "Name is: " + self.name + ", age is " + str(self.age) + ", address is " + self.address

    def change_address(self, new_address):
        self.address = new_address

    def age_diff(self, some_person):
        return self.age - some_person.age
      
p1 = Person("John Smith", 20, "4 Green Road")
p2 = Person("Mary Rose", 25, "12 Amber Road")

print(p2)
