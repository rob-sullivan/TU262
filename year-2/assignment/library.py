from terminaltables import AsciiTable #pip3 install terminaltables # https://robpol86.github.io/terminaltables/install.html
from colorclass import Color, Windows #pip3 install colorclass # https://pypi.org/project/colorclass/

# here we setup our initial dictionary of books
# the schema is id,	title, author, isbn, publisher, qty
books = { 
    1:['Harry Potter and the Half-Blood Prince','J.K. Rowling','439785960','Scholastic Inc.','1'],
    2:['Harry Potter and the Order of the Phoenix','J.K. Rowling','439358078','Scholastic Inc.','2'],
    3:['Harry Potter and the Chamber of Secrets','J.K. Rowling','439554896','Scholastic','0'],
    4:['Harry Potter and the Prisoner of Azkaban','J.K. Rowling','043965548X','Scholastic Inc.','2'],
    5:['The Hitchhiker\'s Guide to the Galaxy','Douglas Adams','345453743','Del Rey Books','3']
}

def setup_gui(bs):
    # we setup the library table and its header
    book_table = [
        ['#', 'Title', 'Author', 'ISBN', 'Publisher', 'Qty'],
    ]

    # we loop through books and add each book to the table
    for b in bs:
        qty = ""
        if int(bs[b][4]) > 1:
            qty = Color("{autogreen}" + str(bs[b][4]) + "{/autogreen}")
        elif int(bs[b][4]):
            qty = Color("{autoyellow}" + str(bs[b][4]) + "{/autoyellow}")
        else:
            qty = Color("{autored}" + str(bs[b][4]) + "{/autored}")
            
        b_row = [b, bs[b][0], bs[b][1], bs[b][2], bs[b][3], qty] # we add a book per row
        book_table.append(b_row)

    return AsciiTable(book_table) # we return the library table in an ascii table format

def add_book():
    print("book to add")
    check_user_finished()
    

def show_books():
    library.title = "\n\npyBook Library: Showing " + str(len(books)) + " Books"
    print(library.table + " \n")
    check_user_finished()

def update_info():
    print("update book")
    check_user_finished()

def delete_book():
    print("delete book")
    check_user_finished()

def show_help():
    print("Help!")
    check_user_finished()

def check_user_finished():
    x = int(input("Quit or Return to Main Menu? (Return: 1, Quit: Any Other Num): "))
    if(x == 1):
        main_menu()

def main_menu():
    print("\n\n**Welcome to" + Color("{autoblue} pyBook {/autoblue}") + "Library**")
    print("""
    Choose an option:

        1. Show Books
        2. Update Book Information
        3. Add Book
        4. Delete Book
        5. Help

        *Press 0 to exit*
    """)
    try:
        x = int(input("Option: ")) #try catch to make sure not null
        if(x == 1):
            show_books()
        elif(x == 2):
            update_info()
        elif(x == 3):
            add_book()
        elif(x == 4):
            delete_book()
        elif(x == 5):
            show_help()
        else:
            check_user_finished()
    except:
        check_user_finished()

library = setup_gui(books)

main_menu()