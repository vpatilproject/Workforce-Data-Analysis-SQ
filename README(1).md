# Salary and Remote Work Trends Across Job Titles and Company Locations

## Project Overview
This project analyzes workforce salary and remote-work data using SQL / MS-SQL Server. The analysis covers company size, job titles, experience levels, employment types, salary trends, geographic salary differences and remote-work patterns.

## Dataset
**Dataset:** `Salaries.xls`

Important fields include:
- `work_year`
- `experience_level`
- `employment_type`
- `job_title`
- `salary`
- `salary_currency`
- `salary_in_usd`
- `employee_residence`
- `remote_ratio`
- `company_location`
- `company_size`

## Database
Database: `Workforce_Data_Analysis`  
Main table: `Salaries`

## Tasks Covered
1. Employees by company size in 2021
2. Top 3 highest-average-salary part-time job titles in 2023
3. Countries above the overall mid-level salary average
4. Highest and lowest senior-level salary locations in 2023
5. Salary growth by job title
6. Top countries for entry-level salary growth
7. Remote-ratio update for high earners in US/AU
8. Salary updates by experience level in 2024
9. Highest-average-salary year by job title
10. Employment-type percentage by job title
11. Fully remote managers earning over $90K
12. Top 5 countries with the most large companies
13. Fully remote employees earning over $100K
14. Entry-level locations above market average
15. Highest-paying country for each job title
16. Sustained salary growth over three years
17. Fully remote percentage by experience level: 2021 vs 2024
18. Salary increase percentage by experience level and job title
19. Role-based access control by experience level
20. Career/domain guidance using salary insights

## SQL Concepts Used
- SELECT, WHERE, GROUP BY, HAVING, ORDER BY
- Aggregate functions: COUNT, AVG, SUM
- JOIN/CTE-style analytical logic
- CASE expressions
- Subqueries
- CTEs
- ROW_NUMBER()
- RANK()
- Conditional aggregation
- UPDATE
- Variables

## Key Insights
The project is designed to identify salary differences across experience levels, job titles and locations; compare remote-work patterns; evaluate company-size distributions; and support workforce and career decisions.

## Important Notes
Tasks 7 and 8 contain UPDATE statements and therefore modify the database table. Keep a backup of the original imported dataset before executing them.

For Task 8, only the salary adjustment percentages explicitly available in the case brief were applied: Senior (SE) 22% and Mid-level (MI) 30%. Other levels are left unchanged where the source does not specify a percentage.

## Deliverables
- `Project_4_Presentation.pptx`
- `Project_4_Documentation.pdf`
- `Project_4_Documentation.docx`
- `Project_4_SQL_Queries.sql`
- `README.md`

## Conclusion
This project demonstrates how SQL can transform workforce data into practical salary, remote-work and employment insights for data-driven workforce planning and career analysis.
