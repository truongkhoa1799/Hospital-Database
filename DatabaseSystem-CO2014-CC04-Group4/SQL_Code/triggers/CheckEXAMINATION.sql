CREATE OR ALTER TRIGGER hospital.CheckEXAMINATION
ON hospital.EXAMINATION
FOR INSERT AS
    DECLARE @doctor_id INT;
    DECLARE @Job_Type INT;

    SELECT  @doctor_id = Doctor_Exam_ID
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