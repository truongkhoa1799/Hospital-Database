CREATE PROCEDURE hospital.Create_New_Department_Exist_Dean
    @Dean_ID INT,
    @Department_Title VARCHAR(20)
AS
    DECLARE @department_id INT;
     -- Insert data to department table
    INSERT INTO hospital.DEPARTMENT(Title, Dean_ID)
    VALUES(@Department_Title, @Dean_ID);

    select @department_id = MAX(Dep_ID)
    from hospital.DEPARTMENT;

    -- Update department id for new dean
    UPDATE hospital.EMPLOYEE
    SET Dep_ID = @department_id
    WHERE Employee_ID = @Dean_ID;