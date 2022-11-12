#!/bin/bash
#Modify input file path
input_file="files/input"
#Modify output file path
output_file="files/output"
(crontab -l; echo "0 * * * * /usr/bin/python3 <deploy-path>/scripts/membership/loadmember.py -i ${input_file} -o ${output_file}")|awk '!x[$0]++'|crontab -