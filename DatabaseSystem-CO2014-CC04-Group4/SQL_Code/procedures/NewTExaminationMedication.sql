CREATE PROCEDURE hospital.NewTExaminationMedication
    @Patient_ID CHAR(7),
    @Exam_ID INTEGER,
    @Drug_Code INTEGER,
    @Amount INTEGER
AS
    DECLARE @TransactionName VARCHAR(20) = 'NewTExaminationMedication';
    BEGIN TRANSACTION @TransactionName;
        BEGIN TRY

        INSERT INTO hospital.EXAMINATION_MEDICATION(Patient_ID, Exam_ID,Drug_Code, Amount)
        VALUES(@Patient_ID, @Exam_ID, @Drug_Code, @Amount);

        COMMIT TRANSACTION @TransactionName;
        END TRY
        BEGIN CATCH
        ROLLBACK TRANSACTION @TransactionName;
        END CATCH