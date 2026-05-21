/*
Como en Argentina no hay registros de salarios,
haremos un cambio y revisaremos en la región, teniendo en cuenta
Brasil, Argentina, Uruguay y Chile, para el puesto de Data Engineer, con modalidad de trabajo remoto.
*/


SELECT 
  sd.skills,
  ROUND(MEDIAN(jpf.salary_year_avg), 0) AS mediana_salario_anual,
  COUNT(jpf.job_id) AS cantidad,
FROM 
  job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
  ON jpf.job_id = sjd.job_id    
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
    WHERE
    jpf.job_title_short = 'Data Engineer' AND
    jpf.job_country IN ('Argentina', 'Brasil', 'Uruguay', 'Chile') AND
    jpf.job_work_from_home = True AND
    jpf.salary_year_avg IS NOT NULL
GROUP BY
  sd.skills
ORDER BY
  mediana_salario_anual DESC;¨

  /*
┌───────────────┬───────────────────────┬──────────┐
│    skills     │ mediana_salario_anual │ cantidad │
│    varchar    │        double         │  int64   │
├───────────────┼───────────────────────┼──────────┤
│ python        │               60000.0 │        1 │
│ react         │               60000.0 │        1 │
│ gcp           │               60000.0 │        1 │
│ typescript    │               60000.0 │        1 │
│ golang        │               60000.0 │        1 │
│ airflow       │               60000.0 │        1 │
│ sql           │               59700.0 │        2 │
│ aws           │               59400.0 │        1 │
│ hadoop        │               59400.0 │        1 │
│ cassandra     │               59400.0 │        1 │
│ docker        │               59400.0 │        1 │
│ slack         │               59400.0 │        1 │
│ github        │               59400.0 │        1 │
│ git           │               59400.0 │        1 │
│ gitlab        │               59400.0 │        1 │
│ databricks    │               59400.0 │        1 │
│ spark         │               59400.0 │        1 │
│ terraform     │               59400.0 │        1 │
│ kafka         │               59400.0 │        1 │
│ scala         │               59400.0 │        1 │
│ elasticsearch │               59400.0 │        1 │
│ jira          │               59400.0 │        1 │
│ jenkins       │               59400.0 │        1 │
├───────────────┴───────────────────────┴──────────┤

Los resultados hacen sospechar que en estos países tampoco 
publican los salarios, o al menos muy pocos lo hacen. 
  */



  SELECT 
        jpf.job_country,
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
         AND jpf.job_country in ( 'Chile', 'Uruguay', 'Brasil')
    GROUP BY 
        sd.skills,
        jpf.job_country
    HAVING
        cantidad >200
     ORDER BY
            cantidad desc
     LIMIT 10;
/*
Como buena parte de los registros no tienen salario anual, vamos a ver efectivamente
cuantos registros nulos por pais y skill hay.
*/



 WITH ranked_skills AS (
    SELECT 
        jpf.job_country,
        sd.skills,
        COUNT(jpf.job_id) AS cantidad,
        COUNT(CASE WHEN jpf.salary_year_avg IS NULL THEN 1 END) AS nulos_en_salario_anual,
        ROW_NUMBER() OVER (
            PARTITION BY jpf.job_country 
            ORDER BY COUNT(jpf.job_id) DESC
        ) AS ranking
    FROM 
        job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd 
        ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd 
        ON sjd.skill_id = sd.skill_id
    WHERE
        jpf.job_title_short = 'Data Engineer'
        AND jpf.job_work_from_home = TRUE
        AND jpf.job_country IN ('Chile', 'Uruguay', 'Brazil')
    GROUP BY 
        jpf.job_country,
        sd.skills
)
SELECT 
    job_country,
    skills,
    cantidad,
    nulos_en_salario_anual,
    ROUND(nulos_en_salario_anual / cantidad,3)AS porcentaje_nulos
FROM 
    ranked_skills
WHERE 
    ranking <= 10
ORDER BY 
    job_country, 
    cantidad DESC;

    /*
    ┌─────────────┬────────────┬───┬──────────────────────┬──────────────────┐
│ job_country │   skills   │ … │ nulos_en_salario_a…  │ porcentaje_nulos │
│   varchar   │  varchar   │   │        int64         │      double      │
├─────────────┼────────────┼───┼──────────────────────┼──────────────────┤
│ Brazil      │ python     │ … │                  716 │            0.997 │
│ Brazil      │ sql        │ … │                  714 │            0.997 │
│ Brazil      │ aws        │ … │                  413 │            0.998 │
│ Brazil      │ spark      │ … │                  324 │            0.997 │
│ Brazil      │ airflow    │ … │                  287 │              1.0 │
│ Brazil      │ azure      │ … │                  265 │            0.996 │
│ Brazil      │ snowflake  │ … │                  244 │              1.0 │
│ Brazil      │ databricks │ … │                  190 │            0.995 │
│ Brazil      │ kafka      │ … │                  187 │            0.995 │
│ Brazil      │ java       │ … │                  186 │              1.0 │
│ Chile       │ python     │ … │                  618 │              1.0 │
│ Chile       │ sql        │ … │                  561 │            0.998 │
│ Chile       │ airflow    │ … │                  442 │              1.0 │
│ Chile       │ aws        │ … │                  396 │            0.997 │
│ Chile       │ pandas     │ … │                  232 │              1.0 │
│ Chile       │ gcp        │ … │                  209 │              1.0 │
│ Chile       │ docker     │ … │                  177 │            0.994 │
│ Chile       │ pyspark    │ … │                  178 │              1.0 │
│ Chile       │ databricks │ … │                  175 │            0.994 │
│ Chile       │ kubernetes │ … │                  162 │              1.0 │
│ Uruguay     │ python     │ … │                   57 │              1.0 │
│ Uruguay     │ sql        │ … │                   53 │              1.0 │
│ Uruguay     │ aws        │ … │                   31 │              1.0 │
│ Uruguay     │ spark      │ … │                   24 │              1.0 │
│ Uruguay     │ azure      │ … │                   21 │              1.0 │
│ Uruguay     │ java       │ … │                   20 │              1.0 │
│ Uruguay     │ tableau    │ … │                   19 │              1.0 │
│ Uruguay     │ snowflake  │ … │                   16 │              1.0 │
│ Uruguay     │ databricks │ … │                   15 │              1.0 │
│ Uruguay     │ airflow    │ … │                   14 │              1.0 │


la mayoría de las publicaciones no tienen salario anual publicado 
Luego vamos a evaluar cuales son las skills más demandadas, sin tener en cuenta el pais.
También vamos a directamente tener en cuenta las filas en las que el salario anual está disponible*/

SELECT 
    sd.skills,
    COUNT(jpf.salary_year_avg) AS cantidad_demandada,
    ROUND(MEDIAN(jpf.salary_year_avg), 1) AS salario_anual_mediana
FROM 
     job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
     ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
     ON sjd.skill_id = sd.skill_id  
WHERE     jpf.job_title_short = 'Data Engineer'
     AND jpf.job_work_from_home= True
     AND jpf.salary_year_avg IS NOT NULL
GROUP BY 
    sd.skills
HAVING
    cantidad_demandada > 100
ORDER BY 
    salario_anual_mediana DESC
LIMIT 25;

/*

┌────────────┬────────────────────┬───────────────────────┐
│   skills   │ cantidad_demandada │ salario_anual_mediana │
│  varchar   │       int64        │        double         │
├────────────┼────────────────────┼───────────────────────┤
│ terraform  │                193 │              184000.0 │
│ kubernetes │                147 │              150500.0 │
│ airflow    │                386 │              150000.0 │
│ kafka      │                292 │              145000.0 │
│ pyspark    │                152 │              140000.0 │
│ go         │                113 │              140000.0 │
│ git        │                208 │              140000.0 │
│ spark      │                503 │              140000.0 │
│ aws        │                783 │              137320.3 │
│ scala      │                247 │              137290.5 │
│ gcp        │                196 │              136000.0 │
│ mongodb    │                136 │              135750.0 │
│ snowflake  │                438 │              135500.0 │
│ github     │                127 │              135000.0 │
│ docker     │                144 │              135000.0 │
│ python     │               1133 │              135000.0 │
│ java       │                303 │              135000.0 │
│ bigquery   │                123 │              135000.0 │
│ hadoop     │                198 │              135000.0 │
│ r          │                133 │              134775.0 │
│ nosql      │                193 │              134415.0 │
│ databricks │                266 │              132750.0 │
│ mysql      │                101 │              130500.0 │
│ sql        │               1128 │              130000.0 │
│ redshift   │                274 │              130000.0 │
├────────────┴────────────────────┴───────────────────────┤
│ 25 rows                                       3 columns │

*/

/* Pero teniendo en cuenta salario anual y cantidad demandada
se puede hacer otro analisis, intentando ver las optimas skills*/

SELECT 
    sd.skills,
    COUNT(jpf.job_id) AS cant_demandada,
    ROUND(MEDIAN(jpf.salary_year_avg), 1) AS salario__mediana,
    ROUND(LN(COUNT(jpf.*)), 1) AS ln_cant_dem,
    ROUND(MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.job_id))/1000000, 3) AS optima
FROM
        job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
        ON sjd.skill_id = sd.skill_id
WHERE
        jpf.job_title_short = 'Data Engineer'
        AND jpf.job_work_from_home= True
        AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.job_id)  > 100
ORDER BY
    optima DESC, ln_cant_dem DESC
LIMIT 25;

/*

┌────────────┬────────────────┬──────────────────┬─────────────┬────────┐
│   skills   │ cant_demandada │ salario__mediana │ ln_cant_dem │ optima │
│  varchar   │     int64      │      double      │   double    │ double │
├────────────┼────────────────┼──────────────────┼─────────────┼────────┤
│ terraform  │            193 │         184000.0 │         5.3 │  0.968 │
│ python     │           1133 │         135000.0 │         7.0 │  0.949 │
│ aws        │            783 │         137320.3 │         6.7 │  0.915 │
│ sql        │           1128 │         130000.0 │         7.0 │  0.914 │
│ airflow    │            386 │         150000.0 │         6.0 │  0.893 │
│ spark      │            503 │         140000.0 │         6.2 │  0.871 │
│ snowflake  │            438 │         135500.0 │         6.1 │  0.824 │
│ kafka      │            292 │         145000.0 │         5.7 │  0.823 │
│ azure      │            475 │         128000.0 │         6.2 │  0.789 │
│ java       │            303 │         135000.0 │         5.7 │  0.771 │
│ scala      │            247 │         137290.5 │         5.5 │  0.756 │
│ kubernetes │            147 │         150500.0 │         5.0 │  0.751 │
│ git        │            208 │         140000.0 │         5.3 │  0.747 │
│ databricks │            266 │         132750.0 │         5.6 │  0.741 │
│ redshift   │            274 │         130000.0 │         5.6 │   0.73 │
│ gcp        │            196 │         136000.0 │         5.3 │  0.718 │
│ hadoop     │            198 │         135000.0 │         5.3 │  0.714 │
│ nosql      │            193 │         134415.0 │         5.3 │  0.707 │
│ pyspark    │            152 │         140000.0 │         5.0 │  0.703 │
│ docker     │            144 │         135000.0 │         5.0 │  0.671 │
│ mongodb    │            136 │         135750.0 │         4.9 │  0.667 │
│ go         │            113 │         140000.0 │         4.7 │  0.662 │
│ r          │            133 │         134775.0 │         4.9 │  0.659 │
│ github     │            127 │         135000.0 │         4.8 │  0.654 │
│ bigquery   │            123 │         135000.0 │         4.8 │   0.65 │
├────────────┴────────────────┴──────────────────┴─────────────┴────────┤
│ 25 rows                                                     5 columns │
*/