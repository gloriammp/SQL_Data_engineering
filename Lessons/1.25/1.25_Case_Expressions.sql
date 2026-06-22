-- Bucket salaries

SELECT
job_title_short,
salary_hour_avg,
CASE
    WHEN salary_hour_avg < 25 THEN 'Low'
    WHEN salary_hour_avg <50 THEN 'Medium'
    ELSE 'High'
END AS salary_category
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
LIMIT 10;

-- Handling missing values
SELECT
job_title_short,
salary_hour_avg,
CASE
    WHEN salary_hour_avg IS NULL THEN 'Missing'
    WHEN salary_hour_avg < 25 THEN 'Low'
    WHEN salary_hour_avg <50 THEN 'Medium'
    ELSE 'High'
END AS salary_category
FROM job_postings_fact
LIMIT 30;

-- Categorizing categorical values
SELECT
job_title,
job_title_short,
CASE
    WHEN job_title LIKE '%Data%' AND job_title LIKE '%Analyst%' THEN 'Data Analyst'
    WHEN job_title LIKE '%Data%' AND job_title LIKE '%Scientist%' THEN 'Data Scientist'
    WHEN job_title LIKE '%Data%' AND job_title LIKE '%Engineer%' THEN 'Data Engineer'
    ELSE 'Other'
    END AS job_category
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 20;

-- CAlculate median salaries for different buckets

SELECT 
  job_title_short,
  COUNT(*) AS num_postings,
  MEDIAN(
    CASE
       WHEN salary_year_Avg < 100_000 THEN salary_year_avg
    END) AS median_low_salary,
  MEDIAN(
    CASE
       WHEN salary_year_Avg >= 100_000 THEN salary_year_avg
    END) AS median_high_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short;

    -- Conditional calculations
WITH salaries AS (
    SELECT
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
    CASE
        WHEN salary_year_avg IS NOT NULL THEN salary_year_avg 
        WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg*2080
        ELSE NULL
    END AS calculated_salary_hour
    FROM job_postings_fact
)
SELECT 
*,
CASE
    WHEN calculated_salary_hour IS NULL THEN 'Missing'
    WHEN calculated_salary_hour <100_000 THEN 'Low'
    WHEN calculated_salary_hour < 150_000 THEN 'Medium'
    ELSE 'High'
END AS salary_category
FROM salaries
LIMIT 20;