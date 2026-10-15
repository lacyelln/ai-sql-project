INSERT OR IGNORE INTO address (address_id, street, city, state, zip) VALUES
 (1, '1200 Pine Street', 'Denver', 'CO', '80203'),
 (2, '44 River Road', 'Boulder', 'CO', '80302'),
 (3, '500 Cedar Avenue', 'Aurora', 'CO', '80012');

INSERT OR IGNORE INTO role (role_name, pay_rate) VALUES
 ('Phlebotomist', 24.50), ('Coordinator', 27.00);

INSERT OR IGNORE INTO person (id, first_name, last_name, address_id, phone_number, gender, age) VALUES
 (1, 'Avery', 'Morgan', 1, '3035550101', 'F', 29),
 (2, 'Jordan', 'Lee', 2, '3035550102', 'M', 41),
 (3, 'Riley', 'Patel', 3, '3035550103', 'X', 35),
 (4, 'Casey', 'Nguyen', 1, '3035550104', 'F', 32);

INSERT OR IGNORE INTO donor (donor_id, person_id, blood_type, RH_factor) VALUES
 (1001, 1, 'O', '+'), (1002, 2, 'A', '-'), (1003, 3, 'B', '+');

INSERT OR IGNORE INTO staff (staff_id, person_id, donor_id, role_name, hours) VALUES
 (201, 4, NULL, 'Phlebotomist', 36);

INSERT OR IGNORE INTO location (location_id, address_id, phone_number) VALUES
 (10, 1, '3035550200'), (11, 2, '3035550201');

INSERT OR IGNORE INTO staffLocation (location_id, staff_id) VALUES (10, 201);

INSERT OR IGNORE INTO donation (donation_id, donor_id, date, amount, location_id) VALUES
 (5001, 1001, '2026-08-12', 450, 10),
 (5002, 1001, '2026-10-02', 450, 11),
 (5003, 1002, '2026-09-18', 470, 10),
 (5004, 1003, '2026-10-05', 450, 11);

INSERT OR IGNORE INTO condition (condition_id, name) VALUES
 (1, 'Seasonal allergies'), (2, 'Asthma');
INSERT OR IGNORE INTO donorCondition (donor_id, condition_id, seriousness_level) VALUES
 (1001, 1, 1), (1003, 2, 2);

INSERT OR IGNORE INTO medication (medication_id, name) VALUES
 (1, 'Cetirizine'), (2, 'Albuterol');
INSERT OR IGNORE INTO donorMedication (donor_id, medication_id, amount) VALUES
 (1001, 1, 10), (1003, 2, 2);

-- Additional fictional demo records. Names and contact details below are synthetic.
INSERT OR IGNORE INTO address (address_id, street, city, state, zip) VALUES
 (4, '8 Meadow Lane', 'Denver', 'CO', '80204'),
 (5, '19 Aspen Way', 'Boulder', 'CO', '80303'),
 (6, '72 Juniper Court', 'Aurora', 'CO', '80013'),
 (7, '310 Birch Street', 'Lakewood', 'CO', '80226'),
 (8, '55 Spruce Avenue', 'Arvada', 'CO', '80002');

INSERT OR IGNORE INTO person (id, first_name, last_name, address_id, phone_number, gender, age) VALUES
 (5, 'Taylor', 'Reed', 4, '3035550105', 'F', 27),
 (6, 'Morgan', 'Brooks', 5, '3035550106', 'M', 38),
 (7, 'Quinn', 'Rivera', 6, '3035550107', 'X', 24),
 (8, 'Jamie', 'Kim', 7, '3035550108', 'F', 45),
 (9, 'Drew', 'Carter', 8, '3035550109', 'M', 33),
 (10, 'Skyler', 'Bell', 4, '3035550110', 'F', 52),
 (11, 'Alex', 'Foster', 5, '3035550111', 'M', 30),
 (12, 'Robin', 'Diaz', 6, '3035550112', 'X', 41),
 (13, 'Cameron', 'Price', 7, '3035550113', 'F', 36),
 (14, 'Reese', 'Bennett', 8, '3035550114', 'M', 28),
 (15, 'Emery', 'Ward', 4, '3035550115', 'F', 47),
 (16, 'Parker', 'Hayes', 5, '3035550116', 'M', 39),
 (17, 'Finley', 'Ross', 6, '3035550117', 'X', 31),
 (18, 'Harper', 'Gray', 7, '3035550118', 'F', 22),
 (19, 'Rowan', 'James', 8, '3035550119', 'M', 56),
 (20, 'Sage', 'Cole', 4, '3035550120', 'F', 34),
 (21, 'Devon', 'Lane', 5, '3035550121', 'M', 43);

INSERT OR IGNORE INTO donor (donor_id, person_id, blood_type, RH_factor) VALUES
 (1004, 5, 'O', '+'), (1005, 6, 'A', '+'), (1006, 7, 'AB', '-'),
 (1007, 8, 'B', '+'), (1008, 9, 'O', '-'), (1009, 10, 'A', '-'),
 (1010, 11, 'B', '-'), (1011, 12, 'O', '+'), (1012, 13, 'AB', '+'),
 (1013, 14, 'A', '+'), (1014, 15, 'O', '-'), (1015, 16, 'B', '+'),
 (1016, 17, 'A', '-'), (1017, 18, 'O', '+'), (1018, 19, 'AB', '-'),
 (1019, 20, 'B', '-');

INSERT OR IGNORE INTO staff (staff_id, person_id, donor_id, role_name, hours) VALUES
 (202, 5, 1004, 'Coordinator', 32),
 (203, 8, 1007, 'Phlebotomist', 40),
 (204, 12, 1011, 'Coordinator', 28),
 (205, 21, NULL, 'Phlebotomist', 36);

INSERT OR IGNORE INTO location (location_id, address_id, phone_number) VALUES
 (12, 3, '3035550202'), (13, 4, '3035550203'), (14, 5, '3035550204');

INSERT OR IGNORE INTO staffLocation (location_id, staff_id) VALUES
 (10, 202), (11, 203), (12, 204), (13, 205), (14, 203);

INSERT OR IGNORE INTO donation (donation_id, donor_id, date, amount, location_id) VALUES
 (5005, 1004, '2026-07-10', 450, 12), (5006, 1004, '2026-09-15', 470, 10),
 (5007, 1005, '2026-07-14', 450, 11), (5008, 1005, '2026-10-01', 460, 13),
 (5009, 1006, '2026-08-03', 450, 14), (5010, 1007, '2026-07-21', 470, 10),
 (5011, 1007, '2026-09-22', 450, 12), (5012, 1008, '2026-08-11', 460, 11),
 (5013, 1009, '2026-08-20', 450, 13), (5014, 1010, '2026-09-02', 470, 14),
 (5015, 1011, '2026-07-27', 450, 12), (5016, 1011, '2026-10-07', 460, 10),
 (5017, 1012, '2026-08-29', 450, 11), (5018, 1013, '2026-09-11', 470, 13),
 (5019, 1014, '2026-07-18', 450, 14), (5020, 1014, '2026-10-09', 460, 12),
 (5021, 1015, '2026-08-15', 470, 10), (5022, 1016, '2026-09-25', 450, 11),
 (5023, 1017, '2026-07-31', 460, 13), (5024, 1018, '2026-08-07', 450, 14),
 (5025, 1019, '2026-09-19', 470, 12), (5026, 1002, '2026-10-12', 450, 13),
 (5027, 1003, '2026-10-13', 460, 10), (5028, 1006, '2026-10-14', 450, 11);

INSERT OR IGNORE INTO condition (condition_id, name) VALUES
 (3, 'Migraine'), (4, 'Mild seasonal asthma'), (5, 'Iron deficiency history');
INSERT OR IGNORE INTO donorCondition (donor_id, condition_id, seriousness_level) VALUES
 (1005, 3, 1), (1008, 4, 1), (1012, 5, 2), (1016, 3, 2);

INSERT OR IGNORE INTO medication (medication_id, name) VALUES
 (3, 'Vitamin D'), (4, 'Iron supplement'), (5, 'Loratadine');
INSERT OR IGNORE INTO donorMedication (donor_id, medication_id, amount) VALUES
 (1005, 3, 1), (1008, 5, 10), (1012, 4, 1), (1016, 3, 1);
