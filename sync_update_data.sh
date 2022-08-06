#/usr/bin/bash


/usr/bin/python3 /home/ec2-user/covid/update_data.py sync_cdc
/usr/bin/python3 /home/ec2-user/covid/update_data.py sync_hhs
/usr/bin/python3 /home/ec2-user/covid/update_data.py sync_cdc_wastewater