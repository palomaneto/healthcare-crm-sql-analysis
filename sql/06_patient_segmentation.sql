/*
=========================================================
Healthcare CRM SQL Analysis
File: 06_patient_segmentation.sql

Objective:
Segment patients based on engagement and spending to
support targeted CRM strategies.
=========================================================
*/

USE healthcare_crm_analysis;

-- Business Question 1
-- Categorise patients based on total spending.

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    ROUND(SUM(b.amount),2) AS total_spent,

    CASE
        WHEN SUM(b.amount) >= 2000 THEN 'Gold'
        WHEN SUM(b.amount) >= 1000 THEN 'Silver'
        ELSE 'Bronze'
    END AS patient_tier

FROM patients p

INNER JOIN billing b
ON p.patient_id = b.patient_id

GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name

ORDER BY total_spent DESC;

-- Business Question 2
-- Number of patients in each tier.

WITH patient_tiers AS
(
    SELECT

        p.patient_id,

        CASE
            WHEN SUM(b.amount) >= 2000 THEN 'Gold'
            WHEN SUM(b.amount) >= 1000 THEN 'Silver'
            ELSE 'Bronze'
        END AS patient_tier

    FROM patients p

    INNER JOIN billing b
    ON p.patient_id = b.patient_id

    GROUP BY p.patient_id
)

SELECT

    patient_tier,
    COUNT(*) AS total_patients

FROM patient_tiers

GROUP BY patient_tier

ORDER BY total_patients DESC;

-- Business Question 3
-- Average spend for each patient tier.

WITH patient_tiers AS
(
    SELECT

        p.patient_id,

        SUM(b.amount) AS total_spent,

        CASE
            WHEN SUM(b.amount) >= 2000 THEN 'Gold'
            WHEN SUM(b.amount) >= 1000 THEN 'Silver'
            ELSE 'Bronze'
        END AS patient_tier

    FROM patients p

    INNER JOIN billing b
    ON p.patient_id = b.patient_id

    GROUP BY p.patient_id
)

SELECT

    patient_tier,

    ROUND(AVG(total_spent),2) AS average_spend

FROM patient_tiers

GROUP BY patient_tier;

-- Business Question 4
-- Highest spending patient within each tier.

WITH ranked_patients AS
(
    SELECT

        p.patient_id,
        p.first_name,
        p.last_name,

        SUM(b.amount) AS total_spent,

        CASE
            WHEN SUM(b.amount) >= 2000 THEN 'Gold'
            WHEN SUM(b.amount) >= 1000 THEN 'Silver'
            ELSE 'Bronze'
        END AS patient_tier,

        RANK() OVER
        (
            PARTITION BY
                CASE
                    WHEN SUM(b.amount) >= 2000 THEN 'Gold'
                    WHEN SUM(b.amount) >= 1000 THEN 'Silver'
                    ELSE 'Bronze'
                END
            ORDER BY SUM(b.amount) DESC
        ) AS ranking

    FROM patients p

    INNER JOIN billing b
    ON p.patient_id = b.patient_id

    GROUP BY
        p.patient_id,
        p.first_name,
        p.last_name
)

SELECT *

FROM ranked_patients

WHERE ranking = 1;
