CREATE ROCEDURE hospital.NewTreatmentMedication
    @Admission_ID INTEGER,
    @Treatment_ID INTEGER,
    @Drug_Code INTEGER,
    @Amount INTEGER
AS
    DECLARE @TransactionName VARCHAR(20) = 'NewTreatmentMedication';
    BEGIN TRANSACTION @TransactionName;
        BEGIN TRY

        INSERT INTO hospital.TREATMENT_MEDICATION(Admission_ID, Treatment_ID,Drug_Code, Amount)
        VALUES(@Admission_ID, @Treatment_ID, @Drug_Code, @Amount);

        COMMIT TRANSACTION @TransactionName;
        END TRY
        BEGIN CATCH
        ROLLBACK TRANSACTION @TransactionName;
        END CATCH