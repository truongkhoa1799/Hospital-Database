-- ----------------------------- Create Sequences -----------------------------
CREATE SEQUENCE hospital.AdmissionSeq  
    AS INT  
    START WITH 1  
    INCREMENT BY 1;

CREATE SEQUENCE hospital.InpatientSeq  
    AS INT  
    START WITH 1  
    INCREMENT BY 1;

CREATE SEQUENCE hospital.OutpatientSeq  
    AS INT  
    START WITH 1  
    INCREMENT BY 1;

drop SEQUENCE hospital.AdmissionSeq;
drop SEQUENCE hospital.InpatientSeq;
drop SEQUENCE hospital.OutpatientSeq;

-- ----------------------------- Create tables -----------------------------
-- Create MEDICATION table
CREATE TABLE hospital.MEDICATION
(
    Drug_Code INTEGER IDENTITY(1,1),
    Name VARCHAR(20) NOT NULL,
    Effects VARCHAR(100) NOT NULL,
    Price NUMERIC(10,1) NOT NULL,
    Expiration_Date DATE NOT NULL,
    Out_Date CHAR(1) NOT NULL DEFAULT 0,
    CHECK(Out_Date IN ('0','1')),
    CONSTRAINT Empty_PK_MEDICATION
        PRIMARY KEY(Drug_Code)
);

-- Create EMPLOYEE table
CREATE TABLE hospital.EMPLOYEE
(
    Employee_ID INTEGER IDENTITY(1,1),
    Dep_ID INTEGER NOT NULL,
    First_Name VARCHAR(7) NOT NULL,
    Last_Name VARCHAR(35) NOT NULL,
    Date_Of_Birth DATE NOT NULL,
    Gender CHAR(1) NOT NULL,
    Address VARCHAR(50) NOT NULL,
    Start_Date DATE NOT NULL,
    Job_Type CHAR(1) NOT NULL,
    Special_Name VARCHAR(40),
    Year_Graduate DATE,
    CONSTRAINT Empty_PK_EMPLOYEE
        PRIMARY KEY (Employee_ID),
    CHECK(Gender IN ('m','f')),
    CHECK(Job_Type IN ('d', 'n')),
    CHECK(DATEDIFF(year,Date_Of_Birth,GETDATE()) > 18)
);

-- Create DEPARTMENT table
CREATE TABLE hospital.DEPARTMENT
(
    Dep_ID INTEGER IDENTITY(1,1),
    Title VARCHAR(20) NOT NULL,
    Dean_ID INTEGER NOT NULL,
    CONSTRAINT Empty_PK_DEPARTMENT
        PRIMARY KEY (Dep_ID),
    CONSTRAINT Empty_FK_Dean_ID_DEPARTMENT
        FOREIGN KEY (Dean_ID) REFERENCES hospital.EMPLOYEE(Employee_ID)
);

-- add foreign key deapartment_id for employee
ALTER TABLE hospital.EMPLOYEE
ADD CONSTRAINT Empty_FK_Dep_ID_EMPLOYEE
    FOREIGN KEY (Dep_ID) REFERENCES hospital.DEPARTMENT(Dep_ID);

-- Create EMPLOYEE_PHONE table
CREATE TABLE hospital.EMPLOYEE_PHONE
(
    Employee_ID INT NOT NULL,
    Phone VARCHAR(11) NOT NULL,
    CONSTRAINT Empty_PK_EMPLOYEE_PHONE
        PRIMARY KEY (Employee_ID, Phone),
    CONSTRAINT Empty_FK_Employee_ID_EMPLOYEE_PHONE
        FOREIGN KEY (Employee_ID) REFERENCES hospital.EMPLOYEE(Employee_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CHECK(LEN(Phone) IN (10,11))
);

-- Create INPATIENT table
CREATE TABLE hospital.INPATIENT
(
    Patient_ID CHAR(7) NOT NULL,
    First_Name VARCHAR(7) NOT NULL,
    Last_Name VARCHAR(35) NOT NULL,
    Date_Of_Birth DATE NOT NULL,
    Gender CHAR(1) NOT NULL,
    Address VARCHAR(50) NOT NULL,
    Phone VARCHAR(11) NOT NULL,
    CONSTRAINT Empty_PK_INPATIENT
        PRIMARY KEY (Patient_ID),
    CHECK(Gender IN ('m','f')),
    CHECK(LEN(Phone) IN (10,11)),
    CHECK(SUBSTRING(Patient_ID, 1,2) = 'IP')
);

CREATE TABLE hospital.ADMISSION
(
    Admission_ID INTEGER NOT NULL,
    Patient_ID CHAR(7) NOT NULL,
    Nurse_ID INTEGER NOT NULL DEFAULT 0,
    Admission_Date DATE NOT NULL,
    Discharge_Date DATE,
    Sickroom CHAR(4) NOT NULL,
    Diagnosis VARCHAR(50) NOT NULL,
    Fee NUMERIC(10,1) NOT NULL DEFAULT 0,
    CONSTRAINT Empty_PK_ADMISSION
        PRIMARY KEY (Admission_ID),
    CONSTRAINT Empty_FK_Patient_ID_ADMISSION
        FOREIGN KEY (Patient_ID) REFERENCES hospital.INPATIENT(Patient_ID),
    CONSTRAINT Empty_FK_Nurse_ID_ADMISSION
        FOREIGN KEY (Nurse_ID) REFERENCES hospital.EMPLOYEE(Employee_ID)
        ON DELETE SET DEFAULT
        ON UPDATE CASCADE
);

-- Create TREATMENT table
CREATE TABLE hospital.TREATMENT(
    Admission_ID INTEGER NOT NULL,
    Treatment_ID INTEGER NOT NULL,
    START_DATE DATE NOT NULL,
    END_DATE DATE NOT NULL,
    Result VARCHAR(50) NOT NULL,
    CONSTRAINT Empty_PK_TREATMENT
        PRIMARY KEY(Admission_ID, Treatment_ID),
    CONSTRAINT Empty_FK_Admission_ID_TREATMENT
        FOREIGN KEY (Admission_ID) REFERENCES hospital.ADMISSION(Admission_ID)
);

-- Create TREATMENT_DOCTOR table
CREATE TABLE hospital.TREATMENT_DOCTOR
(
    Admission_ID INTEGER NOT NULL,
    Treatment_ID INTEGER NOT NULL,
    Doctor_ID INTEGER NOT NULL DEFAULT -1,
    CONSTRAINT Empty_PK_TREATMENT_DOCTOR
        PRIMARY KEY(Admission_ID, Treatment_ID, Doctor_ID),
    CONSTRAINT Empty_FK_Admission_ID_Treatment_ID_TREATMENT_DOCTOR
        FOREIGN KEY(Admission_ID,Treatment_ID) REFERENCES hospital.TREATMENT(Admission_ID,Treatment_ID),
    CONSTRAINT Empty_FK_Doctor_ID_TREATMENT_DOCTOR
        FOREIGN KEY(Doctor_ID) REFERENCES hospital.EMPLOYEE(Employee_ID)
        ON DELETE SET DEFAULT
        ON UPDATE CASCADE
);

CREATE TABLE hospital.TREATMENT_MEDICATION
(
    Admission_ID INTEGER NOT NULL,
    Treatment_ID INTEGER NOT NULL,
    Drug_Code INTEGER NOT NULL DEFAULT 0,
    Amount INT NOT NULL,
    CONSTRAINT Empty_PK_TREATMENT_MEDICATION
        PRIMARY KEY(Admission_ID,Treatment_ID, Drug_Code),
    CONSTRAINT Empty_FK_Admission_ID_Treatment_ID_TREATMENT_MEDICATION
        FOREIGN KEY(Admission_ID,Treatment_ID) REFERENCES hospital.TREATMENT(Admission_ID,Treatment_ID),
    CONSTRAINT Empty_FK_Drug_Code_TREATMENT_MEDICATION
        FOREIGN KEY(Drug_Code) REFERENCES hospital.MEDICATION(Drug_Code)
        ON DELETE SET DEFAULT
        ON UPDATE CASCADE
);

-- Create OUTPATIENT table
CREATE TABLE hospital.OUTPATIENT
(
    Patient_ID CHAR(7) NOT NULL,
    First_Name VARCHAR(7) NOT NULL,
    Last_Name VARCHAR(35) NOT NULL,
    Phone VARCHAR(11) NOT NULL,
    Address VARCHAR(50) NOT NULL,
    Gender CHAR(1) NOT NULL,
    Date_Of_Birth DATE NOT NULL,
    CONSTRAINT Empty_PK_OUTPATIENT
        PRIMARY KEY (Patient_ID),
    CHECK(Gender IN ('m','f')),
    CHECK(LEN(Phone) IN (10,11)),
    CHECK(SUBSTRING(Patient_ID, 1,2) = 'OP')
);

-- Create EXAMINATION table
CREATE TABLE hospital.EXAMINATION
(
    Patient_ID CHAR(7) NOT NULL,
    Exam_ID INTEGER NOT NULL,
    Doctor_Exam_ID INTEGER NOT NULL DEFAULT -1,
    Exam_Date DATE NOT NULL,
    Second_Exam_Date DATE,
    Diagnosis VARCHAR(50) NOT NULL,
    Fee NUMERIC(10,1) NOT NULL,
    CONSTRAINT Empty_PK_EXAMINATION
        PRIMARY KEY(Patient_ID, Exam_ID),
    CONSTRAINT Empty_FK_Patient_ID_EXAMINATION
        FOREIGN KEY (Patient_ID) REFERENCES hospital.OUTPATIENT(Patient_ID),
    CONSTRAINT Empty_FK_Doctor_Exam_ID_EXAMINATION
        FOREIGN KEY (Doctor_Exam_ID) REFERENCES hospital.EMPLOYEE(Employee_ID)
        ON DELETE SET DEFAULT
        ON UPDATE CASCADE
);

CREATE TABLE hospital.EXAMINATION_MEDICATION
(
    Patient_ID CHAR(7) NOT NULL,
    Exam_ID INTEGER NOT NULL,
    Drug_Code INTEGER NOT NULL DEFAULT 0,
    Amount INT NOT NULL,
    CONSTRAINT Empty_PK_EXAMINATION_MEDICATION
        PRIMARY KEY(Patient_ID,Exam_ID, Drug_Code),
    CONSTRAINT Empty_FK_Patient_ID_Exam_ID_EXAMINATION_MEDICATION
        FOREIGN KEY(Patient_ID,Exam_ID) REFERENCES hospital.EXAMINATION(Patient_ID,Exam_ID),
    CONSTRAINT Empty_FK_Drug_Code_EXAMINATION_MEDICATION
        FOREIGN KEY(Drug_Code) REFERENCES hospital.MEDICATION(Drug_Code)
        ON DELETE SET DEFAULT
        ON UPDATE CASCADE
);