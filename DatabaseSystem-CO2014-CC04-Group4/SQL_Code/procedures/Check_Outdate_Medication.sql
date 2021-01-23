CREATE PROCEDURE hospital.Check_Outdate_Medication
AS
	UPDATE 
        MEDICATION
	SET 
        Out_Date = 1
	WHERE 
        Expiration_Date < CONVERT(date, CURRENT_TIMESTAMP);