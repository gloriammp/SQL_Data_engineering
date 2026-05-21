# Primer proyecto
## Análisis exploratorio con SQL realizado en el publicaciones de búsquedas laborales. 

Este proyecto está hecho en base al tutorial de Luke Barouse [***SQL for Data Engineering*** *Full course for begginers*](https://www.youtube.com/watch?v=UjhFbq4uU2Y&t=18658s).

El mismo comprende el proceso entre la configuración de VisualCode y MotherDuck para trabajar de manera local y los siguientes pasos para poder trabajar con datos con SQL (la herramienta utilizada fue Duckdb) .



<figure>
  <img src="https://github.com/lukebarousse/SQL_Data_Engineering_Course/raw/main/Resources/images/1_1_Project1_EDA.png">
  <figcaption>Imagen extraida del repositorio de L. Barousse</figcaption>
</figure>


En en primer proyecto se realizaron tres análisis  en un *data warehouse* hecho con el esquema de estrella. La estructura del mismo es:


![Fuente: Luke Barousse](https://github.com/lukebarousse/SQL_Data_Engineering_Course/raw/main/Resources/images/1_2_Data_Warehouse.png)

Las consultas realizadas fueron las siguientes:


- Encontrar cuales son las habilidades mas demandadas para trabajar de manera remota en la Argentina como ingeniero de datos. [Código utilizado](../1_EDA/01_Habilidades_mas_demandadas.sql)
- Cuales son las habilidades mejor pagas. [Código utilizado](../1_EDA/02_Habilidades_mejor_pagas.sql)
- Cuales son los skills óptimos basándose en un criterio armado combinando cantidad demandada y mediana salarial.[Código utilizado](../1_EDA/03_Skills_optimos.sql)


