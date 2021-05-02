Copyright 2021, Rob Sullivan, All rights reserved.
@author Rob Sullivan <http://mailto:c08345457@mytudublin.ie> 

What is it:
This program is a simple implementation of a small college management system to 
illustrate main object-oriented concepts

How it works:
The system is made up of a student and module entity. A course controller manages data taken from the user
in the collegeUI boundary object.

The system keeps track of Students. 
-Each student has a student ID, name, email address and list of current modules they are taking. 
-Each student can enrol in up to 5 modules max.
-Each Module has an unique code, a name, a number of ECTS credits. 
-Each module also has a max capacity, and once that is reached no more students can be enrolled until somebody unenrolls first.
-The system keeps track of and updates what modules students are enrolled in.
-An admin can do the following:
    • Print and update details about the students
    • Print and update details about the modules
    • Search for a student using different parameters (e.g. by email or student ID)
    • Enrol and unenrol a student from a module
    • Create and delete students and modules
-Relevant error checking is implemented along with unexpected input handling.

This program was made in Python3 3.8.8. python3 --version = 3.8.8

Installation & Running
 - pip3 install terminaltables # https://robpol86.github.io/terminaltables/install.html
 - pip3 install colorclass # https://pypi.org/project/colorclass/
 - python3 ./library.py

Future Scope:
-create a class for student menu and modules menu
-better form validation

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


TODO(rob): form validation on bulk adding students
TODO(rob): bulk add student returns error "RuntimeError: dictionary changed 
            size during iteration". interate over copied list required first.
