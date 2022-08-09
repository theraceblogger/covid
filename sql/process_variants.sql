TRUNCATE TABLE processed_data.variants;
INSERT INTO processed_data.variants

-- CREATE TABLE processed_data.variants AS

SELECT
week_ending 
, variant 
, round("share"::numeric * 100, 2) AS pct

FROM raw_data.variants
WHERE usa_or_hhsregion = 'USA'
AND "share"::numeric >= .0025
AND modeltype = 'weighted'
AND published_date = (SELECT max(published_date) FROM raw_data.variants)

ORDER BY 1, 3 DESC
;
