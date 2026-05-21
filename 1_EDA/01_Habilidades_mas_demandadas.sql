    /* Con este código se analiza cuales son las skills mas demandadas en el mercado laboral para data engineers.
    El foco está puesto en los trabajos remotos en Argentina para data engineers, por lo que se filtra por el título del trabajo y se cuentan las habilidades asociadas a esos trabajos.
    */

/* En primer lugar se busca en general para poder comparar luego con los puestos ofrecidos en la Argentina
*/
    SELECT
        sd.skills,
        COUNT(jpf.*) AS cantidad_demandada
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
    WHERE jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home= True
    GROUP BY sd.skills
    ORDER BY cantidad_demandada DESC
    LIMIT 10;

/*
┌────────────┬────────────────────┐
│   skills   │ cantidad_demandada │
│  varchar   │       int64        │
├────────────┼────────────────────┤
│ sql        │              29221 │
│ python     │              28776 │
│ aws        │              17823 │
│ azure      │              14143 │
│ spark      │              12799 │
│ airflow    │               9996 │
│ snowflake  │               8639 │
│ databricks │               8183 │
│ java       │               7267 │
│ gcp        │               6446 │
├────────────┴────────────────────┤
│ 10 rows               2 columns │
└─────────────────────────────────┘
*/

 SELECT
        sd.skills,
        COUNT(jpf.*) AS cantidad_demandada
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
    WHERE jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home= True
    GROUP BY sd.skills
    ORDER BY cantidad_demandada DESC
    LIMIT 10;

    SELECT * FROM job_postings_fact
    LIMIT 10;

DESCRIBE job_postings_fact;
/*
Habilidades demandadas en Argentina
*/  

SELECT
        sd.skills,
        COUNT(jpf.*) AS cantidad_demandada,
        jpf.job_country
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
    WHERE jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home= True
    AND jpf.job_country = 'Argentina'
    GROUP BY sd.skills, jpf.job_country
    ORDER BY cantidad_demandada DESC
    LIMIT 10;
