CREATE PROCEDURE hospital.Add_Employee
    @Dep_ID INTEGER,
    @First_Name VARCHAR(7),
    @Last_Name VARCHAR(35),
    @Date_Of_Birth DATE,
    @Gender CHAR(1),
    @Address VARCHAR(50),
    @Start_Date DATE,
    @Job_Type CHAR(1),
    @Special_Name VARCHAR(40),
    @Year_Graduate DATE,
    @Phone VARCHAR(11)
AS
    DECLARE @Employee_ID INT;
    DECLARE @TransactionName VARCHAR(20) = 'AddEmployee';
    BEGIN TRANSACTION @TransactionName;
        BEGIN TRY
            INSERT INTO hospital.EMPLOYEE(Dep_ID, First_Name,Last_Name,Date_Of_Birth,Gender,Address, Start_Date, Job_Type, Special_Name, Year_Graduate)
            VALUES(@Dep_ID,@First_Name,@Last_Name,@Date_Of_Birth,@Gender,@Address,@Start_Date,@Job_Type, @Special_Name, @Year_Graduate);

            select @Employee_id = MAX(Employee_ID)
            from hospital.EMPLOYEE;

            INSERT INTO hospital.EMPLOYEE_PHONE(Employee_ID, Phone)
            VALUES(@Employee_id, @Phone);
            COMMIT TRANSACTION @TransactionName; 
        END TRY
        BEGIN CATCH
            PRINT 'Error occurs when create employee'
            ROLLBACK TRANSACTION @TransactionName; 
        END CATCH