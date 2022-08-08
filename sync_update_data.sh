#/usr/bin/bash


/usr/bin/python3 /home/ec2-user/covid/update_data.py sync_cases_deaths
/usr/bin/python3 /home/ec2-user/covid/update_data.py sync_hospitalizations
/usr/bin/python3 /home/ec2-user/covid/update_data.py sync_wastewater
/usr/bin/python3 /home/ec2-user/covid/update_data.py sync_tests
/usr/bin/python3 /home/ec2-user/covid/update_data.py sync_vaccinations
/usr/bin/python3 /home/ec2-user/covid/update_data.py sync_variants