import wget
import os
import psycopg2


# connect to database
def db_connect():
	db_name = os.environ['db_name_covid']
	db_user = os.environ['db_user_covid']
	db_host = os.environ['db_host_covid']
	db_credentials = os.environ['db_creds_covid']
	# conn_string = f'dbname={db_name} user={db_user} host={db_host} password={db_credentials}'
	conn_string = "dbname='" + str(db_name) + "' user='" + str(db_user) + "' host='" + str(db_host) + "' password='" + str(db_credentials) + "'"

	try:
		conn = psycopg2.connect(conn_string)
		conn.autocommit = True
	except:
		print('Unable to connect to the database')

	cur = conn.cursor()
	return cur

dwh_cur = db_connect()

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

# sync_cdc()
