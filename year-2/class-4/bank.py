# Python program to create Bankaccount class 
# with both a deposit() and a withdraw() function 
class Bank_Account: 
	def __init__(self): 
		self.bal = 0

	def deposit(self): 
		cash = float(input("Enter amount to be Deposited: ")) 
		self.bal += cash 
		print("\n Amount Deposited:",cash) 

	def withdraw(self): 
		cash = float(input("Enter amount to be Withdrawn: ")) 
		if self.bal >= cash: 
			self.bal -= cash 
			print("\n You Withdrew:", cash) 
		else: 
			print("\n Insufficient funds ") 

	def display(self): 
		print("\n Balance=",self.bal) 

# creating an object of class 
s = Bank_Account() 

# Calling functions with that class object 
s.deposit() 
s.withdraw() 
s.display() 
