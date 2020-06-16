CREATE DATABASE IF NOT EXISTS airline;
USE airline;

CREATE TABLE IF NOT EXISTS AIRPORT
(
  acode CHAR(3) NOT NULL,
  aname VARCHAR(50) NOT NULL,
  city VARCHAR(20) NOT NULL,
  state VARCHAR(20) NOT NULL,
  zipcode NUMERIC NOT NULL,
  PRIMARY KEY (acode),
  UNIQUE (aname)
);
    
CREATE TABLE IF NOT EXISTS ITINERARY
(
  itinerary_id INT NOT NULL,
  from_acode CHAR(3) NOT NULL,
  to_acode CHAR(3) NOT NULL,
  miles FLOAT NOT NULL,
  weekDays VARCHAR(30) DEFAULT 'Everyday',         
  PRIMARY KEY (itinerary_id),
  CONSTRAINT `fk_acode` FOREIGN KEY (to_acode) REFERENCES AIRPORT(acode) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_depcode` FOREIGN KEY (from_acode) REFERENCES AIRPORT(acode) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS PASSENGER
(
  name VARCHAR(20) NOT NULL,
  surname VARCHAR(20) NOT NULL,
  passportNo CHAR(9) NOT NULL,
  address VARCHAR(40) NOT NULL,
  email VARCHAR(50),
  birthday DATE NOT NULL,
  PRIMARY KEY (passportNo)
);

CREATE TABLE IF NOT EXISTS AIRPLANE
(
  airplane_id CHAR(4) NOT NULL,
  model VARCHAR(30) NOT NULL,
  capacity INT NOT NULL,
  manufacturer VARCHAR(40) NOT NULL,
  PRIMARY KEY (airplane_id)
);

CREATE TABLE IF NOT EXISTS EMPLOYEE
(
  e_id NUMERIC(4) NOT NULL,
  firstname VARCHAR(20) NOT NULL,
  surname VARCHAR(20) NOT NULL,
  position ENUM('Pilot','Flight Attendant','Flight Engineer','Booking Agent',
                'In-flight security','Gate Agent','Ticket Agent','Schedule Coordinator') DEFAULT NULL,
  salary FLOAT NOT NULL,
  startingDate DATE NOT NULL,
  contact VARCHAR(20),
  address VARCHAR(40),
  PRIMARY KEY (e_id)
);

CREATE TABLE IF NOT EXISTS FLIGHT_SEGMENT
(
  segment_id NUMERIC(4) NOT NULL,
  scheduled_dep_time TIME NOT NULL,
  scheduled_arr_time TIME NOT NULL,
  miles FLOAT NOT NULL,
  itinerary_id INT NOT NULL,
  departure_acode CHAR(3) NOT NULL,
  arrival_acode CHAR(3) NOT NULL,
  PRIMARY KEY (segment_id),
  FOREIGN KEY (itinerary_id) REFERENCES ITINERARY(itinerary_id),
  CONSTRAINT `seg_acode`FOREIGN KEY (arrival_acode) REFERENCES AIRPORT(acode) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `seg_depcode` FOREIGN KEY  (departure_acode) REFERENCES AIRPORT(acode) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS FLIGHT_INSTANCE
( 
  flightNo NUMERIC(5) NOT NULL,
  date DATE NULL,
  airplane_id CHAR(4) NOT NULL,
  segment_id NUMERIC(4) NOT NULL,
  arrival_time TIME DEFAULT NULL,
  departure_time TIME DEFAULT NULL,
  status ENUM('Active','Cancelled','Completed') default 'Active',
  PRIMARY KEY (flightNo),
  FOREIGN KEY (airplane_id) REFERENCES AIRPLANE(airplane_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (segment_id) REFERENCES FLIGHT_SEGMENT(segment_id) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS BAGGAGE
(
  baggage_id INT NOT NULL,
  weight FLOAT NOT NULL,
  status ENUM('Claimed','Missing') DEFAULT NULL,
  extraCharge DECIMAL(4,2),
  passportNo CHAR(9) NOT NULL,
  flightNo NUMERIC(5) NOT NULL,
  PRIMARY KEY (baggage_id),
  CONSTRAINT `FK_Passenger` FOREIGN KEY (passportNo) REFERENCES PASSENGER(passportNo) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Flight` FOREIGN KEY (flightNo) REFERENCES FLIGHT_INSTANCE(flightNo) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS CARD
(
  cardNo CHAR(19) NOT NULL,
  cardType ENUM('VISA','MASTER CARD'),
  expirationDate DATE NOT NULL,
  PRIMARY KEY (cardNo)
);

CREATE TABLE IF NOT EXISTS PAYMENT
(
  payment_id INT NOT NULL,
  p_method ENUM('Cash','Card') NOT NULL,
  fare FLOAT NOT NULL,
  cardNo CHAR(19),
  PRIMARY KEY (payment_id),
  FOREIGN KEY (cardNo) REFERENCES CARD(cardNo) ON DELETE SET NULL ON UPDATE CASCADE  
);

CREATE TABLE IF NOT EXISTS RESERVATION
( 
  payment_id INT NOT NULL,
  passportNo CHAR(9) NOT NULL,
  flightNo NUMERIC(5) NOT NULL,
  reservationDate DATETIME NOT NULL,
  seat char(3),
  class ENUM('First Class','Business Class','Economy Class') NOT NULL,
  price FLOAT NOT NULL,
  PRIMARY KEY (passportNo,flightNo),
  CONSTRAINT `FK_Payment` FOREIGN KEY (payment_id) REFERENCES PAYMENT(payment_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Passenger` FOREIGN KEY (passportNo) REFERENCES PASSENGER(passportNo) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Flight` FOREIGN KEY (flightNo) REFERENCES FLIGHT_INSTANCE(flightNo) ON UPDATE CASCADE 
);

CREATE TABLE IF NOT EXISTS CREW_MEMBER
(
  e_id NUMERIC(4) NOT NULL,
  flightNo NUMERIC(5) NOT NULL,
  PRIMARY KEY (e_id, flightNo),
  FOREIGN KEY (e_id) REFERENCES EMPLOYEE(e_id) ON DELETE CASCADE,
  FOREIGN KEY (flightNo) REFERENCES FLIGHT_INSTANCE(flightNo) ON DELETE CASCADE ON UPDATE CASCADE
);