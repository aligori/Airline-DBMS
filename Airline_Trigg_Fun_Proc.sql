

#------------------------------------------------------- STORED PROCEDURES-------------------------------------------------------------


# 1. Stored procedure that finds the number of available seats in a given flight 

DELIMITER //

CREATE PROCEDURE AvailableSeats(IN flightNumber Numeric(5), OUT available int)

BEGIN 
      select(
	  ( select capacity from AIRPLANE as A, FLIGHT_INSTANCE as FI where FI.airplane_id = A.airplane_id and flightNo = flightNumber)
	  -
      (select count(*) from RESERVATION where flightNo = flightNumber)
	  ) into available;
END //

DELIMITER ;

CALL AvailableSeats(40001,@available);
select @available;


# 2. Stored Procedure that marks a flight as completed and sets its real departure and arrival time

DELIMITER //

CREATE PROCEDURE CompleteFlight(IN flightNumber Numeric(5), IN deptime TIME, IN arrtime TIME)

BEGIN 
       UPDATE FLIGHT_INSTANCE 
       SET status = 'Completed', arrival_time = arrtime, departure_time = deptime 
       WHERE flightNo = flightNumber;
END //

DELIMITER ;

# Testing
select * from FLIGHT_INSTANCE where flightNo = 60003;
CALL CompleteFlight(60003,'06:31:00','07:55:00');
select * from FLIGHT_INSTANCE where flightNo = 60003;


# 3. Stored Procedure that cancels a reservation 
DELIMITER //

CREATE PROCEDURE CancelReservation(IN flightNumber Numeric(5), IN pNo char(9))

BEGIN 
       DELETE FROM RESERVATION WHERE flightNo = flightNumber and passportNo = pNo;  #--> Will fire canceled reservation Trigger
END //

DELIMITER ;


# 4. Stored Procedure that Cancels a flight -> Status of flight is changed and all the reservations are canceled ! 

DELIMITER $$

CREATE PROCEDURE CancelFlight(IN flightNumber NUMERIC(5))

BEGIN 
      UPDATE FLIGHT_INSTANCE SET status = 'Cancelled' WHERE flightNo = flightNumber;
      DELETE FROM RESERVATION WHERE flightNo = flightNumber;    # --> This will fire cancel Reservation trigger that is created below.
      
END $$ 

DELIMITER ;

# Testing is done after the following trigger




# -----------------------------------------------------TRIGGERS--------------------------------------------------------------




# 1. Trigger that inserts into CANCELLED_RESERVATION a Reservation when it is deleted from Reservation table
# For this we need to create a backup table for cancelled reservations.

CREATE TABLE IF NOT EXISTS CANCELLED_RESERVATION(  # No manual inserts on this table only with trigger
  payment_id INT NOT NULL,
  passportNo CHAR(9) NOT NULL,
  flightNo NUMERIC(5) NOT NULL,
  reservationDate DATE NOT NULL,
  cancellationDate DATE NOT NULL,
  price FLOAT NOT NULL,
  PRIMARY KEY (passportNo, flightNo),
  FOREIGN KEY (payment_id) REFERENCES PAYMENT(payment_id),
  FOREIGN KEY (passportNo) REFERENCES PASSENGER(passportNo) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (flightNo) REFERENCES FLIGHT_INSTANCE(flightNo) 
);


DELIMITER //
CREATE TRIGGER CancelReservation AFTER DELETE ON RESERVATION
FOR EACH ROW
BEGIN
    -- Insert Record into CANCELLED_RESERVATION--

    INSERT INTO CANCELLED_RESERVATION (flightNo, passportNo,  payment_id, reservationDate,cancellationDate, price) VALUES
    (OLD.flightNo, OLD.passportNo, OLD.payment_id, OLD.reservationDate,NOW(), OLD.price); 

END//
DELIMITER ;

CALL CancelFlight(10001); # ---> Stored procedure we created will delete reservations, trigger will be fired
select flightNo, status from FLIGHT_INSTANCE where flightNo = 10001;
select * from RESERVATION; # Resevations of flight Removed
select * from CANCELLED_RESERVATION; # Reservations added to cancelled Reservations


# 2. Trigger that prevents insertion on table Reservation for a flight that is fully booked.

DELIMITER //
CREATE TRIGGER FullyBooked BEFORE INSERT ON RESERVATION 
FOR EACH ROW
BEGIN
    CALL AvailableSeats(New.flightNo, @avail);
    IF @avail < 1 THEN 
    SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'There are no available seats for this flight. The reservation was not successful! ';
    END IF;
END//
DELIMITER ; 

# To test this trigger lets create an airplane with capacity 2 and lets use it in a flight, 
# Then lets try to make three reservations for that flight.
INSERT INTO AIRPLANE (airplane_id, model, capacity, manufacturer) VALUES
	 ('A002', 'Airbus A300', 2, 'Airbus');
     
INSERT INTO FLIGHT_INSTANCE (flightNo, segment_id, date, airplane_id, arrival_time, departure_time,status) VALUES
	 (50006, 5000,'2020-06-01','A002',null, null,'Active');
     
INSERT INTO RESERVATION (flightNo, passportNo,  payment_id, reservationDate, seat, class, price) VALUES
	(50006, 'BA3459829', 1,'2020-03-20 17:34:00','1A','First Class', 130.0),
	(50006, 'GK9899872', 2,'2020-03-22 19:49:00','10A','Economy Class', 60.0);

INSERT INTO RESERVATION (flightNo, passportNo,  payment_id, reservationDate, seat, class, price) VALUES
	(50006, 'BA8384481', 3,'2020-03-28 13:00:00','9A','Economy Class', 69.0); # ---> Trigger will raise an error, this tupple will not be entered
select * from RESERVATION where flightNo = 50006; # --> Only 2 will be displayed


# 3. A trigger that sets a new date for a flight that is going to happen (that has status active) when the date provided has already passed. 
#    For any new Instance of Flight that is going to happen, the date must be a future date.

DELIMITER //
CREATE TRIGGER FlightDate BEFORE INSERT ON FLIGHT_INSTANCE
FOR EACH ROW
BEGIN
	DECLARE currentdate DATE;
    SELECT CURDATE() INTO currentdate;
    IF NEW.status = 'Active' and  NEW.date < currentdate THEN 
	SET NEW.date = DATE_ADD(currentdate, INTERVAL 7 DAY);
    END IF;
END//
DELIMITER ; 

# Testing: This flight that is about to be enetered has date 5 April 2020 and says active
INSERT INTO FLIGHT_INSTANCE (flightNo, segment_id, date, airplane_id, departure_time, arrival_time,status)
VALUES(60013, 6001,'2020-04-05','DF8X',null, null,'Active');
select * from FLIGHT_INSTANCE where flightNo = 60013;

# 4. Trigger that sets the extra charge for each baggage if weight > 23kg, before insert on baggage

DELIMITER //
CREATE TRIGGER ExtraCharge BEFORE INSERT ON BAGGAGE
FOR EACH ROW
BEGIN
      # max kg is 23
      IF NEW.weight - 23 > 0 THEN
          SET NEW.extraCharge = (NEW.weight - 23)*10;   # 10 $ for every extra kg
      ELSE
          SET NEW.extraCharge = 0;
      END IF;
             
END//
DELIMITER ;

INSERT INTO BAGGAGE (baggage_id, weight, status, extraCharge, flightNo, passportNo) VALUES 
       (10, 24.5, 'Claimed', null, 40001, 'BA9987665'); # --> Trigger is fired
select * from BAGGAGE where baggage_id = 10; # --> View inserted ExtraCharge


#------------------------------------------------------FUNCTIONS----------------------------------------------------------




# 1. A function that returns the real duration of a flight

DELIMITER $$
CREATE FUNCTION DurationOfFlight(
	flightNumber NUMERIC(5)
) 
RETURNS TIME
DETERMINISTIC
BEGIN
    DECLARE duration TIME;
	DECLARE x TIME;
    DECLARE y TIME;
    
    select departure_time  into x from FLIGHT_INSTANCE where flightNo = flightNumber;
    select arrival_time into y from FLIGHT_INSTANCE where flightNo = flightNumber ; 
	select TIMEDIFF(y,x) into duration;
           
	RETURN (duration);
END$$
DELIMITER ;

# Query : Testing this function
select flightNo, date, departure_acode as 'From', arrival_acode as 'To', DurationOfFlight(flightNo) as Duration 
    from FLIGHT_INSTANCE natural join FLIGHT_SEGMENT;


# 2. A function that returns the differene between the scheduled arrival time vs true arrival time

DELIMITER $$
CREATE FUNCTION Delay(
	flightNumber NUMERIC(5)
) 
RETURNS TIME
DETERMINISTIC
BEGIN
    DECLARE delay TIME;
	DECLARE scheduled TIME;
    DECLARE realtime TIME;

    select distinct scheduled_arr_time  into scheduled from FLIGHT_INSTANCE  natural join FLIGHT_SEGMENT  
         where flightNo = flightNumber;
    select arrival_time  into realtime from FLIGHT_INSTANCE where flightNo = flightNumber; 
	select TIMEDIFF(realtime, scheduled) into delay;
           
	RETURN (delay);
END$$
DELIMITER ;


# Testing this function
select flightNo, date, departure_acode as 'From', arrival_acode as 'To', scheduled_arr_time as 'Scheduled Arrival Time',
    arrival_time as 'Real Arrival Time', Delay(flightNo) as 'Delay' 
    from FLIGHT_INSTANCE natural join FLIGHT_SEGMENT;
 
 
# 3. A function that gives the status of a person related to Frequent Flyer Program.

DELIMITER $$
CREATE FUNCTION FrequentFlyerStatus(
	pNo char(9)
) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN 
      declare level varchar(20);
      declare accumulatedMiles float;
      
      # Calculate the accumulated miles in the last 6 months
      select sum(miles) into accumulatedMiles from FLIGHT_SEGMENT where segment_id in
        (select segment_id from FLIGHT_INSTANCE where date > date_sub(curdate(), interval 6 month) and flightNo in
          (select flightNo from RESERVATION as R, PASSENGER as P
             where R.passportNo = P.passportNo and P.passportNo = pNo));
          
      IF accumulatedMiles > 7000 THEN 
         set level = 'Platinium';
	  ELSEIF accumulatedMiles > 4000 THEN 
		 set level = 'Gold';
	  ELSEIF accumulatedMiles > 1000 THEN
         set level = 'Silver';
	  ElSE
         set level = 'Not a frequent flyer';
      END IF;
	  RETURN (level);
END$$
DELIMITER ;

# Testing
select name, surname, FrequentFlyerStatus(passportNo) as 'Frequent Flyer Level' from PASSENGER;

# 4. Average Price of Flight by class

DELIMITER $$
CREATE FUNCTION AveragePriceOfFlight(
	flightN char(9),
    class ENUM('First Class','Business Class','Economy Class')
) 
RETURNS FLOAT
DETERMINISTIC
BEGIN 
      DECLARE avgprice FLOAT;
      
      # Calculate the average price of flight by class
      select avg(price) into avgprice from FLIGHT_INSTANCE as F, RESERVATION as R 
          where F.flightNo = R.flightNo and R.flightNo = flightN and R.class = class;
             
	  RETURN (avgprice);
END$$
DELIMITER ;

# Testing:
select flightNo, AveragePriceOfFlight(flightNo,'Economy class') from FLIGHT_INSTANCE where flightNo = 40001;




# -------------------------------------------------- USER AUTHORISATION----------------------------------------------------


# 1. Database Administrator - All priviledges
CREATE USER IF NOT EXISTS airline_admin@localhost     
IDENTIFIED BY 'administrator';

GRANT ALL PRIVILEGES ON airline.* TO airline_admin@localhost;
DROP USER IF EXISTS airline_admin@localhost;

# 2. Schedule Coordinator 
CREATE USER IF NOT EXISTS schcoordinator@localhost
IDENTIFIED BY 'coordinator';                             
# Grant Privileges
GRANT ALL PRIVILEGES ON airline.FLIGHT_INSTANCE TO schcoordinator@localhost;
GRANT ALL PRIVILEGES ON airline.CREW_MEMBER TO schcoordinator@localhost;
GRANT SELECT ON airline.FLIGHT_SEGMENT TO schcoordinator@localhost;
GRANT SELECT ON airline.ITINERARY TO schcoordinator@localhost;
GRANT SELECT ON airline.AIRPLANE TO schcoordinator@localhost;
GRANT SELECT ON airline.AIRPORT TO schcoordinator@localhost;
GRANT SELECT(e_id, firstname, surname, position) ON airline.EMPLOYEE TO schcoordinator@localhost;
GRANT EXECUTE ON PROCEDURE CompleteFlight to schcoordinator@localhost;
GRANT EXECUTE ON PROCEDURE CancelFlight to schcoordinator@localhost;
GRANT EXECUTE ON FUNCTION DurationOfFlight to schcoordinator@localhost;
GRANT EXECUTE ON FUNCTION Delay to schcoordinator@localhost;


# 3. Booking Agent 
CREATE USER IF NOT EXISTS bkagent@localhost
IDENTIFIED BY 'booking';                                 
# Grant Privileges
GRANT SELECT,INSERT,DELETE ON airline.PASSENGER TO bkagent@localhost;
GRANT SELECT,INSERT ON airline.RESERVATION TO bkagent@localhost;
GRANT SELECT,INSERT,DELETE ON airline.PAYMENT TO bkagent@localhost;
GRANT SELECT ON airline.FLIGHT_INSTANCE to bkagent@localhost; 
GRANT SELECT ON airline.FLIGHT_SEGMENT to bkagent@localhost; 
GRANT EXECUTE ON PROCEDURE AvailableSeats to bkagent@localhost; 
GRANT EXECUTE ON PROCEDURE CancelReservation to bkagent@localhost;
GRANT EXECUTE ON FUNCTION FrequentFlyerStatus to bkagent@localhost; 


# 4. Employee Manager
CREATE USER IF NOT EXISTS empmanager@localhost IDENTIFIED BY 'manager';
GRANT ALL PRIVILEGES ON airline.EMPLOYEE to empmanager@localhost;
GRANT SELECT ON airline.CREW_MEMBER to empmanager@localhost; 

