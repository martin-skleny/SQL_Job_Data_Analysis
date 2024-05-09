/*
What are the most in-demand skills for data analysts?
    - identify the top 5 in-demand skills for a data analyst
    - join job postings to inner join table similar to query 2
    - focus on all job postings
*/

SELECT
    skills AS "Skill",
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;