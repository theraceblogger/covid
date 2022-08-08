TRUNCATE TABLE processed_data.tests;
INSERT INTO processed_data.tests

-- CREATE TABLE processed_data.tests AS

WITH test_data AS (
	
	SELECT
	"state" AS state_abbreviation
	, "date" AS result_date
	, COALESCE(sum(new_results_reported) FILTER (WHERE overall_outcome = 'Positive'), 0) AS positive_results
	, sum(new_results_reported) AS total_results
	
	FROM raw_data.tests
	
	GROUP BY 1, 2
	)

, trailing_tests AS (
	
	SELECT
	*
	, sum(positive_results) OVER (PARTITION BY state_abbreviation ORDER BY result_date ROWS 6 PRECEDING) AS trailing7_positive_results
	, sum(total_results) OVER (PARTITION BY state_abbreviation ORDER BY result_date ROWS 6 PRECEDING) AS trailing7_total_results
	
	FROM test_data
	)

, population_tests AS (
	
	SELECT
	test.*
	, round((test.trailing7_total_results / pop.population * 100000), 2) AS trailing7_tests_per100k
	
	FROM trailing_tests test
	JOIN public.state_abbreviations_populations pop
	USING (state_abbreviation)
	)

SELECT
state_abbreviation 
, result_date
, positive_results AS positives
, total_results AS tests
, CASE 
	WHEN total_results IS NULL OR total_results = 0 THEN 0
	ELSE round((100 * positive_results / total_results), 2)
	END AS positivity
, trailing7_positive_results AS trailing7_positives
, trailing7_total_results AS trailing7_tests
, trailing7_tests_per100k
, CASE 
	WHEN trailing7_total_results IS NULL OR trailing7_total_results = 0 THEN 0
	ELSE round((100 * trailing7_positive_results / trailing7_total_results), 2)
	END AS trailing7_positivity
, DENSE_RANK() OVER (PARTITION BY state_abbreviation ORDER BY result_date DESC) AS recency_rank

FROM population_tests

ORDER BY 1, 2
;
