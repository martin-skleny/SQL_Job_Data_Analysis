/*
What are the top-paying data analyst jobs?
    - identify the top 10 highest-paying Data Analyst roles that are available remotely
    - include only job postings with specified salaries (remove null)
*/
SELECT  
    job_title AS "Job title",
    job_location AS "Job location",
    name AS "Company",
    job_schedule_type AS "Schedule",
    salary_year_avg "Yearly salary"
FROM job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;