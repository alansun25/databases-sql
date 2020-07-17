-- Alan Sun

-- 1. Find the names of all students who are friends with someone named Gabriel.

SELECT name
FROM Friend, Highschooler
WHERE ID = ID1 AND ID2 IN (SELECT ID FROM Highschooler WHERE name = "Gabriel");

-- 2. For every student who likes someone 2 or more grades younger than themselves,
-- return that student's name and grade, and the name and grade of the student they like.

SELECT Old.name, Old.grade, Young.name, Young.grade
FROM Highschooler Old, Highschooler Young, Likes
WHERE Old.ID = ID1 AND Young.ID = ID2 AND Old.grade - Young.grade > 1;

-- 3. For every pair of students who both like each other, return the name and grade of
-- both students. Include each pair only once, with the two names in alphabetical order.

SELECT DISTINCT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1, Highschooler H2, Likes
WHERE ((H1.ID = ID1 AND H2.ID = ID2) OR (H1.ID = ID2 AND H2.ID = ID1))
	AND ID2 IN (SELECT ID1 FROM Likes) AND ID1 IN (SELECT ID2 FROM Likes)
	AND H1.name < H2.name;

-- 4. Find all students who do not appear in the Likes table (as a student who likes or is
-- liked) and return their names and grades. Sort by grade, then by name within each grade.

SELECT DISTINCT name, grade
FROM Highschooler
WHERE ID NOT IN (SELECT ID1 FROM Likes) AND ID NOT IN (SELECT ID2 FROM Likes);

-- 5. For every situation where student A likes student B, but we have no information about
-- whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's
-- names and grades.

SELECT A.name, A.grade, B.name, B.grade
FROM Highschooler A, Highschooler B, Likes
WHERE A.ID = ID1 AND B.ID = ID2 AND B.ID NOT IN (SELECT ID1 FROM Likes);

-- 6. Find names and grades of students who only have friends in the same grade. Return the
-- result sorted by grade, then by name within each grade.

SELECT name, grade
FROM Highschooler A
WHERE ID NOT IN
(SELECT ID1 FROM Friend, Highschooler B WHERE A.ID = ID1 AND B.ID = ID2 AND A.grade <> B.grade)
ORDER BY grade, name;

-- 7. For each student A who likes a student B where the two are not friends, find if they
-- have a friend C in common (who can introduce them!). For all such trios, return the name
-- and grade of A, B, and C.

SELECT DISTINCT A.name, A.grade, B.name, B.grade, C.name, C.grade
FROM Likes, Friend, Highschooler A, Highschooler B, Highschooler C
WHERE Likes.ID1 = A.ID AND Likes.ID2 = B.ID AND B.ID NOT IN (SELECT ID2 FROM Friend WHERE ID1 = A.ID)
	AND C.ID IN (SELECT ID1 FROM Friend WHERE ID2 = A.ID)
	AND C.ID IN (SELECT ID1 FROM Friend WHERE ID2 = B.ID);

-- 8. Find the difference between the number of students in the school and the number of different
-- first names.

SELECT
(SELECT COUNT(ID) FROM Highschooler) - (SELECT COUNT(name) FROM (SELECT DISTINCT name FROM Highschooler));

-- 9. Find the name and grade of all students who are liked by more than one other student.

SELECT name, grade
FROM Highschooler, Likes
WHERE ID = ID2
GROUP BY ID2
HAVING COUNT(ID1) > 1;
