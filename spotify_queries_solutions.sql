DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify(
	                 Artist VARCHAR(255),
					 Track VARCHAR(255),	
					 Album VARCHAR(255),
					 Album_type VARCHAR(50),	
					 Danceability FLOAT,	
					 Energy FLOAT,	
					 Loudness FLOAT,	
					 Speechiness FLOAT,	
					 Acousticness FLOAT,	
					 Instrumentalness FLOAT,	
					 Liveness FLOAT,	
					 Valence FLOAT,	
					 Tempo FLOAT,	
					 Duration_min FLOAT,	
					 Title VARCHAR(255),	
					 Channel VARCHAR(255),	
					 Views FLOAT,	
					 Likes BIGINT,	
					 Comments BIGINT,	
					 Licensed BOOLEAN,	
					 official_video BOOLEAN,	
					 Stream BIGINT,	
					 EnergyLiveness FLOAT,
					 most_playedon VARCHAR(50)
	)

SELECT * FROM spotify;	

SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT MAX(duration_min) FROM spotify;


SELECT * FROM spotify
WHERE duration_min = 0

DELETE FROM spotify
WHERE duration_min = 0


SELECT DISTINCT channel FROM spotify;

SELECT DISTINCT most_playedon FROM spotify;

--  -----------------------------
--  Data Analysis -Easy Category
--  -----------------------------

-- Q 1. Retrieve the names of all tracks that have more than 1 billion streams.
 
SELECT 
      *
FROM spotify
WHERE stream > 1000000000;

-- Q 2. List all albums along with their respective artists

SELECT 
      DISTINCT album,
	  artist
FROM spotify


-- Q 3. Get the total number of comments for tracks where licensed = True

SELECT 
	  SUM(comments) AS total_comments
FROM spotify
WHERE licensed = 'true'


-- Q 4. Find all tracks that belong to the album type single.

SELECT 
      *
FROM spotify
WHERE album_type = 'single'


-- Q 5. Count the total number of tracks by each artist.

SELECT 
      artist,
	  COUNT(track) AS total_no_songs
FROM spotify
GROUP BY 1
ORDER BY 2 


--  -----------------------------
--  Data Analysis - Medium level
--  -----------------------------

-- Q 6. Calculate the average danceability of tracks in each album.

SELECT 
      album,
	  AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY 1
ORDER BY 2 DESC


-- Q 7. Find the top 5 tracks with the highest energy values.

SELECT 
      track,
	  MAX(energy)
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


-- Q 8. List all tracks along with their views and likes where official_video = TRUE.

SELECT 
      track,
	  SUM(views) AS total_views,
	  SUM(likes) AS total_likes
FROM spotify
WHERE official_video = 'true'
GROUP BY 1
ORDER BY 2 DESC


-- Q 9. For each album, calculate the total views of all associated tracks.
   
SELECT 
      track,
	  album,
	  SUM(views) AS total_views
FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC


-- Q 10. Retrive the track names that have been streamed on spotify more than youtube.

SELECT * FROM
			(SELECT 
			      track,
				  COALESCE(SUM(CASE WHEN most_playedon = 'Youtube' THEN stream END),0) AS streamed_on_youtube,
				  COALESCE(SUM(CASE WHEN most_playedon = 'Spotify' THEN stream END),0) AS streamed_on_spotify
			FROM spotify
			GROUP BY 1
			) AS t1
WHERE 
    streamed_on_spotify > streamed_on_youtube
    AND
	streamed_on_youtube <> 0;

--  -----------------------------
--  Data Analysis - Advance level
--  -----------------------------

-- Q 11. Find the top 3 most-viewed tracks for each artist using window functions.

WITH ranking_artist
AS
(SELECT 
      artist,
	  track,
	  SUM(views) as total_view,
	  DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC
)
SELECT * FROM ranking_artist
WHERE 
     rank <= 3


-- 	Q 12. Write a query to find tracks where the liveness score is above the average

SELECT 
      track,
	  artist,
	  liveness
FROM spotify
WHERE liveness > (
                  SELECT 
				        AVG(liveness)
				  FROM spotify		
                 )

-- 	Q 13. Use a WITH clause to calculate the diffrence between
--        the highest and lowest energy values for tracks in each album
WITH cte
AS
(
SELECT 
      album,
	  MAX(energy) as highestenergy,
	  MIN(energy) as lowest_energy
FROM spotify
GROUP BY 1
)
SELECT 
      album,
	  highestenergy - lowest_energy AS energy_diff
FROM cte
ORDER BY 2 DESC





























































