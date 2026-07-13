/*
=========================================================
Healthcare CRM SQL Analysis
File: 03_patient_engagement_overview.sql

Objective:
Create an overview of patient engagement using patient
and appointment activity.
=========================================================
*/

USE healthcare_crm_analysis;

-- Business Question 1
-- How many patients are recorded in the CRM?

SELECT
    COUNT(*) AS total_patients
FROM patients;

-- Business Question 2
-- How many appointments are recorded?

SELECT
    COUNT(*) AS total_appointments
FROM appointments;

-- Business Question 3
-- How many appointments fall under each status?

SELECT
    status,
    COUNT(*) AS total_appointments
FROM appointments
GROUP BY status
ORDER BY total_appointments DESC;

-- Business Question 4
-- How many appointments has each patient made?

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    COUNT(a.appointment_id) AS total_appointments
FROM patients p
LEFT JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name
ORDER BY total_appointments DESC;

-- Business Question 5
-- Which patients have more than one appointment?

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
