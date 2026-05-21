

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

    /*
    ┌───────────┬────────────────────┬─────────────┐
│  skills   │ cantidad_demandada │ job_country │
│  varchar  │       int64        │   varchar   │
├───────────┼────────────────────┼─────────────┤
│ python    │                988 │ Argentina   │
│ sql       │                863 │ Argentina   │
│ airflow   │                635 │ Argentina   │
│ aws       │                617 │ Argentina   │
│ pandas    │                306 │ Argentina   │
│ redshift  │                274 │ Argentina   │
│ snowflake │                267 │ Argentina   │
│ spark     │                258 │ Argentina   │
│ flow      │                223 │ Argentina   │
│ azure     │                213 │ Argentina   │
├───────────┴────────────────────┴─────────────┤
│ 10 rows                            3 columns │
└──────────────────────────────────────────────┘
*/

    describe table job_postings_fact;
    /*
    ───────────────────────┬─────────────┬─────────┬─────────┬─────────┬─────────┐
│      column_name      │ column_type │  null   │   key   │ default │  extra  │
│        varchar        │   varchar   │ varchar │ varchar │ varchar │ varchar │
├───────────────────────┼─────────────┼─────────┼─────────┼─────────┼─────────┤
│ job_id                │ INTEGER     │ NO      │ PRI     │ NULL    │ NULL    │
│ company_id            │ INTEGER     │ YES     │ NULL    │ NULL    │ NULL    │
│ job_title_short       │ VARCHAR     │ YES     │ NULL    │ NULL    │ NULL    │
│ job_title             │ VARCHAR     │ YES     │ NULL    │ NULL    │ NULL    │
│ job_location          │ VARCHAR     │ YES     │ NULL    │ NULL    │ NULL    │
│ job_via               │ VARCHAR     │ YES     │ NULL    │ NULL    │ NULL    │
│ job_schedule_type     │ VARCHAR     │ YES     │ NULL    │ NULL    │ NULL    │
│ job_work_from_home    │ BOOLEAN     │ YES     │ NULL    │ NULL    │ NULL    │
│ search_location       │ VARCHAR     │ YES     │ NULL    │ NULL    │ NULL    │
│ job_posted_date       │ TIMESTAMP   │ YES     │ NULL    │ NULL    │ NULL    │
│ job_no_degree_mention │ BOOLEAN     │ YES     │ NULL    │ NULL    │ NULL    │
│ job_health_insurance  │ BOOLEAN     │ YES     │ NULL    │ NULL    │ NULL    │
│ job_country           │ VARCHAR     │ YES     │ NULL    │ NULL    │ NULL    │
│ salary_rate           │ VARCHAR     │ YES     │ NULL    │ NULL    │ NULL    │
│ salary_year_avg       │ DOUBLE      │ YES     │ NULL    │ NULL    │ NULL    │
│ salary_hour_avg       │ DOUBLE      │ YES     │ NULL    │ NULL    │ NULL    │
├───────────────────────┴─────────────┴─────────┴─────────┴─────────┴─────────┤
│ 16 rows                                                           6 columns │*/

/* cálculo de mediana de salario anual, indicando cuantas veces es demandada cada skill 
*/


    SELECT 
        sd.skills,
        COUNT(jpf.*) AS cantidad_demandada,
        ROUND(MEDIAN(jpf.salary_year_avg), 0) AS salario_anual_mediana,
        jpf.job_country
    FROM 
         job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
         ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd
         ON sjd.skill_id = sd.skill_id
    WHERE 
         jpf.job_title_short = 'Data Engineer'
         AND jpf.job_work_from_home= True
         AND jpf.job_country = 'Argentina'
    GROUP BY 
        sd.skills, jpf.job_country
    ORDER BY 
        salario_anual_mediana DESC,
        cantidad_demandada DESC
    LIMIT 10;

    /*
    ┌────────────┬────────────────────┬───────────────────────┬─────────────┐
│   skills   │ cantidad_demandada │ salario_anual_mediana │ job_country │
│  varchar   │       int64        │        double         │   varchar   │
├────────────┼────────────────────┼───────────────────────┼─────────────┤
│ python     │                988 │               60000.0 │ Argentina   │
│ sql        │                863 │               60000.0 │ Argentina   │
│ airflow    │                635 │               60000.0 │ Argentina   │
│ gcp        │                198 │               60000.0 │ Argentina   │
│ golang     │                155 │               60000.0 │ Argentina   │
│ typescript │                 13 │               60000.0 │ Argentina   │
│ react      │                  6 │               60000.0 │ Argentina   │
│ aws        │                617 │                  NULL │ Argentina   │
│ pandas     │                306 │                  NULL │ Argentina   │
│ redshift   │                274 │                  NULL │ Argentina   │
├────────────┴────────────────────┴───────────────────────┴─────────────┤
│ 10 rows                                                     4 columns │
└───────────────────────────────────────────────────────────────────────┘
*/

/*
Como es raro el salario anual mediana de 60000.0 para todas las skills,
 vamos a revisar los salarios anuales promedio para las skills de Python y SQL, que son las más demandadas
*/ 

    SELECT 
        sd.skills,
        jpf.salary_year_avg,
        jpf.job_country
    FROM 
         job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
         ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd
         ON sjd.skill_id = sd.skill_id
    WHERE 
         jpf.job_title_short = 'Data Engineer'
         AND jpf.job_work_from_home= True
         AND jpf.job_country = 'Argentina'
         AND sd.skills IN ('python', 'sql')
    ORDER BY 
        jpf.salary_year_avg DESC    
    LIMIT 20;
/* 
El resultado explica el valor de 60000.0 para la mediana,
 ya que es el único salario anual promedio publicado skills de Python y SQL.

│ skills  │ salary_year_avg │ job_country │
│ varchar │     double      │   varchar   │
├─────────┼─────────────────┼─────────────┤
│ python  │         60000.0 │ Argentina   │
│ sql     │         60000.0 │ Argentina   │
│ python  │            NULL │ Argentina   │
│ python  │            NULL │ Argentina   │
│ python  │            NULL │ Argentina   │
│ sql     │            NULL │ Argentina   │
│ sql     │            NULL │ Argentina   │
│ python  │            NULL │ Argentina   │
│ sql     │            NULL │ Argentina   │
│ python  │            NULL │ Argentina   │
│ python  │            NULL │ Argentina   │
│ python  │            NULL │ Argentina   │
│ sql     │            NULL │ Argentina   │
│ sql     │            NULL │ Argentina   │
│ sql     │            NULL │ Argentina   │
│ sql     │            NULL │ Argentina   │
│ python  │            NULL │ Argentina   │
│ sql     │            NULL │ Argentina   │
│ python  │            NULL │ Argentina   │
│ python  │            NULL │ Argentina   │
├─────────┴─────────────────┴─────────────┤
│ 20 rows                       3 columns │
└─────────────────────────────────────────┘
*/
    SELECT 
    sd.skills,
    COUNT(jpf.job_id) AS cantidad
FROM 
    job_postings_fact AS jpf
INNER JOIN skills_dim AS sd
    ON jpf.job_id = sd.job_id
WHERE
    jpf.salary_year_avg IS NOT NULL
GROUP BY 
    sd.skills
ORDER BY 
    cantidad DESC;



SELECT 
        sd.skills,
        COUNT(jpf.job_id) AS cantidad,
         COUNT(CASE WHEN jpf.salary_year_avg IS NULL THEN 1 END) AS nulos_en_salario_anual,
    FROM 
         job_postings_fact AS jpf
     INNER JOIN skills_job_dim AS sjd
         ON jpf.job_id = sjd.job_id
     INNER JOIN skills_dim AS sd
         ON sjd.skill_id = sd.skill_id
    WHERE
         jpf.job_title_short = 'Data Engineer'
         AND jpf.job_work_from_home= True
         AND jpf.job_country = 'Argentina'
    GROUP BY 
        sd.skills
     ORDER BY
            cantidad desc
     LIMIT 15;
     /*
De la consulta anterior se desprende que la mayoria de los puestos
publicados no incluyen el salario anual promedio, lo que dificulta el análisis de la mediana de salario anual para cada skill.
No se puede determinar con certeza cuáles son las habilidades mejor pagas para los Data Engineers en Argentina, ya que la mayoría de los registros no incluyen esta información.

┌────────────┬──────────┬────────────────────────┐
│   skills   │ cantidad │ nulos_en_salario_anual │
│  varchar   │  int64   │         int64          │
├────────────┼──────────┼────────────────────────┤
│ python     │      988 │                    987 │
│ sql        │      863 │                    862 │
│ airflow    │      635 │                    634 │
│ aws        │      617 │                    617 │
│ pandas     │      306 │                    306 │
│ redshift   │      274 │                    274 │
│ snowflake  │      267 │                    267 │
│ spark      │      258 │                    258 │
│ flow       │      223 │                    223 │
│ azure      │      213 │                    213 │
│ databricks │      210 │                    210 │
│ gcp        │      198 │                    197 │
│ pyspark    │      194 │                    194 │
│ docker     │      176 │                    176 │
│ kubernetes │      169 │                    169 │
├────────────┴──────────┴────────────────────────┤
│ 15 rows                              3 columns │
     */
     

