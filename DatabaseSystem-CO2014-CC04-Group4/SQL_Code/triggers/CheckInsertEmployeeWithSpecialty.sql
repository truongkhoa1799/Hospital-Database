CREATE OR ALTER TRIGGER hospital.CheckInsertEmployeeWithSpecialty
ON hospital.EMPLOYEE
FOR INSERT, UPDATE AS
    DECLARE @Year_Graduate DATE;
    DECLARE @Special_Name VARCHAR(40);

    SELECT @Year_Graduate = Year_Graduate, @Special_Name = Special_Name
    from inserted;

    IF (@Year_Graduate IS NOT NULL AND @Special_Name IS NULL) 
        OR (@Year_Graduate IS NULL AND @Special_Name IS NOT NULL)
    BEGIN
        PRINT('The specialty of employee has error');
        ROLLBACK TRANSACTION;
        RETURN
    END;