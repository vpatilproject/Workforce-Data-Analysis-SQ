USE Workforce_Data_Analysis;
GO

-- TASK 1: Employees by Company Size in 2021
SELECT company_size, COUNT(*) AS employee_count
FROM Salaries
WHERE work_year = 2021
GROUP BY company_size
ORDER BY employee_count DESC;
GO

-- TASK 2: Top 3 Job Titles with Highest Average Salary for Part-Time Positions in 2023
SELECT TOP 3 job_title, AVG(salary_in_usd) AS average_salary, COUNT(*) AS employee_count
FROM Salaries
WHERE employment_type = 'PT' AND work_year = 2023
GROUP BY job_title
HAVING COUNT(*) > 50
ORDER BY average_salary DESC;
GO

-- TASK 3: Countries Where Mid-Level Salary is Above Overall Mid-Level Average in 2023
WITH OverallAverage AS (
    SELECT AVG(salary_in_usd) AS overall_avg_salary
    FROM Salaries
    WHERE experience_level = 'MI' AND work_year = 2023
)
SELECT employee_residence AS country, AVG(salary_in_usd) AS country_avg_salary
FROM Salaries
WHERE experience_level = 'MI' AND work_year = 2023
GROUP BY employee_residence
HAVING AVG(salary_in_usd) > (SELECT overall_avg_salary FROM OverallAverage)
ORDER BY country_avg_salary DESC;
GO

-- TASK 4: Highest and Lowest Average Salary Locations for Senior-Level Employees in 2023
SELECT company_location, AVG(salary_in_usd) AS average_salary
FROM Salaries
WHERE experience_level = 'SE' AND work_year = 2023
GROUP BY company_location
ORDER BY average_salary DESC;
GO

-- TASK 5: Salary Growth Rates by Job Title, 2023 to 2024
WITH SalaryByYear AS (
    SELECT job_title, work_year, AVG(salary_in_usd) AS average_salary
    FROM Salaries
    WHERE work_year IN (2023, 2024)
    GROUP BY job_title, work_year
),
SalaryPivot AS (
    SELECT job_title,
           MAX(CASE WHEN work_year = 2023 THEN average_salary END) AS salary_2023,
           MAX(CASE WHEN work_year = 2024 THEN average_salary END) AS salary_2024
    FROM SalaryByYear
    GROUP BY job_title
)
SELECT job_title, salary_2023, salary_2024,
       ((salary_2024 - salary_2023) / NULLIF(salary_2023,0))*100 AS salary_growth_percentage
FROM SalaryPivot
WHERE salary_2023 IS NOT NULL AND salary_2024 IS NOT NULL
ORDER BY salary_growth_percentage DESC;
GO

-- TASK 6: Top 3 Countries for Entry-Level Salary Growth, 2020 to 2023
WITH CountrySalary AS (
    SELECT employee_residence AS country, work_year,
           AVG(salary_in_usd) AS average_salary,
           COUNT(*) AS employee_count
    FROM Salaries
    WHERE experience_level = 'EN' AND work_year IN (2020,2023)
    GROUP BY employee_residence, work_year
),
CountryPivot AS (
    SELECT country,
           MAX(CASE WHEN work_year=2020 THEN average_salary END) AS salary_2020,
           MAX(CASE WHEN work_year=2023 THEN average_salary END) AS salary_2023,
           SUM(employee_count) AS total_employee_count
    FROM CountrySalary
    GROUP BY country
)
SELECT TOP 3 country, salary_2020, salary_2023,
       ((salary_2023-salary_2020)/NULLIF(salary_2020,0))*100 AS growth_percentage
FROM CountryPivot
WHERE salary_2020 IS NOT NULL AND salary_2023 IS NOT NULL AND total_employee_count > 50
ORDER BY growth_percentage DESC;
GO

-- TASK 7: Update Remote Ratio for Employees Earning > $90K in US and AU
UPDATE Salaries
SET remote_ratio = 100
WHERE salary_in_usd > 90000 AND employee_residence IN ('US','AU');
GO

-- TASK 8: Salary Updates by Experience Level in 2024
-- Percentages explicitly available in the case brief: SE 22%, MI 30%.
UPDATE Salaries
SET salary = CASE
    WHEN experience_level = 'SE' THEN salary * 1.22
    WHEN experience_level = 'MI' THEN salary * 1.30
    ELSE salary
END
WHERE work_year = 2024;
GO

-- TASK 9: Year with Highest Average Salary for Each Job Title
WITH YearlySalary AS (
    SELECT job_title, work_year, AVG(salary_in_usd) AS average_salary
    FROM Salaries
    GROUP BY job_title, work_year
),
RankedSalary AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY job_title ORDER BY average_salary DESC) AS rn
    FROM YearlySalary
)
SELECT job_title, work_year, average_salary
FROM RankedSalary
WHERE rn=1
ORDER BY job_title;
GO

-- TASK 10: Employment-Type Percentage by Job Title
SELECT job_title,
       SUM(CASE WHEN employment_type='FT' THEN 1 ELSE 0 END)*100.0/COUNT(*) AS full_time_percentage,
       SUM(CASE WHEN employment_type='PT' THEN 1 ELSE 0 END)*100.0/COUNT(*) AS part_time_percentage
FROM Salaries
GROUP BY job_title
ORDER BY job_title;
GO

-- TASK 11: Countries with Fully Remote Managers Earning > $90K
SELECT employee_residence AS country, COUNT(*) AS employee_count
FROM Salaries
WHERE job_title LIKE '%Manager%' AND salary_in_usd > 90000 AND remote_ratio=100
GROUP BY employee_residence
ORDER BY employee_count DESC;
GO

-- TASK 12: Top 5 Countries with Most Large Companies
SELECT TOP 5 company_location AS country, COUNT(*) AS large_company_count
FROM Salaries
WHERE company_size='L'
GROUP BY company_location
ORDER BY large_company_count DESC;
GO

-- TASK 13: Percentage Fully Remote Employees Earning > $100K
SELECT COUNT(CASE WHEN remote_ratio=100 AND salary_in_usd>100000 THEN 1 END)*100.0/COUNT(*) AS percentage_remote_over_100k
FROM Salaries;
GO

-- TASK 14: Locations Where Entry-Level Average Salary Exceeds Market Average
WITH MarketAverage AS (
    SELECT AVG(salary_in_usd) AS market_average
    FROM Salaries
    WHERE experience_level='EN'
)
SELECT employee_residence AS location, AVG(salary_in_usd) AS average_salary
FROM Salaries
WHERE experience_level='EN'
GROUP BY employee_residence
HAVING AVG(salary_in_usd) > (SELECT market_average FROM MarketAverage)
ORDER BY average_salary DESC;
GO

-- TASK 15: Highest-Paying Country for Each Job Title
WITH CountryJobSalary AS (
    SELECT job_title, employee_residence AS country, AVG(salary_in_usd) AS average_salary
    FROM Salaries
    GROUP BY job_title, employee_residence
),
RankedCountry AS (
    SELECT *, RANK() OVER(PARTITION BY job_title ORDER BY average_salary DESC) AS rn
    FROM CountryJobSalary
)
SELECT job_title, country, average_salary
FROM RankedCountry
WHERE rn=1
ORDER BY job_title;
GO

-- TASK 16: Countries with Sustained Salary Growth Over Three Years
WITH CountryYearSalary AS (
    SELECT employee_residence AS country, work_year, AVG(salary_in_usd) AS average_salary
    FROM Salaries
    WHERE work_year IN (2021,2022,2023)
    GROUP BY employee_residence, work_year
),
CountryPivot AS (
    SELECT country,
           MAX(CASE WHEN work_year=2021 THEN average_salary END) AS salary_2021,
           MAX(CASE WHEN work_year=2022 THEN average_salary END) AS salary_2022,
           MAX(CASE WHEN work_year=2023 THEN average_salary END) AS salary_2023
    FROM CountryYearSalary
    GROUP BY country
)
SELECT country, salary_2021, salary_2022, salary_2023
FROM CountryPivot
WHERE salary_2021 IS NOT NULL AND salary_2022 IS NOT NULL AND salary_2023 IS NOT NULL
  AND salary_2022 > salary_2021 AND salary_2023 > salary_2022
ORDER BY country;
GO

-- TASK 17: Fully Remote Work Percentage by Experience Level, 2021 vs 2024
SELECT experience_level,
       SUM(CASE WHEN work_year=2021 AND remote_ratio=100 THEN 1 ELSE 0 END)*100.0/
       NULLIF(SUM(CASE WHEN work_year=2021 THEN 1 ELSE 0 END),0) AS remote_percentage_2021,
       SUM(CASE WHEN work_year=2024 AND remote_ratio=100 THEN 1 ELSE 0 END)*100.0/
       NULLIF(SUM(CASE WHEN work_year=2024 THEN 1 ELSE 0 END),0) AS remote_percentage_2024
FROM Salaries
WHERE work_year IN (2021,2024)
GROUP BY experience_level;
GO

-- TASK 18: Average Salary Increase by Experience Level and Job Title, 2023 to 2024
WITH SalaryByYear AS (
    SELECT experience_level, job_title, work_year, AVG(salary_in_usd) AS average_salary
    FROM Salaries
    WHERE work_year IN (2023,2024)
    GROUP BY experience_level, job_title, work_year
),
SalaryPivot AS (
    SELECT experience_level, job_title,
           MAX(CASE WHEN work_year=2023 THEN average_salary END) AS salary_2023,
           MAX(CASE WHEN work_year=2024 THEN average_salary END) AS salary_2024
    FROM SalaryByYear
    GROUP BY experience_level, job_title
)
SELECT experience_level, job_title, salary_2023, salary_2024,
       ((salary_2024-salary_2023)/NULLIF(salary_2023,0))*100 AS salary_increase_percentage
FROM SalaryPivot
WHERE salary_2023 IS NOT NULL AND salary_2024 IS NOT NULL
ORDER BY salary_increase_percentage DESC;
GO

-- TASK 19: Role-Based Access Control by Experience Level
DECLARE @ExperienceLevel VARCHAR(10)='SE';
SELECT work_year, experience_level, employment_type, job_title, salary, salary_currency,
       salary_in_usd, employee_residence, remote_ratio, company_location, company_size
FROM Salaries
WHERE experience_level=@ExperienceLevel;
GO

-- TASK 20: Domain-Switching / Career Guidance from Salary Insights
SELECT experience_level, job_title, AVG(salary_in_usd) AS average_salary, COUNT(*) AS employee_count
FROM Salaries
GROUP BY experience_level, job_title
ORDER BY experience_level, average_salary DESC;
GO
