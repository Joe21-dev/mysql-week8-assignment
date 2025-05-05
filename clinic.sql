-- Clinic Database Setup
-- Tables: Patients, Doctors, Appointments, Treatments, Bills, etc.



-- Patient info - should be straightforward
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    dob DATE NOT NULL,
    gender ENUM('Female', 'Male', 'Other') NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    address TEXT
);

-- Doctors - includes their specialty and contact
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(60) NOT NULL,
    years_of_experience INT DEFAULT 0,
    phone VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- Patients appointments info - linking docs & patients
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    reason TEXT,
    status ENUM('Cancelled', 'Scheduled', 'Completed') DEFAULT 'Scheduled',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE SET NULL
);

-- Possible treatments and cost for each patient
CREATE TABLE Treatments (
    treatment_id INT PRIMARY KEY AUTO_INCREMENT,
    treatment_name VARCHAR(100) NOT NULL UNIQUE,
    cost DECIMAL(10, 2) NOT NULL,
    description TEXT
);

-- Linking treatments with appointment
CREATE TABLE Appointment_Treatments (
    appointment_id INT,
    treatment_id INT,
    PRIMARY KEY (appointment_id, treatment_id),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE,
    FOREIGN KEY (treatment_id) REFERENCES Treatments(treatment_id) ON DELETE CASCADE
);

-- Billing information per patients appointment
CREATE TABLE Billings (
    billing_id INT PRIMARY KEY AUTO_INCREMENT,
    appointment_id INT UNIQUE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('Card', 'Cash', 'Insurance') DEFAULT 'Cash',
    payment_status ENUM('Pending', 'Unpaid', 'Paid') DEFAULT 'Unpaid',
    billing_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE
);

-- Patient sample data
INSERT INTO Patients (full_name, gender, dob, phone, email, address)
VALUES 
('Calvin Ogutu', 'Male', '2001-06-15', '0700123456', 'ogutu@gmail.com', 'Nairobi, Kenya'),
('Janice Njoki', 'Female', '2003-02-20', '0711123456', 'janice@gmail.com', 'Muranga, Kenya');

-- Doctor sample data
INSERT INTO Doctors (full_name, specialty, phone, email, years_of_experience)
VALUES
('Dr. Alice Kimani', 'Cardiology', '0722123456', 'alice@clinic.com', 10),
('Dr. Bradely Otieno', 'Dermatology', '0733123456', 'bradely@clinic.com', 7);

-- Treatments list
INSERT INTO Treatments (treatment_name, description, cost)
VALUES
('ECG', 'Heart scan test (electro)', 2500.00),
('Malaria', 'Blood Test and General body checkup', 400.00);

-- Appointments
INSERT INTO Appointments (appointment_date, patient_id, doctor_id, reason, status)
VALUES
('2025-05-06 10:00:00', 1, 1, 'Chest pain, feels tight', 'Scheduled'),
('2025-05-07 14:00:00', 2, 2, 'Fever for 2 weeks', 'Scheduled');

-- Treatment done in appts
INSERT INTO Appointment_Treatments (appointment_id, treatment_id)
VALUES 
(1, 1), -- ECG for Njoki
(2, 2); -- Malria for Calvins

-- Billing info
INSERT INTO Billings (appointment_id, total_amount, payment_status, payment_method)
VALUES
(1, 2500.00, 'Unpaid', 'Cash'),
(2, 4000.00, 'Paid', 'Card');
