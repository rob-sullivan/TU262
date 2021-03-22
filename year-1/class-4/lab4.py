#find and print all numbers between 2000 and 3200 (both included) which are divided by 7 and are not multiples of 5

""" for i in range(1999,3201):
    if (i % 5 != 0) and (i%7 == 0):
        print(i) """

s = input("Enter some text: ")
digits = 0
letters = 0
for c in s:
    if c.isdigit():
        digits += 1
    if c.isalpha():
        letters += 1
    
print("The number of digits is", count)
print("The number of letters is", letters)