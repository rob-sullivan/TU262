"""
file: lab-test-1-q1.py
date: 27-Oct-20
author: Robert O'Sullivan
description: Lab test 1 for OOSD Python version 3.7.4 used
"""

"""
QUESTION 2:
Write a python program that asks the user to keep entering words and terminates when the user enters a ‘*’. 
When the program terminates it should print how many of the words start and end with the same letter.
"""
# first we set our vars
words = "" #used to store text from the user
x = False #used as trigger to stop program (* was found)
n = 0 #used as counter

# we keep running the program until the user quits using *
while x != True:
    if len(words) == 0: #is this the first time for the user
      #if so we ask user to enter a word and tell them how to exit when they want
      txt = input("Welcome! Enter a word (enter * to exit): ")
    else:
      #if not we ask user to enter another word and remind them how to exit when they want
      txt = input("Enter another word (enter * to exit): ")
    x = "*" in txt #check here for *
    if x != True: #user wants to keep going so we check the word they entered
      first_char = txt[0]
      last_char = txt[-1:]
      #we got the first and last character, now we compare
      if first_char == last_char:
        #we increment the counter if the first and last letters match
        n += 1
      #we add the word to our words string with a space
      words += " "
      words += txt
else:
  #user quit so tell them why the program stopped and show them the counter result
  print("* pressed, program terminated")
  print(str(n) + " words started and ended with the same letter")
