--Given a friendship table, find for each user his friends with whom they have at least 3 friends in common. 
--Rank friends by the number of common friend. The table record one-way relationship: sender of friend request and recipient of friend request.


INSERT INTO `Friendship` (`id`, `user_id`, `friend_id`) VALUES
(1, 'alice', 'bob'),
(2, 'alice', 'charles'),
(3, 'alice', 'david'),
(4, 'alice', 'mary'),
(5, 'bob', 'david'),
(6, 'bob', 'charles'),
(7, 'bob', 'mary'),
(8, 'david', 'sonny'),
(9, 'charles', 'sonny'),
(10, 'bob', 'sonny');

select * from friendship limit 5;
+----+---------+-----------+
| id | user_id | friend_id |
+----+---------+-----------+
|  1 | alice   | bob       |
|  2 | alice   | charles   |
|  3 | alice   | david     |
|  4 | alice   | mary      |
|  5 | bob     | david     |
+----+---------+-----------+
5 rows in set (0.00 sec)

WITH all_friends AS (
    SELECT user_id, friend_id
    FROM friendship
    UNION ALL
    SELECT friend_id, user_id
    FROM friendship
),
-- Join the union result twice, to find friends for each user_id. Filter the results to include common friend only. 
--Note that it is impossible to list one of the user himself as the common friend, because the bf.friend_id = af.friend_id will not be satisfied.
expand_friends AS (
    SELECT 
        all_friends_1.user_id AS a
        ,all_friends_1.friend_id AS b
        ,all_friends_2.friend_id AS a_friend
        ,all_friends_3.friend_id AS b_friend

    FROM all_friends AS all_friends_1
    JOIN all_friends AS all_friends_2
        ON all_friends_1.user_id = all_friends_2.user_id
    JOIN all_friends AS all_friends_3
        ON all_friends_1.friend_id = all_friends_3.user_id
        AND all_friends_3.friend_id = all_friends_2.friend_id
)
--Group by the user_id pair and count the number of common friends. Because we've counted both way, each eligible pair will have a counterpart with the opposite direction.

SELECT a, b, COUNT(*)
FROM expand_friends
GROUP BY 1,2
HAVING common_friend >= 3



