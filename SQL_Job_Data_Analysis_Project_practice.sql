-- Get job details for 'Data Analyst'>100k or 'Business Analyst'>70k, in 'Boston, MA', 'Anywhere'(Remote)
SELECT
    job_title_short,
    job_location,
    job_via,
    salary_year_avg
FROM job_postings_fact
WHERE
    job_location IN ('Boston, MA', 'Anywhere') AND
    (
        (job_title_short = 'Data Analyst' AND salary_year_avg > 100000)
        OR
        (job_title_short = 'Business Analyst' AND salary_year_avg > 70000)
    )
ORDER BY salary_year_avg;

-- Look for non-senior data analyst or business analyst roles
SELECT
    job_title_short AS Pozice,
    job_location AS Lokace,
    salary_year_avg AS Mzda
FROM job_postings_fact
WHERE
    (job_title ILIKE '%data%' OR job_title ILIKE '%business%')
    AND job_title ILIKE '%analyst%'
    AND job_title NOT ILIKE '%senior%';

-- Create a table with columns: job_id, job_title, skills (3 tables)
SELECT
    job_postings_fact.job_id,
    job_postings_fact.job_title,
    skills_dim.skills
FROM job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY job_id;

--Find the average salary and number of job postings for each skill
SELECT
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS "Number of job offerings",
    ROUND(AVG(salary_year_avg),0)
FROM skills_dim
LEFT JOIN skills_job_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
LEFT JOIN job_postings_fact
    ON skills_job_dim.job_id = job_postings_fact.job_id
GROUP BY skills_dim.skills
ORDER BY "Number of job offerings" DESC;


--Creating, inserting into, altering and deleting table 
CREATE TABLE job_applied (
    job_id INT PRIMARY KEY,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    status VARCHAR(50)
);

INSERT INTO job_applied
    (job_id,
    application_sent_date,
    custom_resume,
    resume_file_name,
    cover_letter_sent,
    cover_letter_file_name,
    status)
VALUES
    (1,
    '2024-02-01',
    true,
    'resume_01.pdf',
    true,
    'cover_letter_01.pdf',
    'submitted'),
    (2,
    '2024-02-02',
    false,
    'resume_02.pdf',
    false,
    NULL,
    'interview scheduled'
    );


ALTER TABLE job_applied
ADD COLUMN contact VARCHAR(50);

UPDATE job_applied
SET contact = 'Erich Bachman'
WHERE job_id = 1;

UPDATE job_applied
SET contact = 'Erich Bachman'
WHERE job_id = 2;
 
ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;

ALTER TABLE job_applied
DROP COLUMN contact_name;

DROP TABLE job_applied;

--Create 3 tables for first quarter
--January
CREATE TABLE january_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
;
--February
CREATE TABLE february_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2
;
--March
CREATE TABLE march_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3
;


-- CASE expression

--Label new column
-- 'Anywhere' jobs as 'Remote'
-- 'New York, NY' jobs as 'Local'
-- Otherwise as 'Onsite':
SELECT
    COUNT(job_id) AS "Počet nabídek",
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY location_category;

--Put data analyst salary into different buckets
--define low, medium and high
--order from highest
SELECT
    salary_year_avg,
    job_title_short,
    CASE
        WHEN salary_year_avg BETWEEN 0 AND 80000 THEN 'low'
        WHEN salary_year_avg BETWEEN 80001 AND 110000 THEN 'standard'
        WHEN salary_year_avg > 110000 THEN 'high'
        ELSE 'undefined'
    END AS "kategorie"
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
ORDER BY salary_year_avg;


--SubQueries and CTEs

--SubQuery
--select only jobs, where job posting is in january using subquery
SELECT *
FROM ( --subquery starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1 --subquery ends here
) AS january_jobs;

--find companies with job posting without degree mention
SELECT 
    company_id,
    name
FROM company_dim
WHERE company_id IN (
    SELECT company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention = true
)

--Common Table Expressions (CTE)
--define a temporary result set, that can be referenced
--same as previous, but using CTE:
WITH january_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)
SELECT *
FROM january_jobs;

--find companies that have the most job openings
WITH pocet_nabidek AS (
SELECT
    company_id,
    COUNT(*) AS nabidek_celkem
FROM
    job_postings_fact
GROUP BY company_id
)

SELECT 
    company_dim.name AS nazev_spolecnosti,
    pocet_nabidek.nabidek_celkem
FROM company_dim
LEFT JOIN pocet_nabidek
ON pocet_nabidek.company_id = company_dim.company_id
ORDER BY nabidek_celkem DESC;


--identify the top 5 skills thata re most frequently mentioned in job postings
WITH job_count AS (
    SELECT
        skill_id,
        COUNT(job_id) AS "Počet nabídek"
    FROM skills_job_dim
    GROUP BY skill_id
    )

SELECT 
    skills_dim.skills AS "Dovednost",
    job_count."Počet nabídek"
FROM skills_dim
LEFT JOIN job_count
ON skills_dim.skill_id = job_count.skill_id
ORDER BY "Počet nabídek" DESC
LIMIT 5;

--determine the size category for each company by number of job postings
-- <10 is small
-- 10-50 is medium
-- >50 is large
WITH pocet_nabidek AS(
    SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM job_postings_fact
    GROUP BY company_id
    )

SELECT
    company_dim.name,
    pocet_nabidek.total_jobs,
    CASE
        WHEN pocet_nabidek.total_jobs <10 THEN 'Small'
        WHEN pocet_nabidek.total_jobs BETWEEN 10 AND 50 THEN 'Medium'
        WHEN pocet_nabidek.total_jobs >50 THEN 'Large'
        ELSE 'Undefined'
    END AS category
FROM pocet_nabidek
RIGHT JOIN company_dim
ON pocet_nabidek.company_id = company_dim.company_id
ORDER BY company_dim.name;

--find top 5 skills by their demand in remote jobs
WITH prace_z_domu AS(
    SELECT
        skill_id,
        COUNT(*) AS nabidek_celkem
    FROM skills_job_dim
    INNER JOIN job_postings_fact
    ON skills_job_dim.job_id = job_postings_fact.job_id
    WHERE job_postings_fact.job_location = 'Anywhere'
    GROUP BY skill_id
    )

SELECT
    skills_dim.skills,
    prace_z_domu.nabidek_celkem AS "Nabídek celkem"
FROM prace_z_domu
INNER JOIN skills_dim
ON prace_z_domu.skill_id = skills_dim.skill_id
ORDER BY nabidek_celkem DESC
LIMIT 5;


--UNION and UNION ALL
--combines results from two or more SELECT statements
--must have same amount of columns and same data type
--UNION removes duplicate rows, UNION ALL includes all rows
--UNION ALL is typically used more often

SELECT
    job_title_short,
    company_id,
    job_location
FROM january_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM february_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM march_jobs


--get skill and skill type for each job posting in Q1
--include those without any skills too
--look at those with salary >70k
SELECT
    job_postings_fact.job_title_short,
    job_postings_fact.job_posted_date,
    job_postings_fact.salary_year_avg,
    skills_dim.skills,
    skills_dim.type
FROM job_postings_fact

LEFT JOIN skills_job_dim
ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE EXTRACT(MONTH FROM job_posted_date) <= 3
    AND salary_year_avg > 70000

ORDER BY salary_year_avg;


-- find job postings from Q1 that have salary >70k
WITH prvni_ctvrtleti AS(
    SELECT *
    FROM january_jobs

    UNION ALL

    SELECT *
    FROM february_jobs

    UNION ALL

    SELECT *
    FROM march_jobs
)

SELECT 
    job_title_short,
    job_posted_date::DATE,
    salary_year_avg
FROM prvni_ctvrtleti
WHERE salary_year_avg >70000
ORDER BY salary_year_avg DESC;

--or without UNION:
SELECT
    job_posted_date,
    salary_year_avg
FROM job_postings_fact
WHERE (job_posted_date BETWEEN '2023-01-01' AND '2023-04-01') AND
        salary_year_avg > 70000
ORDER BY job_posted_date DESC;
