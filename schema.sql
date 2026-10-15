PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS address (
    address_id INTEGER PRIMARY KEY,
    street TEXT NOT NULL,
    city TEXT NOT NULL,
    state TEXT NOT NULL,
    zip TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS person (
    id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    address_id INTEGER,
    phone_number TEXT,
    gender TEXT,
    age INTEGER CHECK (age IS NULL OR age >= 0),
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

CREATE TABLE IF NOT EXISTS role (
    role_name TEXT PRIMARY KEY,
    pay_rate REAL
);

CREATE TABLE IF NOT EXISTS donor (
    donor_id INTEGER PRIMARY KEY,
    person_id INTEGER NOT NULL UNIQUE,
    blood_type TEXT,
    RH_factor TEXT,
    FOREIGN KEY (person_id) REFERENCES person(id)
);

CREATE TABLE IF NOT EXISTS staff (
    staff_id INTEGER PRIMARY KEY,
    person_id INTEGER NOT NULL UNIQUE,
    donor_id INTEGER,
    role_name TEXT,
    hours REAL,
    FOREIGN KEY (person_id) REFERENCES person(id),
    FOREIGN KEY (donor_id) REFERENCES donor(donor_id),
    FOREIGN KEY (role_name) REFERENCES role(role_name)
);

CREATE TABLE IF NOT EXISTS location (
    location_id INTEGER PRIMARY KEY,
    address_id INTEGER,
    phone_number TEXT,
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

CREATE TABLE IF NOT EXISTS staffLocation (
    location_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    PRIMARY KEY (location_id, staff_id),
    FOREIGN KEY (location_id) REFERENCES location(location_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS donation (
    donation_id INTEGER PRIMARY KEY,
    donor_id INTEGER NOT NULL,
    date TEXT NOT NULL,
    amount REAL,
    location_id INTEGER,
    FOREIGN KEY (donor_id) REFERENCES donor(donor_id),
    FOREIGN KEY (location_id) REFERENCES location(location_id)
);

CREATE TABLE IF NOT EXISTS condition (
    condition_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS donorCondition (
    donor_id INTEGER NOT NULL,
    condition_id INTEGER NOT NULL,
    seriousness_level INTEGER,
    PRIMARY KEY (donor_id, condition_id),
    FOREIGN KEY (donor_id) REFERENCES donor(donor_id) ON DELETE CASCADE,
    FOREIGN KEY (condition_id) REFERENCES condition(condition_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS medication (
    medication_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS donorMedication (
    donor_id INTEGER NOT NULL,
    medication_id INTEGER NOT NULL,
    amount REAL,
    PRIMARY KEY (donor_id, medication_id),
    FOREIGN KEY (donor_id) REFERENCES donor(donor_id) ON DELETE CASCADE,
    FOREIGN KEY (medication_id) REFERENCES medication(medication_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_person_name ON person(last_name, first_name);
CREATE INDEX IF NOT EXISTS idx_donation_donor_date ON donation(donor_id, date);
