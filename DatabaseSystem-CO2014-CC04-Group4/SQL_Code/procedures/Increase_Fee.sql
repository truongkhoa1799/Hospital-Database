CREATE PROCEDURE hospital.Increase_Fee
AS
BEGIN
    UPDATE 
        hospital.ADMISSION
    SET 
        Fee = Fee * 1.1
    WHERE 
        Admission_Date >= '2020-09-01';
END;