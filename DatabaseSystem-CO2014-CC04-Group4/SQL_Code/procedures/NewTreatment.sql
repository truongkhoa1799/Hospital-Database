CREATE PROCEDURE hospital.NewTreatment
    @Admission_ID INTEGER,
    @START_DATE DATE,
    @END_DATE DATE,
    @Result VARCHAR(30),
    @Doctor_ID INTEGER
AS
    DECLARE @TransactionName VARCHAR(20) = 'NewTreatment';
    DECLARE @treatment_id INTEGER;
    BEGIN TRANSACTION @TransactionName;
        BEGIN TRY

        SELECT @treatment_id = MAX(Treatment_ID) + 1
        FROM hospital.TREATMENT
        WHERE Admission_ID = @Admission_ID;
        
        INSERT INTO hospital.TREATMENT(Admission_ID, Treatment_ID, START_DATE, END_DATE, Result)
        VALUES(@Admission_ID, @treatment_id, @START_DATE, @END_DATE, @Result);

        INSERT INTO hospital.TREATMENT_DOCTOR(Admission_ID, Treatment_ID, Doctor_ID)
        VALUES(@Admission_ID, @treatment_id, @Doctor_ID);

        COMMIT TRANSACTION @TransactionName;
        END TRY
        BEGIN CATCH
        ROLLBACK TRANSACTION @TransactionName;
        END CATCH