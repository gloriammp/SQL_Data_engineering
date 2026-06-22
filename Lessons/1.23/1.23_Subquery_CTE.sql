--Subquery
SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
        OR salary_hour_avg IS NOT NULL
)
LIMIT 10;

-- CTE
WITH valid_salaries AS (
    SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
        OR salary_hour_avg IS NOT NULL
)

SELECT *
FROM valid_salaries;

-- Escenario 1 - Subquery in 'SELECT'
-- Mostrar los trabajos , el salario y  la mediana del mercado

SELECT
   job_title_short,
   salary_year_avg,
 ( SELECT MEDIAN(salary_year_avg) 
   FROM job_postings_fact
 AS market_median_salary
 )  
 FROM job_postings_fact
 WHERE salary_year_avg IS NOT NULL
 LIMIT 10;

 -- Escenario 2 Subquery in FROM
 -- Calcular la mediana del mercado solamente con los trabajos que son remotos.

 SELECT
   job_title_short,
   MEDIAN(salary_year_avg) AS market_median_salary,
 ( SELECT MEDIAN(salary_year_avg) 
   FROM job_postings_fact
   WHERE job_work_from_home = TRUE
   )AS market_remote_median_salary  
 FROM (
    SELECT 
    job_title_short,
    salary_year_avg
FROM job_postings_fact
WHERE job_work_from_home= TRUE
 )
 WHERE salary_year_avg IS NOT NULL
 GROUP BY job_title_short
 LIMIT 10;

 -- Escenario 3- 
 -- Solamente mostrar los job titles que tienen la mediana salarial 
 -- superior a  la  market median salary

 SELECT
   job_title_short,
   MEDIAN(salary_year_avg) AS market_median_salary,
 ( SELECT MEDIAN(salary_year_avg) 
   FROM job_postings_fact
   WHERE job_work_from_home = TRUE
   )AS market_remote_median_salary  
 FROM (
    SELECT 
    job_title_short,
    salary_year_avg
FROM job_postings_fact
WHERE job_work_from_home= TRUE
 )
 WHERE salary_year_avg IS NOT NULL
 GROUP BY job_title_short
 HAVING MEDIAN(salary_year_avg) > (SELECT MEDIAN(salary_year_avg) 
   FROM job_postings_fact
   WHERE job_work_from_home = TRUE
   )
 LIMIT 10;

 SELECT MEDIAN(salary_year_avg) 
   FROM job_postings_fact
   WHERE job_work_from_home = TRUE;

-- Ejemplos con CTE

WITH title_median AS (  
    SELECT
        job_title_short,
        job_work_from_home,
        MEDIAN(salary_year_avg)::INT  AS median_salary
    FROM job_postings_fact
    WHERE job_country = 'Argentina'
    GROUP BY job_title_short, job_work_from_home
)

SELECT 
    r.job_title_short,
    r.median_salary AS remote_median_salary,
    o.median_salary AS onsite_median_salary,
    (r.median_salary - o.median_salary) AS median_diff
FROM title_median AS r
INNER JOIN title_median AS o
 ON r.job_title_short = o.job_title_short
 WHERE r.job_work_from_home = TRUE
 AND o.job_work_from_home = FALSE
 ORDER BY median_diff DESC;

 SELECT range(10);

 SELECT *
 FROM range(4) AS src(key);

 SELECT *
 FROM range(4) AS src(key)
 WHERE NOT EXISTS (
  SELECT 1
  FROM range(2) as tgt(key)
  WHERE src.key = tgt.key   
 );

SELECT *
FROM job_postings_fact as tgt
WHERE  EXISTS (
  SELECT 1
  FROM skills_job_dim AS src
  WHERE tgt.job_id = src.job_id)
ORDER BY job_id;