--Get to know Warby Parker
--Figure out what columns contain in each table
select * 
from purchase 
limit 2;

select * 
from quiz 
limit 2;

select * 
from home_try_on 
limit 2;

select * 
from survey 
limit 2;


--Quiz Funnel
--1. What columns does the survey table have?
select * 
from survey 
limit 10;

-- 2. What is the number of responses for each question?
SELECT question, COUNT(DISTINCT user_id) AS 'responses'
FROM survey
GROUP BY 1
ORDER BY 2 DESC;

--Home Try-On Funnel
--4. 
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;


--5. Create a new table
SELECT DISTINCT quiz.user_id,
   home.user_id IS NOT NULL AS 'is_home_try_on',
   home.number_of_pairs,
   purchase.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'quiz'
LEFT JOIN home_try_on 'home'
  ON home.user_id = quiz.user_id
LEFT JOIN purchase 'purchase'
  ON purchase.user_id = quiz.user_id
LIMIT 10;


--6. Conversion
WITH funnels AS (
SELECT 
   DISTINCT quiz.user_id,
   home.user_id IS NOT NULL AS 'is_home_try_on',
   home.number_of_pairs,
   purchase.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'quiz'
LEFT JOIN home_try_on 'home'
  ON home.user_id = quiz.user_id
LEFT JOIN purchase 'purchase'
  ON purchase.user_id = quiz.user_id) 
SELECT COUNT(*) as 'num_quiz', 
	SUM(is_home_try_on) as 'sum_home_try_on', 
  SUM(is_purchase) as 'sum_is_purchase', 
  1.0 * SUM(is_home_try_on) / COUNT(user_id) as 'quiz_home_conversion', 
  1.0 * SUM(is_purchase) / SUM(is_home_try_on) as 'home_purchase_conversion' 
FROM funnels ;

--6. Home Try On 3 vs. 5 pairs
WITH funnels AS (
SELECT 
   DISTINCT quiz.user_id,
   home.user_id IS NOT NULL AS 'is_home_try_on',
   home.number_of_pairs,
   purchase.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'quiz'
LEFT JOIN home_try_on 'home'
  ON home.user_id = quiz.user_id
LEFT JOIN purchase 'purchase'
  ON purchase.user_id = quiz.user_id)
  SELECT 
  		number_of_pairs,
  		COUNT (*) as 'num_quiz',
			SUM (is_home_try_on) as 'num_try_on',
 			SUM (is_purchase) as 'num_purchase'
 FROM funnels
 GROUP BY number_of_pairs;
 
--6. Most common results of the style quiz
SELECT style,
COUNT(DISTINCT user_id) as 'num_respond' 
FROM quiz
GROUP BY style
ORDER BY num_respond DESC;

--6. Most common type of purchase
SELECT shape,
COUNT(DISTINCT user_id) as 'num_respond'
FROM quiz
GROUP BY shape
ORDER BY num_respond DESC;