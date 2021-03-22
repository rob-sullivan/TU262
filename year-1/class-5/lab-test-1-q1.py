"""
file: lab-test-1-q1.py
date: 27-Oct-20
author: Robert O'Sullivan
description: Lab test 1 for OOSD Python version 3.7.4 used
"""

"""
QUESTION 1:
Write a python program that asks the user to enter a number and prints if the number is a narcissistic number or not. A narcissistic number is a number that is equal to the sum of the cube of its digits.
For example, 153 is a narcissistic number, as 13 + 53 + 33 = 1 + 125 + 27 = 153.  
Another narcissistic number is 370, as 33 + 73 + 03 = 27 + 343 + 0 = 370	
"""

#here we ask the user to enter a number
num = input("Enter next number to check if it is a narcissistic number: ")

"""
we need to get the length of the number so we make use of strings
to quickly determine this

We then also then intial result to zero. We will later check this
"""
num_length = int(len(str(num)))
result = 0

#we loop through the num as a string and convert to integer each digit
for c in str(num):
  result += int(c) ** num_length # We get nth to the power of the digit

#now we print if the number is a narcissistic number or not
if(result == num):
    print(str(num)  + " is a narcissistic number.")
else:
    print(str(num)  + " is not a narcissistic number.")