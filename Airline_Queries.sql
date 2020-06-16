#--------------------------------------------------------------QUERIES-----------------------------------------------------------------

# 1. Find the number of employees working as pilots and flight attendants and the average salary for these two positions
select position, count(*), avg(salary) as 'Average Salary' from EMPLOYEE where position in('Pilot','Flight Attendant') group by position;

# 2. Find number of crew members of each position in flight 40002
select position, count(e_id) as 'Number of Employees' from EMPLOYEE natural join CREW_MEMBER where flightNo = 40002 group by position;

# 3. Find all employees with wage greater than the average cost of seats of flight with number 20002
select firstname, surname from EMPLOYEE where salary > (select avg(price) from RESERVATION where flightNo = 20002);

# 4. Number of available seats in flight no 40001
select(
( select capacity from AIRPLANE, FLIGHT_INSTANCE where FLIGHT_INSTANCE.airplane_id = Airplane.airplane_id and flightNo = 40001)
-
(select count(*) from RESERVATION where flightNo = 40001)
) as Available_Seats;

# 5. Find the name and surname of all passengers flying from Tirana to Malpensa on 5 April
select name,surname from PASSENGER where passportNo in 
( select passportNo from Reservation natural join FLIGHT_INSTANCE 
       where date like '%04-05' and segment_id = 
          ( select segment_id from FLIGHT_SEGMENT 
		      where departure_acode = ( select acode from AIRPORT where aname like 'Tirana%') 
			  and arrival_acode = ( select acode from AIRPORT where aname like '%Malpensa%')
	      )
);

# 6 .Show only the passengers who have made reservations under the same payment for flight 40002, 
select distinct P.passportNo, name, surname, payment_id from PASSENGER as P, RESERVATION as R  
	 where P.passportNo = R.passportNo and payment_id in 
             ( select payment_id from RESERVATION as RS where RS.flightNo = 40002
			   group by payment_id
			   having count(*) > 1);

# 7. Find all the planes who have never been used for a segment of itinerary TIR - MIA
select * from AIRPLANE where airplane_id not in ( 
  select FI.airplane_id from FLIGHT_INSTANCE as FI, FLIGHT_SEGMENT as FS, ITINERARY as I 
       where FI.segment_id = FS.segment_id and FS.itinerary_id = I.itinerary_ID 
            and from_acode = 'TIR' and to_acode = 'MIA');

# 8. Find passengers who have flown more than 1 time to Frankfurt 
select passportNo, name, surname, count(*) as'Number of times' from PASSENGER natural join RESERVATION where flightNo in
(select flightNo from FLIGHT_INSTANCE as FI, FLIGHT_SEGMENT as FS where FI.segment_id = FS.segment_id and departure_acode = 'FRA')
group by passportNo
having count(*) > 1;

# 9. Find the name and position of crew members of flight number 40001 that have not been a part of the crew of flight 20001
select E.e_id, firstname, surname, position from EMPLOYEE as E, CREW_MEMBER as C 
where E.e_id = C.e_id and flightNo = 40001 and E.e_id NOT IN
(select E.e_id from EMPLOYEE as E inner join CREW_MEMBER as C on E.e_id = C.e_id and flightNo = 20001);
     
     
# 10. Find all places that the passenger Hana Koci has gone in the past month
select city, state, date from AIRPORT as A, FLIGHT_SEGMENT as FS, FLIGHT_INSTANCE as FI where A.acode = FS.arrival_acode and 
FS.segment_id = FI.segment_ID and date > DATE_SUB(NOW(), INTERVAL 1 MONTH) and flightNo in 
(select flightNo from RESERVATION as R, PASSENGER as P where R.passportNo = P.passportNo and name='Hana' and surname='Koci');
