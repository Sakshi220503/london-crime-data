-- ============================================================
-- London Crime Analysis (April 2023 – March 2026) — SQL Queries
-- These run inside 03_insights.ipynb via SQLite
-- Table name: crime
-- ============================================================


-- ------------------------------------------------------------
-- Q1. Total crime incidents per year
-- ------------------------------------------------------------
SELECT year,
       COUNT(*) AS total_incidents
FROM crime
GROUP BY year
ORDER BY year;


-- ------------------------------------------------------------
-- Q2. Top 10 boroughs by crime volume (2025)
-- ------------------------------------------------------------
SELECT borough,
       COUNT(*) AS incidents_2025
FROM crime
WHERE year = 2025
GROUP BY borough
ORDER BY incidents_2025 DESC
LIMIT 10;


-- ------------------------------------------------------------
-- Q3. Year-over-year % change per borough (2023 → 2025)
-- ------------------------------------------------------------
WITH yr AS (
    SELECT borough, year, COUNT(*) AS cnt
    FROM crime
    GROUP BY borough, year
)
SELECT
    a.borough,
    a.cnt  AS crimes_2023,
    b.cnt  AS crimes_2025,
    ROUND((CAST(b.cnt AS FLOAT) - a.cnt) / a.cnt * 100, 1) AS change_pct
FROM yr a
JOIN yr b ON a.borough = b.borough
         AND a.year = 2023
         AND b.year = 2025
ORDER BY change_pct DESC;


-- ------------------------------------------------------------
-- Q4. Most common crime type per borough (window function)
-- ------------------------------------------------------------
WITH ranked AS (
    SELECT borough,
           crime_type,
           COUNT(*) AS cnt,
           RANK() OVER (PARTITION BY borough ORDER BY COUNT(*) DESC) AS rnk
    FROM crime
    GROUP BY borough, crime_type
)
SELECT borough, crime_type, cnt AS total_incidents
FROM ranked
WHERE rnk = 1
ORDER BY cnt DESC;


-- ------------------------------------------------------------
-- Q5. Seasonal pattern — incidents by month
-- ------------------------------------------------------------
SELECT month_name,
       month_num,
       COUNT(*) AS total_incidents
FROM crime
GROUP BY month_name, month_num
ORDER BY month_num;


-- ------------------------------------------------------------
-- Q6. Summer comparison across years (Jun–Sep)
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN year = 2023 AND month_num BETWEEN 6 AND 9 THEN 'Summer 2023'
        WHEN year = 2024 AND month_num BETWEEN 6 AND 9 THEN 'Summer 2024'
        WHEN year = 2025 AND month_num BETWEEN 6 AND 9 THEN 'Summer 2025'
    END AS period,
    COUNT(*) AS incidents
FROM crime
WHERE (year = 2023 AND month_num BETWEEN 6 AND 9)
   OR (year = 2024 AND month_num BETWEEN 6 AND 9)
   OR (year = 2025 AND month_num BETWEEN 6 AND 9)
GROUP BY period
ORDER BY incidents;


-- ------------------------------------------------------------
-- Q7. Boroughs where crime FELL (2023 → 2025)
-- ------------------------------------------------------------
WITH yr AS (
    SELECT borough, year, COUNT(*) AS cnt
    FROM crime
    GROUP BY borough, year
)
SELECT
    a.borough,
    a.cnt  AS crimes_2023,
    b.cnt  AS crimes_2025,
    ROUND((CAST(b.cnt AS FLOAT) - a.cnt) / a.cnt * 100, 1) AS change_pct
FROM yr a
JOIN yr b ON a.borough = b.borough
         AND a.year = 2023
         AND b.year = 2025
WHERE change_pct < 0
ORDER BY change_pct ASC;


-- ------------------------------------------------------------
-- Q8. Anti-social behaviour as % of all crime per year
-- ------------------------------------------------------------
SELECT year,
       SUM(CASE WHEN crime_type = 'Anti-Social Behaviour' THEN 1 ELSE 0 END) AS asb_incidents,
       COUNT(*) AS total_incidents,
       ROUND(
           SUM(CASE WHEN crime_type = 'Anti-Social Behaviour' THEN 1 ELSE 0 END) * 100.0
           / COUNT(*), 1
       ) AS asb_pct
FROM crime
GROUP BY year
ORDER BY year;


-- ------------------------------------------------------------
-- Q9. Outcome rates — how many crimes get resolved?
-- ------------------------------------------------------------
SELECT last_outcome_category,
       COUNT(*) AS incidents,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_total
FROM crime
WHERE last_outcome_category IS NOT NULL
GROUP BY last_outcome_category
ORDER BY incidents DESC
LIMIT 10;


-- ------------------------------------------------------------
-- Q10. Crime concentration: top 3 boroughs account for what %?
-- ------------------------------------------------------------
WITH totals AS (
    SELECT COUNT(*) AS grand_total FROM crime
),
by_borough AS (
    SELECT borough, COUNT(*) AS cnt
    FROM crime
    GROUP BY borough
    ORDER BY cnt DESC
    LIMIT 3
)
SELECT
    b.borough,
    b.cnt,
    ROUND(b.cnt * 100.0 / t.grand_total, 1) AS pct_of_london_total
FROM by_borough b, totals t;