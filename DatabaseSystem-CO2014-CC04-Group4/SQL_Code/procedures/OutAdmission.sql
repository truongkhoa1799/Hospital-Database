CREATE PROCEDURE hospital.OutAdmission
    @Patient_ID CHAR(7),
    @Discharge_Date DATE
AS
    DECLARE @TransactionName VARCHAR(20) = 'OutAdmission';
    BEGIN TRANSACTION @TransactionName;
        BEGIN TRY

        UPDATE hospital.ADMISSION
        SET Discharge_Date = @Discharge_Date
        WHERE   Patient_ID = @Patient_ID
            AND Discharge_Date IS NULL;

        COMMIT TRANSACTION @TransactionName; 
        END TRY
        BEGIN CATCH
        ROLLBACK TRANSACTION @TransactionName; 
        END CATCH