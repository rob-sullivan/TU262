"""
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

"""
"""
You are asked to develop a small college management system to illustrate your understanding of the main object-oriented concepts.
Your system should keep track of Students. 
Each student has a student ID, name, email address and list of current modules they are taking. 
Each student can enrol in up to 5 modules max.
Each Module has an unique code, a name, a number of ECTS credits. 
Each module also has a max capacity, and once that is reached no more students can be enrolled until somebody unenrolls first.
You’ll need to keep track of, and update, what modules are students enrolled in.
Some of the functionality your system should provide is:
    • Print and update details about the students
    • Print and update details about the modules
    • Search for a student using different parameters (e.g. by email or student ID)
    • Enrol and unenroll a student from a module
    • Create and delete students and modules

Make sure you include any relevant error checking and handle unexpected input.
"""
# We install both terminaltables and colorClass to create a simple gui for the user in the terminal
from terminaltables import AsciiTable # we are using the ascii table layout.
from colorclass import Color, Windows # we are using color and windows to color the qty level in the terminal
from os import system, name # used for clearing terminal function

class Student():
    def __init__(self, id, name, email, max):
        #personal details of the student
        self.id = id
        self.name = name
        self.email = email

        #how many modules a student can take
        self.max_cap = max
        #modules a student is taking
        self.modules_taken = {}
    
    #return a list of modules a student is taking
    def getModules(self):
        num_mod = len(self.modules_taken)
        if num_mod > 0:
            print(self.name + "'s modules are: ")
            for mod_id, mod_name in modules_taken.items():
                print("id: " + str(mod_id) + ", name: " + mod_name)
        else:
            print(self.name + " does not have any modules.")

    def __str__(self):
        return "id: " + str(self.id) + ", name: " + self.name + ", email: " +  self.email + ", module limit reached: " + ("Yes" if len(self.modules_taken) == self.max_cap else "No")

class Module():
    
    def __init__(self, id, name, num_ects, max):
        self.id = id
        self.name = name
        self.num_ects = num_ects
        self.max_cap = max
        self.students_in_module = {} # max 5
    
    def getStudents(self):
        num_stu = len(self.students_in_module)
        if num_mod > 0:
            print(self.name + "'s students are: ")
            for stu_id, stu_name in students_in_module.items():
                print("id: " + str(mod_id) + ", name: " + mod_name)
        else:
            print(self.name + " does not have any students.")

    def __str__(self):
        return "id: " + str(self.id) + ", name: " + self.name + ", ects: " +  str(self.num_ects) + ", full: " + ("Yes" if len(self.students_in_module) == self.max_cap else "No")

class Course(Student, Module):
    
    def __init__(self, code, name, description):
        self.code = code
        self.name = name
        self.description = description
        self.students = {} #students
        self.modules = {} #modules

        # max set here at parent level
        self.max_modules_taken = 5
        self.max_module_students = 20

    #student management
    #add student
    def addStudent(self, name, email):
        id = len(self.students)
        s = Student(id, name, email, self.max_modules_taken)
        self.students[s.id] = s
    #delete student
    def deleteStudent(self, id):
        self.students.pop(id)
    #search Student
    def searchStudent(id):
        if id in self.students:
            print(self.students[id])
    #view Student
    def viewStudent():
        if id in self.students:
            print(self.students[id])
    #update Student
    def updateStudent(id, name, email):
        self.students[id].name
        self.students[id].email

    ##module management##
    #add module
    def addModule(self, name, num_ects):
        id = len(self.modules)
        m = Module(id, name, num_ects, self.max_module_students)
        self.modules[m.id] = m
    #delete Module
    def deleteModule(self, id):
        self.modules.pop(id)
    #view Module
    def viewModule(self, id):
        if id in self.modules:
            print(self.modules[id])
    #update Module
    def updateModule(self, id, name, num_ects):
        self.students[id].name
        self.students[id].num_ects
    #enroll Student
    def enrollStudent(self, student, module):
        num_mod = len(student.modules_taken)
        num_stu = len(module.students_in_module)
        if num_mod < student.max_cap:
            if num_stu < module.max_cap:
                self.modules_taken[module.id] = module
            else:
                print(module.name + "'s student limit was reached")
        else:
            print(student.name + "'s module limit was reached")
    #unenroll Student
    def unenrollStudent(self, module):
        self.modules_taken.pop(module.id)

class MainMenuController(Course):
    def __init__(self):
        self.course = Course("TU060", "Advanced Software Development", \
            "MSc in Computer Science Advanced Software Development.")
        self.demoModules() #load our demo content of modules and students

    def demoModules(self):
        demoModules = [
            "Programming Paradigms: Principles & Practice",
            "Software Design",
            "Advanced Databases",
            "Systems Architectures",
            "Web Application Architectures",
            "Secure Systems Development",
            "Critical Skills Core Modules",
            "Research Writing & Scientific Literature",
            "Research Methods and Proposal Writing",
            "Research Project & Dissertation",
            "Option Modules",
            "Geographic Information Systems",
            "Universal Design",
            "Programming for Big Data",
            "Problem Solving, Communication and Innovation",
            "Social Network Analysis",
            "User Experience Design",
            "Security",
            "Deep Learning",
            "Speech & Audio Processing",
        ]
        demoStudents = [
            "jon,jon@terminator.com",
            "sarah, sarah@terminator.com",
            "conor, conor@terminator.com",
            "buzz, buzz@toystory.com",
            "woodie, woodie@toystory.com",
            "elsa, elsa@frozen.com"
        ]
        for module in demoModules:
            self.course.addModule(module, 5)

        for student in demoStudents:
            s = student.split(",")
            self.course.addStudent(s[0], s[1])

    def mainMenu(self):
        clear()
        # main title
        print("**Welcome to" + Color("{autoblue}pyLearn{/autoblue}") + " College Management System ** \nCreated by Rob Sullivan v1.0.0")
        print("""
        Main Menu:

            1. Student
            2. Admin

            *Press 0 to exit*
        """)
        try:
            x = input("Main Menu: Choose an option: ")

            #used to fix base 10 error, 
            # just hitting enter will close the program
            if(x == ""):
                x = 0
            else:
                x = int(x)

            if(x == 0):
                clear()
                print("quitting " + Color("{autoblue}pyLearn{/autoblue}") + "...")
                input("Press Enter to continue...")
                return False #set run to false and quit program
            elif(x == 1):
                self.studentMenu()
            elif(x == 2):
                self.adminMenu()
            else:
                clear()
                print(Color("{autored}Not a valid choice. Try again{/autored}"))
                input("Press Enter to continue...")
                self.mainMenu()
        except:
            clear()
            print(Color("{autored}Not a choice. Try again{/autored}"))
            input("Press Enter to continue...")
            self.mainMenu()

    def studentMenu(self):
        #what is your student id
        #what do you want to do
            #see your details
            #update your details
            #see your module
            #enroll in a module
            #drop a module
        print("studentMenu")
    
    def adminMenu(self):
        #what is your student id
        #what do you want to do
            #see your details
            #update your details
            #see your module
            #enroll in a module
            #drop a module
        print("adminMenu")
    """
    This function was taken from https://www.geeksforgeeks.org/clear-screen-python/ to
    allow the terminal to be cleared when changing menus or showing the user important
    messages. It checks what operating system is being used and uses the correct 
    clearing command.
    """
    def clear(self): 
        # for windows 
        if name == 'nt': 
            _ = system('cls') 
    
        # for mac and linux(here, os.name is 'posix') 
        else: 
            _ = system('clear') 

if __name__ == "__main__":
    MainMenu()

