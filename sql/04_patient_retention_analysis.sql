/*
=========================================================
Healthcare CRM SQL Analysis
File: 04_patient_retention_analysis.sql

Objective:
Analyse repeat patient activity and identify patients
showing stronger or weaker engagement with the service.
=========================================================
*/

USE healthcare_crm_analysis;

-- Business Question 1
-- How many patients have attended more than one appointment?

SELECT
    COUNT(*) AS repeat_patients
FROM
(
    SELECT
        patient_id
    FROM appointments
    GROUP BY patient_id
    HAVING COUNT(appointment_id) > 1
) AS repeat_patient_list;

-- Business Question 2
-- How many patients have attended only one appointment?

SELECT
    COUNT(*) AS one_time_patients
FROM
(
    SELECT
        patient_id
    FROM appointments
    GROUP BY patient_id
    HAVING COUNT(appointment_id) = 1
) AS one_time_patient_list;

-- Business Question 3
-- List repeat patients and their total appointments.

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    COUNT(a.appointment_id) AS total_appointments
FROM patients p
INNER JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name
HAVING COUNT(a.appointment_id) > 1
ORDER BY total_appointments DESC;

-- Business Question 4
-- Classify patients by appointment activity.

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    COUNT(a.appointment_id) AS total_appointments,
    CASE
        WHEN COUNT(a.appointment_id) = 0 THEN 'No Activity'
        WHEN COUNT(a.appointment_id) = 1 THEN 'One-Time Patient'
        WHEN COUNT(a.appointment_id) BETWEEN 2 AND 3 THEN 'Repeat Patient'
        ELSE 'Highly Engaged Patient'
    END AS engagement_segment
FROM patients p
LEFT JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name
ORDER BY total_appointments DESC;

-- Business Question 5
-- Summarise the number of patients in each engagement segment.

WITH patient_segments AS
(
    SELECT
        p.patient_id,
        CASE
            WHEN COUNT(a.appointment_id) = 0 THEN 'No Activity'
            WHEN COUNT(a.appointment_id) = 1 THEN 'One-Time Patient'
            WHEN COUNT(a.appointment_id) BETWEEN 2 AND 3 THEN 'Repeat Patient'
            ELSE 'Highly Engaged Patient'
        END AS engagement_segment
    FROM patients p
    LEFT JOIN appointments a
        ON p.patient_id = a.patient_id
    GROUP BY p.patient_id
)

SELECT
    engagement_segment,
    COUNT(*) AS total_patients
FROM patient_segments
GROUP BY engagement_segment
ORDER BY total_patients DESC;
