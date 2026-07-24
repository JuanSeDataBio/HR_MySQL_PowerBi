-- DATA CLEANING -----------

CREATE DATABASE projects;

USE projects;

## Here we can see the first 5 elements of the table HR
SELECT * 
FROM hr_
LIMIT 5;

## Rename the ID Column
ALTER TABLE hr_
CHANGE COLUMN ï»¿id emp_id varchar(20) null;

## Review the type of the data 
describe hr_;

## We want to see how the column of the BT since the current has different structures
Select birthdate from hr_;

## Change birthdate since there are inconsistencies in the information
Set sql_safe_updates = 0;

UPDATE hr_
set birthdate = case 
 when birthdate like "%/%" then date_format(str_to_date(birthdate, "%m/%d/%Y"),"%Y-%m-%d")
 when birthdate like "%-%" then date_format(str_to_date(birthdate, "%m-%d-%Y"),"%Y-%m-%d")
else null 
end;

## now that the format has been change, we need to change the tyoe of the column birthdate
alter table hr_
modify column birthdate date;

## It is need it to do the same to the hire date 
UPDATE hr_
set hire_date = case 
 when hire_date like "%/%" then date_format(str_to_date(hire_date, "%m/%d/%Y"),"%Y-%m-%d")
 when hire_date like "%-%" then date_format(str_to_date(hire_date, "%m-%d-%Y"),"%Y-%m-%d")
else null 
end;

# Transformar hire date to date type
alter table hr_
modify column hire_date Date;

Select hire_date from hr_;

## For the termdate we do not want blank and we need only the date and not the timestamp
update hr_
set termdate = date(str_to_date(termdate, "%Y-%m-%d %H:%i:%s UTC"))
where termdate is not null and trim(termdate) = '';

alter table hr_
modify column termdate date;

## Create a column name Age
alter table hr_ add column age int;
update hr_
set age = timestampdiff(Year,birthdate,curdate());
select birthdate, age from hr_;

## We will going to check on the value on age, with negative we need to clean somo information 
Select
	min(age),
    max(age)
from hr_;

Select emp_id, birthdate from hr_
where age < 18; ## 967 under this, we wont work with this 



