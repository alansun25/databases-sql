-- Alan Sun

-- 1. For every situation where student A likes student B, but student B likes a different
-- student C, return the names and grades of A, B, and C.

SELECT A.name, A.grade, B.name, B.grade, C.name, C.grade
FROM Likes, Highschooler A, Highschooler B, Highschooler C
WHERE A.ID = ID1 AND B.ID = ID2 AND B.ID NOT IN (SELECT ID1 FROM Likes WHERE ID2 = A.ID)
	AND C.ID IN (SELECT ID2 FROM Likes WHERE ID1 = B.ID);

-- 2. Find those students for whom all of their friends are in different grades from themselves.
-- Return the students' names and grades.

SELECT name, grade
FROM Highschooler A
WHERE ID NOT IN (SELECT ID1 FROM Friend, Highschooler B WHERE A.ID = ID1 AND B.ID = ID2 AND A.grade = B.grade)

-- 3. What is the average number of friends per student? (Your result should be just one number.)

SELECT AVG(numFriends)
FROM
(SELECT COUNT(ID2) as numFriends FROM Friend GROUP BY ID1);

-- 4. Find the number of students who are either friends with Cassandra or are friends of friends
-- of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend.

SELECT COUNT(*)
FROM Friend
WHERE ID2 IN (SELECT ID1 FROM Friend WHERE ID2 IN (SELECT ID FROM Highschooler WHERE name = "Cassandra"));

-- 5. Find the name and grade of the student(s) with the greatest number of friends.

SELECT name, grade
FROM (SELECT name, grade, COUNT(ID2) as numFriends FROM Highschooler, Friend WHERE ID = ID1 GROUP BY ID1)
WHERE numFriends IN
(SELECT MAX(numFriends)
FROM (SELECT name, grade, COUNT(ID2) as numFriends FROM Highschooler, Friend WHERE ID = ID1 GROUP BY ID1));
