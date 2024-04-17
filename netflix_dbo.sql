--Get the count of records

SELECT COUNT(*) FROM netflix;

--Sample records

SELECT TOP 1000 * FROM dbo.netflix;


---------------------------------------------------------Data Expolration-------------------------------------------------------------- 


--Number of titles released each year:

SELECT release_year, title_type, COUNT(*) AS num_titles
FROM netflix
GROUP BY release_year, title_type
ORDER BY release_year, title_type;


-- Number of Movie and Show titls released each year:

SELECT release_year,
       SUM(CASE WHEN title_type = 'MOVIE' THEN 1 ELSE 0 END) AS num_movies,
       SUM(CASE WHEN title_type = 'SHOW' THEN 1 ELSE 0 END) AS num_tv_shows
FROM Netflix
GROUP BY release_year
ORDER BY release_year;


-- Average IMDB score per year:

SELECT release_year, AVG(imdb_score) AS avg_imdb_score
FROM netflix
GROUP BY release_year
ORDER BY release_year;


-- Average Movie and TV Show IMdB score by year:

SELECT release_year,
       AVG(CASE WHEN title_type = 'MOVIE' THEN imdb_score ELSE NULL END) AS avg_movie_score,
       AVG(CASE WHEN title_type = 'SHOW' THEN imdb_score ELSE NULL END) AS avg_tv_show_score
FROM Netflix
GROUP BY release_year
ORDER BY release_year;


-----------------------------------------------------Content Analysis------------------------------------------------------------- 


--Total Number of titles by Age Certification:

SELECT age_certification, COUNT(*) AS num_titles
FROM Netflix
GROUP BY age_certification;


-- Number of Movies and Show Titles by Age Certification:

SELECT age_certification,
       SUM(CASE WHEN title_type = 'MOVIE' THEN 1 ELSE 0 END) AS num_movies,
       SUM(CASE WHEN title_type = 'SHOW' THEN 1 ELSE 0 END) AS num_tv_shows
FROM Netflix
GROUP BY age_certification;


-- Average IMDb score of total number of Movies and TV Show:

SELECT title_type, AVG(imdb_score) AS avg_imdb_score
FROM Netflix
GROUP BY title_type;


-- Average IMDb score of Movie and TV Shows by year:

SELECT 
    release_year,
    AVG(CASE WHEN title_type = 'Movie' THEN imdb_score ELSE NULL END) AS avg_movie_score,
    AVG(CASE WHEN title_type = 'TV Show' THEN imdb_score ELSE NULL END) AS avg_tv_show_score
FROM 
    Netflix
GROUP BY 
    release_year;



----------------------------------------------------------Viewer Engagement--------------------------------------------------------------


--Average IMDb score and IMDb votes:

SELECT ROUND(AVG(imdb_score), 1) AS avg_imdb_score,
       ROUND(AVG(imdb_votes), 1) AS avg_imdb_votes
FROM Netflix;


--Average IMDb score and IMDb votes by year"

SELECT 
    release_year,
    ROUND(AVG(imdb_score), 1) AS avg_imdb_score,
    ROUND(AVG(imdb_votes), 1) AS avg_imdb_votes
FROM 
    Netflix
GROUP BY 
    release_year
ORDER BY 
    release_year;


-- Top 20 Movies as per IMDb score by year

WITH RankedMovies AS (
    SELECT
        Id,
        title,
        release_year,
        imdb_score,
        ROW_NUMBER() OVER (ORDER BY imdb_score DESC) AS RowNum
    FROM
        Netflix
    WHERE
        title_type = 'Movie'
)


-- Moies sorted by runtime with most number of IMDb votes:
SELECT
    Id,
    title,
    release_year,
    imdb_score
FROM
    RankedMovies
WHERE
    RowNum <= 20
ORDER BY
    imdb_score DESC;


-- Top rated shows with number of votes:

SELECT TOP 20
    Id,
    title,
    release_year,
    imdb_score,
    imdb_votes
FROM
    Netflix
WHERE
    title_type = 'Show'
ORDER BY
    imdb_votes DESC;


-- Top 20 Shows as per IMDb score by year

WITH RankedMovies AS (
    SELECT
        Id,
        title,
        release_year,
        imdb_score,
        ROW_NUMBER() OVER (ORDER BY imdb_score DESC) AS RowNum
    FROM
        Netflix
    WHERE
        title_type = 'Show'
)
SELECT
    Id,
    title,
    release_year,
    imdb_score
FROM
    RankedMovies
WHERE
    RowNum <= 20
ORDER BY
    imdb_score DESC;


--Movies sorted by runtime with the most votes:

SELECT
    Id,
    title,
    runtime,
    imdb_votes
FROM
    Netflix
WHERE
    title_type = 'Movie'
ORDER BY
    imdb_votes DESC,
    runtime DESC;


--Correlation between IMDb score and IMDb votes:

SELECT 
    (COUNT(*) * SUM(CAST(imdb_score AS decimal(18, 6)) * CAST(imdb_votes AS decimal(18, 6))) - 
     SUM(CAST(imdb_score AS decimal(18, 6))) * SUM(CAST(imdb_votes AS decimal(18, 6)))) / 
    (SQRT((COUNT(*) * SUM(CAST(imdb_score AS decimal(18, 6)) * CAST(imdb_score AS decimal(18, 6))) - 
           POWER(SUM(CAST(imdb_score AS decimal(18, 6))), 2)) * 
          (COUNT(*) * SUM(CAST(imdb_votes AS decimal(18, 6)) * CAST(imdb_votes AS decimal(18, 6))) - 
           POWER(SUM(CAST(imdb_votes AS decimal(18, 6))), 2)))) AS correlation
FROM 
    Netflix;



----------------------------------------------------Demographic Analysis----------------------------------------------------------------

--Average IMDb score by age certification:

SELECT age_certification, AVG(imdb_score) AS avg_imdb_score
FROM Netflix
GROUP BY age_certification;


--Average IMDb votes by age certification:

SELECT 
    age_certification, 
    AVG(imdb_votes) AS avg_imdb_votes
FROM 
    Netflix
GROUP BY 
    age_certification
ORDER BY 
    AVG(imdb_votes) DESC;


--Distribution of titles by content type and age certification:

SELECT title_type, age_certification, COUNT(*) AS num_titles
FROM Netflix
GROUP BY title_type, age_certification
ORDER BY num_titles DESC;



















