class Recipe:

    def __init__(self, name):
        self._name = name
        self._method = ''
        self._ingredients = []

    def add_method(self, method):
        self._method = method

    def add_ingredient(self, ingredient):
        (self._ingredients).append(ingredient)

    def add_ingredients(self, ingredients):
        (self._ingredients).extend(ingredients)

    def print_recipe(self):
        print("Name:", self._name)
        print("Ingredients:", self._ingredients)
        print("Method:", self._method)

    def contains(self, ingredient):
        for i in self._ingredients:
            if ingredient in i:
                return True
        return False

class RecipeBook():

    def __init__(self):
        self._recipes = []

    def add_recipe(self, r):
        self._recipes.append(r)


    def print_all_recipes(self):
        for r in self._recipes:
            r.print_recipe()
            print()

    def all_contain(self, ingredient):
        print("All recipes that contain", ingredient)
        for r in self._recipes:
            if r.contains(ingredient):
                r.print_recipe()
                print()



##

r = Recipe("Muffins")
r.add_ingredient("2 eggs")
r.add_ingredient("100g butter")
r.add_ingredient("140g sugar")
r.add_ingredient("tsp baking powder")
r.add_ingredient("150g self-raising flour")

r.add_method("Mix butter and sugar together. Add eggs. Add the rest of the ingredients. Bake at 180C for 20 minutes")



r1 = Recipe("Pitta bread")
r1.add_ingredient('water')
r1.add_ingredients(["2 tsp fast-action dried yeast", "500g strong white bread flour", "2 tsp salt", "1 tbsp olive oil"])
r1.add_method("Mix yeast with warm water. Let rise. Add all ingredients together. Form small balls of dough. Strech and cook.")


my_recipe_book = RecipeBook()

my_recipe_book.add_recipe(r)
my_recipe_book.add_recipe(r1)

my_recipe_book.all_contain("milk")