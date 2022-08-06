#/usr/bin/bash

/usr/local/bin/python3 update_cdc_cases_deaths.py sync_cdc
/usr/local/bin/python3 update_cdc_cases_deaths.py sync_hhs
/usr/local/bin/python3 update_cdc_cases_deaths.py sync_cdc_wastewater