class Car:

  def __init__(self, make, model, eng_size, eng_make):
    self._make = make
    self._model = model
    self._engine = Engine(eng_size, eng_make)
    self._tyres = []

  def add_tyre(self, tyre_depth, tyre_make):
    (self._tyres).append(Tyre(tyre_depth, tyre_make))

  def tyres_safe(self):
    for t in self._tyres:
      if not(t.is_safe()):
        return False

    return True

  def __str__(self):
    result = ""
    result += "Car make: " + self._make
    result += "\nCar model: " + self._model
    result += "\n"+str(self._engine)
    result += "\nTyres:\n"

    for t in self._tyres:
      result += str(t)+"\n"
    
    return result


class Engine:
  def __init__(self, size, make):
    self._size = size
    self._make = make

  def __str__(self):
    return "Engine size: "+self._size +" engine make: "+self._make


class Tyre:
  def __init__(self, depth, make):
    self._depth = depth
    self._make = make

  def is_safe(self):
    return (self._depth >= 1.6)

  def __str__(self):
    return "Tyre make:" + self._make +" depth:" + str(self._depth)

#main

car1 = Car("Nissan", "Micra", "1.0", "superengine")
car1.add_tyre(1.7, "tyremake1")
car1.add_tyre(1.8, "tyremake1")
car1.add_tyre(1.8, "tyremake1")
car1.add_tyre(1.7, "tyremake1")

print(car1)
print(car1.tyres_safe())