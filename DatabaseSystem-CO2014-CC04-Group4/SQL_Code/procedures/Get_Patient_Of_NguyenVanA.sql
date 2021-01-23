CREATE PROCEDURE hospital.Get_Patient_Of_NguyenVanA 
AS BEGIN
    SELECT 
        OUTPATIENT.Patient_ID,
        First_Name,
        Last_Name,
        Date_Of_Birth,
        Gender,
        Address,
        Phone
    FROM EXAMINATION
    JOIN
    (
        SELECT EMPLOYEE_ID
        FROM EMPLOYEE
        WHERE EMPLOYEE.job_type='d'
            AND CONCAT(EMPLOYEE.last_name, ' ', EMPLOYEE.first_name) LIKE '%Nguyen Van A%'
    ) AS DOCTOR_NVA 
        ON EXAMINATION.Doctor_Exam_ID = DOCTOR_NVA.EMPLOYEE_ID
    JOIN OUTPATIENT 
        ON EXAMINATION.Patient_ID=OUTPATIENT.Patient_ID
    UNION ALL

    SELECT 
        INPATIENT.Patient_ID,
        First_Name,
        Last_Name,
        Date_Of_Birth,
        Gender,
        Address,
        Phone
    FROM TREATMENT_DOCTOR
    JOIN
    (
        SELECT EMPLOYEE_ID
        FROM EMPLOYEE
        WHERE EMPLOYEE.job_type='d'
            AND CONCAT(EMPLOYEE.last_name, ' ', EMPLOYEE.first_name) LIKE '%Nguyen Van A%'
    ) AS DOCTOR_NVA 
        ON DOCTOR_NVA.EMPLOYEE_ID=TREATMENT_DOCTOR.DOCTOR_ID
    JOIN TREATMENT 
        ON TREATMENT_DOCTOR.Admission_ID=TREATMENT.Admission_ID
        AND TREATMENT_DOCTOR.Treatment_ID=TREATMENT.Treatment_ID
    JOIN ADMISSION ON TREATMENT.Admission_ID=ADMISSION.Admission_ID
    JOIN INPATIENT ON ADMISSION.Patient_ID=INPATIENT.Patient_ID 
END;