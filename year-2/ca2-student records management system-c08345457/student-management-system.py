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

class MainMenu(Course):
    def __init__(self):
        self.course = Course("TU060", "Advanced Software Development", \
            "MSc in Computer Science Advanced Software Development.")
        self.demoModules()

    def demoModules(self):
        self.course.addModule("Programming Paradigms: Principles & Practice", 5)
        self.course.addModule("Software Design", 5)
        self.course.addModule("Advanced Databases", 5)
        self.course.addModule("Systems Architectures", 5)
        self.course.addModule("Web Application Architectures", 5)
        self.course.addModule("Secure Systems Development", 5)
        self.course.addModule("Critical Skills Core Modules", 5)
        self.course.addModule("Research Writing & Scientific Literature", 5)
        self.course.addModule("Research Methods and Proposal Writing", 5)
        self.course.addModule("Research Project & Dissertation", 5)
        self.course.addModule("Option Modules", 5)
        self.course.addModule("Geographic Information Systems", 5)
        self.course.addModule("Universal Design", 5)
        self.course.addModule("Programming for Big Data", 5)
        self.course.addModule("Problem Solving, Communication and Innovation", 5)
        self.course.addModule("Social Network Analysis", 5)
        self.course.addModule("User Experience Design", 5)
        self.course.addModule("Security", 5)
        self.course.addModule("Deep Learning", 5)
        self.course.addModule("Speech & Audio Processing", 5)
        self.course.addStudent("jon", "jon@terminator.com")
        for mod_id, mod in self.course.modules.items():
            print(str(mod_id) + ", " + mod.name)
        print(self.course.students[0].name)
        print(self.course.code)
        print(self.course.name)
        print(self.course.description)

if __name__ == "__main__":
    MainMenu()

