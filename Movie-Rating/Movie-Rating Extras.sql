-- Alan Sun

-- 1. Find the names of all reviewers who rated Gone with the Wind.
SELECT DISTINCT name
FROM (Reviewer JOIN Rating USING(rID)) JOIN Movie USING(mID)
WHERE title = 'Gone with the Wind';

-- 2.  For any rating where the reviewer is the same as the director of the
-- movie, return the reviewer name, movie title, and number of stars.
SELECT name, title, stars
FROM (Reviewer JOIN Rating USING(rID)) JOIN Movie USING(mID)
WHERE name = director;

-- 3.  Return all reviewer names and movie names together in a single list,
-- alphabetized. (Sorting by the first name of the reviewer and first word in
-- the title is fine; no need for special processing on last names or removing "The".)
SELECT name
FROM Reviewer
UNION
SELECT title
FROM Movie;

-- 4.  Find the titles of all movies not reviewed by Chris Jackson.
SELECT title
FROM Movie
WHERE mID NOT IN (SELECT mID FROM Rating JOIN Reviewer USING(rID) WHERE name = 'Chris Jackson');

-- 5.  For all pairs of reviewers such that both reviewers gave a rating to
-- the same movie, return the names of both reviewers. Eliminate duplicates,
-- don't pair reviewers with themselves, and include each pair only once. For
-- each pair, return the names in the pair in alphabetical order.
SELECT DISTINCT Rv1.name, Rv2.name
FROM Rating Rt1 JOIN Rating Rt2 USING(mID), Reviewer Rv1, Reviewer Rv2
WHERE Rt1.rID = Rv1.rID AND Rt2.rID = Rv2.rID AND Rv1.name < Rv2.name
ORDER BY Rv1.name;

-- 6.  For each rating that is the lowest (fewest stars) currently in the
-- database, return the reviewer name, movie title, and number of stars.
SELECT name, title, MIN(stars)
FROM (Reviewer JOIN Rating USING(rID)) JOIN Movie USING(mID)
GROUP BY title
HAVING stars = (SELECT MIN(stars) FROM Rating);

-- 7.  List movie titles and average ratings, from highest-rated to
-- lowest-rated. If two or more movies have the same average rating, list them
-- in alphabetical order.
SELECT title, AVG(stars)
FROM Movie JOIN Rating USING(mID)
GROUP BY title
ORDER BY AVG(stars) DESC, title;

-- 8.Find the names of all reviewers who have contributed three or more ratings
-- (As an extra challenge, try writing the query without HAVING or without COUNT).
SELECT name
FROM Reviewer JOIN Rating USING(rID)
GROUP BY name
HAVING COUNT(stars) >= 3;

-- Challenge version:
SELECT name
FROM (SELECT rID, SUM(1) S FROM Rating GROUP BY rID) JOIN Reviewer USING(rID)
WHERE S >= 3;
-- Note: 'SUM(1) S' adds a constant to the SELECT statement in the subquery,
-- which results in that value being repeated for every row returned, and so it
-- adds up how many times each rID appears in Rating, thus recreating the 'COUNT'
-- aggregation function.

-- 9. Some directors directed more than one movie. For all such directors,
-- return the titles of all movies directed by them, along with the director
-- name. Sort by director name, then movie title. (As an extra challenge, try
-- writing the query both with and without COUNT.)
-- (With COUNT)
SELECT title, director
FROM Movie
WHERE director IN (SELECT director FROM Movie GROUP BY director HAVING COUNT(title) > 1)
ORDER BY director, title;
-- (Without COUNT)
SELECT title, director
FROM (SELECT director, SUM(1) S FROM Movie GROUP BY director) JOIN Movie USING(director)
WHERE S > 1
ORDER BY director, title;

-- 10.  Find the movie(s) with the highest average rating. Return the movie
-- title(s) and average rating. (Hint: This query is more difficult to write in
-- SQLite than other systems; you might think of it as finding the highest average
-- rating and then choosing the movie(s) with that average rating.)
SELECT title, avg
FROM (SELECT title, AVG(stars) as avg FROM Movie JOIN Rating USING(mID) GROUP BY title)
WHERE avg IN
(SELECT MAX(avg)
FROM (SELECT title, AVG(stars) as avg FROM Movie JOIN Rating USING(mID) GROUP BY title));

-- 11.  Find the movie(s) with the lowest average rating. Return the movie title(s)
-- and average rating. (Hint: This query may be more difficult to write in SQLite than
-- other systems; you might think of it as finding the lowest average rating and then
-- choosing the movie(s) with that average rating.)
SELECT title, avg
FROM (SELECT title, AVG(stars) as avg FROM Movie JOIN Rating USING(mID) GROUP BY title)
WHERE avg IN
(SELECT MIN(avg)
FROM (SELECT title, AVG(stars) as avg FROM Movie JOIN Rating USING(mID) GROUP BY title));

-- 12.  For each director, return the director's name together with the title(s) of
-- the movie(s) they directed that received the highest rating among all of their
-- movies, and the value of that rating. Ignore movies whose director is NULL. 
SELECT director, title, MAX(stars)
FROM Movie JOIN Rating USING(mID)
WHERE director IS NOT NULL
GROUP BY director;
