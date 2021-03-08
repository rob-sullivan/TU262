def main_menu():
    x = int(input("main_menu Choose an option: ")) #try catch to make sure not null
    return x

def show_books():
    x = int(input("show_books Choose an option: ")) #try catch to make sure not null
    return x

def rent_books():
    x = int(input("rent_books Choose an option: ")) #try catch to make sure not null
    return x

run = True
while run:
    #do stuff
    choice = main_menu()
    if(choice == 1):
        # show books
        choice = show_books()
        print("show books")
        if(choice == 1):
            #rent book
            choice = rent_books()
            print("rent book")
            if(choice == 0):
                print("Win!")
                run = False
            else:
                pass
        elif(choice == 2):
            #return book
            run = False
        elif(choice == 3):
            #update info
            run = False
        elif(choice == 4):
            #add book
            run = False
        elif(choice == 5):
            #delete book
            run = False
        else:
            pass
    elif(choice == 2):
        # show help
        run = False
    else:
        run = False