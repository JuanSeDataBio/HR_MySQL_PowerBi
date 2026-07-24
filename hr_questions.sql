-- Questions to resolve 

use projects;

select *  from hr_;

-- 1) What is the gender breakdown of employees in the company??

Select gender, count(*) as gender_count from hr_
where age >= 18 and termdate is null
group by gender;

-- 2) what it is the etnicity or race breakdown of employees ?
Select race, count(*) as race_count from hr_
where age >= 18 and termdate is null
group by race
order by count(*) desc;

-- 3) what is the age distribution of employees in the company?
Select
	min(age) as youngest,
    max(age) as oldest
from hr_ where age >= 18 and termdate is null;

SELECT 
	CASE
		when age >= 18 and age <= 24 then '18-24'
        when age >= 25 and age <= 34 then '25-34'
        when age >= 35 and age <= 44 then '35-44'
        when age >= 45 and age <= 54 then '45-54'
        when age >= 55 and age <= 64 then '55-64'
        else '65+'
	END as age_group,
    count(*) as count
from hr_
where age >= 18 and termdate is null
group by age_group
order by age_group;

## Want to know how the gender is related to this age group
SELECT 
	CASE
		when age >= 18 and age <= 24 then '18-24'
        when age >= 25 and age <= 34 then '25-34'
        when age >= 35 and age <= 44 then '35-44'
        when age >= 45 and age <= 54 then '45-54'
        when age >= 55 and age <= 64 then '55-64'
        else '65+'
	END as age_group, gender,
    count(*) as count
from hr_
where age >= 18 and termdate is null
group by age_group, gender
order by age_group, gender;

-- 4) How many employees work at headquarters versus remote locations?
Select location, count(*) as total_location
from hr_ 
where age >= 18 and termdate is null
group by location;

-- 5) What is the average length of employement  for employees who have been terminated 
Select
	round(avg(datediff(termdate,hire_date))/365) as avg_lenght_employeement
from hr_
where termdate <= curdate() and termdate is not null and age >=18;

-- 6) how does the gender distribution vary across the company?
Select department, gender, count(*) as total
from hr_
where age >= 18 and termdate is null
group by department, gender
order by department;

-- 7)What is the distribution of jobs titles across the compnay?
Select jobtitle, count(*) as total
from hr_
where age >= 18 and termdate is null
group by jobtitle
order by jobtitle desc;

-- 8) Which department has the highest turnover rate?
SELECT department,
	total_count,
    terminated_count,
    (terminated_count/total_count)*100 as termination_rate
from (
	Select department,
    count(*) as total_count,
    sum(case when termdate is not null and termdate <= curdate() then 1 else 0 end) as terminated_count
    from hr_
    where age >= 18
    group by department
    ) as subquery
order by termination_rate desc;

-- 9) What is the distribution of employees across locations by city and state??
Select location_state, count(*) as total
from hr_
where age >= 18 and termdate is not null
group by location_state
order by total desc;

-- 10) How has the company's employee count change over time based on hire and term dates?
Select
	year,
    hires,
    terminations,
    hires - terminations as net_change,
    round((hires - terminations)/hires * 100,2) as net_change_percent
from (
	Select Year(hire_date) as  year,
    count(*) as hires,
    sum(case when termdate is not null and termdate <= curdate() then 1 else 0 end) as terminations
    from hr_
    where age >= 18
    group by year(hire_date)
    ) as subquery
ORDER BY year ASC;

-- 11) What is the tenure distribution for each deparment?

Select department, round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
from hr_
where termdate <= curdate() and termdate is not null and age >= 18
group by department;

