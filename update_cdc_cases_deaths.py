import wget
import os


tmp_data_path = os.environ['tmp_data_path']


def sync_cdc():
	url = 'https://data.cdc.gov/api/views/9mfq-cb36/rows.csv?accessType=DOWNLOAD'
	filename = f'{tmp_data_path}/cdc_cases_deaths.csv'
	wget.download(url, filename)

	os.system("psql -U $db_user_covid -d $db_name_covid -h $db_host_covid -c \"TRUNCATE public.cdc_cases_deaths\"")

	try:
		os.system(f"psql -U $db_user_covid -d $db_name_covid -h $db_host_covid -c \"\\COPY public.cdc_cases_deaths FROM '{filename}' HEADER DELIMITER ',' CSV\"")
	except:
		print('Unable to import cdc_cases_deaths data')

	os.system(f"rm {filename}")

sync_cdc()
