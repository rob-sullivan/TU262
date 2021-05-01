"""
Copyright 2021, Rob Sullivan, All rights reserved.
@author Rob Sullivan <http://mailto:c08345457@mytudublin.ie> 

What is it:
This program is a simple implementation of a small college management system to 
illustrate main object-oriented concepts

How it works:
The system is made up of a student and module entity. A course controller manages data taken from the user
in the menu boundary object.

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


TODO(rob): form validation on student menu
TODO(rob): modules menu

"""
"""
"""
# We install both terminaltables and colorClass to create a simple gui for the user in the terminal
from terminaltables import AsciiTable # we are using the ascii table layout.
from colorclass import Color, Windows # we are using color and windows to color the qty level in the terminal
from os import system, name # used for clearing terminal function

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
    
    def __init__(self, code, name, description, max_mod, max_stu):
        self.code = code
        self.name = name
        self.description = description
        # max set here at parent level
        self.max_modules_taken = max_mod #5
        self.max_module_students = max_stu #20

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
        
        student.modules_taken[mod_id] = module
        module.students_in_module[stu_id] = student
    #unenroll Student
    def unenrollStudent(self, stu_id, mod_id):
        stu_id = int(stu_id)
        mod_id = int(mod_id)
        student = self.students[stu_id]
        student.modules_taken.pop(mod_id) #remove module from student     
        module = self.modules[mod_id]
        module.students_in_module.pop(stu_id) #remove student from module

# This is a boundary class that takes user input and sends it to the controller class.
class CollegeUI(CourseManager, StudentMenuUI, ModuleMenuUI):
    def __init__(self):
        self.cm = CourseManager("TU060", "Advanced Software Development", \
            "MSc in Computer Science Advanced Software Development.", 5, 20)
        self.demo() #load our demo content of modules and students
        self.mainMenu() # start the main menu
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
    def __init__(self):
        self.c = CourseManager("TU060", "Advanced Software Development", \
            "MSc in Computer Science Advanced Software Development.", 5, 20)
        self.welcomeScreen()
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
            x = choice("Main Menu: Choose an option: ") #custom input to handle base 10 error errors

            if(x == 0):
                self.quitApp()#tells user app will close then quits
            elif(x == 1):
                self.StudentMenuUI()
            elif(x == 2):
                self.ModuleMenuUI()
            else:
                raise
                msg = Color("{autored}Not a valid choice. Try again{/autored}")
                self.goBack(msg, self.WelcomeScreen)

        except:
            raise
            msg = Color("{autored}Not a valid choice. Try again{/autored}")
            self.goBack(msg, self.WelcomeScreen)

        #get the student
        self.clear()
        self.c.viewAllStudents()
        print(Color("{autoblue}View Student:{/autoblue}"))
        stu_id = int(input("Student Id: "))
        
        #get the module
        self.clear()
        self.c.searchStudent(str(stu_id))#string validation and checking if item exists already
        print(Color("{autoblue}Select course to unenroll{/autoblue} "+ self.cm.students[stu_id].name +" {autoblue}from:{/autoblue}"))
        mod_id = int(input("Module Id: "))
        
        #now unenrol the student in the module
        self.c.unenrollStudent(stu_id, mod_id)
        self.clear()

        #now go back to the main student menu
        self.c.searchStudent(str(stu_id))#string validation and checking if item exists already
        input("Press Enter to return to student menu...")
        self.studentsMenu()
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
    def choice(self, msg):
        x = input(msg)
        #used to fix base 10 error, 
        # # just hitting enter will close the program
        if(x == ""):
            x = 0
        else:
            x = int(x)
        return x   
    def quitApp(self):
            self.clear()
            print("quitting " + Color("{autoblue}pyLearn{/autoblue}") + "...")
            input("Press Enter to continue...")
            return False #set run to false and quit program

class StudentMenuUI(CollegeUI):
    def __init__(self):
        self.c = CollegeUI()
        self.studentScreen()
    def studentScreen(self):
        self.c.clear()
        # main title
        print("** Welcome to " + Color("{autoblue}pyLearn{/autoblue}") + " College Management System ** \nCreated by Rob Sullivan v1.0.0")
        self.c.viewAllStudents()
        print("""
        Students Menu:

            1. View Student Details
            2. Add Student
            3. Delete Student
            4. Enrol Student
            5. Unenrol Student

            *Press 0 to go back*
        """)
        self.studentOptions()
    def studentOptions(self):
        try:
            x = c.choice("Students Menu: Choose an option: ") #custom input to handle base 10 error errors
            
            if(x == 0):#return to previous menu
                msg = Color("{autoblue}Returning to Main Menu{/autoblue}")
                self.c.goBack(msg, self.c.WelcomeScreen)
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
                msg = Color("{autored}Not a valid choice. Try again{/autored}")
                self.c.goBack(msg, self.WelcomeScreen)
        except:
            raise
            msg = Color("{autored}Not a valid choice. Try again{/autored}")
            self.c.goBack(msg, self.WelcomeScreen)
    def studentProfileScreen(self):
        #show a list of all students.
        self.clear()
        self.c.viewAllStudents()#show a list of students
        print(Color("{autoblue}View Student:{/autoblue}"))

        #now we get a search query from the user.
        query = str(input("Search for a student by id, name or email: "))
        self.c.clear()

        #with the search query we format it and look for the student
        y = self.c.searchStudent(query)#string validation and checking if item exists already

        #y will return the student id if found
        if(y > -1):
            z = self.c.choice("Edit? Yes: 1, No: 0 : ") #custom input to handle base 10 error errors
            if(z == 0):
                msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
                self.c.goBack(msg, self.studentScreen)  
            elif(z == 1):
                student = self.cm.students[y]
                name = input("Student Name: ")
                student.name = name
                email = input("Student Email: ")
                student.email = email
                msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
                self.c.goBack(msg, self.studentScreen)  
        else:
            msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
            self.c.goBack(msg, self.studentScreen)  
    def addStudentScreen():
        self.clear()
        print(Color("{autoblue}Add new student:{/autoblue}"))
        name = input("Student Name: ")
        email = input("Student Email: ")
        self.c.addStudent(name, email)#string validation and checking if item exists already
        msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
        self.c.goBack(msg, self.studentsMenu)  
    def deleteStudentScreen():
        self.clear()
        self.c.viewAllStudents()
        print(Color("{autored}Delete student:{/autored}"))
        id = int(input("Student Id: "))
        self.c.deleteStudent(id)#string validation and checking if item exists already
        msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
        self.c.goBack(msg, self.studentsMenu)
    def enrollStudentScreen():
        #get the student
        self.clear()
        self.c.viewAllStudents()
        print(Color("{autoblue}Select Student to enroll:{/autoblue}"))
        stu_id = int(input("Student Id: "))

        #get the module
        self.clear()
        self.c.viewAllModule()
        print(Color("{autoblue}Select cm to enroll{/autoblue} " + self.cm.students[stu_id].name + " {autoblue}into:{/autoblue}"))
        mod_id = int(input("Module Id: "))

        #now enrol the student in the module
        self.c.enrollStudent(stu_id, mod_id)
        self.clear()
        self.c.searchStudent(str(stu_id))#string validation and checking if item exists already

        #now go back to the main student menu
        msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
        self.c.goBack(msg, self.studentsMenu)
    def unenrollStudentScreen():
        #get the student
        self.clear()
        self.c.viewAllStudents()
        print(Color("{autoblue}Select Student to enroll:{/autoblue}"))
        stu_id = int(input("Student Id: "))

        #get the module
        self.clear()
        self.c.viewAllModule()
        print(Color("{autoblue}Select cm to enroll{/autoblue} " + self.cm.students[stu_id].name + " {autoblue}into:{/autoblue}"))
        mod_id = int(input("Module Id: "))

        #now unenrol the student in the module
        self.c.unenrollStudent(stu_id, mod_id)
        self.clear()
        self.c.searchStudent(str(stu_id))#string validation and checking if item exists already

        #now go back to the main student menu
        msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
        self.c.goBack(msg, self.studentsMenu)
class ModuleMenuUI(CollegeUI):
    def __init__(self):
        self.c = CollegeUI()
        self.moduleScreen()
    def moduleScreen()
        self.clear()
        # main title
        print("** Welcome to " + Color("{autoblue}pyLearn{/autoblue}") + " College Management System ** \nCreated by Rob Sullivan v1.0.0")
        self.c.viewAllModule()
        print("""
        Module Menu:

            1. View Module Details
            2. Add Module
            3. Delete Module
            4. Enrol Students
            5. Unenrol Students

            *Press 0 to go back*
        """)
        self.moduleOptions()
    def moduleOptions(self):
        try:
            x = c.choice("Module Menu: Choose an option: ") #custom input to handle base 10 error errors

            if(x == 0):#back to main menu
                msg = Color("{autoblue}Returning to Main Menu{/autoblue}")
                self.c.goBack(msg, self.c.WelcomeScreen)
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
                #self.clear()
                #print(Color("{autored}Not a valid choice. Try again{/autored}"))
                #input("Press Enter to continue...")
                #self.mainMenu()
        except:
            raise
            #self.clear()
            #print(Color("{autored}Not a choice. Try again{/autored}"))
            #input("Press Enter to continue...")
            #self.mainMenu()
    def moduleDetailScreen(self):
        #show a list of all modules.
        self.clear()#clear the terminal
        self.c.viewAllModule()#show a list of current modules
        print(Color("{autoblue}Search Module:{/autoblue}"))
        
        #now we get a search query from the user.
        query = str(input("Search for a module by Id or Name: ")) # enter search term
        self.clear()

        #with the search query we format it and look for the module
        y = self.cm.searchModule(query)

        #y will return the module id if found
        if(y > -1):
            z = self.c.choice("Edit? Yes: 1, No: 0 : ") #custom input to handle base 10 error errors
            if(z == 0):
                msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
                self.c.goBack(msg, self.moduleScreen) 
            elif(z == 1):
                module = self.cm.modules[y]
                name = input("Module Name: ")
                module.name = name
                ects = input("ECTs: ")
                module.num_ects = ects
                msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
                self.c.goBack(msg, self.moduleScreen)  
        else:
            msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
            self.c.goBack(msg, self.moduleScreen)  
    def addModuleStudent(self):
        self.clear()
        print(Color("{autoblue}Add new module:{/autoblue}"))
        name = input("Module Name: ")
        ect = input("ECT amount: ")
        self.c.addModule(name, ect)#string validation and checking if item exists already
        msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
        self.c.goBack(msg, self.moduleScreen) 
    def deleteStudentScreen(self):
        self.clear()
        self.c.viewAllModule()
        print(Color("{autored}Delete Module:{/autored}"))
        id = int(input("Module Id: "))
        self.c.deleteModule(id)#string validation and checking if item exists already
        msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
        self.c.goBack(msg, self.moduleScreen) 
    def bulkEnrollStudentScreen(self):
        #first we show a list to the user and ask them to pick a module
        self.clear()
        self.c.viewAllModule()
        print(Color("Pick a {autoblue}Module{/autoblue} to enroll students into."))
        mod_id = int(input("Module Id: "))
        
        #now we show that module and the students in it
        self.clear()
        y = self.cm.searchModule(str(mod_id))

        #we now ask the user to add students to the module
        if(y > -1): 
            print(Color("Enter the IDs of Students to enroll into {autoblue}" + str(self.cm.modules[mod_id].name) + "{/autoblue} followed by a comma \',\': "))
            z = str(input("Student IDs: "))
            if(z == ""):
                msg = Color("{autoblue}Nothing entered. Press Enter to return to module menu...{/autoblue}")
                self.c.goBack(msg, self.moduleScreen) 
            else:
                result = z.lower()
                result = result.replace(" ", "")
                result = result.split(",")
                print(result)
                for stu_id in result:
                    self.c.enrollStudent(stu_id, mod_id)
                msg = Color("{autoblue}enrolled student into course{/autoblue}")
                self.c.goBack(msg, self.moduleScreen) 
        else:
            msg = Color("{autoblue}Press Enter to return to student menu...{/autoblue}")
            self.c.goBack(msg, self.studentScreen)  
    def bulkUnenrollStudentScreen(self):
        #first we show a list to the user and aask them to pick a module
        self.clear()
        self.cm.viewAllModule()
        print(Color("Pick a {autoblue}Module{/autoblue} to unenroll students from."))
        mod_id = int(input("Module Id: "))
        
        #now we show that module and the students in it
        self.clear()
        y = self.cm.searchModule(str(mod_id))

        #we now ask the user to remove students to the module
        if(y>-1): 
            print(Color("Enter the IDs of Students to unenroll from {autoblue}" + str(self.cm.modules[mod_id].name) + "{/autoblue} followed by a comma \',\': "))
            z = str(input("Student IDs: "))
            if(z == ""):
                input("Nothing entered. Press Enter to return to module menu...")
                self.modulesMenu()
            else:
                result = z.lower()
                result = result.replace(" ", "")
                result = result.split(",")
                print(result)
                for stu_id in result:
                    self.cm.unenrollStudent(stu_id, mod_id)
                self.modulesMenu()
        else:
            input("Press Enter to return to module menu...")
            self.modulesMenu() 
if __name__ == "__main__":
    #CollegeUI()
    MainMenuUI()

