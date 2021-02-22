class Book:
    def __init__(self, title, author, isbn, category, isFiction, genre, publisher, released, quantity):
        self.title = title
        self.author = author
        self.isbn = isbn
        self.category = category
        self.isFiction = isFiction
        self.genre = genre
        self.publisher = publisher
        self.released = released
        self.quantity = quantity

    def __str__(self):
        return "| " + self.title + " | " + self.author + " | " + str(self.isbn) + " | " + self.category + " | " + self.isFiction + " | " + self.genre + " | " + self.genre + " | " + self.publisher + " | " + self.released + " | " + str(self.quantity) + " |"

b1 = Book("Man Who Didn't Call","Rosie Walsh",9.78151E+12,"Adult","Fiction","Contemporary", "Unknown", "01/05/2018",282)
print(b1)