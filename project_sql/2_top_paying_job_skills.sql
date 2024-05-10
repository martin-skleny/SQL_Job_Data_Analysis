/*
What are the top-paying data analyst jobs?
    - identify the top 10 highest-paying Data Analyst roles that are available remotely
    - include only job postings with specified salaries (remove null)
    - add the specific skills required for these roles
*/

WITH top_paying_jobs AS(
    SELECT
        job_id,
        job_title,
        job_location,
        name,
        job_schedule_type,
        salary_year_avg
    FROM job_postings_fact
    LEFT JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.job_title AS "Job title",
    top_paying_jobs.name AS "Company",
    top_paying_jobs.salary_year_avg "Yearly salary",
    skills_dim.skills AS "Skill required"
FROM top_paying_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY salary_year_avg DESC;