#Michael McTighe final script SQL. 
##task 1 
### Write a query that shows bands & their respective albums’ release date in descending order. 
select b.bandname, a.albumname, a.releasedate
from band_db.band as b
join band_db.album as a
on b.idband = a.idband
order by a.releasedate desc

#______________________________________
##task 2
### select drummers and their bands
select concat(p.pfname,' ',p.plname) as player_full_name, i.instrument, b.bandname
from band_db.player as p
join band_db.instrument as i 
on p.InstID = i.InstID
join band_db.band as b
on b.idband =p.idband
where i.instrument = 'drums'


#________________________________
##task 3
### Count the number of instruments per band
select b.bandname,count(i.instrument) as number_of_instruments
from band_db.instrument as i
join band_db.player as p 
on i.InstID = p.InstID
join band_db.band as b
on p.idband = b.idband
group by b.bandname

#__________________________
##task 4 
### Most popular instruments
select instrument, count(instrument) as inst_count
from band_db.player as p 
join band_db.instrument as i 
on i.InstID = p.InstID
group by instrument
order by inst_count DESC

#________________________
##task 5
### write a query that lists alumbs with missing names or relate dates
select idalbum,albumname,releasedate from band_db.album
where albumname or releasedate is null
#if there are null values, the ifnull function could be used 
## Ifnull(null,'N/A'

#_____PART 2_________________________
## Task 1
### Add bands
insert into band_db.band
values (22,1,'weezer'), (23,1,'TLC'),(24,1,'Paramore'), (25,1,'Blackpink'), (26,1,'Vampire weekend')

#________________________________
##Task 2
###  Which table would we use to add the names of band members?
#ANSWER = band_db.player

#______________________________________________
##task 3
###Instert player data
insert into band_db.player 
values (30,3,22,'rivers','cuomo', 'Rochester', 'New York'),
(31,1,22,'Brian', 'Bell', 'iowa city', 'iowa'),
(32,4,22,'Patrick', 'wislon','buffalo','new york'),
(33,2,22,'scott','shriner','Toledo','Ohio'),
(34,3,23,'Tionne','Watkins','Des Moines','Iowa'),
(35,3,23,'Rozonda','Thomas','Columbus','Georgia'),
(36,3,24,'Hayley','Williams','Franklin','Tennessee'),
(37,1,24,'Taylor','York','Nashville','Tennessee'),
(38,4,24,'Zac','Farro','Voorhees Township','New Jersey'),
(39,3,25,'Jisoo','Kim','n/a','South Korea'),
(40,3,25,'Jennie','Kim','n/a','South Korea'),
(41,3,25,'Roseanne','Park','n/a','New Zealand'),
(42,3,25,'Lisa','Manoban','n/a','Thailand'),
(43,3,26,'Ezra','Koenig','New York','New York'),
(44,2,26,'Chris','Baio','Bronxville','New York'),
(45,4,26,'Chris','tomson','Upper Freehold Township','New Jersey')

#_______________________________
##task 4
#### insert venue data
insert into band_db.venue
values (12,'Twin City Rock House','Minneapolis','MN',55414,2000)


#_____________________________________________________
##Task 5
### Which state has the largest amount of seating available (regardless of the number of venues at the state)?
select state, sum(seats) from band_db.venue
group by state
order by sum(seats) desc

#____________________PART 3________________________
## Task 1
### We need to add some data on upcoming performances for some of the artists. Which table should we use to add this information?
#Answer = band_db.gig

#_______________________________
##task2
### create gig data
insert into band_db.gig
values 
(1,4,2,'2022-05-05',19000),
(2,12,26,'2022-04-15',null),
(3,8,23,'2022-06-07',18000),
(4,2,22,'2022-07-03',175)

#_____________________________
##task 3
###Are venues oversold
Select gigID, numattendees,seats from band_db.gig as g 
join band_db.venue as v
on v.idvenue = g.idvenue

###Answer = yes. GigID 3 & 4 are oversold. 

#_________________________________
## task4
### update vampire weekend
update band_db.gig 
set numattendees = 1750
where GigID = 2

#_____________________________________
##task 5
### Update weezer
update band_db.gig 
set numattendees = 125
where GigID = 4


#___________________________
## task 6
### create gig info view. NOTE: named gig info two to provide more requested info.
create view band_db.vs_giginfo2 as
select b.bandname, g.gigdate,v.vname, g.numattendees, g.numattendees/v.seats as percent_full
from band_db.band as b
join band_db.gig as g 
on b.idband = g.idband
join band_db.venue as v
on v.idvenue = g.idvenue
;
#Part 4
##Task 1
### Create a stored procedure that lists all of the venues that can handle more than 10,000 guests.
delimiter $$
create procedure Venues_greaterthan_10K()
begin
select vname, seats from band_db.venue
where seats > 10000;
end
$$

#___________________________________________
#Task 2
## Create a stored procedure that lists all of the players that come from a specific state. 
delimiter $$
create procedure Player_from_state(in player_home varchar(25))
begin
select concat(p.pfname,' ',p.plname),p.homestate,b.bandname from 
band_db.player as p
join band_db.band as b
on p.idband = b.idband
where p.homestate like (player_home);
end
$$

