#!/bin/bash
#Modify input file path
input_file='/files/input'
(crontab -l; echo "30 0-23 * * *  /deploy/path/sale_csv_psql.sh -i ${input_file}")|awk '!x[$0]++'|crontab -