"""
file: OOSD_LabTest2_2020_21_Q1.py
date: 15-Dec-20
author: Robert O'Sullivan
description: Lab test 2 for OOSD Python version 3.7.4 used
"""

"""
QUESTION 1:
Write a Python function that takes a list of numbers and returns a new list that contains only the numbers greater than 30 and divisible by 3.

SAMPLE INPUT AND OUTPUT:
For example, for the list [34, 12, 1, 16, 39, 44, 11, 57, 44, 3] your function should return [39, 57]

"""

n = [34, 12, 1, 16, 39, 44, 11, 57, 44, 3] #should return [39 57]

#we create a function that takes in a list as a parameter
def greater_30_divided_by_3(list_of_nums):
    """local to this function we create an empty list
    this will be used to store our new values"""
    new_list = []
    """we only need one loop. First check will be values
    greater than 30. Then we will make use of mod to check if
    the value is a whole number or not."""
    for num in list_of_nums:
        if num>30:
            if num % 3 == 0:
                #if greater than 30 and whole number (div by 3), we add to new list
                new_list.append(num)
    """we now return the new list to the user 
    to do whatever they want with it"""
    return str(new_list)

#in this case the user prints to the console.
print(greater_30_divided_by_3(n))