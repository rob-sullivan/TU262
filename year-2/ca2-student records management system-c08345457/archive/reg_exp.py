import re
#email
#pattern accepts uppercase, lowercase and numbers
#plus means we want 1 or more of these characters
#we first check everything until we hit an @ symbol
#then up to dot using backslash
#finally we only accept a .com or a .ie email address
pattern = "[a-zA-Z0-9]+@[a-zA-Z]+\.(com|ie)"

user_input = input()
if(re.search(pattern, user_input)):
    print("valid email")
else:
    print("invalid email")

"""
hello
this is a sentence
1234
test45
this is a number 5
"""
