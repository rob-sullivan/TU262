"""
Exercise 1A: Write a Python program to create a list of contact details – using name and office number.
contacts  = { ‘john”:”K22”, “mary”:”K21”, “ann”:”K22”, … }
Write a function that takes a dictionary and an office number, and returns the names of all people in that office.

"""
contacts = {
    'John' : 'K22', 
    'Mary' : 'K21', 
    'Ann' : 'K22'
    }

def getContact(o,c):
  for key in c:
    if c[key] == o:
      print("ex1a - " + key + " works in " + o + " department")

getContact('K21', contacts)

"""
Exercise 1B: Write a Python program to create a list of contact details – using name, phone number and office number.
Write a function that takes a dictionary and an office number, and returns a list of the names of all people in that office.
"""
contacts = {
    'John' : ['352-1234', 'K1-25'], 
    'Mary' : ['352-1235', 'K1-25'], 
    'Alan' : ['352-1236', 'K1-30'],
    'Kate' : ['352-1237', 'K1-35'],
    }

def getContact(n,c):
  for i in c:
    if c[i][0] == n:
        x = c[i][1]
        for j in c:
          if c[j][1] == x:
            print("ex1b - " + j + " works in " + x + " department")


getContact('352-1234', contacts)

"""
Exercise 2: Using the contact list from Exercise 1 write a python function that prints all people whose name begins with a specific character. 
Your function will take two parameters – the character and the dictionary.
"""
contacts = {
    'John' : ['352-1234', 'K1-25'], 
    'Mary' : ['352-1235', 'K1-25'], 
    'Alan' : ['352-1236', 'K1-30'],
    'Kate' : ['352-1237', 'K1-35'],
    }

def getContact(c,d):
  for key in d:
    for l in key:
      a = l.lower()
      b = c.lower()
      if a == b:
        print("ex2 - " + key) #counts any letter so will print alan twice.
    

getContact('a', contacts)

"""
Exercise 3: Write a Python program to create a list of items and corresponding quantities, e.g. 
inventory = { ‘apple’:20, ‘banana’:30, ‘orange’:10}

Write functions in Python to:
a)	returns the total number of items (in the example above 60)

b)	add stock, for example stock_up(inventory, ‘apple’,10) should result in the inventory being updated with 10 extra apples

inventory will be  { ‘apple’:30, ‘banana’:30, ‘orange’:10}

You have to search through the inventory first to see if item is available
a.	if available – update the quantity plus the new amount
b.	if not available - add it with the specified quantity

"""
inventory = { 'apple':20, 'banana':30, 'orange':10}

def invSize(d):
  x = d.values()
  y = 0
  for val in x:
    y += val
  print("ex3  a - total: " + str(y))

def stockUp(k,v,d):
  if k in d:
    x = d[k]
    d.update({k: v})
    print("ex3  b - updated: " + k + " from " + str(x) + " to " + str(v))
  else:
    print("ex3  b - key does not exist")

invSize(inventory)
stockUp('apple', 10, inventory)