"""
Exercise 1: The Fibonacci sequence is 
1, 1, 2, 3, 5, 8, 13, 21, 34, 55, … 
defined by beginning with two 1s and then adding the two previous numbers to get the next one. 

Write a function fib(n) that returns a list of the first n Fibonacci numbers. 

For example, fib(5) → [1, 1, 2, 3, 5]


def fib(n):
    a, b = 0, 1
    count = 0
    while count < x:
       print(a)
       c = a + b
       a = b
       b = c
       count += 1

x = int(input("How many Fibonacci terms? "))

fib(x)
"""

"""
Exercise 2: Happy numbers

A happy number is a number (a positive integer) defined by the following process: 
Starting with the number replace the number by the sum of the squares of its digits, and repeat the process until the number either equals 1 (where it will stay at 1 looping), or it reaches 4 (where it will also loop through a sequence of numbers 4, 16, 37, 58, 89, 145, 42, 20, 4). 
In this process you’ll always either reach either 1 or 4 (you can take this as a fact, no need to prove it)
Those numbers for which this process ends in 1 are happy numbers, while those that reach 4 are unhappy numbers (or sad numbers).
For example, 19 is happy, as
12 + 92 = 82        82 + 22 = 68        62 + 82 = 100             12 + 02 + 02 = 1

On the other hand, 24 is unhappy, as

22 + 42 = 20        22 + 02 = 4

The first twenty happy numbers are 1, 7, 10, 13, 19, 23, 28, 31, 32, 44, 49, 68, 70, 79, 82, 86, 91, 94, 97, 100.

Write a Python function that checks if a number is happy or unhappy.

def sum_sq_digits(n):
    sum = 0
    for i in str(n):
        sum += int(i)*int(i)
    return sum
    
print(sum_sq_digits(82))

def happy(n):
    while (n!=1 and n!=4):
        n = sum_sq_digits(n)
        print(n)
    if n == 1:
        return True
    else:
        return False
print(happy(19))
"""
"""

Exercise 3: Hangman
We’ll implement the game hangman where the program thinks of a secret word and the player has to guess it. There are different ways to implement this, here is one suggestion:
•	Word representation – you can use a list. 
Let’s say the secret word is ‘dublin’. 
o	Initially the word would be represented as [‘-‘, ‘-‘, ‘-‘, ‘-‘,‘-‘, ‘-‘] ( a list of 6 dashes). 
o	You can write a function to automatically generate the initial word based on the length of the secret word. 
o	You can also write a function to display the current guessed word nicer, e.g. ‘-ub-i-‘ instead of showing a list.
•	Write a function to check if a letter is in a word, and if it is, to replace the corresponding dash with that letter. For example if the user enters u as a guess, the current word should change from
[‘-‘, ‘-‘, ‘-‘, ‘-‘,‘-‘, ‘-‘]    to [‘-‘, ‘u‘, ‘-‘, ‘-‘,‘-‘, ‘-‘]
•	Write a function to check if the word is guessed (no dashes!)
•	You can also keep track of number of guesses and put a limit on those, e.g. 10 guesses, after which game is lost.
"""

def showBanner():
    print("""
██╗░░██╗░█████╗░███╗░░██╗░██████╗░███╗░░░███╗░█████╗░███╗░░██╗
██║░░██║██╔══██╗████╗░██║██╔════╝░████╗░████║██╔══██╗████╗░██║
███████║███████║██╔██╗██║██║░░██╗░██╔████╔██║███████║██╔██╗██║
██╔══██║██╔══██║██║╚████║██║░░╚██╗██║╚██╔╝██║██╔══██║██║╚████║
██║░░██║██║░░██║██║░╚███║╚██████╔╝██║░╚═╝░██║██║░░██║██║░╚███║
╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝░╚═════╝░╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝\n 
Welcome to Hangman in Python by Robert O Sullivan\n\n""")

def makeSecret(w):
    # turn word into - - - -
    answer = w
    secret_word = ""
    for c in answer:
        secret_word += "- "
    return secret_word


def guess(w):
    # guess word
    print(w)


def hint(w):
    # give player a hint
    print(w)


def game():
    quitGame = False
    attempts = 10

    #intro banner
    showBanner()
    word = str(input("Debug Mode - Enter a word to guess: "))
    word = makeSecret(word)

    #do while loop check if run if game not one
    while quitGame != True:
        #
        action = str(input(attempts + " attempts left. Type either guess, hint or quit: "))
        print (action)
        if action == "quit":
            quitGame = True
        elif action == "guess":
            print("guess...")
        elif action == "hint":
            print("hint...")
        else:
            print(action[10] + "... is not a valid action")

game()