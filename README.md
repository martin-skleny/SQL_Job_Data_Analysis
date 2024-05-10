# Introduction
Project about analysing job market data with focus on data analyst roles. Explore top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics.

Final SQL queries are available here: [project_sql folder](/project_sql/)

# Background
This project was born from a desire to analyse the data analyst job market and identify top-paid and in-demand skills.

Data source is [SQL Course](https://lukebarousse.com/sql)
# Tools I used
This project was successfully completed using several different tools:

- **SQL**: The core building element of the whole project, that allowed me to query the large database and find answers to all of the questions.

- **PostgreSQL**: Was the chosen database management system, due to its popularity and ability for handling the job posting data.

- **Visual Studio Code**: One of the best, most popular and versatile tool on the market not only for database management and execution of SQL queries.

- **Git & GitHub**: Last but not least I chose Git as a version control system for project tracking and GitHub as place where to share my SQL scripts and analysis, making collaboration possible.

# The analysis
Each step of this project was aimed at investigating specific aspects of the data analyst job market. 
### 1. Top paying Data Analyst Jobs
First I had to identify the highest-paying roles. I filtered the database by the top 10 average yearly salary position with focus on data analyst position and remote job location.

```sql
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
```
### 2. Skills for top paying jobs
Goal of this query was to understand what skills are required for the top-paying jobs. To identify them, I joined the job postings table with the skills data table through skills job table and yet again looked for top 10 paying positions with focus on remote job location and data analyst role while also including skills associated with these positions.

### 3. The most in-demand skills for Data Analysts
The next step was to identify the skills that are most frequently requested in job postings. I again joined the job postings table with skills table and used function to calculate how many job offers there are for each specific skill.

### 4. Skills based on salary
In this query, I wanted to explore which skills are the highest paying. Again I joined job postings table with skills table and through function identify the top 25 skills based on the average salary associated with these skills. 

### 5. The most optimal skills to learn
All previous queries led to this final one. By combining information gain from queries 1-4, goal of this final one was to pinpoint skills that not only have high salaries, but also are in high demand, therefore making them ideal as the next focus for personal skill development. I've included 2 different versions for this query, both leading to the identical result. 

# What I learned
While working through this project, my primary focus was to hone my SQL skills. Not only I've dusted my basic SQL knowledge, but most importantly I've learned some more advanced SQL skills from sorting and filtering, through aggregate functions and complex query crafting (merging tables, temp tables using WITH clauses) to real-world puzzle-solving skills, turning questions into SQL queries.

Last but not least I've also revived my knowledge about different tools, that I've been using throughout this whole project.

# Conclusion
Aim of this project for me was to enhance my SQL skills, learn how to craft more complex queries and different variants of this queries. I can safely say I've achieved what I envisioned and much more. I've practiced with different tools used throughout this whole project and gained insight into the data analyst job market. As a result, findings from this analysis can serve as a guide on which skills to focus and which to prioritize for the next personal development.