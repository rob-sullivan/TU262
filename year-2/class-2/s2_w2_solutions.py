# Exercise 1A: Write a Python program to create a dictionary of contact details – using name and office number.

# contacts  = { ‘john”:”K22”, “mary”:”K21”, “ann”:”K22”, … }

# Write a function that takes a dictionary and an office number, and returns the names of all people in that office.

contacts  = {'john':'K22', 'mary':'K21', 'ann':'K22', 'brian':'K23', 'paul':'K21' }

def people_in_office(d1, office_n):
    
    result = []
    
    for name in d1:
        if d1[name] == office_n:
            #print(name, d1[name])
            result.append((name, d1[name]))
    return result

print(people_in_office(contacts, "K22"))


# Exercise 1B: Write a Python program to create a list of contact details – using name, phone number and office number.
# Write a function that takes a dictionary and an office number, and returns a list of the names of all people in that office.


contacts  = {'john':['202-133','K22'], 
             'mary':['202-134','K21'], 
             'ann': ['202-135','K22'], 
             'brian':['202-136','K23'], 
             'paul':['202-137','K21'] }

def people_in_office(d1, office_n):
    
    result = []
    
    for name in d1:
        if d1[name][1] == office_n:
            result.append(name)
    return result

print(people_in_office(contacts, "K25"))


# Exercise 2: Using the contact list from Exercise 1 write a python function that prints all people whose name begins with a specific character. 

contacts  = {'john':'K22', 'mary':'K21', 'ann':'K22', 'brian':'K23', 'paul':'K21', 'molly':'K23'}


def starts_with(d, letter):
    for name in contacts:
        if name[0] == letter:
            print(name, d[name])
            
starts_with(contacts, 'm' )



#Exercise 3

inventory = {'apple':20, 'banana':50, 'orange':10}

def total(d):
    total_number = 0
    
    for item in d:
        total_number += d[item]
        
    return total_number
    
#print(total(inventory))

def stock_up(d, item, quantity):
    if item in d:
        d[item] += quantity
    else:
        d[item] = quantity
        

print(inventory)
stock_up(inventory, 'orange', 10)
print(inventory)
stock_up(inventory, 'kiwi', 20)
print(inventory)      