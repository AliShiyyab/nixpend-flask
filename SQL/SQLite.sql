DROP TABLE IF EXISTS DOCTOR_PATIENT;
DROP TABLE IF EXISTS TESTS;
DROP TABLE IF EXISTS DIAGNOSES;
DROP TABLE IF EXISTS MEDICATION_PRESCRIPED;
DROP TABLE IF EXISTS MEDICATION;
DROP TABLE IF EXISTS PATIENT;
DROP TABLE IF EXISTS BILL;
DROP TABLE IF EXISTS CAFETERIA_STAFF;
DROP TABLE IF EXISTS CAFETERIA;
DROP TABLE IF EXISTS STAFF;
DROP TABLE IF EXISTS DOCTOR;
DROP TABLE IF EXISTS WORKER;
DROP TABLE IF EXISTS DEPARTMENT;

CREATE TABLE DEPARTMENT (
    id INT PRIMARY KEY,
    workers INT,
    building_location VARCHAR(255));

CREATE TABLE WORKER (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    phone_number VARCHAR(255),
    gender VARCHAR(6),
    salary FLOAT);

CREATE TABLE DOCTOR (
    id INT PRIMARY KEY,
    field VARCHAR(255),
    degree VARCHAR(255),
    department_id INT,
    worker_id INT,
    FOREIGN KEY (department_id) REFERENCES DEPARTMENT(id),
    FOREIGN KEY (worker_id) REFERENCES WORKER(id));

CREATE TABLE STAFF (id INT PRIMARY KEY,
                   job_title VARCHAR(100),
                   worker_id INT,
                   FOREIGN KEY (worker_id) REFERENCES WORKER(id));

CREATE TABLE CAFETERIA (
  	id INT PRIMARY KEY,
  	seating VARCHAR(100),
  	food_type VARCHAR(100));

CREATE TABLE CAFETERIA_STAFF (
    cafeteria_id INT,
    staff_id INT,
    position VARCHAR(255),
    PRIMARY KEY (cafeteria_id, staff_id),
    FOREIGN KEY (cafeteria_id) REFERENCES CAFETERIA(id),
    FOREIGN KEY (staff_id) REFERENCES STAFF(id));

CREATE TABLE BILL (
	id INT PRIMARY KEY,
  	test VARCHAR(255),
  	treatment_type VARCHAR(255),
  	time_admitted TIME,
  	prescription VARCHAR(255));

CREATE TABLE PATIENT (
  	id INT PRIMARY KEY,
  	contact_number INT,
  	name VARCHAR(30),
  	address VARCHAR(100),
  	gender VARCHAR(6),
  	age INT,
  	blood_type VARCHAR(3),
  	cafeteria_id INT,
	bill_id INT,
  	FOREIGN KEY (cafeteria_id) REFERENCES CAFETERIA(id),
  	FOREIGN KEY (bill_id) REFERENCES BILL(id));

CREATE TABLE MEDICATION (
  	id INT PRIMARY KEY,
  	doses INT,
  	expire_date DATE);

CREATE TABLE MEDICATION_PRESCRIPED (
  	id INT PRIMARY KEY,
  	medication_id INT,
  	patient_id INT,
  	FOREIGN KEY (medication_id) REFERENCES MEDICATION(id),
  	FOREIGN KEY (patient_id) REFERENCES PATIENT(id));

CREATE TABLE DIAGNOSES (
  	illness VARCHAR(255) PRIMARY KEY,
  	doctor_id INT,
    patient_id INT,
  	FOREIGN KEY (doctor_id) REFERENCES DOCTOR(id),
  	FOREIGN KEY (patient_id) REFERENCES PATIENT(id));

CREATE TABLE TESTS(
  	id INT PRIMARY KEY,
  	result VARCHAR(255),
  	illness VARCHAR(255),
  	doctor_id INT,
    patient_id INT,
  	FOREIGN KEY (doctor_id) REFERENCES DOCTOR(id),
  	FOREIGN KEY (patient_id) REFERENCES PATIENT(id),
  	FOREIGN KEY (illness) REFERENCES DIAGNOSES(illness));

CREATE TABLE DOCTOR_PATIENT (
  	visit_time DATE,
  	doctor_id INT,
    patient_id INT,
  	FOREIGN KEY (doctor_id) REFERENCES DOCTOR(id),
  	FOREIGN KEY (patient_id) REFERENCES PATIENT(id));
    
insert INTO DEPARTMENT (id, workers, building_location) VALUES (1,20,"Amman");
insert INTO DEPARTMENT (id, workers, building_location) VALUES (2, 18, "Irbid");
INSERT INTO WORKER (id, name, phone_number, gender, salary) VALUES (1, "ALI", 0780704421, "Male", 5000);
INSERT INTO WORKER (id, name, phone_number, gender, salary) VALUES (2, "Fawzi", 0795385093, "Male", 3000);
INSERT INTO DOCTOR (id, field, degree, department_id, worker_id) VALUES (1, "Dentist", "ABCD", 1, 2);
INSERT INTO STAFF (id, job_title, worker_id) VALUES (1, 'Nurse', 2);
INSERT INTO CAFETERIA (id, seating, food_type) VALUES (1, "50", "Vegitarian");
INSERT INTO CAFETERIA_STAFF (cafeteria_id, staff_id, position) VALUES (1, 1, 'Chef');
INSERT INTO BILL (id, test, treatment_type, time_admitted, prescription) VALUES (1, 'Blood Test', 'Routine Checkup', '10:00', 'Painkillers');
INSERT INTO PATIENT (id, contact_number, name, address, gender, age, blood_type, cafeteria_id, bill_id) VALUES (1, 0780704421, 'Khaled Obha', 'Ajloun', 'male', 35, 'AB', 1, 1);
INSERT INTO MEDICATION (id, doses, expire_date) VALUES (1, 100, DATE('2023-12-30'));
INSERT INTO DIAGNOSES (illness, doctor_id, patient_id) VALUES ('Troma', 1, 1);
INSERT INTO TESTS (id, result, illness, doctor_id, patient_id) VALUES (1, 'Normal', 'Hypertension', 1, 1);
INSERT INTO DOCTOR_PATIENT (visit_time, doctor_id, patient_id) VALUES (DATE('2023-09-05'), 1, 1);
INSERT INTO DOCTOR_PATIENT (visit_time, doctor_id, patient_id) VALUES (DATE('2023-01-05'), 1, 1);

-- FIRST ONE --
SELECT
    M.id AS Medication_ID,
    M.doses AS Medication_Doses,
    M.expire_date AS Medication_Expire_Date,
    CASE
        WHEN M.expire_date < DATE('now') THEN 'expired'
        ELSE 'activated'
    END AS Medication_Status
FROM
    MEDICATION M
LEFT JOIN
    MEDICATION_PRESCRIPED MP ON M.id = MP.medication_id
GROUP BY
    M.id, M.doses, M.expire_date
    

-- SECOND ONE --
SELECT
    D.id AS Doctor_ID,
    D.field AS Doctor_Field,
    D.degree AS Doctor_Degree,
    W.name AS Doctor_Name,
    DP.visit_time AS Visit_Time,
    P.name AS Patient_Name,
    P.age AS Patient_Age,
    DEP.building_location AS Department_Location
FROM
    DOCTOR AS D
JOIN
    WORKER AS W ON D.worker_id = W.id
JOIN
    DEPARTMENT AS DEP ON D.department_id = DEP.id
JOIN
    DOCTOR_PATIENT As DP ON D.id = DP.doctor_id
JOIN
    PATIENT AS P ON DP.patient_id = P.id
WHERE
    P.age > 12
    AND strftime('%Y', DP.visit_time) <> '2022'
ORDER BY
    W.name DESC,
    P.name ASC;