#ex 1
x = 1
while x < 11:
  print(x)
  x = x + 1
#ex 2
for i in range(1,11):
  print(i)
#ex 3
for i in range(1,11):
  if (i % 2) == 0:
    print("{0} is Even".format(i))
  else:
    print("{0} is Odd".format(i))
#ex 4
for i in range(1,11):
  print(i*9)

#ex 5
n1 = input("Enter a number to sum. Enter 0 to end. \n")
n2 = 0
while n1 != '0':
  print('You entered', n1)
  n2 = n2 + int(n1)
  print("sum:", n2)
  n1 = input("Enter next number:")
print("Goodbye!")

#ex 6
x=1
for i in range(1,11):
  i **= i
  print(i)

# ex 7
s = input("Keep entering numbers. Enter a negative number to end. \n")
x = "-" in s

while x != True:
  print('You entered', s)
  s = input("Enter next number:")
print("Negative. Goodbye!")

# ex 8
a = "*"
for i in range(1,7):
  print(a)
  a = a + "*"

# ex 9 a
# ex 9
z = 0
for i in range(1,4):
  for j in range(1,5):
    print(z)

# ex 9 b
a = ""
for i in range(1,6):
  a = a + " " + str(i+1)
  print(a)
