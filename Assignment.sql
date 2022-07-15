create schema assignment;
use assignment;
SET SQL_SAFE_UPDATES=0;

-- formatting date column to change its datatype
update `bajaj_auto` set `Date` = str_to_date(`Date`,'%d-%M-%Y');
alter table `bajaj_auto` modify column `Date` date;

update `eicher_motors` set `Date` = str_to_date(`Date`,'%d-%M-%Y');
alter table `eicher_motors` modify column `Date` date;

update `hero_motocorp` set `Date` = str_to_date(`Date`,'%d-%M-%Y');
alter table `hero_motocorp` modify column `Date` date;

update `infosys` set `Date` = str_to_date(`Date`,'%d-%M-%Y');
alter table `infosys` modify column `Date` date;

update `tcs` set `Date` = str_to_date(`Date`,'%d-%M-%Y');
alter table `tcs` modify column `Date` date;

update `tvs_motors` set `Date` = str_to_date(`Date`,'%d-%M-%Y');
alter table `tvs_motors` modify column `Date` date;

-- Create a new table named 'bajaj1' containing the date, close price, 20 Day MA and 50 Day MA. 
-- 				(This has to be done for all 6 stocks)

create table bajaj1 as 
	select `date` ,`Close Price` ,
    avg(`Close Price`) over (rows between 0 preceding and 19 following) as 'ma20',
	avg(`Close Price`) over (rows between 0 preceding and 49 following) as 'ma50'
	from bajaj_auto ;
    
    create table eicher1 as 
	select `date` ,`Close Price` ,
    avg(`Close Price`) over (rows between 0 preceding and 19 following) as 'ma20',
	avg(`Close Price`) over (rows between 0 preceding and 49 following) as 'ma50'
	from eicher_motors ;
    
    create table hero1 as 
	select `date` ,`Close Price` ,
    avg(`Close Price`) over (rows between 0 preceding and 19 following) as 'ma20',
	avg(`Close Price`) over (rows between 0 preceding and 49 following) as 'ma50'
	from hero_motocorp ;
    
    create table infosys1 as 
	select `date` ,`Close Price` ,
    avg(`Close Price`) over (rows between 0 preceding and 19 following) as 'ma20',
	avg(`Close Price`) over (rows between 0 preceding and 49 following) as 'ma50'
	from infosys ;
    
    create table tcs1 as 
	select `date` ,`Close Price` ,
    avg(`Close Price`) over (rows between 0 preceding and 19 following) as 'ma20',
	avg(`Close Price`) over (rows between 0 preceding and 49 following) as 'ma50'
	from tcs ;

create table tvs1 as 
	select `date` ,`Close Price` ,
    avg(`Close Price`) over (rows between 0 preceding and 19 following) as 'ma20',
	avg(`Close Price`) over (rows between 0 preceding and 49 following) as 'ma50'
	from tvs_motors ;


-- view values inserted in each table 
select * from bajaj1;
select * from eicher1;
select * from hero1;
select * from infosys1;
select * from tcs1;
select * from tvs1;

-- Create a master table containing the date and close price of all the six stocks. 
-- 				(Column header for the price is the name of the stock)


create table master_table as
select b.`Date`,b.`Close Price` as Bajaj,
tc.`Close Price` as TCS,
tv.`Close Price` as TVS,
i.`Close Price` as Infosys,
e.`Close Price` as Eicher,
h.`Close Price` as Hero
from bajaj1 b inner join tcs1 tc on b.`Date`=tc.`Date`
inner join tvs1 tv on  b.`Date`=tv.`Date`
inner join infosys1 i on  b.`Date`=i.`Date`
inner join eicher1 e on  b.`Date`=e.`Date`
inner join hero1 h on  b.`Date`=h.`Date`;

-- view master_table
select *from master_table;
   
    -- Use the table created in Part(1) to generate buy and sell signal. Store this in another table named 
--              'bajaj2'. Perform this operation for all stocks.

-- Create a new table bajaj2, eicher2, hero2, infosys2, tcs2, tvs2

create table bajaj2 as 
select `Date`,`Close Price`,
  case 
     when(`ma20` >`ma50`) THEN 'BUY'
     when(`ma20` <`ma50`) THEN 'SELL'
      when row_number() over(order by date) < 50 then 'Not Applicable'
     else 'Hold'	
     end as `Signal`
     from bajaj1;
     
create table eicher2 as 
select `Date`,`Close Price`,
  case 
     when(`ma20` >`ma50`) THEN 'BUY'
     when(`ma20` <`ma50`) THEN 'SELL'
      when row_number() over(order by date) < 50 then 'Not Applicable'
     else 'Hold'	
     end as `Signal`
     from eicher1;
     
create table hero2 as 
select `Date`,`Close Price`,
  case 
     when(`ma20` >`ma50`) THEN 'BUY'
     when(`ma20` <`ma50`) THEN 'SELL'
      when row_number() over(order by date) < 50 then 'Not Applicable'
     else 'Hold'	
     end as `Signal`
     from hero1;
     
create table infosys2 as 
select `Date`,`Close Price`,
  case 
     when(`ma20` >`ma50`) THEN 'BUY'
     when(`ma20` <`ma50`) THEN 'SELL'
      when row_number() over(order by date) < 50 then 'Not Applicable'
     else 'Hold'	
     end as `Signal`
     from infosys1;
     
create table tcs2 as 
select `Date`,`Close Price`,
  case 
     when(`ma20` >`ma50`) THEN 'BUY'
     when(`ma20` <`ma50`) THEN 'SELL'
      when row_number() over(order by date) < 50 then 'Not Applicable'
     else 'Hold'	
     end as `Signal`
     from tcs1;
     
create table tvs2 as 
select `Date`,`Close Price`,
  case 
     when(`ma20` >`ma50`) THEN 'BUY'
     when(`ma20` <`ma50`) THEN 'SELL'
      when row_number() over(order by date) < 50 then 'Not Applicable'
     else 'Hold'	
     end as `Signal`
     from tvs1;
         
    -- view all the tables bajaj2, eicher2, hero2, infosys2, tcs2, tvs2
select * from bajaj2;
select * from eicher2;
select * from hero2;
select * from infosys2;
select * from tcs2;
select * from tvs2;
   
-- Create a User defined function, that takes the date as input and returns the signal for that particular 
 --               day (Buy/Sell/Hold) for the Bajaj stock.
 
 
drop function if exists signalBajaj;

delimiter $$

create function signalBajaj(input_date date) 
  returns varchar(15) 
  deterministic
begin   
  declare output_trade_signal varchar(15);
  
  select bajaj2.signal into output_trade_signal from bajaj2 
  where date = input_date;
  
  return output_trade_signal ;
  end
  
$$ delimiter ;

select signalBajaj('2015-07-24') as trade_signal;

-- Inferences For Bajaj

select `Date`, `Close Price`
from bajaj2
where `signal` = 'Buy'
order by `Close Price`
limit 1;

select `Date`, `Close Price`
from bajaj2
where `signal` = 'Sell'
order by `Close Price` desc
limit 1;


-- For Eicher

select `Date`, `Close Price`
from eicher2
where `signal` = 'Buy'
order by `Close Price`
limit 1;

select `Date`, `Close Price`
from eicher2
where `signal` = 'Sell'
order by `Close Price` desc
limit 1;


-- For Hero

select `Date`, `Close Price`
from hero2
where `signal` = 'Buy'
order by `Close Price`
limit 1;

select `Date`, `Close Price`
from hero2
where `signal` = 'Sell'
order by `Close Price` desc
limit 1;


-- For Infosys 

select `Date`, `Close Price`
from infosys2
where `signal` = 'Buy'
order by `Close Price`
limit 1;

select `Date`, `Close Price`
from infosys2
where `signal` = 'Sell'
order by `Close Price` desc
limit 1;


-- For TCS 

select `Date`, `Close Price`
from tcs2
where `signal` = 'Buy'
order by `Close Price`
limit 1;

select `Date`, `Close Price`
from tcs2
where `signal` = 'Sell'
order by `Close Price` desc
limit 1;


-- For TVS 

select `Date`, `Close Price`
from tvs2
where `signal` = 'Buy'
order by `Close Price`
limit 1;

select `Date`, `Close Price`
from tvs2
where `signal` = 'Sell'
order by `Close Price` desc
limit 1;





