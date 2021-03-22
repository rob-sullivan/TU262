#Exercise 1
def numberCounter(n):
    for i in range(1, (n+1)):
        print(i)
num = int(input("Ex1 - Enter a number: "))
numberCounter(num)

#Exercise 2
def evenChecker(n):
    for i in range(1, (n+1)):
        if (i % 2) > 0:
            print(i, "is odd")
        else:
            print(i, "is even")
num = int(input("Ex2 - Enter a number: "))
evenChecker(num)

#Exercise 3
def nineMultiplier(n):
    for i in range(1, (n+1)):
        i*=9
        print(i)
num = int(input("Ex3 - Enter a number: "))
nineMultiplier(num)

#Exercise 4
def adder(n):
    sum = 1
    for i in range(1, (n+1)):
        sum +=i
        print(sum)
num = int(input("Ex4 - Enter a number: "))
adder(num)

#Exercise 5
def factorialChecker(n):
    f = 1
    # check if the number is negative, positive or zero
    if num < 0:
        print("null for < 0")
    elif num == 0:
        print("factorial is 1")
    else:
        for i in range(1,num + 1):
            f = f*i
        print(num,"factorial is",f)

num = int(input("Ex5 - Enter a number: "))
factorialChecker(num)

#Exercise 6
def WordSlicer(t):
    t = t[:2]+t[-2:]
    if len(t) >=2:
        print(t)

txt = input("Ex6 - Enter a word: ")
WordSlicer(txt)

#Exercise 7
def oddSlicer(t):
    #removes the characters which have odd index values 
    word = ""
    index = 0
    for c in t:
        index = t.find(c)
        if (index % 2) <= 0:
            word += c
    print(word)

txt = input("Ex7 - Enter a word: ")
oddSlicer(txt)

#Exercise 8
def string_first_half(t):
    #get first half of string
    t = t.split(" ", 1)
    t = t[0]
    #removes the characters which have odd index values 
    word = ""
    index = 0
    for c in t:
        index = t.find(c)
        if (index % 2) == 0:
            word += c
    print(word)

txt = input("Ex8 - Enter a word: ")
string_first_half(txt)

#Exercise 9
insert_sting_middle(a,b):
    c = a[:2] + b + a[2:]
    print(c)

surString = input("Ex8a - Enter surrounding string: ")
midString = input("Ex8b - Enter middle string: ")
insert_sting_middle(surString,midString)


#Exercise 10
txt = input("Ex10 - Enter a string: ")
begin = 5
end = 10
# Remove charactes from index 5 to 10
def remove_string(t):
    if len(t) > end :
        t = t[0: begin:] + t[end + 1::]
    print(t)
remove_string(txt)