# !/usr/bin/python
import os

book_file = open("books.txt", 'w', encoding="utf-8")

os.chdir("D:\\Documents\\Books\\") #TODO: turn this into a user input

print(os. getcwd() + "\n", file=book_file)

for root, dirs, files in os.walk(".", topdown=True):
      for name in dirs:
            print(os.path.join(root, name), file=book_file)
      for name in files:
             print(os.path.join(root, name), file=book_file)
book_file.close()

#print("root:" + str(root), file=book_file)
#print("dirs:" + str(dirs), file=book_file)
#print("files:" + str(files), file=book_file)
#(base, ext) = os.path.splitext(name)