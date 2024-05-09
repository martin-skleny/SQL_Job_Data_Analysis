/*
What are the top skills based on salary?
    - look at average salary associated with each skill
    - focus on roles with specified salaries, regardless of location
*/

SELECT
    skills AS "Skill",
    ROUND(AVG(salary_year_avg), 0) AS "Average salary"
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY "Average salary" DESC
LIMIT 25;