TRUNCATE TABLE processed_data.cases;
INSERT INTO processed_data.cases

-- CREATE TABLE processed_data.cases AS

WITH cases_data AS (
	
	SELECT
	"state" AS state_abbreviation
	, submission_date AS result_date
	, new_case AS cases
	, sum(new_case) OVER (PARTITION BY "state" ORDER BY submission_date ROWS 6 PRECEDING) AS trailing7_cases
	
	FROM raw_data.cases_deaths
	)
	
SELECT
cases.*
, round((cases.trailing7_cases / pop.population * 100000), 2) AS trailing7_cases_per100k
, DENSE_RANK() OVER (PARTITION BY state_abbreviation ORDER BY result_date DESC) AS recency_rank

FROM cases_data cases
JOIN public.state_abbreviations_populations pop
USING (state_abbreviation)

ORDER BY 1, 2
;
