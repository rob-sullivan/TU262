# !/usr/bin/python
import os

book_file = open("books.html", 'w', encoding="utf-8")

os.chdir("D:\\Documents\\Books\\")

print("<html><head><title>"+ os.getcwd() + "</title></head><body>", file=book_file)

#html header
for root, dirs, files in os.walk(".", topdown=True):
   for name in dirs:
      print("<h3>" + os.path.join(root, name) + "</h3>", file=book_file)
   for name in files:
      print("<p>" + os.path.join(root, name) + "</p>", file=book_file)

print("</body></html>", file=book_file)#html bottom
book_file.close()