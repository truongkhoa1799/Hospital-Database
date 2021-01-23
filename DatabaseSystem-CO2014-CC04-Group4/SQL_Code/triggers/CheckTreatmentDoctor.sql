CREATE OR ALTER TRIGGER hospital.CheckTreatmentDoctor
ON hospital.TREATMENT_DOCTOR
FOR INSERT, UPDATE AS
    DECLARE @doctor_id INT;
    DECLARE @Job_Type CHAR(1);

    SELECT  @doctor_id = Doctor_ID
    FROM inserted;

    SELECT @Job_Type = Job_Type
    FROM hospital.EMPLOYEE AS E
    WHERE @doctor_id = E.Employee_ID;

    IF @Job_Type != 'd'
    BEGIN
        PRINT('There is no doctor');
        ROLLBACK TRANSACTION;
        RETURN
    END;