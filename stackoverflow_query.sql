-- Stack Overflow 2023 answer-acceptance data extraction
-- Run on the public Stack Exchange Data Explorer:
--   https://data.stackexchange.com/stackoverflow
--
-- For each user active on Stack Overflow during 2023, this query returns:
--   N1 = number of answers posted in first half of 2023 (Jan-Jun)
--   Y1 = number of those answers accepted by the question-asker
--   N2 = number of answers posted in second half of 2023 (Jul-Dec)
--   Y2 = number of those answers accepted by the question-asker
--
-- Self-accepted answers (where the answerer is the same as the question-asker)
-- are excluded.

WITH answers_2023 AS (
  SELECT
    a.OwnerUserId       AS user_id,
    a.Id                AS answer_id,
    a.CreationDate      AS posted_at,
    q.AcceptedAnswerId  AS accepted_id,
    q.OwnerUserId       AS asker_id,
    CASE WHEN MONTH(a.CreationDate) <= 6 THEN 1 ELSE 2 END AS half
  FROM Posts a
  INNER JOIN Posts q
    ON q.Id = a.ParentId
  WHERE a.PostTypeId = 2                         -- answers only
    AND YEAR(a.CreationDate) = 2023
    AND a.OwnerUserId IS NOT NULL
    AND q.OwnerUserId IS NOT NULL
    AND a.OwnerUserId <> q.OwnerUserId           -- exclude self-accepted
),
aggregated AS (
  SELECT
    user_id,
    SUM(CASE WHEN half = 1 THEN 1 ELSE 0 END) AS N1,
    SUM(CASE WHEN half = 1 AND answer_id = accepted_id THEN 1 ELSE 0 END) AS Y1,
    SUM(CASE WHEN half = 2 THEN 1 ELSE 0 END) AS N2,
    SUM(CASE WHEN half = 2 AND answer_id = accepted_id THEN 1 ELSE 0 END) AS Y2
  FROM answers_2023
  GROUP BY user_id
)
SELECT
  user_id, Y1, N1, Y2, N2
FROM aggregated
WHERE N1 >= 11 AND N2 >= 11                     -- both-halves cutoff
ORDER BY user_id;
