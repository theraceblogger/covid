TRUNCATE TABLE processed_data.wastewater;
INSERT INTO processed_data.wastewater

-- CREATE TABLE processed_data.wastewater AS

SELECT
reporting_jurisdiction AS state_abbreviation
, date_end AS result_date
, round(avg(percentile), 2) AS percentile
, DENSE_RANK() OVER (PARTITION BY reporting_jurisdiction ORDER BY date_end DESC) AS recency_rank

FROM raw_data.wastewater
WHERE key_plot_id ~~ '%raw wastewater'
AND percentile != 999.0

GROUP BY 1, 2
ORDER BY 1, 2
;
