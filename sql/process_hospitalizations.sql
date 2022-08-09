TRUNCATE TABLE processed_data.hospitalizations;
INSERT INTO processed_data.hospitalizations

-- CREATE TABLE processed_data.hospitalizations AS

WITH hospitalizations_data AS (
	
	SELECT
	"state" AS state_abbreviation
	, "date" AS result_date
	, previous_day_admission_adult_covid_confirmed + previous_day_admission_pediatric_covid_confirmed AS hospitalizations
	, sum(previous_day_admission_adult_covid_confirmed + previous_day_admission_pediatric_covid_confirmed) OVER (PARTITION BY "state" ORDER BY "date" ROWS 6 PRECEDING) AS trailing7_hospitalizations
	, previous_day_admission_pediatric_covid_confirmed_0_4 AS pediatric_hospitalizations_0_4
	, previous_day_admission_pediatric_covid_confirmed_5_11 AS pediatric_hospitalizations_5_11
	, previous_day_admission_pediatric_covid_confirmed_12_17 AS pediatric_hospitalizations_12_17
	, previous_day_admission_pediatric_covid_confirmed_unknown AS pediatric_hospitalizations_unknown
	, "previous_day_admission_adult_covid_confirmed_18-19" AS adult_hospitalizations_18_19
	, "previous_day_admission_adult_covid_confirmed_20-29" AS adult_hospitalizations_20_29
	, "previous_day_admission_adult_covid_confirmed_30-39" AS adult_hospitalizations_30_39
	, "previous_day_admission_adult_covid_confirmed_40-49" AS adult_hospitalizations_40_49
	, "previous_day_admission_adult_covid_confirmed_50-59" AS adult_hospitalizations_50_59
	, "previous_day_admission_adult_covid_confirmed_60-69" AS adult_hospitalizations_60_69
	, "previous_day_admission_adult_covid_confirmed_70-79" AS adult_hospitalizations_70_79
	, "previous_day_admission_adult_covid_confirmed_80+" AS adult_hospitalizations_80_plus
	, previous_day_admission_adult_covid_confirmed_unknown AS adult_hospitalizations_unknown
	
	FROM raw_data.hospitalizations
	)
	
SELECT
hosp.state_abbreviation
, hosp.result_date
, hosp.hospitalizations
, hosp.trailing7_hospitalizations
, round((hosp.trailing7_hospitalizations / pop.population * 100000), 2) AS trailing7_hospitalizations_per100k
, hosp.pediatric_hospitalizations_0_4
, hosp.pediatric_hospitalizations_5_11
, hosp.pediatric_hospitalizations_12_17
, hosp.pediatric_hospitalizations_unknown
, hosp.adult_hospitalizations_18_19
, hosp.adult_hospitalizations_20_29
, hosp.adult_hospitalizations_30_39
, hosp.adult_hospitalizations_40_49
, hosp.adult_hospitalizations_50_59
, hosp.adult_hospitalizations_60_69
, hosp.adult_hospitalizations_70_79
, hosp.adult_hospitalizations_80_plus
, hosp.adult_hospitalizations_unknown
, DENSE_RANK() OVER (PARTITION BY hosp.state_abbreviation ORDER BY hosp.result_date DESC) AS recency_rank

FROM hospitalizations_data hosp
JOIN public.state_abbreviations_populations pop
USING (state_abbreviation)

ORDER BY 1, 2
;
