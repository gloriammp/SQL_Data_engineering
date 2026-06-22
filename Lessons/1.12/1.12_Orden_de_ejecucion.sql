SELECT 
    cd.name AS company_name,
    COUNT(jpf.*) AS postings_count
FROM
    job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id   
GROUP BY cd.name
ORDER BY postings_count DESC;

EXPLAIN ANALYZE
SELECT 
    cd.name AS company_name,
    COUNT(jpf.*) AS postings_count
FROM
    job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id  
WHERE  jpf.job_country = 'United States'
GROUP BY cd.name
HAVING COUNT(jpf.job_id) > 2500
ORDER BY postings_count DESC
LIMIT 20;

SELECT DISTINCT jpf.job_country
FROM job_postings_fact AS jpf
ORDER BY jpf.job_country DESC;