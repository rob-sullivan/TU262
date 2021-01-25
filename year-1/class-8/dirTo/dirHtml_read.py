book_file = open("books.txt", 'r', encoding="utf-8")

for line in book_file:
	print(line)
book_file.close()