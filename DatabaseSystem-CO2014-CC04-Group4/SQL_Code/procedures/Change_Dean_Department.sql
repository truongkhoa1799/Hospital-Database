CREATE OR ALTER PROCEDURE hospital.Change_Dean_Department
    @Replace_Dean_ID INTEGER,
    @Dep_ID INTEGER
AS
    DECLARE @TransactionName VARCHAR(20) = 'ChangeDeanDepartment';
    BEGIN TRANSACTION @TransactionName;
        BEGIN TRY
            UPDATE hospital.DEPARTMENT
            SET Dean_ID = @Replace_Dean_ID
            WHERE Dep_ID = @Dep_ID;
            COMMIT TRANSACTION @TransactionName; 
        END TRY
        BEGIN CATCH
            PRINT 'Error occurs when create new dep with new dean'
            ROLLBACK TRANSACTION @TransactionName; 
        END CATCH