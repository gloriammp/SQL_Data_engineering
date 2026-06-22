SELECT 
job_posted_date,
--job_posted_date::DATE as date,
job_posted_date::TIMESTAMP as timestamp,
job_posted_date::TIMESTAMPTZ as timestamptz
FROM
job_postings_fact
LIMIT 10;

SELECT 
job_posted_date,
--job_posted_date::DATE as date,
EXTRACT (YEAR FROM job_posted_date) AS job_posted_year
FROM
job_postings_fact
LIMIT 10;

SELECT 
    EXTRACT (YEAR FROM job_posted_date) AS job_posted_year,
    EXTRACT (MONTH FROM job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM
    job_postings_fact
WHERE job_title_short='Data Engineer'
GROUP BY
    EXTRACT (YEAR FROM job_posted_date),
    EXTRACT (MONTH FROM job_posted_date)
ORDER BY
    job_posted_year,
    job_posted_month;


SELECT
    '2026-01-26 00:00:00+00'::TIMESTAMPTZ AS example_timestamptz,
    '2026-01-26 00:00:00+00'::TIMESTAMPTZ AT TIME ZONE 'UTC' AS example_timestamptz_utc,
    '2026-01-26 00:00:00+00'::TIMESTAMPTZ AT TIME ZONE 'CTT' AS example_timestamptz_cts;