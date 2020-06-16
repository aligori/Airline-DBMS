USE airline;

INSERT INTO AIRPORT (acode, aname, city, state, zipcode) VALUES
     ('TIR', 'Tirana International Airport Mother Theresa', 'Tirana', 'Albania', 1001),
     ('MXP', 'Milan Malpensa Airport', 'Milan', 'Italy', 21019),
     ('FCO', 'Leonardo DaVinci Fiumicino Airport', 'Rome', 'Italy', 00054),
     ('AYT', 'Antalya Airport', 'Antalya', 'Turkey', 07010),
     ('FRA', 'Frankfurt am Main Airport', 'Frankfurt', 'Germany', 60488),
     ('MIA', 'Miami International Airport', 'Miami', 'Florida', 33126),
     ('YVR', 'Vancouver International Airport', 'Vancouver','Canada', 00203),
     ('VIE', 'Vienna International Airport', 'Vienna', 'Austria', 1300),
     ('AMS', 'Amsterdam Airport Schiphol', 'Amsterdam', 'The Netherlands', 1118),
     ('ATH', 'Athens International Airport Eleftherios Venizelos', 'Athens', 'Greece', 19019),
     ('BOS', 'Boston Logan International Airport', 'Boston', 'Massachusets', 02128),
     ('MUC', 'Munich International Airport', 'Munich', 'Germany', 80331);
    
INSERT INTO ITINERARY (itinerary_id, from_acode, to_acode, miles, weekdays) VALUES
     (1,'TIR','MXP', 623, 'Everyday'),
     (2,'TIR','MIA', 5641.28, 'Monday Thursday'),
     (3,'TIR','ATH', 329, 'Everyday'),
     (4,'TIR','YVR', 6021, 'Tuesday Friday'),
     (5,'TIR','AMS', 1428.5, 'Except Sunday'),
     (6,'TIR','BOS', 4480, 'Wednesday Sunday'),
     (7,'TIR','AYT', 329.14, 'Except Sunday');

INSERT INTO FLIGHT_SEGMENT (segment_id, itinerary_id, scheduled_dep_time, scheduled_arr_time, miles, departure_acode, arrival_acode) VALUES
     (1000, 1, '13:00:00', '14:55:00', 623, 'TIR', 'MXP'),
     (2000, 2, '03:00:00', '05:15:00', 809.28, 'TIR', 'FRA'),
     (2001, 2, '07:00:00', '17:30:00', 4832,'FRA', 'MIA'),
     (3000, 3, '11:00:00', '12:15:00', 329,'TIR', 'ATH'),
     (4000, 4, '08:25:00', '10:10:00', 823,'TIR','MUC'),
     (4001, 4, '11:15:00', '23:45:00', 5198,'MUC','YVR'),
     (5000, 5, '14:15:00', '15:55:00', 830.5,'TIR','VIE'),
     (5001, 5, '16:45:00', '18:40:00', 598,'VIE','AMS'),
     (6000, 6, '06:30:00', '07:55:00', 387,'TIR','FCO'),
     (6001, 6, '09:30:00', '20:00:00', 4093,'FCO','BOS'),
     (7000, 7, '08:00:00', '10:02:00', 329.14,'TIR','AYT');
	
INSERT INTO AIRPLANE (airplane_id, model, capacity, manufacturer) VALUES
	 ('A30B', 'Airbus A300', 345, 'Airbus'),
     ('A20B', 'Airbus A200', 200, 'Airbus'),
	 ('A319', 'Airbus A319', 100, 'Airbus'),
     ('A30C', 'Airbus A300', 300, 'Airbus'),
     ('A20C', 'Airbus A20C', 180, 'Airbus'),
	 ('A320', 'Airbus A320', 100, 'Airbus'),
     ('B717', 'Boeing 717', 134, 'Boeing Commercial Airplanes'),
     ('B779', 'Boeing 777-9', 426, 'Boeing Commercial Airplanes'),
     ('DC10', 'Douglas DC-10', 50, 'McDonnell Douglas'),
     ('DF7X', 'Dassault Falcon 7X', 140,'Dassault Aviation'),
     ('B718', 'Boeing 718', 110, 'Boeing Commercial Airplanes'),
     ('B777', 'Boeing 777-9', 426, 'Boeing Commercial Airplanes'),
     ('DC1A', 'Douglas DC-10', 80, 'McDonnell Douglas'),
     ('DF8X', 'Dassault Falcon 8X', 400,'Dassault Aviation');
     
INSERT INTO FLIGHT_INSTANCE (flightNo, segment_id, date, airplane_id, departure_time, arrival_time,status) VALUES
       # Tirana Malpenza
	 (10001, 1000,'2020-04-05','B718','13:03:00', '15:05:00','Completed'),
	 (10002, 1000,'2020-04-20','B717','13:01:00', '14:58:00','Completed'),
	 (10003, 1000,'2020-04-07','A319','13:10:00', '15:15:00','Completed'),
	  # Tirana Miami - 2 segments 
      # for 1st segment
	 (20001, 2000,'2020-04-15','A20B','03:02:00', '05:20:00','Completed'),
	 (20002, 2001,'2020-04-15','A30B','07:00:00', '17:45:00','Completed'),
      # for 2nd segment
	 (20003, 2000,'2020-05-01','A30B','03:00:00', '05:13:00','Completed'),
     (20004, 2001,'2020-05-01','DF8X','07:03:00', '17:32:00','Completed'),
      
     (20005, 2000,'2020-05-07','A20B','03:03:00', '05:15:00','Completed'),
     (20006, 2001,'2020-05-07','A30B','07:20:00', '17:50:00','Completed'),
      # Tirana - Athens
     (30001, 3000,'2020-04-30','A319','11:02:00', '12:18:00','Completed'),
     (30002, 3000,'2020-05-02','A20C','11:00:00', '12:16:00','Completed'),
     (30003, 3000,'2020-05-07','B718','11:05:00', '12:20:00','Completed'),
      # Tirana Vancouver - 2 segments
     (40001, 4000,'2020-05-02','A30B','08:25:00', '10:15:00','Completed'),
     (40002, 4001,'2020-05-02','B777','11:15:00', '23:48:00','Completed'),
      
     (40003, 4000,'2020-05-06','A30B','08:26:00', '10:09:00','Completed'),
     (40004, 4001,'2020-05-06','DF8X','11:20:00', '23:50:00','Completed'),
      
     (40005, 4000,'2020-05-15','A30B','08:25:00', '10:12:00','Completed'),
     (40006, 4001,'2020-05-15','B777','11:26:00', '23:45:00','Completed'),
      # Tirana - Amsterdam - 2 segments
     (50001, 5000,'2020-05-18','A20C','14:17:00', '15:59:00','Completed'),
     (50002, 5001,'2020-05-18','DF7X','16:45:30', '18:43:00','Completed'),
      
     (50003, 5000,'2020-05-18','B718','14:15:00', '15:56:00','Completed'),
     (50004, 5001,'2020-05-18','A20C','16:46:00', '18:45:00','Completed'),
      # Tirana Boston - 2 segments
     (60001, 6000,'2020-05-17','A20B','06:31:00', '07:59:00','Completed'),
     (60002, 6001,'2020-05-17','DF8X','09:32:00', '20:10:00','Completed'),
     # Flight with null departure time and arrival time has not taken place yet     
     (60003, 6000,'2020-06-01','A20B',null, null,'Active'),
     (60004, 6001,'2020-06-01','DF8X',null, null,'Active'),

     (60005, 6000,'2020-06-07','A20B',null, null,'Active'),
     (60006,6001,'2020-06-07','DF8X',null, null,'Active'),
      # Tirana Antalya
     (70001, 7000,'2020-05-04','DC1A','08:03:00', '10:12:00','Completed');
 
INSERT INTO EMPLOYEE (e_id, firstname, surname, position, salary, startingDate, contact, address) VALUES
    (0001,'Arban','Kola', 'Pilot', 1500, '2020-02-01', '+355699312956', 'Rr. Myslym Shyri, Tirana, Albania'),
    (0002,'Genti','Papa', 'Pilot', 1500, '2020-01-01', '+355699318338', 'Rr. Dibres, Tirana, Albania'),
    (0003,'John ','Smith', 'Pilot', 1600, '2019-12-01','+4930390182', 'Frankfurt, Germany'),
    (0004,'David','Muller', 'Pilot', 1600, '2019-01-01', '+43 004 019 27', 'Vienna, Austria'),    
    (0005,'Selma','Bajrami', 'Flight Attendant', 600, '2020-01-01', '+355699327321', 'Durres, Albania'),
    (0006,'Jennifer','Lorence', 'Flight Attendant', 600, '2020-01-01', '+4301401988', 'Frankfurt, Germany'),
    (0007,'Sara','Domja', 'Flight Attendant', 600, '2020-02-01', '+355678493478', 'Blloku, Tirana, Albania'),
    (0008,'Andi','Molla', 'Flight Attendant', 600, '2020-02-01', '+355678493478', '21-Dhjetori, Tirana, Albania'),
    (0009,'Samuel','Henesi', 'Flight Attendant', 600, '2020-01-01', '+4300401999', 'Vienna, Austria'),
    (0010,'Krisa','Prifti', 'Booking Agent', 700, '2019-01-01', '+355678473940', 'Tirana, Albania'),
    (0011,'Atea','Kristo', 'Booking Agent', 700, '2019-01-01', '+355672939495', 'Tirana, Albania'),
    (0012,'Dea','Cota', 'Booking Agent', 700, '2020-01-01', '+355678411111', 'Durres, Albania'),    
    (0013,'Fidel','Mala', 'Flight Engineer', 1400, '2019-01-01', '+355678414959', 'Rr. Durresit, Tirana, Albania'),
    (0014,'Kristina','Shkembi', 'Flight Engineer', 1400, '2020-01-01', '+355678418392', 'Selvia, Tirana, Albania'),
    (0015,'Laura','Zelo', 'Flight Engineer', 1400, '2019-11-01', '+355671293219', 'Blloku, Tirana, Albania'),
	(0016,'Drini','Gashi', 'Flight Engineer', 1400, '2019-12-01', '+355691010203', '21-Dhjetori, Tirana, Albania'),
    (0017,'Gerti','Soti', 'Gate Agent', 350, '2019-01-01', '+355691010222', 'Rr. Myslym Shyri, Tirana, Albania'),
	(0018,'Kliti','Topi', 'Gate Agent', 350, '2019-01-01', '+355691010111', '21-Dhjetori, Tirana, Albania'),
	(0019,'Desara','Tolaj', 'Gate Agent', 350, '2019-01-01', '+355691010444', 'Rr. Myslym Shyri, Tirana, Albania'),
    (0020,'Dan','Brown', 'In-flight security', 500, '2019-11-01', '+4300401927', 'Vienna, Austria'),
    (0021,'Jurgen','Baci', 'In-flight security', 500, '2019-09-07', '+355691010888', 'Rr. Dibres, Tirana, Albania'),
    (0022,'Kevin','Kollcaku', 'In-flight security', 500, '2020-01-09', '+355694567654', 'Blloku, Tirana, Albania'),
    (0023,'Anna','Koci', 'Flight Attendant', 600, '2019-01-07', '+355689765795', 'Xhamlliku, Tirane, Albania'),
	(0024,'Jona','Hitaj', 'Schedule Coordinator', 1000, '2019-10-07', '+355691016677', 'Rr. Dibres, Tirana, Albania'),
    (0025,'Klejt','Bamiri', 'Schedule Coordinator', 1000, '2020-02-09', '+355694560000', 'Blloku, Tirana, Albania'),
    (0026,'Afrim','Daja', 'Schedule Coordinator', 1000, '2019-05-07', '+355689000033', 'Xhamlliku, Tirane, Albania');
    
INSERT INTO PASSENGER (passportNo, name, surname, address, email, birthday) VALUES
    ('BA3459829', 'Alma', 'Gjata', 'Rr. Dibres, Tirana','agjata@gmail.com','1978-12-01'),
    ('BB7865678', 'Bojken', 'Kola', 'Rr. M.Shyri, Tirana','bkola@gmail.com','1995-10-03'),
	('GK9899872', 'Henri', 'Malaj', 'Selvia, Tirana','hmalaj@gmail.com','1999-04-01'),
	('KJ3466767', 'Guido', 'Kristo', 'Rr. Dibres, Tirana','gkristo@ymail.com','1993-12-09'),
	('BA9987665', 'Albert', 'Ndregjoni', '21-Dhjetori, Tirana','angregjoni@gmail.com','1987-03-06'),
	('DA6670876', 'Kristofer', 'Kolombi', 'Rr. Dibres, Tirana','kkolombi@gmail.com','1995-12-11'),
    ('BA2998466', 'Armir', 'Shehu', 'Rr. Dibres, Tirana','ashehu@gmail.com','1998-08-01'),
    ('BB1862993', 'Bora', 'Zeneli', 'Rr. M.Shyri, Tirana','bzeneli@gmail.com','1996-06-03'),
	('GI2300344', 'Hana', 'Koci', 'Selvia, Tirana','hkoci@gmail.com','1990-04-20'),
	('KK3433496', 'Gesa', 'Kuka', 'Rr. Dibres, Tirana','gkuka@yahoo.com','1996-02-21'),
	('BA8384481', 'Andia', 'Shehaj', '21-Dhjetori, Tirana','ashehaj@gmail.com','1999-05-06'),
	('DA6242353', 'Kejda', 'Shehaj', 'Rr. Dibres, Tirana',null,'2010-12-11'),
    ('BA7784848', 'Anisa', 'Kola', 'Rr. Dibres, Tirana','akola@gmail.com','1983-12-01'),
    ('BB2939032', 'Besi', 'Baca', 'Rr. M.Shyri, Tirana',null,'1990-10-03'),
	('GK2343223', 'Romina', 'Kristo', 'Rr. Dibres, Tirana','rkristo@gmail.com','1990-04-01'),
	('KJ3993488', 'Selma', 'Kristo', 'Rr. Dibres, Tirana',null,'2012-12-09'),
	('BA0012305', 'Alda', 'Ndregjoni', '21-Dhjetori, Tirana',null,'2008-03-30'),
	('DA6600876', 'Adela ', 'Cenaj', 'Rr. Dibres, Tirana','acenaj@hotmail.com','1993-10-11'),
    ('BA9308466', 'Artan', 'Hoxha', 'Rr. Dibres, Tirana','ahoxha@gmail.com','1985-08-01'),
    ('BB1862057', 'Lorena', 'Domi', 'Rr. M.Shyri, Tirana','ldomi@gmail.com','1993-08-03'),
	('GI0310884', 'Jeton ', 'Duka', 'Selvia, Tirana','jduka@yahoo.com','1990-04-20'),
	('KK0033405', 'Gerta', 'Malaj', 'Rr. Dibres, Tirana','gmalaj@gmail.com','1997-06-21'),
	('BA8380203', 'Briken', 'Kadi', '21-Dhjetori, Tirana','bkadi@gmail.com','2000-07-06'),
	('DA6242880', 'Kiana', 'Shona', 'Rr. Dibres, Tirana',null,'2011-12-11');
    
INSERT INTO CARD (cardNo, cardType, expirationDate) VALUES
	('1234 5678 9876 2345','VISA','2022-10-01'),
	('2345 678 7856 1234','MASTER CARD','2023-09-04'),
	('4567 7657 5468 3145','VISA','2021-05-20'),
	('1233 5678 6654 6667','MASTER CARD','2022-11-05'),
	('4455 6778 6654 4567','VISA','2024-02-07'),
    ('3345 5567 6654 6665','VISA','2022-08-14');
    
INSERT INTO PAYMENT (payment_id, p_method, fare, cardNo) VALUES
    (1, 'Cash', 130.0, null),
    (2, 'Cash', 60.0, null),
    (3, 'Card', 138.0, '1234 5678 9876 2345'),
    (4, 'Card', 1000.0, '2345 678 7856 1234'),
    (5, 'Card', 710.0, '4567 7657 5468 3145'),
    (6, 'Cash', 750.0, null),
    (7, 'Card', 755.0, '1233 5678 6654 6667'),
    (8, 'Cash', 1000.0, '4455 6778 6654 4567'),
    (9, 'Cash', 760.0, null),
    (10, 'Card', 762.0, '1234 5678 9876 2345'),
    (11, 'Cash', 130.0, null),
    (12, 'Card', 1854.0, '3345 5567 6654 6665'),
    (13, 'Cash', 630.0, null),
	(14, 'Cash', 762.0, null),
    (15, 'Cash', 130.0, null),
    (16, 'Cash', 1854.0,null),
    (17, 'Cash', 630.0, null);
    
INSERT INTO RESERVATION (flightNo, passportNo,  payment_id, reservationDate, seat, class, price) VALUES
	(10001, 'BA3459829', 1,'2020-03-20 13:00:00','1A','First Class', 130.0),
	(10001, 'GK9899872', 2,'2020-03-22 14:00:00','10A','Economy Class', 60.0),
	(10001, 'BA8384481', 3,'2020-03-28 15:00:00','9A','Economy Class', 69.0),
	(10001, 'DA6242353', 3,'2020-03-28 15:00:00','9B','Economy Class', 69.0),
    
    (20001, 'BB1862057', 4,'2020-04-02 14:00:00','2A','First Class', 200.0),
	(20001, 'KK0033405', 5,'2020-04-03 13:00:00','15A','Economy Class', 110.0),
	(20001, 'BA8380203', 6,'2020-04-06 13:00:00','13A','Economy Class', 120.0),
	(20001, 'DA6242353', 7,'2020-04-10 13:00:00','20A','Economy Class', 120.0),
    
    (20002, 'BB1862057', 4,'2020-04-02 14:00:00','1A','First Class', 800.0),
	(20002, 'KK0033405', 5,'2020-04-03 13:00:00','17C','Economy Class', 600.0),
	(20002, 'BA8380203', 6,'2020-04-06 13:00:00','21B','Economy Class', 630.0),
	(20002, 'DA6242353', 7,'2020-04-10 13:00:00','10C','Economy Class', 635.0),
    
	(20004, 'BB1862057', 14,'2020-04-08 13:00:00','1A','First Class', 800.0),
	(20004, 'BA9308466', 15,'2020-04-10 13:00:00','17C','Economy Class', 600.0),
	(20004, 'GI0310884', 16,'2020-04-22 13:00:00','21B','Economy Class', 630.0),
    
    (40001, 'GI2300344', 8,'2020-04-15 13:00:00','1A','First Class', 250.0),
    (40001, 'BB7865678', 9,'2020-04-18 13:00:00','4A','Business Class', 190.0),
    (40001, 'GK9899872', 10,'2020-04-19 13:00:00','3D','Business Class', 192.0),
    (40001, 'GI0310884', 11,'2020-04-19 16:00:00','13E','Economy Class', 130.0),
    (40001, 'KJ3466767', 12,'2020-04-20 18:00:00','10A','Economy Class', 135.0),
    (40001, 'KJ3993488', 12,'2020-04-20 18:00:00','10B','Economy Class', 135.0),
    (40001, 'GK2343223', 12,'2020-04-20 18:00:00','10C','Economy Class', 135.0),
    (40001, 'BA9987665', 13,'2020-04-25 13:00:00','15D','Economy Class', 140.0),
    
	(40002, 'GI2300344', 8,'2020-04-15 13:00:00','1A','First Class', 650.0),
    (40002, 'BB7865678', 9,'2020-04-18 13:00:00','4A','Business Class', 570.0),
    (40002, 'GK9899872', 10,'2020-04-19 13:00:00','3D','Business Class', 570.0),
    (40002, 'GI0310884', 11,'2020-04-19 16:00:00','13E','Economy Class', 480.0),
    (40002, 'KJ3466767', 12,'2020-04-20 18:00:00','10A','Economy Class', 483.0),
    (40002, 'KJ3993488', 12,'2020-04-20 18:00:00','10B','Economy Class', 483.0),
    (40002, 'GK2343223', 12,'2020-04-20 18:00:00','10C','Economy Class', 483.0),
    (40002, 'BA9987665', 13,'2020-04-25 13:00:00','15D','Economy Class', 490.0),
    
	(50003, 'GI2300344', 17,'2020-05-05 13:00:00','1A','First Class', 250.0),
	(60001, 'GI2300344', 17,'2020-05-05 13:00:00','1A','First Class', 250.0);
    
INSERT INTO BAGGAGE (baggage_id, weight, status, extraCharge, flightNo, passportNo) VALUES  
       (1, 24.5, 'Claimed', 15, 40002, 'BA9987665'),
       (2, 22, null, null, 40002, 'GK9899872'),
       (3, 18, null, null, 20004, 'BB1862057'),
       (4, 13.5, 'Claimed', null, 20002, 'DA6242353'),
       (5, 30, 'Claimed', 70, 20001, 'DA6242353'),
       (6, 25, null, 20, 20001, 'BA9987665'),
       (7, 24.5, 'Missing', 15, 10001, 'BA3459829'),
       (8, 27, 'Claimed', 40, 20001, 'BA8380203');
    
    
INSERT INTO CREW_MEMBER (e_id, flightNo) VALUES 
     # Tirana Malpensa i dates 5 Prill
	(0001,10001),
    (0005,10001),
    (0009,10001),
    (0013,10001),
    (0021,10001),
    
    (0003,40002),
    (0002,40002),
    (0008,40002),
    (0014,40002),
    (0006,40002),
    (0022,40002),
    
	(0003,20001),
    (0007,20001),
    (0009,20001),
    (0008,20001),
    (0016,20001),
    
    (0003,40001),
    (0007,40001),
    (0008,40001),
    (0023,40001),
    (0022,40001)
    ;