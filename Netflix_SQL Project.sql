-- NETFLIX PROJECT 
-- DATABASE CREATE 
CREATE DATABASE netflix_db;
USE netflix_db;

-- TABLE CREATE

CREATE TABLE netflix ( 
show_id VARCHAR (10),
type VARCHAR (20),
title VARCHAR (255),
director TEXT,
casts TEXT,
country VARCHAR (255),
date_added VARCHAR (50),
release_year INT,
rating  VARCHAR (20),
duration VARCHAR(50),
listed_in TEXT,
description TEXT
);

-- DATABASE CLEANING QUERIES ( CHECK NULL VALUES)

SELECT
SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) AS missing_director,
SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS missing_country,
SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS missing_rating
FROM netflix;


--  REMOVE DUPLICATE RECORD

SELECT title, COUNT(*)
FROM netflix
GROUP BY title
HAVING COUNT(*)>1;

-- MISSING COUNTRY RECORDS

SELECT *
FROM netflix
WHERE country IS NULL;

-- MISSING DIRECTOR RECORDS

SELECT *
FROM netflix
WHERE director IS NULL;


-- Exploratory Data Analysis (EDA)

-- 1. Total Movies vs TV Shows

SELECT type, COUNT(*) AS total
FROM netflix
GROUP BY type;

-- 2. Content by Rating

SELECT rating,
COUNT(*) AS total_content
FROM netflix
GROUP BY rating
ORDER BY total_content DESC;


-- 3. Top 10 Countries

SELECT country,
COUNT(*) AS total
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total DESC
LIMIT 10;


-- 4. Content Released Per Year

SELECT release_year,
COUNT(*) AS total_content
FROM netflix
GROUP BY release_year
ORDER BY release_year;


-- 5. Top 10 Directors

SELECT director,
COUNT(*) AS total_shows
FROM netflix
WHERE director IS NOT NULL
GROUP BY director
ORDER BY total_shows DESC
LIMIT 10;


-- 6. Movies Added Every Year

SELECT YEAR(STR_TO_DATE(date_added,'%M %d, %Y')) AS year_added,
COUNT(*) AS total
FROM netflix
WHERE date_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added;


-- 7. Latest Content

SELECT title, release_year
FROM netflix
ORDER BY release_year DESC;


-- 8. Movies Longer Than 120 Minutes

SELECT title, duration
FROM netflix
WHERE type='Movie'
AND CAST(REPLACE(duration,' min','') AS UNSIGNED) > 120;


-- 9. TV Shows With More Than 3 Seasons

SELECT title, duration
FROM netflix
WHERE type='TV Show'
AND CAST(REPLACE(REPLACE(duration,' Seasons',''),' Season','') AS UNSIGNED) > 3;


-- 10. India Content Analysis

SELECT type,
COUNT(*) AS total
FROM netflix
WHERE country LIKE '%India%'
GROUP BY type;


-- 11. Most Popular Genres

SELECT listed_in,
COUNT(*) AS total
FROM netflix
GROUP BY listed_in
ORDER BY total DESC
LIMIT 10;


-- 12. TV Shows vs Movies Percentage

SELECT
type,
ROUND(COUNT(*)*100.0/
(SELECT COUNT(*) FROM netflix),2) AS percentage
FROM netflix
GROUP BY type;


-- 13. Content Added by Month

SELECT MONTHNAME(
STR_TO_DATE(date_added,'%M %d, %Y')
) AS month_name,
COUNT(*) AS total
FROM netflix
GROUP BY month_name
ORDER BY total DESC;


-- 14. Running Total of Releases

SELECT release_year,
COUNT(*) AS yearly_content,
SUM(COUNT(*)) OVER(
ORDER BY release_year
) AS running_total
FROM netflix
GROUP BY release_year;


-- 15. Rank Top Countries

SELECT country,
COUNT(*) AS total_content,
RANK() OVER(
ORDER BY COUNT(*) DESC
) AS ranking
FROM netflix
GROUP BY country;


-- 16. Top 5 Years With Highest Releases

SELECT release_year,
COUNT(*) AS total
FROM netflix
GROUP BY release_year
ORDER BY total DESC
LIMIT 5;