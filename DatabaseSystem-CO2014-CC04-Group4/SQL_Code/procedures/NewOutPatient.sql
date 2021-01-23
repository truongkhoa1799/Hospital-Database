CREATE PROCEDURE hospital.NewOutPatient
    @First_Name VARCHAR(7),
    @Last_Name VARCHAR(35),
    @Phone VARCHAR(11),
    @Address VARCHAR(50),
    @Gender CHAR(1),
    @Date_Of_Birth DATE,
    @Doctor_Exam_ID INTEGER,
    @Exam_Date DATE,
    @Second_Exam_Date DATE,
    @Diagnosis VARCHAR(30),
    @Fee NUMERIC(10,1),
    @Drug_Code INTEGER
AS
    DECLARE @TransactionName VARCHAR(20) = 'Create new outpatient';
    DECLARE @patient_id CHAR(7);
    BEGIN TRANSACTION @TransactionName;
        BEGIN TRY

        SELECT @patient_id = CONCAT('OP',format(NEXT VALUE FOR hospital.InpatientSeq, '00000'));

        INSERT INTO hospital.OUTPATIENT(Patient_id, First_Name, Last_Name, Phone, Address, Gender, Date_Of_Birth)
        VALUES(@patient_id, @First_Name, @Last_Name, @Phone, @Address, @Gender, @Date_Of_Birth);

        INSERT INTO hospital.EXAMINATION(Patient_ID, Exam_ID, Doctor_Exam_ID, Exam_Date, Second_Exam_Date, Diagnosis, Fee)
        VALUES(@patient_id, 1, @Doctor_Exam_ID, @Exam_Date, @Second_Exam_Date, @Diagnosis, @Fee);

        INSERT into hospital.EXAMINATION_MEDICATION(Patient_ID, Exam_ID, Drug_Code)
        VALUES(@patient_id, 1, @Drug_Code)

        COMMIT TRANSACTION @TransactionName; 
        END TRY
        BEGIN CATCH
        ROLLBACK TRANSACTION @TransactionName; 
        END CATCH;