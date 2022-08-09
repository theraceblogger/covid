TRUNCATE TABLE processed_data.vaccinations;
INSERT INTO processed_data.vaccinations

-- CREATE TABLE processed_data.vaccinations AS

WITH vaccinations_data AS (
	
	SELECT
	"Location" AS state_abbreviation
	, "Date" AS result_date
	, "Administered" AS cumulative_vaccinations
	, "Administered" - COALESCE(lag("Administered") OVER (PARTITION BY "Location" ORDER BY "Date"), 0) AS vaccinations
	, "Series_Complete_Yes" AS full_vaccination
	, "Series_Complete_Pop_Pct" AS full_vaccination_pct
	
	FROM raw_data.vaccinations
	)

, trailing_vaccinations AS (
	
	SELECT
	state_abbreviation
	, result_date
	, cumulative_vaccinations
	, vaccinations
	, sum(vaccinations) OVER (PARTITION BY state_abbreviation ORDER BY result_date ROWS 6 PRECEDING) AS trailing7_vaccinations
	, full_vaccination
	, full_vaccination_pct
	
	FROM vaccinations_data
	)

SELECT
vax.state_abbreviation
, vax.result_date
, vax.cumulative_vaccinations
, vax.vaccinations
, vax.trailing7_vaccinations
, round((vax.trailing7_vaccinations / pop.population * 100000), 2) AS trailing7_vaccinations_per100k
, vax.full_vaccination
, vax.full_vaccination_pct
, DENSE_RANK() OVER (PARTITION BY state_abbreviation ORDER BY result_date DESC) AS recency_rank

FROM trailing_vaccinations vax
JOIN public.state_abbreviations_populations pop
USING (state_abbreviation)

ORDER BY 1, 2
;
