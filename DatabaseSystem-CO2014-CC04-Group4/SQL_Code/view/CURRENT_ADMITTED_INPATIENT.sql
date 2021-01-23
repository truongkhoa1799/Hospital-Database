-- Create VIEW CURRENT_ADMITTED_INPATIENT
CREATE OR ALTER VIEW hospital.CURRENT_ADMITTED_INPATIENT
AS
    SELECT 
        AD.Patient_ID, AD.Admission_ID
    FROM 
        hospital.ADMISSION as AD
    INNER JOIN 
    (
        SELECT 
            A.Patient_ID, MAX(A.Admission_ID) AS Ad_ID
        FROM 
            hospital.ADMISSION AS A
        WHERE 
            A.Discharge_Date IS NULL
        GROUP BY 
            A.Patient_ID
    ) AS TEMP
    ON AD.Admission_ID = TEMP.Ad_ID;