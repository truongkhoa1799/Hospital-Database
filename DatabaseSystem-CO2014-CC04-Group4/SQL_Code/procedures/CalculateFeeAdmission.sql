CREATE PROCEDURE hospital.CalculateFeeAdmission
AS
    DECLARE @pre_admission_id INT;
    DECLARE @admission_id INT;
    DECLARE @pirce NUMERIC(10,1);
    DECLARE @amount INT;
    DECLARE @total_fee NUMERIC(10,1);

    DECLARE fee_admission CURSOR FOR
        SELECT 
            TM.Admission_ID, M.Price, TM.Amount
        FROM 
            hospital.TREATMENT_MEDICATION AS TM
        JOIN 
            hospital.MEDICATION AS M 
            ON M.Drug_Code = TM.Drug_Code;

    OPEN fee_admission
    
    FETCH NEXT FROM fee_admission   
    INTO @admission_id, @pirce, @amount;

    SET @pre_admission_id = @admission_id;
    SET @total_fee = 0;

    WHILE @@FETCH_STATUS = 0  
    BEGIN
        if  @pre_admission_id != @admission_id
        BEGIN
            PRINT RTRIM(@pre_admission_id) + N' ' + RTRIM(@total_fee)
            UPDATE 
                hospital.ADMISSION
            SET 
                fee = @total_fee
            WHERE 
                Admission_ID = @pre_admission_id;

            SET @pre_admission_id = @admission_id;
            SET @total_fee = 0;
        END

        SET @total_fee = @total_fee + @pirce*@amount

        FETCH NEXT FROM fee_admission   
        INTO @admission_id, @pirce, @amount;
    END

    UPDATE 
        hospital.ADMISSION
    SET 
        fee = @total_fee
    WHERE 
        Admission_ID = @pre_admission_id;
    
    CLOSE fee_admission;  
    DEALLOCATE fee_admission; 
    RETURN