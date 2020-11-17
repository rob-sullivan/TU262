#Exercise 1: Write a Python function to sum all numbers in a list.
def sumList(list):
    x = 0
    for i in list:
        x += i
    print("sum is: "+ str(x))

sumList([1,2,3,4])

#Exercise 2: Write a Python function to get the largest number from a list.
def maxList(list):
    x = 0
    for i in list:
        if i > x:
            x = i
    print("max is: " + str(x))

maxList([1,2,3,4])

#Exercise 3: Write a Python function that takes a list of words and counts how many of them begin with 'a'.
def countList(list):
    x = 0
    for i in list:
        a = i.find("a")
        if a == 0:
            x += 1
    print("words starting with a: " + str(x))

countList(["apple", "banana", "cherry"])
#Exercise 4: (modify Ex3) Write a Python function that takes a list of words and a character, and counts how many of the words in the list begin with that character.
#Exercise 5: Write a Python function that takes a list of numbers and returns a new list containing only the even numbers from the first list.