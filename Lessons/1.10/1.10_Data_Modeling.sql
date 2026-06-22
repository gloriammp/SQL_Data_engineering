SELECT 
    job_id,
    job_title_short as Abreviatura,
    salary_year_avg,
    company_id
FROM
    job_postings_fact
LIMIT 10;

SELECT * FROM
    company_dim
LIMIT 10;
SHOW tables;

SELECT 
    *
FROM
    company_dim
WHERE
    name IN ('Facebook', 'Meta');

DESCRIBE company_dim;

SELECT 