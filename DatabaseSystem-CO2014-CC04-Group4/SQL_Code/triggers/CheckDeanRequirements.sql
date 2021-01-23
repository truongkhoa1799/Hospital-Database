CREATE OR ALTER TRIGGER hospital.CheckDeanRequirements
ON hospital.DEPARTMENT
FOR INSERT, UPDATE AS
    DECLARE @Year_Graduate DATE;
    DECLARE @Special_Name VARCHAR(40);
    DECLARE @Job_Type CHAR(1);
    DECLARE @Year_Of_Experience INT;
    DECLARE @Inserted_Dean_ID INT;
    DECLARE @Inserted_Dept_ID INT;

    SELECT  @Inserted_Dean_ID = Dean_ID, 
            @Inserted_Dept_ID = Dep_ID
    from inserted;

    IF EXISTS(select * from hospital.DEPARTMENT WHERE Dean_ID = @Inserted_Dean_ID AND Dep_ID != @Inserted_Dept_ID)
    BEGIN
        PRINT 'This dean is already a dean of another department'
        ROLLBACK TRANSACTION;
        RETURN
    END

    select  @Year_Graduate = E.Year_Graduate, 
            @Special_Name = E.Special_Name, 
            @Job_Type = E.Job_Type
    from hospital.EMPLOYEE AS E
    WHERE E.Employee_ID = @Inserted_Dean_ID;

    SET @Year_Of_Experience = DATEDIFF(year,@Year_Graduate,GETDATE());
    
    IF @Year_Of_Experience <= 5 
        OR @Special_Name IS NULL 
        OR @Job_Type = 'n' 
    BEGIN
        PRINT('The deans requirement error');
        ROLLBACK TRANSACTION;
        RETURN
    END;