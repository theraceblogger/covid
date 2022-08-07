import wget
import os
import sys
import psycopg2
from psycopg2.extras import DictCursor

tmp_data_path = os.environ['tmp_data_path']


# connect to database
def db_connect():
	db_name = os.environ['db_name_covid']
	db_user = os.environ['db_user_covid']
	db_host = os.environ['db_host_covid']
	db_credentials = os.environ['db_creds_covid']
	conn_string = f'dbname={db_name} user={db_user} host={db_host} password={db_credentials}'

	try:
		conn = psycopg2.connect(conn_string)
		conn.autocommit = True
	except:
		print('Unable to connect to the database')

	cur = conn.cursor(cursor_factory=DictCursor)
	return cur

# db_cur = db_connect()



def sync_cases_deaths():
	url = 'https://data.cdc.gov/api/views/9mfq-cb36/rows.csv?accessType=DOWNLOAD'
	filename = f'{tmp_data_path}/cases_deaths.csv'
	wget.download(url, filename)

	os.system("/usr/bin/psql -U $db_user_covid -d $db_name_covid -h $db_host_covid -c \"TRUNCATE raw_data.cases_deaths\"")

	try:
		os.system(f"/usr/bin/psql -U $db_user_covid -d $db_name_covid -h $db_host_covid -c \"\\COPY raw_data.cases_deaths FROM '{filename}' HEADER DELIMITER ',' CSV\"")
	except:
		print('Unable to import cases_deaths data')

	os.system(f"rm {filename}")



def sync_hospitalizations():
	url = 'https://healthdata.gov/api/views/g62h-syeh/rows.csv?accessType=DOWNLOAD'
	filename = f'{tmp_data_path}/hospitalizations.csv'
	wget.download(url, filename)

	os.system("/usr/bin/psql -U $db_user_covid -d $db_name_covid -h $db_host_covid -c \"TRUNCATE raw_data.hospitalizations\"")

	try:
		os.system(f"/usr/bin/psql -U $db_user_covid -d $db_name_covid -h $db_host_covid -c \"\\COPY raw_data.hospitalizations FROM '{filename}' HEADER DELIMITER ',' CSV\"")
	except:
		print ('Unable to import hospitalizations data')

	os.system(f"rm {filename}")



def sync_wastewater():
	url = 'https://data.cdc.gov/resource/2ew6-ywp6.csv?$limit=500000'
	filename = f'{tmp_data_path}/wastewater.csv'
	wget.download(url, filename)

	os.system("/usr/bin/psql -U $db_user_covid -d $db_name_covid -h $db_host_covid -c \"TRUNCATE raw_data.wastewater\"")

	try:
		os.system(f"/usr/bin/psql -U $db_user_covid -d $db_name_covid -h $db_host_covid -c \"\\COPY raw_data.wastewater FROM '{filename}' HEADER DELIMITER ',' CSV\"")
	except:
		print ('Unable to import wastewater data')

	os.system(f"rm {filename}")



def sync_tests():
	url = 'https://healthdata.gov/api/views/j8mb-icvb/rows.csv?accessType=DOWNLOAD'
	filename = f'{tmp_data_path}/tests.csv'
	wget.download(url, filename)

	os.system("/usr/bin/psql -U $db_user_covid -d $db_name_covid -h $db_host_covid -c \"TRUNCATE raw_data.tests\"")

	try:
		os.system(f"/usr/bin/psql -U $db_user_covid -d $db_name_covid -h $db_host_covid -c \"\\COPY raw_data.tests FROM '{filename}' HEADER DELIMITER ',' CSV\"")
	except:
		print ('Unable to import tests data')

	os.system(f"rm {filename}")



# setup initial functions that will redirect CLI to approriate function with zero to 2 params
def no_params():
	getattr(sys.modules[__name__], function_name)()

def one_param():
	getattr(sys.modules[__name__], function_name)(param1)

def two_params():
	getattr(sys.modules[__name__], function_name)(param1, param2)

if __name__ == "__main__":
	#first param should be the function
	function_name = sys.argv[1]

	#second param optional and represents the first parameter for the CLI function
	try:
		param1 = sys.argv[2]
	except Exception:
		pass

	#third param optional and represents the second parameter for the CLI function
	try:
		param2 = sys.argv[3]
	except Exception:
		pass

	#determine the number of parameters passed into python.  0 is the file, 1 is the method and params start @ 2
	param_length = len(sys.argv) - 2

	# map the inputs to the function blocks
	options = {
		0 : no_params,
		1 : one_param,
		2 : two_params
		}

	#now call the approriate function which will relay the CLI params to the underlying function
	options[param_length]()