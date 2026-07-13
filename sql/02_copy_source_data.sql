/*
=========================================================
Healthcare CRM SQL Analysis
File: 02_copy_source_data.sql

Objective:
Copy the existing hospital dataset into the CRM analysis
database for a separate patient engagement project.
=========================================================
*/

USE healthcare_crm_analysis;

CREATE TABLE patients AS
SELECT *
FROM hospital_appointment_analysis.patients;

CREATE TABLE doctors AS
SELECT *
FROM hospital_appointment_analysis.doctors;

CREATE TABLE appointments AS
SELECT *
FROM hospital_appointment_analysis.appointments;

CREATE TABLE treatments AS
SELECT *
FROM hospital_appointment_analysis.treatments;

CREATE TABLE billing AS
SELECT *
FROM hospital_appointment_analysis.billing;

-- Confirm the copied tables

SHOW TABLES;
