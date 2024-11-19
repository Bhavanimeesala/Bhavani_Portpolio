drop table projects;
select count(*) from projects;

-- Question 1 change epoch time tonormal date

SELECT FROM_UNIXTIME(created_at) AS readable_time
FROM projects ;

SELECT FROM_UNIXTIME(updated_at) AS updated_date
FROM projects ;

SELECT FROM_UNIXTIME(deadline) AS deadline_date
FROM projects ;

SELECT FROM_UNIXTIME(state_changed_at) AS state_changed_date
FROM projects ;

SELECT FROM_UNIXTIME(successful_at) AS successful_date from projects ;


select from_unixtime(launched_at) as launched_date from projects;

--- 2nd  calendar table

select * from calendar;

-- 4 q usd goal
alter table projects add column usd_goal int;

update projects
set usd_goal = goal*static_usd_rate;
select usd_goal from projects;

--- Kpi 
--- 5 q1 No of projects based on outcomes

select state ,count(projectid) from projects group by state;

-- 5 q2 No of projects based location

select count(*), location.country from projects right join location on projects.location_id = location.id group by country;

--- 5 q3  No of projects based on category

SELECT c.category_name, COUNT(p.projectid) AS project_count
FROM category AS c
JOIN projects AS p ON c.id = p.category_id
GROUP BY c.category_name;

-- 5 q4 no of projects based on year

SELECT 
    YEAR(FROM_UNIXTIME(created_at)) AS project_year,
    QUARTER(FROM_UNIXTIME(created_at)) AS project_quarter,
    MONTH(FROM_UNIXTIME(created_at)) AS project_month,
    COUNT(*) AS total_projects
FROM 
    projects
GROUP BY 
    YEAR(FROM_UNIXTIME(created_at)), 
    QUARTER(FROM_UNIXTIME(created_at)), 
    MONTH(FROM_UNIXTIME(created_at))
ORDER BY 
    project_year, 
    project_quarter, 
    project_month;

-- 6 no of backers of successful project
 
select sum(backers_count) from projects where state = "successful";

-- 6 sucessful projects amount raised
select sum(usd_pledged) from projects where state = "successful";
--- 6 average no of days
SELECT AVG(DATEDIFF(FROM_UNIXTIME(deadline), FROM_UNIXTIME(created_at))) AS average_days_to_complete
FROM projects;

-- 7 q top successful project amount raised

select  name,usd_pledged from projects where state = "successful"
order by usd_pledged desc limit 1;

--- 7 q top successful project based on backers count 
select name, backers_count from projects where state = "successful" order by backers_count desc 
limit 1;

-- 8 q persentage of succeful projects
SELECT 
    (COUNT(CASE WHEN state = 'successful' THEN 1 END) / COUNT(*)) * 100 AS success_percentage
FROM projects;

-- 8 persentage of succeful projects based on category
SELECT 
    category.category_name,
    (COUNT(CASE WHEN state = 'successful' THEN 1 END) / COUNT(*)) * 100 AS success_percentage
FROM projects inner join category on projects.category_id = category.id
GROUP BY category_name;

-- 8 q successful projects on year,month ,quater

select 
  year(from_unixtime(created_at)) as project_year,
  month(from_unixtime(created_at)) as project_month,
  quarter(from_unixtime(created_at)) as project_quater,
  count(case when state = "successful" then 1 end) as successful_count,
  count(*) as total_count,
  (count(case when state = "successful" then 1 end) * 100.0 / count(*)) as successful_percentage 
  from projects group by year(from_unixtime(created_at)),
  month(from_unixtime(created_at)),quarter(from_unixtime(created_at))
  order by project_year, project_month,project_quater;
  
  -- 8 q persentage of successful projects based on goal ranges
  
  SELECT 
    CASE 
        WHEN goal BETWEEN 0 AND 300000 THEN 'Low Goal (0 - 300000)'
        WHEN goal BETWEEN 300000 AND 500000 THEN 'Medium Goal (300000 - 500000)'
        WHEN goal BETWEEN 500000 AND 750000 THEN 'High Goal (500000 - 750000)'
        ELSE 'Very High Goal (750000+)'
    END AS goal_range,
    COUNT(CASE WHEN state = "successful" THEN 1 END) AS successful_count,
    COUNT(*) AS total_count,
    (COUNT(CASE WHEN state = "successful" THEN 1 END) * 100.0 / COUNT(*)) AS successful_percentage
FROM 
    projects
GROUP BY 
    goal_range
ORDER BY 
    successful_percentage DESC;









