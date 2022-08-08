TRUNCATE TABLE processed_data.deaths;
INSERT INTO processed_data.deaths

-- CREATE TABLE processed_data.deaths AS

WITH deaths_data AS (
	
	SELECT
	"state" AS state_abbreviation
	, submission_date AS result_date
	, new_death AS deaths
	, sum(new_death) OVER (PARTITION BY "state" ORDER BY submission_date ROWS 6 PRECEDING) AS trailing7_deaths
	
	FROM raw_data.cases_deaths
	)
	
SELECT
deaths.*
, round((deaths.trailing7_deaths / pop.population * 100000), 2) AS trailing7_deaths_per100k
, DENSE_RANK() OVER (PARTITION BY state_abbreviation ORDER BY result_date DESC) AS recency_rank

FROM deaths_data deaths
JOIN public.state_abbreviations_populations pop
USING (state_abbreviation)

ORDER BY 1, 2
;
