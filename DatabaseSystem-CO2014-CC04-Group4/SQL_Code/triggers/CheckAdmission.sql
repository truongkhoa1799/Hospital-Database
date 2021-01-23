CREATE OR ALTER TRIGGER hospital.CheckAdmission
ON hospital.ADMISSION
FOR INSERT AS
    DECLARE @is_outadmitted INT;
    DECLARE @inserted_Patient_ID CHAR(7);
    DECLARE @inserted_Nurse_ID INT;
    DECLARE @inserted_admisison INT;
    DECLARE @Job_Type CHAR(1);

    SELECT  @inserted_Nurse_ID = Nurse_ID, 
            @inserted_Patient_ID = Patient_ID, 
            @inserted_admisison = Admission_ID
    FROM inserted;

    SELECT @Job_Type = Job_Type
    FROM hospital.EMPLOYEE AS E
    WHERE @inserted_Nurse_ID = E.Employee_ID;

    SELECT @is_outadmitted = COUNT(*)
    from ADMISSION AS A
    WHERE   A.Patient_ID = @inserted_Patient_ID
        AND A.Admission_ID != @inserted_admisison
        AND Discharge_Date IS NULL;

    IF @is_outadmitted != 0
    BEGIN
        PRINT('The patient is already admitted');
        ROLLBACK TRANSACTION;
        RETURN
    END
    ELSE IF @Job_Type != 'n'
    BEGIN
        PRINT('There is no nurse');
        ROLLBACK TRANSACTION;
        RETURN
    END;