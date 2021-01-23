CREATE PROCEDURE hospital.NewExamination
    @Patient_ID CHAR(7),
    @Doctor_Exam_ID INTEGER,
    @Exam_Date DATE,
    @Second_Exam_Date DATE,
    @Diagnosis VARCHAR(30),
    @Fee NUMERIC(10,1)
AS
    DECLARE @TransactionName VARCHAR(20) = 'Create new examination';
    DECLARE @examination_id INTEGER;
    BEGIN TRANSACTION @TransactionName;
        BEGIN TRY

        SELECT @examination_id =  MAX(Exam_ID) + 1
        FROM hospital.EXAMINATION
        WHERE Patient_ID = @Patient_ID;

        INSERT INTO hospital.EXAMINATION(Patient_ID, Exam_ID, Doctor_Exam_ID, Exam_Date, Second_Exam_Date, Diagnosis, Fee)
        VALUES(@Patient_ID, @examination_id, @Doctor_Exam_ID, @Exam_Date, @Second_Exam_Date, @Diagnosis, @Fee);

        COMMIT TRANSACTION @TransactionName; 
        END TRY
        BEGIN CATCH
        ROLLBACK TRANSACTION @TransactionName; 
        END CATCH;