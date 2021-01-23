CREATE PROCEDURE hospital.Sort_Doctors_In_A_Period_Of_Time 
    @start_date AS DATE, 
    @end_date AS DATE
AS BEGIN
    SELECT 
        EMPLOYEE.Employee_ID,
        -- CONCAT(EMPLOYEE.Last_Name, ' ', EMPLOYEE.First_Name) AS Employee_Name,
        COUNT(*) AS NUM_PATIENTS
    FROM 
        EMPLOYEE
    JOIN 
        TREATMENT_DOCTOR 
    ON EMPLOYEE.Employee_ID=TREATMENT_DOCTOR.Doctor_ID
    JOIN 
        TREATMENT 
        ON TREATMENT_DOCTOR.Admission_ID=TREATMENT.Admission_ID
        AND TREATMENT_DOCTOR.Treatment_ID=TREATMENT.Treatment_ID
    WHERE 
        TREATMENT.START_DATE <= @end_date
        AND @start_date <= TREATMENT.END_DATE
    GROUP BY 
        EMPLOYEE.Employee_ID
    ORDER BY 
        NUM_PATIENTS; 
END;