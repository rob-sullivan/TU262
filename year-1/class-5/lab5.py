""" #exercise 1
s = "hello world"
for c in s:
    print(c)

#exercise 2
s = "hello world"
count = 0
for c in s:
    count += 1
print(count)

#exercise 3
s = "hello there"
print(s[0:2]+s[-2:])
 
#exercise 4
s0 = "hello world"
s1 = ""
for i in range(len(s0)+1):
    s1 += s0[-i]

print(s1)

#exercise 4 - alternative
s = "hello world"
print(s[::-1])
"""
s = input("Enter text:")
for c in s:
    s1 += chr(ord(c)+1)

print(s1)