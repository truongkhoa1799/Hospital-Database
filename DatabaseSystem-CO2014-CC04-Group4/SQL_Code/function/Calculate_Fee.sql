CREATE FUNCTION hospital.Calculate_Fee 
    (@inputID AS CHAR(8)) 
    RETURNS @totalFee TABLE (Total INT) 
AS BEGIN 
    IF 
        SUBSTRING(@inputID, 1, 1) = 'I'
        INSERT INTO 
            @totalFee
        SELECT 
            sum(m.price*tm.Amount) Total
        FROM 
            ADMISSION a
        LEFT JOIN 
            TREATMENT_MEDICATION tm 
            ON a.Admission_ID = tm.Admission_ID
        LEFT JOIN 
            MEDICATION m 
            ON tm.Drug_Code = m.Drug_Code
        WHERE 
            a.Patient_ID = @inputID
        GROUP BY 
            a.Admission_ID,
            tm.Treatment_ID 
    ELSE
        INSERT INTO 
            @totalFee
        SELECT 
            SUM(m.Price*em.Amount) Total
        FROM 
            EXAMINATION_MEDICATION em
        LEFT JOIN 
            MEDICATION m 
            ON em.Drug_Code = m.Drug_Code
        WHERE 
            em.Patient_ID = @inputId
        GROUP BY 
            em.Exam_ID 
    RETURN 
END