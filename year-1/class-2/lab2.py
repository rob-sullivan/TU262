num_ppl=int(input("How Many People? "))
bill = int(input("Total bill? "))

if num_ppl < 4:
  print("Pay bill as is.")
else:
  if bill<100:
    print("Leave 10% tip")
  else:
    print("Leave 15% tip")


    """
Lab: If-else and if-elif-else statements
Exercise 1:
Prompt the user to enter a mark between 0 and 100 and to print “This is a pass” if the mark is 40 or over, and “This is a fail” if the mark is below 40. Hint: use >=
"""
mark = int(input("Enter your exam mark: "))
if mark>=40:
  print("You passed!")
else:
  print("You failed")

""""
Exercise 2:
Prompt the user to enter an integer number, and output if the number is even or odd (Hint: use % to get the remainder of a division, e.g. 5%2 will return 1)
"""
n = int(input("Enter first value: "))
d = int(input("Enter second value: "))

ans = n % d

if ans:
  print("number is odd")
else:
  print("number is even")

"""
Exercise 3:
Prompt the user to enter two integer numbers, and output if the first is larger, smaller or equal to the second one. Use if-elif-else.
"""
a = int(input("Enter first value: "))
b = int(input("Enter second value: "))

if a==b:
  print("a = b")
elif a>b:
  print("a > b")
else:
  print("a < b")

""""
Exercise 4: It costs €1 to post a letter to Ireland, €1.70 to Europe and €2.00 to the rest of the world.
Write a program that asks the user where do they want to post the letter to and prints the correct postage.
"""
ans = int(input("where do you want to post your letter? 1. Ireland, 2. Europe 3. Rest of the World"))

if ans == 1:
  print("Pay 1 euro for ireland")
elif ans ==2:
  print ("Pay 1.70 euro for Europe")
elif ans ==3:
  print("Pay 2 euro for rest of the world")
else:
  print("No such selection exists. Try again.")
"""
Exercise 5: Parking at a specific area costs €2 per hour, with the first two hours free. Ask the user for how long will they park for and calculate the amount they need to pay.
"""
ans = int(input("How many hours do you want to stay?"))

if ans < 2:
  print("Parking is free for first 2 hours")
else:
  print("Pay: " + (ans * 2) + "euros.")

"""
Exercise 6: Write a small calculator simulator – ask the user to enter two numbers and an operation (+, -, *, /), and either add, subtract, multiply or divide the numbers, and print the result.
"""
a = int(input("Enter first value: "))
b = int(input("Enter second value: "))
opp = input("Enter operation (+, -, *, /)")

if opp == "+":
  print(a+b)
elif opp == "-":
  print(a-b)
elif opp == "*":
  print(a*b)
elif opp == "/":
  print(a/b)
else:
  print("Operation does not exist")
