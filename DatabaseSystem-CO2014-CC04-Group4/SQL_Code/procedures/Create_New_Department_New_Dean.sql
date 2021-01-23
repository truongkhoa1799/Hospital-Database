CREATE PROCEDURE hospital.Create_New_Department_New_Dean
    @Department_Title VARCHAR(20),
    @Dean_First_Name VARCHAR(7),
    @Dean_Last_Name VARCHAR(35),
    @Dean_Address VARCHAR(50),
    @Dean_Start_Date DATE,
    @Dean_Date_Of_Birth DATE,
    @Dean_Gender CHAR(1),
    @Dean_Job_Type CHAR(1),
    @Dean_Special_Name VARCHAR(40),
    @Dean_Year_Graduate DATE,
    @Phone VARCHAR(11)
AS
    DECLARE @TransactionName VARCHAR(20) = 'CreateNewDepartmentNewDean';
    BEGIN TRANSACTION @TransactionName;
        BEGIN TRY
            -- Create department with new employee as dean
            -- Check whether employee meet requirements for dean of department
            -- Get id of department and dean
            DECLARE @department_id INT;
            DECLARE @dean_id INT;

            -- Insert data to employee table
            insert into hospital.EMPLOYEE(  
                First_Name,
                Last_Name,
                Date_Of_Birth,
                Gender,
                Address,
                Start_Date,
                Job_Type,
                Dep_ID,
                Special_Name,
                Year_Graduate
            )
            VALUES (    
                @Dean_First_Name,
                @Dean_Last_Name,
                @Dean_Date_Of_Birth,
                @Dean_Gender,
                @Dean_Address,
                @Dean_Start_Date,
                @Dean_Job_Type,
                0,
                @Dean_Special_Name,
                @Dean_Year_Graduate
            );

            select @dean_id = MAX(Employee_ID)
            from hospital.EMPLOYEE;

            -- Insert data to EMPLOYEE_PHONE table
            INSERT INTO hospital.EMPLOYEE_PHONE(Employee_ID, Phone)
            VALUES(@dean_id, @Phone);

            -- Insert data to department table
            INSERT INTO hospital.DEPARTMENT(Title, Dean_ID)
            VALUES(@Department_Title, @dean_id);

            select @department_id = MAX(Dep_ID)
            from hospital.DEPARTMENT;

            UPDATE hospital.EMPLOYEE
            SET Dep_ID = @department_id
            WHERE Employee_ID = @dean_id;
            COMMIT TRANSACTION @TransactionName; 
        END TRY
        BEGIN CATCH
            PRINT 'Error occurs when create new dep with new dean'
            ROLLBACK TRANSACTION @TransactionName; 
        END CATCH