#list of books taken from cork library: https://data.gov.ie/dataset/most-borrowed-items/resource/f406b891-1ba6-4ed9-b299-19e31c6008e6
inventory = { 
1:['Harry Potter and the Half-Blood Prince','J.K. Rowling','439785960','Scholastic Inc.','1'],
2:['Harry Potter and the Order of the Phoenix','J.K. Rowling','439358078','Scholastic Inc.','2'],
4:['Harry Potter and the Chamber of Secrets','J.K. Rowling','439554896','Scholastic','0'],
5:['Harry Potter and the Prisoner of Azkaban','J.K. Rowling','043965548X','Scholastic Inc.','2'],
13:['The Hitchhiker\'s Guide to the Galaxy','Douglas Adams','345453743','Del Rey Books','3']

    }

#bookID	title	authors	average_rating	isbn	isbn13	language_code	  num_pages	ratings_count	text_reviews_count	publication_date	publisher


def addBook():
    print("book to add")

def showBooks():
    print("\n--- Showing " + str(len(inventory)) + " Books---\n")
    for a in inventory.values():
        print("Title: " + a[0] + "\n" + "Author: " + a[1] + "\n" + "ISBN: " + a[2] + "\n" + "Publisher: " + a[3] + "\n" + "Qty: " + a[4] + "\n")

def updateBookInfo():
    print("update book")

def deleteBook():
    print("delete book")

def returnMainMenu():
    x = int(input("Return to Main Menu? (Yes: 1, No: 0): "))
    if(x == 1):
        mainMenu()

def mainMenu():
    print("**Welcome to pyBook Library**")
    print("""
    Choose an option:
        0. Exit
        1. Show Books
        2. Update Book Information
        3. Add Book
        4. Delete Book
    """)
    x = int(input("Option: "))
    if(x == 0):
        print("Exited Program")
        quit()
    elif(x == 1):
        showBooks()
        returnMainMenu()
    elif(x == 2):
        updateBookInfo()
        returnMainMenu()
    elif(x == 3):
        addBook()
        returnMainMenu()
    elif(x == 4):
        deleteBook()
        returnMainMenu()
    else:
        print("Not a valid option")
        returnMainMenu()

mainMenu()