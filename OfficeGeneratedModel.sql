DROP TABLE Employee;

DROP TABLE Department;

DROP TABLE Supervisor;

DROP TABLE Project;

CREATE TABLE Department
(
	DepartmentName       CHAR(18) NOT NULL,
	CONSTRAINT XPKDepartment PRIMARY KEY (DepartmentName)
);

CREATE TABLE Employee
(
	EmployeeNumber       INTEGER NOT NULL,
	DepartmentName       CHAR(18) NULL,
	EmployeeName         CHAR(18) NULL,
	CONSTRAINT XPKEmployee PRIMARY KEY (EmployeeNumber)
);

CREATE TABLE Project
(
	ProjectNumber        INTEGER NOT NULL,
	ProjectName          CHAR(18) NULL,
	CONSTRAINT XPKProject PRIMARY KEY (ProjectNumber)
);

CREATE TABLE Supervisor
(
	SupervisorNumber     INTEGER NOT NULL,
	SupervisorName       CHAR(18) NULL,
	CONSTRAINT XPKSupervisor PRIMARY KEY (SupervisorNumber)
);

ALTER TABLE Employee
ADD CONSTRAINT R_12 FOREIGN KEY (DepartmentName) REFERENCES Department (DepartmentName);
