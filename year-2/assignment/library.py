"""
Copyright 2021, C08345457, All rights reserved.
@author Robert O Sullivan <http://mailto:c08345457@mytudublin.ie> 

What is it:
This program is a simple implementation of a small library system using only dictionaries
to describe and keep track of books. No objects or classes are used.

How it works:
Each book has a unique ISBN (13 digit number), a title and an author.  
The library also keeps track of how many copies of the book are currently available to loan. 
Books can be borrowed and returned.

This program was made in Python3 3.8.8. python3 --version = 3.8.8

Installation & Running
 - pip3 install terminaltables # https://robpol86.github.io/terminaltables/install.html
 - pip3 install colorclass # https://pypi.org/project/colorclass/
 - python3 ./library.py


License
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
A copy of the GNU General Public License can be found at 
<http://www.gnu.org/licenses/>.


TODO(rob): Implement a Python function that searches the library for a book by the book title 
    and returns the book’s ISBN (Note: Assume that for every book title there is only one corresponding ISBN)

BUG(rob): When user hits enter during x = int(Input("prompt")) it gives a base 10 error
"""

# We install both terminaltables and colorClass to create a simple gui for the user in the terminal
from terminaltables import AsciiTable # we are using the ascii table layout.
from colorclass import Color, Windows # we are using color and windows to color the qty level in the terminal
# import only system from os 
from os import system, name 

# here we setup our initial dictionary of books. A min of 3 books were required.
# the schema is isbn-13 as key, [title, author, qty] as values
books = { 
    9780747581086:['Harry Potter and the Half-Blood Prince','J.K. Rowling',1],
    9780553573404:['A Game of Thrones: A Song of Ice and Fire','George R. R. Martin',0],
    9780345391803:['The Hitchhiker\'s Guide to the Galaxy','Douglas Adams',42],
    9780345391803:['The Da Vinci Code', 'Dan Brown', 3]
}

books_rented = { 
    9780553573404:['A Game of Thrones: A Song of Ice and Fire','George R. R. Martin',1],
}

"""
This function was taken from https://www.geeksforgeeks.org/clear-screen-python/ to
allow the terminal to be cleared when changing menus or showing the user important
messages
"""
# define our clear function 
def clear(): 
  
    # for windows 
    if name == 'nt': 
        _ = system('cls') 
  
    # for mac and linux(here, os.name is 'posix') 
    else: 
        _ = system('clear') 

def main_menu():
    clear()
    # main title
    print("**Welcome to" + Color("{autoblue} pyBook {/autoblue}") + "Library**")
    print("""
    Main Menu:

        1. Show Books
        2. Help

        *Press 0 to exit*
    """)
    try:
        x = int(input("Main Menu: Choose an option: ")) #try catch to make sure not null
        if(x == 0):
            clear()
            print("quitting " + Color("{autoblue}pyBook{/autoblue}") + "...")
            input("Press Enter to continue...")
            return False #set run to false and quit program
        elif(x == 1):
            show_books()
        elif(x == 2):
            print("show help")
        else:
            clear()
            print(Color("{autored}Not a valid choice. Try again{/autored}"))
            input("Press Enter to continue...")
            main_menu()
    except:
        clear()
        print(Color("{autored}Not a choice. Try again{/autored}"))
        input("Press Enter to continue...")
        main_menu()

def show_books():
    clear()
    # we setup the library table and its header
    library_table = [
        ['ISBN-13', 'Title', 'Author', 'Qty'],
    ]

    # we loop through books and add each book to the ascii table
    for isbn in books:
        #find and colour code quantity
        qty = "" # we set qty to zero then get the qty from dictionary
        if int(books[isbn][2]) > 1: # we set the colour based on stock level
            qty = Color("{autogreen}" + str(books[isbn][2]) + "{/autogreen}")
        elif int(books[isbn][2]):
            qty = Color("{autoyellow}" + str(books[isbn][2]) + "{/autoyellow}") # we want to warn the user that stock is low
        else:
            qty = Color("{autored}" + str(books[isbn][2]) + "{/autored}")

        b_row = [isbn, books[isbn][0], books[isbn][1], qty] # we add a book per row
        library_table.append(b_row) # we add a row to the table using append. which will add to end of dictionary
        library = AsciiTable(library_table) # we add the library table in an ascii table format

    library.title = Color("{autoblue} pyBook {/autoblue}") + " Library: Showing " + str(len(books)) + " Books"

    print(library.table + " \n") # we print our ascii table library
    print("""
    Library Menu:

        1. Rent a book
        2. Return a book
        3. Update book info
        4. Add a new book
        5. Delete a book

        *Press 0 to return to main menu*
    """)
    try:
        x = int(input("Library Menu: Choose an option: ")) #try catch to make sure not null
        if(x == 0):
            clear()
            print(Color("{autoblue}Returning to Main Menu{/autoblue}"))
            input("Press Enter to continue...")
            main_menu()
        elif(x == 1):
            rent_book()
        elif(x == 2):
            return_book()
        elif(x == 3):
            update_info()
        elif(x == 4):
            add_book()
        elif(x == 5):
            delete_book()
        else:
            clear()
            print(Color("{autored}Not a valid choice. Try again{/autored}"))
            input("Press Enter to continue...")
            show_books()
    except:
        x = 0
        return x

def rent_book():
    clear()
    # we setup the library table and its header
    library_table = [
        ['ISBN-13', 'Title', 'Author', 'Qty'],
    ]

    # we loop through books and add each book to the ascii table
    for isbn in books:
        #find and colour code quantity
        qty = "" # we set qty to zero then get the qty from dictionary
        if int(books[isbn][2]) > 1: # we set the colour based on stock level
            qty = Color("{autogreen}" + str(books[isbn][2]) + "{/autogreen}")
        elif int(books[isbn][2]):
            qty = Color("{autoyellow}" + str(books[isbn][2]) + "{/autoyellow}") # we want to warn the user that stock is low
        else:
            qty = Color("{autored}" + str(books[isbn][2]) + "{/autored}")

        b_row = [isbn, books[isbn][0], books[isbn][1], qty] # we add a book per row
        library_table.append(b_row) # we add a row to the table using append. which will add to end of dictionary
        library = AsciiTable(library_table) # we add the library table in an ascii table format

    library.title = Color("{autoblue}pyBook {/autoblue}") + " Library: Showing " + str(len(books)) + " Books"
    print(library.table + " \n") # we print our ascii table library

    # we setup the rented table and its header
    rented_table = [
        ['ISBN-13', 'Title', 'Author', 'Qty'],
    ]    
    # we loop through rented books and add each book to the ascii table if they exist
    if(len(books_rented) > 0):
        for isbn in books_rented:
            #find and colour code quantity
            # qty = Color("{autoblue}" + str(books_rented[isbn][2]) + "{/autoblue}")
            b_row = [isbn, books_rented[isbn][0], books_rented[isbn][1], books_rented[isbn][2]] # we add a book per row
            rented_table.append(b_row) # we add a row to the table using append. which will add to end of dictionary
    rented = AsciiTable(rented_table) # we add the library table in an ascii table format

    rented.title = Color("{autoblue}Rented{/autoblue}") + " Books : Showing " + str(len(books_rented)) + " Books"
    print(rented.table + " \n") # we print our ascii table library
    
    print("""
    Rent a book:
        - To rent a book, enter the ISBN-13 number and hit enter.
        *Press 0 return to library menu*
    """)
    
    try:#try catch to make sure not null or string
        x = int(input("ISBN-13: "))
        if(x == 0):
            clear()
            print(Color("{autoblue}Returning to Library Menu{/autoblue}"))
            input("Press Enter to continue...")
            show_books()
        elif(len(str(x)) == 13):
            
            # get book from book dictionary and check qty
            isbn = x
            qty = books[isbn][2]
            book_title = books[isbn][0]
            if(qty > 0): #book in stock let user rent it
                # ask user are they sure they want to rent
                x = int(input("Rent: " + book_title + "? (Yes: 1. No: 0): "))
                if(x == 0):
                    rent_book()
                elif(x == 1):       
                    # add book to rented dictionary7
                    books_rented[isbn] = [books[isbn][0],books[isbn][1], 1]
                    # deduct qty from book dictionary
                    qty -= 1
                    books[isbn][2] = qty
                    rent_book()
                else:
                    clear()
                    print(Color("{autored}Not a valid choice. Try again{/autored}"))
                    input("Press Enter to continue...")
                    rent_book()
            else: #book not in stock let user rent something else
                clear()
                print(Color("{autored}" + book_title + " is not available.. Try again{/autored}"))
                input("Press Enter to continue...")
                rent_book()
        else:
            clear()
            print(Color("{autored}ISBN must be 13 digits long. Try again{/autored}"))
            input("Press Enter to continue...")
            rent_book()
            
    except:
        clear()
        print(Color("{autored}Something went wrong. Try again{/autored}"))
        input("Press Enter to continue...")
        rent_book()

def return_book():
    clear()
    # we setup the library table and its header
    library_table = [
        ['ISBN-13', 'Title', 'Author', 'Qty'],
    ]

    # we loop through books and add each book to the ascii table
    for isbn in books:
        #find and colour code quantity
        qty = "" # we set qty to zero then get the qty from dictionary
        if int(books[isbn][2]) > 1: # we set the colour based on stock level
            qty = Color("{autogreen}" + str(books[isbn][2]) + "{/autogreen}")
        elif int(books[isbn][2]):
            qty = Color("{autoyellow}" + str(books[isbn][2]) + "{/autoyellow}") # we want to warn the user that stock is low
        else:
            qty = Color("{autored}" + str(books[isbn][2]) + "{/autored}")

        b_row = [isbn, books[isbn][0], books[isbn][1], qty] # we add a book per row
        library_table.append(b_row) # we add a row to the table using append. which will add to end of dictionary
        library = AsciiTable(library_table) # we add the library table in an ascii table format

    library.title = Color("{autoblue}pyBook {/autoblue}") + " Library: Showing " + str(len(books)) + " Books"
    print(library.table + " \n") # we print our ascii table library

    # we setup the rented table and its header
    rented_table = [
        ['ISBN-13', 'Title', 'Author', 'Qty'],
    ]

    # we loop through rented books and add each book to the ascii table if they exist
    if(len(books_rented) > 0):
        for isbn in books_rented:
            #find and colour code quantity
            # qty = Color("{autoblue}" + str(books_rented[isbn][2]) + "{/autoblue}")
            b_row = [isbn, books_rented[isbn][0], books_rented[isbn][1], books_rented[isbn][2]] # we add a book per row
            rented_table.append(b_row) # we add a row to the table using append. which will add to end of dictionary
    rented = AsciiTable(rented_table) # we add the library table in an ascii table format
    rented.title = Color("{autoblue}Rented{/autoblue}") + " Books : Showing " + str(len(books_rented)) + " Books"
    print(rented.table + " \n") # we print our ascii table library
    
    print("""
    Return a book:
        - To return a book, enter the ISBN-13 number of rented book and hit enter.
        *Press 0 return to library menu*
    """)
    
    try:#try catch to make sure not null or string
        x = int(input("ISBN-13: "))
        if(x == 0):
            clear()
            print(Color("{autoblue}Returning to Library Menu{/autoblue}"))
            input("Press Enter to continue...")
            show_books()
        elif(len(str(x)) == 13):
            # get book from rented book dictionary and check qty
            isbn = x
            qty = books_rented[isbn][2]
            book_title = books_rented[isbn][0]

            # ask user are they sure they want to rent
            x = int(input("Return: " + book_title + "? (Yes: 1. No: 0): "))
            if(x == 0):
                return_book()
            elif(x == 1):       
                # return rented book to books dictionary
                books[isbn] = [books[isbn][0],books[isbn][1], books[isbn][2] + 1]

                # deduct qty from rented book dictionary or remove it
                if(qty > 1):
                    books_rented[isbn][2] -= 1
                else:
                    books_rented.pop(isbn)
                return_book()
            else:
                clear()
                print(Color("{autored}Not a valid choice. Try again{/autored}"))
                input("Press Enter to continue...")
                return_book()
        else:
            clear()
            print(Color("{autored}ISBN must be 13 digits long. Try again{/autored}"))
            input("Press Enter to continue...")
            return_book()
            
    except:
        clear()
        print(Color("{autored}Something went wrong. Try again{/autored}"))
        input("Press Enter to continue...")
        return_book()

def update_info():
    clear()
    # we setup the library table and its header
    library_table = [
        ['ISBN-13', 'Title', 'Author', 'Qty'],
    ]
    # we loop through books and add each book to the ascii table
    for isbn in books:
        #find and colour code quantity
        qty = "" # we set qty to zero then get the qty from dictionary
        if int(books[isbn][2]) > 1: # we set the colour based on stock level
            qty = Color("{autogreen}" + str(books[isbn][2]) + "{/autogreen}")
        elif int(books[isbn][2]):
            qty = Color("{autoyellow}" + str(books[isbn][2]) + "{/autoyellow}") # we want to warn the user that stock is low
        else:
            qty = Color("{autored}" + str(books[isbn][2]) + "{/autored}")

        b_row = [isbn, books[isbn][0], books[isbn][1], qty] # we add a book per row
        library_table.append(b_row) # we add a row to the table using append. which will add to end of dictionary
        library = AsciiTable(library_table) # we add the library table in an ascii table format

    library.title = Color("{autoblue} pyBook {/autoblue}") + " Library: Showing " + str(len(books)) + " Books"

    print(library.table + " \n") # we print our ascii table library
    print("""
    Update a book:
        - To update a book, enter the ISBN-13 number and hit enter.
        *Press 0 return to library menu*
    """)
    try:#try catch to make sure not null or string
        x = int(input("ISBN-13: "))
        if(x == 0):
            clear()
            print(Color("{autoblue}Returning to Library Menu{/autoblue}"))
            input("Press Enter to continue...")
            show_books()
        elif(len(str(x)) == 13):
            # get book from book dictionary and check qty
            isbn = x
            book_title = books[isbn][0]
            book_author = books[isbn][1] 
            qty = books[isbn][2]
            # ask user are they sure they want to update
            x = int(input("Update: " + book_title + "? (Yes: 1. No: 0): "))
            if(x == 0):
                update_info()#return to the update book menu
            elif(x == 1):
                old_isbn = isbn
                #get updated ISBN from user or use existing
                x = input("ISBN: " + str(isbn) + ". New ISBN (Press enter to skip..): ")
                # clean up raw input to stop base 10 error
                if(x ==''):
                    x = 0
                else:
                    x = int(x)
                
                # now x is cleaned up
                if(x > 0):
                    if(len(str(x)) == 13):
                        isbn = x
                    else:
                        clear()
                        print(Color("{autored}ISBN must be 13 digits long. Try again{/autored}"))
                        input("Press Enter to continue...")
                        update_info()

                #get updated title from user or use existing
                x = ""
                x = str(input("Name: " + book_title + ". New Name (Press enter to skip..): "))
                if(x != ""):
                    book_title = x

                #get updated author from user or use existing
                x = ""
                x = str(input("Author: " + book_author + ". New Author (Press enter to skip..): "))
                if(x != ""):
                    book_author = x

                #get updated author from user or use existing
                x = 0
                x = int(input("Qty: " + str(qty) + ". New Qty (Press enter to skip..): "))
                # clean up raw input to stop base 10 error
                if(x ==''):
                    x = 0
                else:
                    x = int(x)
                    qty = x
                    ## error when skip, print
                # update book and add to books dictionary then remove old data
                books[old_isbn] = [book_title,book_author, qty]
                books[isbn] = books.pop(old_isbn) 
                update_info()
            else:
                clear()
                print(Color("{autored}Not a valid choice. Try again{/autored}"))
                input("Press Enter to continue...")
                update_info()
            
        else:
            clear()
            print(Color("{autored}ISBN must be 13 digits long. Try again{/autored}"))
            input("Press Enter to continue...")
            update_info()
    except:
        clear()
        print(Color("{autored}Something went wrong. Try again{/autored}"))
        input("Press Enter to continue...")
        update_info()

def add_book():
    clear()
    # we setup the library table and its header
    library_table = [
        ['ISBN-13', 'Title', 'Author', 'Qty'],
    ]
    # we loop through books and add each book to the ascii table
    for isbn in books:
        #find and colour code quantity
        qty = "" # we set qty to zero then get the qty from dictionary
        if int(books[isbn][2]) > 1: # we set the colour based on stock level
            qty = Color("{autogreen}" + str(books[isbn][2]) + "{/autogreen}")
        elif int(books[isbn][2]):
            qty = Color("{autoyellow}" + str(books[isbn][2]) + "{/autoyellow}") # we want to warn the user that stock is low
        else:
            qty = Color("{autored}" + str(books[isbn][2]) + "{/autored}")

        b_row = [isbn, books[isbn][0], books[isbn][1], qty] # we add a book per row
        library_table.append(b_row) # we add a row to the table using append. which will add to end of dictionary
        library = AsciiTable(library_table) # we add the library table in an ascii table format

    library.title = Color("{autoblue} pyBook {/autoblue}") + " Library: Showing " + str(len(books)) + " Books"

    print(library.table + " \n") # we print our ascii table library
    print("""
    Add a book:
        - To add a book, enter the ISBN-13 number and hit enter.
        *Press 0 return to library menu*
    """)
    try:#try catch to make sure not null or string
        x = int(input("New ISBN-13: "))
        if(x == 0):
            clear()
            print(Color("{autoblue}Returning to Library Menu{/autoblue}"))
            input("Press Enter to continue...")
            show_books()
        elif(len(str(x)) == 13):
            # get book from book dictionary and check qty
            isbn = x # we got the new isbn

            #get new title from user
            x = ""
            x = str(input("New Book Title: "))
            if(x != ""):
                book_title = x
            else:
                clear()
                print(Color("{autored}Book Title needed. Try again{/autored}"))
                input("Press Enter to continue...")
                add_book()

            #get updated author from user
            x = ""
            x = str(input("New Author Title: "))
            if(x != ""):
                book_author = x
            else:
                clear()
                print(Color("{autored}Book Author needed. Try again{/autored}"))
                input("Press Enter to continue...")
                add_book()

            #get qty of new book from user
            x = 0
            x = int(input("Qty: "))
            if(x ==''):
                x = 0
            else:
                x = int(x)
                qty = x


            # add new book to books dictionary
            books[isbn] = [book_title, book_author, qty]
            add_book()
            
        else:
            clear()
            print(Color("{autored}ISBN must be 13 digits long. Try again{/autored}"))
            input("Press Enter to continue...")
            add_book()
    except:
        clear()
        print(Color("{autored}Something went wrong. Try again{/autored}"))
        input("Press Enter to continue...")
        add_book()

def delete_book():
    clear()
    # we setup the library table and its header
    library_table = [
        ['ISBN-13', 'Title', 'Author', 'Qty'],
    ]
    # we loop through books and add each book to the ascii table
    for isbn in books:
        #find and colour code quantity
        qty = "" # we set qty to zero then get the qty from dictionary
        if int(books[isbn][2]) > 1: # we set the colour based on stock level
            qty = Color("{autogreen}" + str(books[isbn][2]) + "{/autogreen}")
        elif int(books[isbn][2]):
            qty = Color("{autoyellow}" + str(books[isbn][2]) + "{/autoyellow}") # we want to warn the user that stock is low
        else:
            qty = Color("{autored}" + str(books[isbn][2]) + "{/autored}")

        b_row = [isbn, books[isbn][0], books[isbn][1], qty] # we add a book per row
        library_table.append(b_row) # we add a row to the table using append. which will add to end of dictionary
        library = AsciiTable(library_table) # we add the library table in an ascii table format

    library.title = Color("{autoblue} pyBook {/autoblue}") + " Library: Showing " + str(len(books)) + " Books"

    print(library.table + " \n") # we print our ascii table library
    print("""
    Delete a book:
        - To add a book, enter the ISBN-13 number and hit enter.
        *Press 0 return to library menu*
    """)
    try:#try catch to make sure not null or string
        x = int(input("New ISBN-13: "))
        if(x == 0):
            clear()
            print(Color("{autoblue}Returning to Library Menu{/autoblue}"))
            input("Press Enter to continue...")
            show_books()
        elif(len(str(x)) == 13):
            # get book from rented book dictionary and check qty
            isbn = x
            book_title = books[isbn][0]

            # ask user are they sure they want to rent
            x = int(input("Delete: " + book_title + "? (Yes: 1. No: 0): "))
            if(x == 0):
                delete_book()
            elif(x == 1):       
                # delete book from books dictionary
                books.pop(isbn)
                delete_book() 
        else:
            clear()
            print(Color("{autored}ISBN must be 13 digits long. Try again{/autored}"))
            input("Press Enter to continue...")
            delete_book()
    except:
        clear()
        print(Color("{autored}Something went wrong. Try again{/autored}"))
        input("Press Enter to continue...")
        delete_book()

def search_library():
    print("search")
def show_help():
    print("**" + Color("{autoblue} pyBook {/autoblue}") + "Library Help Section**")
    print("""
        pyBook is an implementation of a small library of 3 books using a Python dictionary.
        You will be given options throughout the program. You either chose the option using your keypad
        or answer Yes/No questions with either the number 1 or zero.

        Known Issues:
            - BUG(rob): When user hits enter during x = int(Input("prompt")) it gives a base 10 error
    """)
    input("Press Enter to return to Main Menu...")
    clear()
    main_menu()

run = True #used to control main program, false will quit
while run:
    run = main_menu()