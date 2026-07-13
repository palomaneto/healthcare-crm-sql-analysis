/*
=========================================================
Healthcare CRM SQL Analysis
File: 05_patient_value_analysis.sql

Objective:
Analyse patient value using billing and treatment data
to identify high-value patients and revenue trends.
=========================================================
*/

USE healthcare_crm_analysis;

-- Business Question 1
-- Which patients have generated the highest total revenue?

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    ROUND(SUM(b.amount),2) AS total_spent
FROM patients p
INNER JOIN billing b
    ON p.patient_id = b.patient_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name
ORDER BY total_spent DESC;

-- Business Question 2
-- What is the average amount spent per patient?

SELECT
    ROUND(AVG(amount),2) AS average_patient_spend
FROM billing;

-- Business Question 3
-- Which patients have outstanding payments?

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    b.amount,
    b.payment_status
FROM patients p
INNER JOIN billing b
    ON p.patient_id = b.patient_id
WHERE b.payment_status <> 'Paid';

-- Business Question 4
-- Which payment method generates the highest revenue?

SELECT
    payment_method,
    ROUND(SUM(amount),2) AS total_revenue
FROM billing
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- Business Question 5
-- Rank patients by total revenue generated.

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    ROUND(SUM(b.amount),2) AS total_spent,
    RANK() OVER
    (
        ORDER BY SUM(b.amount) DESC
    ) AS patient_rank
FROM patients p
INNER JOIN billing b
    ON p.patient_id = b.patient_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name;
