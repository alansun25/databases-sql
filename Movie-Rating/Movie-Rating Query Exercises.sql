-- Alan Sun

-- 1. Find the titles of all movies directed by Steven Spielberg.

SELECT title
FROM Movie
WHERE director = 'Steven Spielberg';

-- 2. Find all years that have a movie that received a rating of 4 or 5, and sort
-- them in increasing order.

SELECT DISTINCT year
FROM Movie JOIN Rating using(mID)
WHERE stars > 3
ORDER BY year;

-- 3. Find the titles of all movies that have no ratings.

SELECT title
FROM Movie
WHERE mID NOT IN (SELECT mID FROM Rating);

-- 4. Some reviewers didn't provide a date with their rating. Find the names of
-- all reviewers who have ratings with a NULL value for the date.

SELECT name
FROM Reviewer
WHERE rID IN (SELECT rID FROM Rating WHERE ratingDate IS NULL);

-- 5. Write a query to return the ratings data in a more readable format: reviewer
-- name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer
-- name, then by movie title, and lastly by number of stars.

SELECT name, title, stars, ratingDate
FROM (Movie JOIN Rating USING(mID)) JOIN Reviewer USING(rID)
ORDER BY name, title, stars;

-- 6. For all cases where the same reviewer rated the same movie twice and gave
-- it a higher rating the second time, return the reviewer's name and the title of the movie.

SELECT name, title
FROM (Movie JOIN Rating R1 using(mID)) JOIN Reviewer using(rID)
GROUP BY name
HAVING COUNT(stars) = 2 AND (SELECT stars FROM Rating R2) < R1.stars
                        AND (SELECT ratingDate FROM Rating R2) < R1.ratingDate;

-- 7. For each movie that has at least one rating, find the highest number of
-- stars that movie received. Return the movie title and number of stars. Sort by movie title.

SELECT title, MAX(stars)
FROM Movie JOIN Rating using(mID)
GROUP BY title;

-- 8.  For each movie, return the title and the 'rating spread', that is, the
-- difference between highest and lowest ratings given to that movie. Sort by rating
-- spread from highest to lowest, then by movie title.

SELECT DISTINCT title, (MAX(stars) - MIN(STARS)) as ratingSpread
FROM Movie JOIN Rating using(mID)
GROUP BY title
ORDER BY ratingSpread DESC, title;

-- 9. Find the difference between the average rating of movies released before 1980
-- and the average rating of movies released after 1980. (Make sure to calculate the average
-- rating for each movie, then the average of those averages for movies before 1980 and
-- movies after. Don't just calculate the overall average rating before and after 1980.)

SELECT avg(before1980) - avg(after1980)
FROM
(SELECT avg(stars) as before1980
 FROM Movie JOIN Rating USING(mID)
 WHERE year < 1980
 GROUP BY title),
(SELECT avg(stars) as after1980
 FROM Movie JOIN Rating USING(mID)
 WHERE year > 1980
 GROUP BY title);
