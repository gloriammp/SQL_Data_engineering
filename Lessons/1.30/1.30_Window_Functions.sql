SELECT COUNT(*) AS total_rows
FROM job_postings_fact;

SELECT job_id
FROM job_postings_fact;

--10.29 youtube

SELECT
    job_id,
    COUNT(*) OVER ()
FROM
    job_postings_fact;


SELECT 
    job_id,
    job_title_short,
    salary_hour_avg,
    company_id,
    AVG (salary_hour_avg) OVER(
        PARTITION BY job_title_short, company_id
    ) AS avg_hourly_by_title
FROM
    job_postings_fact
ORDER BY 
    salary_hour_avg DESC
LIMIT 20;

SELECT 
    job_id,
    job_title_short,
    salary_hour_avg,
    company_id,
    RANK() OVER (
     ORDER BY salary_hour_avg DESC) AS salary_rank
 FROM
    job_postings_fact
ORDER BY salary_hour_avg DESC
LIMIT 20;