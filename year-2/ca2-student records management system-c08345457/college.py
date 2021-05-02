"""
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


TODO(rob): form validation on student menu. #import re and use regular expressions in choice function to filter out unwanted input behaviour
TODO(rob): restrict adding if maxed
TODO(rob): form validation on bulk adding students
TODO(rob): checking if student already part of module/ module already taken by student.

"""
"""
"""
# We install both terminaltables and colorClass to create a simple gui for the user in the terminal
from terminaltables import AsciiTable # we are using the ascii table layout.
from colorclass import Color, Windows # we are using color and windows to color the qty level in the terminal
from os import system, name # used for clearing terminal function
from sys import exit # we use system exit to allow us to quit the program
import re # we use regular expressions to do form validation
# This is an entity class that holds information about a student.
class Student():
    def __init__(self, id, name, email, max):
        #personal details of the student
        self.id = id
        self.name = name
        self.email = email
        #how many modules a student can take and modules a student is taking
        self.max_cap = max
        self.modules_taken = {}
    
    def __str__(self):
        result = str(self.id) + self.name +  self.email
        result = result.lower()
        result = result.replace(" ", "")
        return result
# This is an entity class that holds information about a module students can take.
class Module():
    
    def __init__(self, id, name, num_ects, max):
        self.id = id
        self.name = name
        self.num_ects = num_ects
        self.max_cap = max
        self.students_in_module = {} # max 5

    def __str__(self):
        result = str(self.id) + self.name
        result = result.lower()
        result = result.replace(" ", "")
        return result
# This is a controller class that manages the CRUD functionality of modules and students
class CourseManager(Student, Module):
    
    def __init__(self):
        # max set here at parent level
        self.max_modules_taken = 5
        self.max_module_students = 20

        self.students = {} #students
        self.modules = {} #modules

    #student management
    #view Student
    def viewAllStudents(self):
        # we setup the library table and its header
        student_table = [
            ['Id', 'Name', 'Email', 'Modules'],
        ]

        # we loop through books and add each book to the ascii table
        #print(self.students)

        for student_id in self.students.keys():
            student = self.students[student_id]

            qty = int(len(student.modules_taken))
            #find and colour code qty of modules taken by students
            modules_qty = "" # we set qty to zero then get the qty from dictionary
            if qty == self.max_modules_taken: # we set the colour to red to inform the admin that the max level was reached
                modules_qty = Color("{autored}" + str(qty) + "{/autored}")
            elif qty > (self.max_modules_taken / 2):
                modules_qty = Color("{autoyellow}" + str(qty) + "{/autoyellow}") # we want to warn the admin that module level is about to max
            else:
                modules_qty = Color("{autogreen}" + str(qty) + "{/autogreen}") # if module qty level is less than half of max colour it green

            s_row = [student_id, student.name, student.email, modules_qty] # we add a student per row
            student_table.append(s_row) # we add a row to the table using append. which will add to end of dictionary
        student_list = AsciiTable(student_table) # we add the library table in an ascii table format
            
        student_list.title = Color(" {autoblue}Student{/autoblue}") + " list: Showing " + str(len(self.students)) + " students"
        print("\n" + student_list.table) # we print our ascii table library
    #add student
    def addStudent(self, name, email):
        id = len(self.students)
        s = Student(id, name, email, self.max_modules_taken)
        self.students[s.id] = s
        print(self.students[s.id].name + " added.")
    #delete student
    def deleteStudent(self, id):
        self.students.pop(id)
    #search Student
    def searchStudent(self, q):#used for enrolling student. use string not int
        found = False
        for s in self.students.values():        
            if q in s.__str__():
                student = s
                found = True
                break
            #show list of found items and let the user pick one. Then set id to that.
        if(found):
            # we setup the student table and its header
            student_table = [
                ['Id', 'Name', 'Email', 'Modules'],
            ]

            qty = int(len(student.modules_taken))
            #find and colour code qty of modules taken by students
            modules_qty = "" # we set qty to zero then get the qty from dictionary
            if qty == self.max_modules_taken: # we set the colour to red to inform the admin that the max level was reached
                modules_qty = Color("{autored}" + str(qty) + "{/autored}")
            elif qty > (self.max_modules_taken / 2):
                modules_qty = Color("{autoyellow}" + str(qty) + "{/autoyellow}") # we want to warn the admin that module level is about to max
            else:
                modules_qty = Color("{autogreen}" + str(qty) + "{/autogreen}") # if module qty level is less than half of max colour it green

            s_row = [student.id, student.name, student.email, modules_qty] # we add a student per row
            student_table.append(s_row) # we add a row to the table using append. which will add to end of dictionary
            student_list = AsciiTable(student_table) # we add the library table in an ascii table format
                
            student_list.title = Color(" {autoblue}"+ student.name + "{/autoblue}'s") + " details"
            print("\n" + student_list.table) # we print our ascii table library

            # we setup the library table and its header
            module_table = [
                ['Row', 'Name', 'ECTs', 'Students'],
            ]
            # we loop through books and add each book to the ascii table
            #print(self.students)

            for module_id in student.modules_taken.keys():
                module = student.modules_taken[module_id]

                qty = int(len(module.students_in_module))
                #find and colour code qty of modules taken by students
                student_qty = "" # we set qty to zero then get the qty from dictionary
                if qty == self.max_module_students: # we set the colour to red to inform the admin that the max level was reached
                    student_qty = Color("{autored}" + str(qty) + "{/autored}")
                elif qty > (self.max_modules_taken / 2):
                    student_qty = Color("{autoyellow}" + str(qty) + "{/autoyellow}") # we want to warn the admin that module level is about to max
                else:
                    student_qty = Color("{autogreen}" + str(qty) + "{/autogreen}") # if module qty level is less than half of max colour it green

                m_row = [module_id, module.name, module.num_ects, student_qty] # we add a student per row
                module_table.append(m_row) # we add a row to the table using append. which will add to end of dictionary
            module_list = AsciiTable(module_table) # we add the library table in an ascii table format
                
            module_list.title = Color(" {autoblue}"+ student.name + "{/autoblue} is taking ") + str(len(student.modules_taken)) + " modules"
            print("\n" + module_list.table) # we print our ascii table library
            return student.id
        else:
            print("Search: no result found..")
            return -1
    #update Student
    def updateStudent(id, name, email):
        self.students[id].name
        self.students[id].email
    ##module management##
    #view module
    def viewAllModule(self):
        # we setup the library table and its header
        module_table = [
            ['Id', 'Name', 'ECTs', 'Students'],
        ]
        # we loop through books and add each book to the ascii table
        #print(self.students)

        for module_id in self.modules.keys():
            module = self.modules[module_id]

            qty = int(len(module.students_in_module))
            #find and colour code qty of modules taken by students
            student_qty = "" # we set qty to zero then get the qty from dictionary
            if qty == self.max_module_students: # we set the colour to red to inform the admin that the max level was reached
                student_qty = Color("{autored}" + str(qty) + "{/autored}")
            elif qty > (self.max_modules_taken / 2):
                student_qty = Color("{autoyellow}" + str(qty) + "{/autoyellow}") # we want to warn the admin that module level is about to max
            else:
                student_qty = Color("{autogreen}" + str(qty) + "{/autogreen}") # if module qty level is less than half of max colour it green

            m_row = [module_id, module.name, module.num_ects, student_qty] # we add a student per row
            module_table.append(m_row) # we add a row to the table using append. which will add to end of dictionary
        module_list = AsciiTable(module_table) # we add the library table in an ascii table format
            
        module_list.title = Color(" {autoblue}Module{/autoblue}") + " list: Showing " + str(len(self.modules)) + " modules"
        print("\n" + module_list.table) # we print our ascii table library
    #add module
    def addModule(self, name, num_ects):
        id = len(self.modules)
        m = Module(id, name, num_ects, self.max_module_students)
        self.modules[m.id] = m
        print(self.modules[m.id].name + " added.")
    #delete Module
    def deleteModule(self, id):
        self.modules.pop(id)
    #search Student
    def searchModule(self, q):
        found = False
        for m in self.modules.values():     
            if q in m.__str__():
                module = m
                found = True
                break
            #show list of found items and let the user pick one. Then set id to that.
        if(found):
            # we setup the library table and its header
            module_table = [
                ['Id', 'Name', 'ECTs', 'Students'],
            ]
            # we loop through books and add each book to the ascii table

            qty = int(len(module.students_in_module))
            #find and colour code qty of modules taken by students
            student_qty = "" # we set qty to zero then get the qty from dictionary
            if qty == self.max_module_students: # we set the colour to red to inform the admin that the max level was reached
                student_qty = Color("{autored}" + str(qty) + "{/autored}")
            elif qty > (self.max_modules_taken / 2):
                student_qty = Color("{autoyellow}" + str(qty) + "{/autoyellow}") # we want to warn the admin that module level is about to max
            else:
                student_qty = Color("{autogreen}" + str(qty) + "{/autogreen}") # if module qty level is less than half of max colour it green

            m_row = [module.id, module.name, module.num_ects, student_qty] # we add a student per row
            module_table.append(m_row) # we add a row to the table using append. which will add to end of dictionary
            module_list = AsciiTable(module_table) # we add the library table in an ascii table format

            module_list.title = Color(" {autoblue}"+ module.name + "{/autoblue}'s") + " details" 
            print("\n" + module_list.table) # we print our ascii table library
            
            #add students list
            # we setup the library table and its header
            student_table = [
                ['Id', 'Name', 'Email', 'Modules'],
            ]

            # we loop through books and add each book to the ascii table
            #print(self.students)

            for student_id in self.students.keys():
                student = self.students[student_id] # get our student

                #check if enrolled in subject
                taken = False
                for m in student.modules_taken.values():
                    if (module == m):    
                        taken = True
                        break
                if(taken):
                    qty = int(len(student.modules_taken))
                    #find and colour code qty of modules taken by students
                    modules_qty = "" # we set qty to zero then get the qty from dictionary
                    if qty == self.max_modules_taken: # we set the colour to red to inform the admin that the max level was reached
                        modules_qty = Color("{autored}" + str(qty) + "{/autored}")
                    elif qty > (self.max_modules_taken / 2):
                        modules_qty = Color("{autoyellow}" + str(qty) + "{/autoyellow}") # we want to warn the admin that module level is about to max
                    else:
                        modules_qty = Color("{autogreen}" + str(qty) + "{/autogreen}") # if module qty level is less than half of max colour it green

                    s_row = [student_id, student.name, student.email, modules_qty] # we add a student per row
                    student_table.append(s_row) # we add a row to the table using append. which will add to end of dictionary
            student_list = AsciiTable(student_table) # we add the library table in an ascii table format       
            student_list.title = Color(" {autoblue}Students{/autoblue}") + " enrolled: Showing " + str(len(module.students_in_module)) + " enrolled"
            print("\n" + student_list.table) # we print our ascii table library
            return module.id
        else:
            print("Search: no result found..")
            return -1
    #update Module
    def updateModule(self, id, name, num_ects):
        self.students[id].name
        self.students[id].num_ects
    #enroll Student
    def enrollStudent(self, stu_id, mod_id):
        stu_id = int(stu_id)
        mod_id = int(mod_id)

        student = self.students[stu_id]
        module = self.modules[mod_id]
        
        #check if student can take more classes
        
        #check if module taken by student
        for mod in student.modules_taken.keys()
            if(mod !== mod_id):
                student.modules_taken[mod_id] = module
            else:
                print(student.name + " is already taking " + module.name)

        #check if module is not full

        #check if student in module
        for stu in module.students_in_module.keys()
            if(stu !== stu_id):
                module.students_in_module[stu_id] = student
            else:
                print(module.nam + " shows " + student.name + " is enrolled in it")

    #unenroll Student
    def unenrollStudent(self, stu_id, mod_id):
        stu_id = int(stu_id)
        mod_id = int(mod_id)
        student = self.students[stu_id]
        student.modules_taken.pop(mod_id) #remove module from student     
        module = self.modules[mod_id]
        module.students_in_module.pop(stu_id) #remove student from module
# This is a boundary class that takes user input and sends it to the controller class.
class CollegeUI(CourseManager):
    def __init__(self):
        self.cm = CourseManager()
    #some demo students and modules
    def demo(self):
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
            "sarah,sarah@terminator.com",
            "conor,conor@terminator.com",
            "buzz,buzz@toystory.com",
            "woodie,woodie@toystory.com",
            "elsa,elsa@frozen.com"
        ]
        for module in demoModules:
            self.cm.addModule(module, 5)

        for student in demoStudents:
            s = student.split(",")
            self.cm.addStudent(s[0], s[1])
    #main menu
    def welcomeScreen(self):
        self.clear()
        # main title
        print("** Welcome to " + Color("{autoblue}pyLearn{/autoblue}") + " College Management System ** \nCreated by Rob Sullivan v1.0.0")
        print("""
        Main Menu:

            1. Students
            2. Modules

            *Press 0 to exit*
        """)
        self.welcomeOptions()
    def welcomeOptions(self):
        try:
            x = self.choice("Main Menu: Choose an option: ", "numbers") #custom input to handle base 10 error errors
            if(x == 0):
                self.quitApp()#tells user app will close then quits
            elif(x == 1):
                self.studentScreen()
            elif(x == 2):
                self.moduleScreen()
            else:
                raise
                #msg = Color("{autored}Not a valid choice. Try again{/autored}")
                #self.goBack(msg, self.WelcomeScreen)
        except:
            raise
            #msg = Color("{autored}Not a valid choice. Try again{/autored}")
            #self.goBack(msg, self.WelcomeScreen)
    #student menu
    def studentScreen(self):
        print("hello")
        self.clear()
        # main title
        print("** Welcome to " + Color("{autoblue}pyLearn{/autoblue}") + " College Management System ** \nCreated by Rob Sullivan v1.0.0")
        self.cm.viewAllStudents()
        print("""
        Students Menu:

            1. View Student Details
            2. Add Student
            3. Delete Student
            4. Enrol Student
            5. Unenrol Student

            *Press 0 to go back*
        """)
        self.studentOptionScreen()
    def studentOptionScreen(self):
        try:
            x = self.choice("Students Menu: Choose an option: ", "numbers") #custom input to handle base 10 error errors
            
            
            if(x == 0):#return to previous menu
                msg = Color("{autoblue}Returning to Main Menu{/autoblue}")
                self.goBack(msg, self.welcomeScreen)
            elif(x == 1):#show a student
               self.studentProfileScreen()
            elif(x == 2):#add student
                self.addStudentScreen()
            elif(x == 3):#delete student
                self.deleteStudentScreen()
            elif(x == 4): #Enrol Student
                self.enrollStudentScreen()
            elif(x == 5): #Unenrol Student
                self.unenrollStudentScreen()
            else:
                raise
                #msg = Color("{autored}Not a valid choice. Try again{/autored}")
                #self.goBack(msg, self.WelcomeScreen)
        except:
            raise
            #msg = Color("{autored}Not a valid choice. Try again{/autored}")
            #self.goBack(msg, self.WelcomeScreen)
    def studentProfileScreen(self):
        #show a list of all students.
        self.clear()
        self.cm.viewAllStudents()#show a list of students
        print(Color("{autoblue}View Student:{/autoblue}"))

        #now we get a search query from the user.
        query = self.choice("Search for a student by id, name or email: ","any")
        self.clear()

        #with the search query we format it and look for the student
        y = self.cm.searchStudent(query)#string validation and checking if item exists already

        #y will return the student id if found
        if(y > -1):
            z = self.choice("Edit? Yes: 1, No: 0 : ", "binary") #custom input to handle base 10 error errors
            if(z == 0):
                msg = Color("{autoblue}returning to student menu...{/autoblue}")
                self.goBack(msg, self.studentScreen)  
            elif(z == 1):
                student = self.cm.students[y]
                name = self.choice("Student Name: ", "text")
                student.name = name
                email = self.choice("Student Email: ", "email")
                student.email = email
                msg = Color("{autoblue}returning to student menu...{/autoblue}")
                self.goBack(msg, self.studentScreen)  
        else:
            msg = Color("{autoblue}returning to student menu...{/autoblue}")
            self.goBack(msg, self.studentScreen)  
    def addStudentScreen(self):
        self.clear()
        self.cm.viewAllStudents()
        print(Color("{autogreen}Add new student:{/autogreen}"))
        name = input("Student Name: ", "text")
        email = input("Student Email: ", "email")
        self.cm.addStudent(name, email)#string validation and checking if item exists already
        msg = Color("{autoblue}returning to student menu...{/autoblue}")
        self.goBack(msg, self.studentScreen)  
    def deleteStudentScreen(self):
        self.clear()
        self.cm.viewAllStudents()
        print(Color("{autored}Delete student:{/autored}"))
        id = self.choice("Student Id: ", "numbers")
        self.cm.deleteStudent(id)#string validation and checking if item exists already
        msg = Color("{autoblue}returning to student menu...{/autoblue}")
        self.goBack(msg, self.studentScreen)
    def enrollStudentScreen(self):
        #get the student
        self.clear()
        self.cm.viewAllStudents()
        print(Color("{autoblue}Select Student to enroll:{/autoblue}"))
        stu_id = self.choice("Student Id: ", "numbers")

        #get the module
        self.clear()
        self.cm.viewAllModule()
        print(Color("{autoblue}Select cm to enroll{/autoblue} " + self.cm.students[stu_id].name + " {autoblue}into:{/autoblue}"))
        mod_id = self.choice("Module Id: ", "numbers")

        #now enrol the student in the module
        self.cm.enrollStudent(stu_id, mod_id)
        self.clear()
        self.cm.searchStudent(str(stu_id))#string validation and checking if item exists already

        #now go back to the main student menu
        msg = Color("{autoblue}returning to student menu...{/autoblue}")
        self.goBack(msg, self.studentScreen)
    def unenrollStudentScreen(self):
        #get the student
        self.clear()
        self.cm.viewAllStudents()
        print(Color("{autoblue}Select Student to enroll:{/autoblue}"))
        stu_id = self.choice("Student Id: ", "numbers")

        #get the module
        self.clear()
        self.cm.viewAllModule()
        print(Color("{autoblue}Select cm to enroll{/autoblue} " + self.cm.students[stu_id].name + " {autoblue}into:{/autoblue}"))
        mod_id = self.choice("Module Id: ", "numbers")

        #now unenrol the student in the module
        self.cm.unenrollStudent(stu_id, mod_id)
        self.clear()
        self.cm.searchStudent(str(stu_id))#string validation and checking if item exists already

        #now go back to the main student menu
        msg = Color("{autoblue}returning to student menu...{/autoblue}")
        self.goBack(msg, self.studentScreen)
    #module menu
    def moduleScreen(self):
        self.clear()
        # main title
        print("** Welcome to " + Color("{autoblue}pyLearn{/autoblue}") + " College Management System ** \nCreated by Rob Sullivan v1.0.0")
        self.cm.viewAllModule()
        print("""
        Module Menu:

            1. View Module Details
            2. Add Module
            3. Delete Module
            4. Enrol Students
            5. Unenrol Students

            *Press 0 to go back*
        """)
        self.moduleOptionScreen()
    def moduleOptionScreen(self):
        try:
            x = self.choice("Module Menu: Choose an option: ", "numbers") #custom input to handle base 10 error errors

            if(x == 0):#back to main menu
                msg = Color("{autoblue}Returning to Main Menu{/autoblue}")
                self.goBack(msg, self.welcomeScreen)
            elif(x == 1):#back show all modules and pick one to edit
                self.moduleDetailScreen()
            elif(x == 2):#add new module
                self.addModuleScreen()
            elif(x == 3):#delete module
                self.deleteModuleScreen()
            elif(x == 4):#bulk enroll
                self.bulkEnrollStudentScreen()
            elif(x == 5):#bulk unenroll
                self.bulkUnenrollStudentScreen()
            else:
                raise
                #msg = Color("{autored}Not a valid choice. Try again{/autored}")
                #self.goBack(msg, self.WelcomeScreen)
        except:
            raise
            #msg = Color("{autored}Not a valid choice. Try again{/autored}")
            #self.goBack(msg, self.WelcomeScreen)
    def moduleDetailScreen(self):
        #show a list of all modules.
        self.clear()#clear the terminal
        self.cm.viewAllModule()#show a list of current modules
        print(Color("{autoblue}Search Module:{/autoblue}"))
        
        #now we get a search query from the user.
        query = self.choice("Search for a module by Id or Name: ", "any") # enter search term
        self.clear()

        #with the search query we format it and look for the module
        y = self.cm.searchModule(query)

        #y will return the module id if found
        if(y > -1):
            z = self.choice("Edit? Yes: 1, No: 0 : ", "binary") #custom input to handle base 10 error errors
            if(z == 0):
                msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
                self.goBack(msg, self.moduleScreen) 
            elif(z == 1):
                module = self.cm.modules[y]
                name = self.choice("Module Name: ", "text")
                module.name = name
                ects = self.choice("ECTs: ", "numbers")
                module.num_ects = ects
                msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
                self.goBack(msg, self.moduleScreen)  
        else:
            msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
            self.goBack(msg, self.moduleScreen)  
    def addModuleScreen(self):
        self.clear()
        print(Color("{autoblue}Add new module:{/autoblue}"))
        name = self.choice("Module Name: ", "text")
        ect = self.choice("ECT amount: ", "numbers")
        self.addModule(name, ect)#string validation and checking if item exists already
        msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
        self.goBack(msg, self.moduleScreen) 
    def deleteModuleScreen(self):
        self.clear()
        self.cm.viewAllModule()
        print(Color("{autored}Delete Module:{/autored}"))
        id = self.choice("Module Id: ", "numbers")
        self.cm.deleteModule(id)#string validation and checking if item exists already
        msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
        self.goBack(msg, self.moduleScreen) 
    def bulkEnrollStudentScreen(self):
        #first we show a list to the user and ask them to pick a module
        self.clear()
        self.cm.viewAllModule()
        print(Color("Pick a {autoblue}Module{/autoblue} to enroll students into."))
        mod_id = self.choice("Module Id: ", "numbers")
        
        #now we show that module and the students in it
        self.clear()
        y = self.cm.searchModule(str(mod_id))

        #we now ask the user to add students to the module
        if(y > -1): 
            print(Color("Enter the IDs of Students to enroll into {autoblue}" + str(self.cm.modules[mod_id].name) + "{/autoblue} followed by a comma \',\': "))
            z = self.choice("Student IDs: ", "any")
            if(z == ""):
                msg = Color("{autoblue}Nothing entered. Press Enter to return to module menu...{/autoblue}")
                self.goBack(msg, self.moduleScreen) 
            else:
                result = z.lower()
                result = result.replace(" ", "")
                result = result.split(",")
                print(result)
                for stu_id in result:
                    self.cm.enrollStudent(stu_id, mod_id)
                msg = Color("{autoblue}enrolled students in module{/autoblue}")
                self.goBack(msg, self.moduleScreen) 
        else:
            msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
            self.goBack(msg, self.studentScreen)  
    def bulkUnenrollStudentScreen(self):
        #first we show a list to the user and aask them to pick a module
        self.clear()
        self.cm.viewAllModule()
        print(Color("Pick a {autoblue}Module{/autoblue} to unenroll students from."))
        mod_id = self.choice("Module Id: ", "numbers")
        
        #now we show that module and the students in it
        self.clear()
        y = self.cm.searchModule(str(mod_id))

        #we now ask the user to remove students to the module
        if(y > -1): 
            print(Color("Enter the IDs of Students to unenroll from {autoblue}" + str(self.cm.modules[mod_id].name) + "{/autoblue} followed by a comma \',\': "))
            z = str(input("Student IDs: "))
            if(z == ""):
                msg = Color("{autoblue}Nothing entered. Press Enter to return to module menu...{/autoblue}")
                self.goBack(msg, self.moduleScreen) 
            else:
                result = z.lower()
                result = result.replace(" ", "")
                result = result.split(",")
                print(result)
                for stu_id in result:
                    self.cm.unenrollStudent(stu_id, mod_id)
                msg = Color("{autoblue}unenrolled students in module{/autoblue}")
                self.goBack(msg, self.moduleScreen) 
        else:
            msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
            self.goBack(msg, self.studentScreen)   
    #utilities
    def clear(self): 
        """
        This function was taken from https://www.geeksforgeeks.org/clear-screen-python/ to
        allow the terminal to be cleared when changing menus or showing the user important
        messages. It checks what operating system is being used and uses the correct 
        clearing command.
        """
        # for windows 
        if name == 'nt': 
            _ = system('cls') 
    
        # for mac and linux(here, os.name is 'posix')
        else: 
            _ = system('clear')
    def goBack(self, msg, action):
        self.clear()
        print(msg)
        input("Press Enter to continue...")
        method_to_run = action()
        return method_to_run   
    def choice(self, msg, type="binary"):#form validation default is binary choice
        #type="numbers"
        if(type=="binary"):#used to fix base 10 error and hitting spacebar or enter on empty string
            pattern = "[0-1]+"
            x = input(msg) 

            valid = False
            valid_binary = 0
            while !valid:
                if(re.search(pattern, str(x))):
                    valid = True
                    valid_binary = int(x)
                else:
                    valid = False
                    msg = Color("{autored}Only 1 or 0 accepted{/autored}") + ". Try again: "
                    x = str(input(msg))
            return valid_binary
        elif(type=="text"):
            pattern = "[a-zA-Z]+\s[a-zA-Z]+"
            x = input(msg)
            valid = False
            valid_text = ""
            while !valid:
                if(re.search(pattern, str(x))):
                    valid = True
                    valid_text = str(x)
                else:
                    valid = False
                    msg = Color("{autored}Only text accepted{/autored}") + ". Try again: "
                    x = str(input(msg))
            return valid_text
        elif(type=="email"):#email validation
            #pattern accepts uppercase, lowercase and numbers
            #plus means we want 1 or more of these characters
            #we first check everything until we hit an @ symbol
            #then up to dot using backslash
            #finally we only accept a .com or a .ie email address
            # This was adapted from https://www.youtube.com/watch?v=UQQsYXa1EHs
            pattern = "[a-zA-Z0-9]+@[a-zA-Z]+\.(com|ie)"
            x = input(msg)
            valid = False
            valid_email = ""
            while !valid:
                if(re.search(pattern, str(x))):
                    valid = True
                    valid_email = str(x)
                else:
                    valid = False
                    msg = Color("{autored}Invalid email{/autored}") + ". Try again: "
                    x = str(input(msg))
            return valid_email
        elif(type=="numbers"):
            pattern = "[0-9]+"
            x = input(msg)
            valid = False
            valid_numbers = ""
            while !valid:
                if(re.search(pattern, str(x))):
                    valid = True
                    valid_numbers = int(x)
                else:
                    valid = False
                    msg = Color("{autored}Only numbers accepted{/autored}") + ". Try again: "
                    x = str(input(msg))
            return valid_numbers
        elif(type=="any"):#everything accepted. Used for search queries
            x = input(msg)
            return str(x)     
    def quitApp(self):
        self.clear()
        print("quitting " + Color("{autoblue}pyLearn{/autoblue}") + "...")
        input("Press Enter to continue...")
        exit()#quit program

if __name__ == "__main__":
    uni = CollegeUI()
    uni.demo()#load demo students and modules
    uni.welcomeScreen() #start the program
