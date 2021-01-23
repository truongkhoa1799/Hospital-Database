CREATE OR ALTER TRIGGER hospital.TRIG_INCREASE_FEE
ON hospital.ADMISSION
for INSERT, UPDATE
AS
BEGIN
    DECLARE @fee NUMERIC(10,1);
    DECLARE @admission_id INT;
    DECLARE @admission_date DATE;

    select @fee = Fee, @admission_id = Admission_ID, @admission_date = Admission_Date
    from inserted;
    
    update hospital.ADMISSION
    set Fee = @fee * 1.1
    WHERE Admission_ID = @admission_id And @admission_date>='2020-09-01';
    
    RETURN
END;