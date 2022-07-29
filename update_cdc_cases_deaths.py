import wget
import os


def sync_cdc():
	url = 'https://data.cdc.gov/api/views/9mfq-cb36/rows.csv?accessType=DOWNLOAD'
	filename = '/Users/chuckschultz/covid/data/cdc_cases_deaths.csv'
	wget.download(url, filename)

	os.system("psql -U chuckschultz -d covid -c \"TRUNCATE cdc.cdc_cases_deaths\"")

	try:
		os.system(f"psql -U chuckschultz -d covid -c \"\\COPY cdc.cdc_cases_deaths FROM '{filename}' HEADER DELIMITER ',' CSV\"")
	except:
		print("Unable to import cdc_cases_deaths data")

	os.system(f"rm {filename}")

sync_cdc()
#