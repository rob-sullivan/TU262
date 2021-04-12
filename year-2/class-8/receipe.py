#!/usr/bin/env python
#https://www.bbcgoodfood.com/recipes/best-ever-chocolate-brownies-recipe
class Recipe(Ingredients):
  def __init__(self, name, description, method):
    self.name = name
    self.description = description
	self.ingredients_needed = Ingredients.getItems()
	self.method = method
	
class Ingredients():
	def __init__(self):
		self.name = ""
		self.items = {}
		
	def addItem(self, item_name, item_amt):
		self.items[item_name] = item_amt
		
	def getItems(self, items):
		ingredients = ""
		for name, amount in items.items():
			ingredients += amount + " " + name + "\n"
		return ingredients
	