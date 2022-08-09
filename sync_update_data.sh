#/usr/bin/bash


# update raw data
/usr/bin/python3 /home/ec2-user/covid/update_data.py sync_cases_deaths
/usr/bin/python3 /home/ec2-user/covid/update_data.py sync_hospitalizations
/usr/bin/python3 /home/ec2-user/covid/update_data.py sync_wastewater
/usr/bin/python3 /home/ec2-user/covid/update_data.py sync_tests
/usr/bin/python3 /home/ec2-user/covid/update_data.py sync_vaccinations
/usr/bin/python3 /home/ec2-user/covid/update_data.py sync_variants

# process raw data
/usr/bin/psql -U $db_user_covid -d $db_name_covid -h $db_host_covid -f /home/ec2-user/covid/sql/process_tests.sql
/usr/bin/psql -U $db_user_covid -d $db_name_covid -h $db_host_covid -f /home/ec2-user/covid/sql/process_cases.sql
/usr/bin/psql -U $db_user_covid -d $db_name_covid -h $db_host_covid -f /home/ec2-user/covid/sql/process_deaths.sql
/usr/bin/psql -U $db_user_covid -d $db_name_covid -h $db_host_covid -f /home/ec2-user/covid/sql/process_hospitalizations.sql
/usr/bin/psql -U $db_user_covid -d $db_name_covid -h $db_host_covid -f /home/ec2-user/covid/sql/process_vaccinations.sql