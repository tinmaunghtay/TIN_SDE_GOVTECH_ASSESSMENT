# Process Membership Application Program
This program is to be executed as a standalone scheduler job. It will run hourly to process membership applications. The program exports successful and fail applications into separate output directories. It uses default python libraries only.

Command Example: python3 scripts/membership/loadmember.py -i files/input -o files/output

Legends
- -i, --input: directory path for membership input files
- -o, --output: directory path for membership output files

## Pre-Requisites and Assumptions
- Installed Python 3.8.* ++ version on linux machine where this program shall be deployed.
- Pre-defined Input and Output directories
- Cron job to deploy as user instead of system

## Deployment
Deploy this program by copying python program file to linux instance or machine. 
Detailed steps are as follows:
- Identify <deploy-path>
- Copy scripts/membership/loadmember.py into <deploy-path>
- Identify which input directory to read files as to provide as -i <input>
- Identify which output directory to save files as to provide as -o <output>
- Setup Cron Job to run hourly as follows: 
    - Open crontab -e or run loadmember_schedule.sh from deploy folder
    - Add entry "0 * * * * /usr/bin/python3 <deploy-path>/scripts/membership/loadmember.py -i <input> -o <output>"
    - If loadmember_schedule.sh is used, set <input> and <output> directories and save. Then execute chmod +x for loadmember_schedule.sh before executing.
    
### Output Files
Processed output files are available at files/output/success and files/output/file directories.