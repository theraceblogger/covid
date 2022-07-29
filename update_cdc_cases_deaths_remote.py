import wget
import os


def sync_cdc():
	url = 'https://data.cdc.gov/api/views/9mfq-cb36/rows.csv?accessType=DOWNLOAD'
	# filename = '/Users/chuckschultz/covid/data/cdc_cases_deaths.csv'
	filename = '/home/ec2-user/covid/data/cdc_cases_deaths.csv'
	wget.download(url, filename)

	# os.system("psql -U chuckschultz -d covid -c \"TRUNCATE cdc.cdc_cases_deaths\"")
	os.system("psql -U covid_admin -d covid -h covid-db.cm8jjuqgct4h.us-east-2.rds.amazonaws.com -c \"TRUNCATE public.cdc_cases_deaths\"")

	try:
		os.system(f"psql -U covid_admin -d covid -h covid-db.cm8jjuqgct4h.us-east-2.rds.amazonaws.com -c \"\\COPY public.cdc_cases_deaths FROM '{filename}' HEADER DELIMITER ',' CSV\"")
	except:
		print("Unable to import cdc_cases_deaths data")

	os.system(f"rm {filename}")

sync_cdc()

# path from remote /usr/bin/python3
# path from local /usr/local/bin/python3


# import psycopg2
# db_name = os.environ['db_name_covid']
# db_user = os.environ['db_user_covid']
# db_host = os.environ['db_host_covid']
# db_credentials = os.environ['db_creds_covid']
# tmp_data_path = os.environ['tmp_data_path']


# connect to database
def db_connect():
	conn_string = f'dbname={db_name} user={db_user} host={db_host} password={db_credentials}'

	try:
		conn = psycopg2.connect(conn_string)
		conn.autocommit = True
	except:
		print('Unable to connect to the database')

	cur = conn.cursor()
	return cur

# dwh_cur = db_connect()

# truncate_sql = "TRUNCATE public.cdc_cases_deaths"
	# dwh_cur.execute(truncate_sql)