"""
file: OOSD_LabTest2_2020_21_Q2.py
date: 15-Dec-20
author: Robert O'Sullivan
description: Lab test 2 for OOSD Python version 3.7.4 used
"""

"""
QUESTION 2:
(a)	[20 marks] Write a Python function that will take a string and will reverse every second word if the length of the word is even. 
You can ignore punctuation (consider it part of the word)
a_string = "Rudolph the Red-Nosed Reindeer Had a very shiny nose And if you ever saw it You would even say it glows"
Reindeer
"""
s = "And if you ever saw it" # first we set our string

#we create a function that passes a string as a parameter
def reverse__second_even_words(a_string):
    #we create a counter to get the index of the word
    c = 0 #counter set to zero
    #we lower the letters to remove chance of error from cap word
    a_string = a_string.lower()
    #we now split our string into a list
    a_string = a_string.split(" ")

    #we loop through each word in the list
    for word in a_string:
        c += 1 #increment our counter
        #we check if our counter is even (i.e it's the second word)
        if c%2 ==0:
            #we now check if the secnd word is even or odd
            if len(word) % 2 == 0:
                #if it's an even word we reverse the word
                new_word = ''.join(reversed(word))
                #and add the new reversed word to replace the old
                a_string[c-1] = new_word
    #we return the new string to the user to do with as they please
    new_string = ' '.join(a_string)
    return str(new_string)
print("Q2 a: " + reverse__second_even_words(s))
#print("after: " + str(a_string))

"""
(b)	[10 marks] Use the function from part (a) in a program, that reads text from a file file_input.txt and reverses every second word in each line if the length of that word is an even number. 

Save the “reversed” text in a second file called file_output.txt.

sample = 
Rudolph the Red-Nosed Reindeer
Had a very shiny nose
And if you ever saw it
You would even say it glows


result = 
Rudolph the Red-Nosed reednieR 
Had a very shiny nose
Rudolph the Red-Nosed reednieR 
Had a very shiny nose
And fi you reve saw ti
You would even say it glows
"""
 # we contain this file read and write in a try catch
 # this is to stop any errors if the file has some issue
try:
    #first we get and read the input file
    input_file = open("file_input.txt", 'r') 
    #second we get and set the output file to write
    #this will be created if it doesn't exist
    file_output = open("file_output.txt", 'w')

    #noew we loop through each line of the input file
    for line in input_file:
        #for some reason /n new line is added when we read
        #python has a strip command (https://www.w3schools.com/python/ref_string_strip.asp)
        line = line.strip() #remove empty lines from file
        #now we write to the output file using our function
        # we created earlier in part (a)
        print(reverse__second_even_words(line), file=file_output)
    #now we are done so we close both files
    input_file.close()
    file_output.close()
    print("Q2 b: output file successfully created.")
#we return an error message to the user if something goes wrong with the file
except IOError:
    print ("Something went wrong. Check that the input file exists and not corrupted.")