#/usr/bin/bash

cd ~/covid/

/usr/bin/python3 update_data.py sync_cdc
/usr/bin/python3 update_data.py sync_hhs
/usr/bin/python3 update_data.py sync_cdc_wastewater