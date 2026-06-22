SELECT 
table_name,
column_name,
data_type
FROM information_schema.columns
WHERE table_name = 'job_postings_fact';

DESCRIBE job_postings_fact;

DESCRIBE
SELECT
    job_title_short,
    salary_year_avg
FROM 
job_postings_fact;

SELECT 
CAST(i AS DOUBLE) AS i
FROM generate_series(1, 3) tbl(i);

SELECT
 job_id,
 company_id,
 job_work_from_home, 
 job_posted_date,
 salary_year_avg
FROM job_postings_fact
LIMIT 10;

SELECT
 CASt(job_id AS VARCHAR) ||'_'||CAST(company_id AS VARCHAR) AS company_id,
 CAST(job_work_from_home AS INT) AS job_work_from_home,
 CAST(job_posted_date AS DATE) AS   job_posted_date,
 CAST(salary_year_avg AS DECIMAL(10, 0)) AS     salary_year_avg
FROM job_postings_fact
WHERE salary_year_avg   IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;


SELECT
 job_id::VARCHAR || '_' || company_id::VARCHAR AS
 company_job_id,
 job_work_from_home::INT AS job_work_from_home,
 job_posted_date::DATE AS job_posted_date,
 salary_year_avg::DECIMAL(10, 0) AS salary_year_avg 
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

SELECT (3 + 4.5):: INT;