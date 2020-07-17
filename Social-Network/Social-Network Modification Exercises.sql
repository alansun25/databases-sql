-- Alan Sun

-- 1. It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
DELETE FROM Highschooler
WHERE grade = 12;

-- 2. If two students A and B are friends, and A likes B but not vice-versa, remove the
-- Likes tuple.
DELETE FROM Likes
WHERE ID2 IN
(SELECT ID2 FROM Friend WHERE Likes.ID1 = ID1)
AND ID2 NOT IN (SELECT ID1 FROM Likes L2 WHERE ID2 = Likes.ID1);

-- 3. For all cases where A is friends with B, and B is friends with C, add a new friendship
-- for the pair A and C. Do not add duplicate friendships, friendships that already exist, or
-- friendships with oneself.
INSERT INTO Friend
SELECT DISTINCT A.ID1, C.ID2
FROM Friend A, Friend C
WHERE A.ID2 = C.ID1 AND A.ID1 <> C.ID2 AND C.ID2 NOT IN
(SELECT B.ID2
 FROM Friend B
 WHERE B.ID1 = A.ID1);
