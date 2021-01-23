CREATE PROCEDURE hospital.CalculateFeeExam
AS
    DECLARE @pre_patient_id CHAR(7);
    DECLARE @pre_exam_id INT;
    DECLARE @patient_id CHAR(7);
    DECLARE @exam_id INT;
    DECLARE @pirce NUMERIC(10,1);
    DECLARE @amount INT;
    DECLARE @total_fee NUMERIC(10,1);

    DECLARE fee_exam CURSOR FOR
        SELECT 
            EM.Patient_ID, EM.Exam_ID, M.Price, EM.Amount
        FROM 
            hospital.EXAMINATION_MEDICATION AS EM
        JOIN 
            hospital.MEDICATION AS M 
            ON M.Drug_Code = EM.Drug_Code;

    OPEN fee_exam  
    
    FETCH NEXT FROM fee_exam   
    INTO @patient_id, @exam_id, @pirce, @amount;

    SET @pre_exam_id = @exam_id;
    SET @pre_patient_id = @patient_id;
    SET @total_fee = 0;

    WHILE @@FETCH_STATUS = 0  
    BEGIN

        IF @pre_exam_id != @exam_id OR @pre_patient_id != @patient_id
        BEGIN
            UPDATE 
                hospital.EXAMINATION
            SET 
                fee = @total_fee
            WHERE 
                Patient_ID = @pre_patient_id 
                AND Exam_ID = @pre_exam_id;

            SET @pre_exam_id = @exam_id;
            SET @pre_patient_id = @patient_id;
            SET @total_fee = 0;
        END

        SET @total_fee = @total_fee + @pirce*@amount

        FETCH NEXT FROM fee_exam   
        INTO @patient_id, @exam_id, @pirce, @amount;
    END

    UPDATE 
        hospital.EXAMINATION
    SET
        fee = @total_fee
    WHERE 
        Patient_ID = @pre_patient_id 
        AND Exam_ID = @pre_exam_id;

    CLOSE fee_exam;  
    DEALLOCATE fee_exam; 
    RETURN