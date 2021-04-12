You are asked to develop a small college management system to illustrate your understanding of the main object-oriented concepts.
Your system should keep track of Students. Each student has a student ID, name, email address and list of current modules they are taking. Each student can enrol in up to 5 modules max.
Each Module has an unique code, a name, a number of ECTS credits. Each module also has a max capacity, and once that is reached no more students can be enrolled until somebody unenrolls first.
You’ll need to keep track of, and update, what modules are students enrolled in.
Some of the functionality your system should provide is:
    • Print and update details about the students
    • Print and update details about the modules
    • Search for a student using different parameters (e.g. by email or student ID)
    • Enrol and unenroll a student from a module
    • Create and delete students and modules

Make sure you include any relevant error checking and handle unexpected input.


class Student
    #id
    #name
    #email
    #list of modules (max 5)

    #updateDetail
    #getDetail

class Module
    #id
    #name
    #num_ects
    #max capacity
    
    #enrol student
    #unenroll student

class College
    #add student
    #add module
    #delete student
    #delete module