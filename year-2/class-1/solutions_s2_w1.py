
# Exercise 1: The Fibonacci sequence is 
# 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, … 
# defined by beginning with two 1s and then adding the two previous numbers to get the next one. 

# Write a function fib(n) that returns a list of the first n Fibonacci numbers. 

# For example, fib(5) → [1, 1, 2, 3, 5]

def fib(n):
    result = [1, 1]
    for i in range(n-2):
        next_number = result[-1] + result[-2]
        result.append(next_number)
        
    return result
    
print(fib(20))


#----
# Exercise 2: Happy numbers

def sum_sq_digits(n):
    
    sum = 0
    for i in str(n):
        sum += int(i)*int(i)

    return sum
    
def happy(n):
    while (n!=1 and n!=4):
        n = sum_sq_digits(n)
        #print(n)
    
    # if n == 1:
    #     return True
    # else:
    #     return False
        
    return n == 1 #same as above

print(happy(19))

#-----------
# Exercise 3 - start

# secret_word = 'dublinina'
# guess = ['-', '-', '-', '-', '-', '-', '-', '-', '-']

secret_word = 'dublin'
guess = ['d', 'u', '-', 'l','i', 'n']


def print_guess(guess):
    print(guess)
    #modify this function to print the current word prettier
    #e.g -u----
    
    
def check_letter(letter):
    for index in range(len(secret_word)):
        if letter == secret_word[index]:
            #that letter is in the secret word
            guess[index] = letter
    
    print(guess)      
    return guess

def guessed():
    return (not ('-' in guess))
    
    
#check_letter('i')
print(guessed())
print(guess)
