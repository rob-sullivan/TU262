# Exercise 1: Write a program which will finds and prints all numbers between 2000 and 3200 (both included)
# which are divisible by 7 but are not a multiple of 5.
#

# for i in range(2000,3201):
#     if (i%7==0) and (i%5!=0):
#         print (i)


# Exercise 2: Write a Python program that will count how many digits (0-9) are in a string entered by the user.
# Hint: To check if a string c represents a digit you can check if c is between ‘0’ and ‘9’
# Alternative way would be to use c.isDigit() which returns True if c represents a digit and False otherwise.
# You’ll need to use a loop to get every character of the string.
#

# s = input("Please enter a string: ")
# count = 0
# for c in s:
#     if (c>='0') and (c<='9'):      # or alternatively if c.isdigit():
#         count+=1
# print(count)


# Exercise 3: Extend your program from Exercise 2 and write a program to count how many digits (0-9)
# and how many letters (a-z or A-Z) are in a sentence entered by the user.
#

# s = input("Please enter a string: ")
# dig_count = 0
# letter_count = 0
# for c in s:
#     if (c>='0') and (c<='9'):
#         dig_count+=1
#     elif (c>='a') and c<='z':
#         letter_count+=1
#     elif (c>='A') and c<='Z':
#         letter_count+=1
# print("Letters: ", letter_count, "Digits: ", dig_count)


# Exercise 4: Write a Python program to find and print the sum of digits of a number entered by the user.
# Hint: There are different ways of approaching this problem. One way would be to read the number as a string
# and use a loop to iterate over it to get each digit.
#

# number_s = input("Enter a number: ")
# sum = 0
# for c in number_s:
#     sum = sum + int(c)
# print (sum)


# -- With Error checking
# 
# number = input("Enter a number: ")
# while not(number.isdigit()):
#   number = input("Not a number. Try again. Enter a number: ")


# total = 0

# for c in number:
#   print(c) 
#   total = total + int(c)

# print("Total sum of digits is", total)

# Exercise 5: Write a Python program to keep asking the user to enter positive numbers and terminates
# when they enter a negative. When the program terminates, print how many positive numbers were entered
# and what was the smallest number.
# Hint: You can use a while-loop to keep asking the user to enter a number, the loop will keep going
# while they enter a value >0. Once the loop is working correctly see how you’d add a condition to keep
# track of the current smallest value and update it when a smaller value is found.
#

# number = int(input("Enter a number: "))
# count_pos = 0
# smallest_number = number

# while (number >= 0):
#   if number >=0:
#     count_pos += 1
  
#   if (number < smallest_number):
#     smallest_number = number

#   number = int(input("Enter another number: "))

# print("Number of positive numbers:", count_pos)
# print("Smallest number:", smallest_number)

# print("Good bye!")
