CREATE PROCEDURE hospital.NewInpatient
    @First_Name VARCHAR(7),
    @Last_Name VARCHAR(35),
    @Date_Of_Birth DATE,
    @Gender CHAR(1),
    @Address VARCHAR(50),
    @Phone VARCHAR(11),
    @Nurse_ID INTEGER,
    @Admission_Date DATE,
    @Sickroom CHAR(4),
    @Diagnosis VARCHAR(30),
    @Fee NUMERIC(10,1),
    @Doctor_ID INTEGER
AS
    DECLARE @TransactionName VARCHAR(20) = 'AddNewInpatient';
    DECLARE @patient_id CHAR(7);
    DECLARE @admission_id INTEGER;
    BEGIN TRANSACTION @TransactionName;
        BEGIN TRY

        SELECT @patient_id = CONCAT('IP',format(NEXT VALUE FOR hospital.InpatientSeq, '00000'));
        SELECT @admission_id = NEXT VALUE FOR hospital.AdmissionSeq;

        INSERT INTO hospital.INPATIENT(Patient_ID, First_Name, Last_Name, Date_Of_Birth, Gender, Address, Phone)
        VALUES(@patient_id, @First_Name, @Last_Name, @Date_Of_Birth, @Gender, @Address, @Phone);
        
        INSERT INTO hospital.ADMISSION(Admission_ID, Patient_ID, Nurse_ID, Admission_Date, Discharge_Date, Sickroom, Diagnosis, Fee)
        VALUES(@admission_id, @patient_id, @Nurse_ID, @Admission_Date, NULL, @Sickroom, @Diagnosis, @Fee);

        INSERT INTO hospital.TREATMENT(Admission_ID, Treatment_ID, START_DATE, END_DATE, Result)
        VALUES(@admission_id, 1, @Admission_Date, @Admission_Date, 'nhap vien');

        INSERT INTO hospital.TREATMENT_DOCTOR(Admission_ID, Treatment_ID, Doctor_ID)
        VALUES(@admission_id, 1, @Doctor_ID)

        COMMIT TRANSACTION @TransactionName;
        END TRY
        BEGIN CATCH
        ROLLBACK TRANSACTION @TransactionName;
        END CATCH