#ex 1a
sentence = str(input("Enter a sentence: "))
sentence = sentence.split()
for word in sentence:
	x = 0
	for c in word:
		x += 1
	print(x)

#ex 1b
sentence_file = open("sentence.txt", 'r', encoding="utf-8")
for line in sentence_file:
	line = line.split()
	for word in line:
		x = 0
		for c in word:
			x += 1
		print(x)
sentence_file.close()

#ex 2
print("example 2: \n")
sentence = str(input("Enter a sentence: "))
sentence = sentence.split()
for word in sentence:
	if word[1:] == "a":
		word = ' '.join(reversed(word))
print(sentence)

#ex 3
def replace_all(number_list, l_out, l_in):
	for i in number_list:
			if i == l_out[0]:
				i = l_in[0]
			elif i == l_out[1]:
				i = l_in[1]
	print(number_list)

replace_all([1,2,5,6,2,7,1,2], [2,4],[200,400]

#ex 4
sentence_file = open("sentence.txt", 'r', encoding="utf-8")

for line in sentence_file:
	item = line.split()
	x = 0
	for word in item:
		x += 1
		if x == 3:
			word = "hello"
			x = 0
	print(item)


#ex 5
sentence_file = open("sentence.txt", 'r', encoding="utf-8")

for line in sentence_file:
	item = line.split()
	for word in item:
		if word > 5:
			word = "blah"
	print(item)

#Exercise 6: Write a Python program that reads text from a file and generates a dictionary – a list of unique words. Save those words in a new file, one word per line.
#ex 5