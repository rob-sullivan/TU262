Copyright 2021, Rob Sullivan, All rights reserved.
@author Rob Sullivan <http://mailto:c08345457@mytudublin.ie> 

What is it:
This program is a simple implementation of a small library system using only dictionaries
to describe and keep track of books. No objects or classes were used.

How it works:
Each book has a unique ISBN (13 digit number), a title and an author.  
The library also keeps track of how many copies of the book are currently available to loan. 
Books can be borrowed and returned.

This program was made in Python3 3.8.8. python3 --version = 3.8.8

Installation & Running
 - pip3 install terminaltables # https://robpol86.github.io/terminaltables/install.html
 - pip3 install colorclass # https://pypi.org/project/colorclass/
 - python3 ./library.py


License
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
A copy of the GNU General Public License can be found at 
<http://www.gnu.org/licenses/>.


TODO(rob): Allow user to give feedback

BUG(rob): When user hits enter during x = int(Input("prompt")) it gives a base 10 error 
    - used x = "" check to try solve.
    - update_info() function most frequent
