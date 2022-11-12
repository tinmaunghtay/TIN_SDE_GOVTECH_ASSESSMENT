import csv
from datetime import datetime, date
import re
import hashlib
import sys
import getopt
import os

email_re = re.compile(
    r"([-!#-'*+/-9=?A-Z^-~]+(\.[-!#-'*+/-9=?A-Z^-~]+)*|\"([]!#-[^-~ \t]|(\\[\t -~]))+\")@([-!#-'*+/-9=?A-Z^-~]+(\.["
    r"-!#-'*+/-9=?A-Z^-~]+)*|\[[\t -Z^-~]*])")


def membership_id(lastname, dob):
    """
    Generate Membership Id

    Membership id will be generated with the user's last name, followed by a SHA256 hash of the applicant's birthday,
    truncated to first 5 digits of hash (i.e <last_name>_<hash(YYYYMMDD)>)

    :param lastname: member's last name
    :param dob: date of birth (String)
    :return: membership id (i.e <last_name>_<hash(YYYYMMDD)>)
    """
    hash_string = hashlib.sha256(dob.encode('utf-8')).hexdigest()
    return '_'.join([lastname, hash_string[:5]])


def is_adult(dob):
    """
    Verify if Member is adult

    Verify whether member is adult by checking date of birth against today date

    :param dob: date of birth (String)
    :return: True or False (bool)
    """
    today = date.today()
    age = today.year - dob.year - ((today.month, today.day) < (dob.month, dob.day))
    if age >= 18:
        return True
    else:
        return False


def valid_mobile(mobile):
    """
    Validate Mobile Number

    Validate mobile number as follows:
    1. The first digit should contain numbers between 6 to 9.
    2. The rest 7 digits can contain any number between 0 to 9.

    :param mobile: mobile no as received from CSV file
    :return: True or False (bool)
    """
    if re.fullmatch('[6-9][0-9]{7}', mobile):
        return True
    else:
        return False


def valid_email(email):
    """
    Validate Email Address

    Validate email address

    :param email: email as received from CSV file
    :return: True or False (bool)
    """
    if re.fullmatch(email_re, email):
        return True
    else:
        return False


def parse_date(dt):
    """
    Parse Date String to date

    Parse date string to date by checking against multiple format of dates. If format is found, return date.
    Otherwise, return ValueError

    :param dt: date to parse
    :return: return datetime if date format is in the given format list
    """
    for fmt in ('%Y-%m-%d', '%d/%m/%Y', '%Y/%m/%d', '%m/%d/%Y', '%d-%m-%Y'):
        try:
            return datetime.strptime(dt, fmt)
        except ValueError:
            pass
    raise ValueError('no valid date format found')


def process_membership(input_file, success_file, fail_file):
    """
    Process Membership Application

    It will process membership applications as follows:
    An application is successful if:

    1. Application mobile number is 8 digits
    2. Applicant is over 18 years old as of 1 Jan 2022
    3. Applicant has a valid email (email ends with @emailprovider.com or @emailprovider.net)

    Transformations are done as follows:

    1. Split name into first_name and last_name
    2. Format birthday field into YYYYMMDD
    3. Remove any rows which do not have a name field (treat this as unsuccessful applications)
    4. Create a new field named above_18 based on the applicant's birthday
    5. Membership IDs for successful applications should be the user's last name, followed by a SHA256 \n
    hash of the applicant's birthday, truncated to first 5 digits of hash (i.e <last_name>_<hash(YYYYMMDD)>)
    6. reason field is added for failed applications

    :param input_file: membership input file path
    :param success_file: membership output file path for success applications
    :param fail_file: membership output file path for fail applications
    :return: None
    """
    success_header = ['membership_id', 'firstname', 'lastname', 'email', 'date_of_birth', 'mobile_no', 'above_18']
    fail_header = ['name', 'email', 'date_of_birth', 'mobile_no', 'reason']
    with open(success_file, 'w', encoding='UTF8', newline='') as success, \
            open(fail_file, 'w', encoding='UTF8', newline='') as fail:
        with open(input_file, 'r', newline='') as file:
            csvReader = csv.DictReader(file)
            fw = csv.writer(fail)
            fw.writerow(fail_header)
            sw = csv.writer(success)
            sw.writerow(success_header)
            for row in csvReader:
                name = row["name"]
                print(name)
                email = row["email"]
                dob = parse_date(row["date_of_birth"])
                mobile = row["mobile_no"]
                mobile_valid = valid_mobile(mobile)
                email_valid = valid_email(email)
                if not name or not mobile_valid or not email_valid:
                    reason = ("No Name given" if not name else "", "Invalid Mobile" if not mobile_valid else "",
                              "Invalid Email" if not email_valid else "")
                    fail_row = [name, email, dob.strftime("%Y%m%d"), mobile, ':'.join(reason)]
                    print(fail_row)
                    fw.writerow(fail_row)
                    continue
                first, *last = name.split()
                mid = membership_id(" ".join(last), dob.strftime("%Y%m%d"))
                success_row = [mid, first, " ".join(last), email, dob.strftime("%Y%m%d"), mobile]
                is18 = is_adult(dob)
                if is18:
                    success_row.append("yes")
                else:
                    success_row.append("no")
                sw.writerow(success_row)


def start_membership(argv):
    """
    Check arguments and Start processing Membership applications

    :param argv: arguments given through command
    :return: None
    """
    print('Starting...')
    arg_input = ""
    arg_output = ""
    arg_help = "Usage: python3 {0} -i <input> -o <output>\n -i, --input: directory path for membership input files\n " \
               "-o, --output: directory path for membership output files".format(argv[0])

    try:
        opts, args = getopt.getopt(argv[1:], "hi:o:", ["help", "input=",
                                                       "output="])
    except ValueError:
        print(arg_help)
        sys.exit(2)

    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print(arg_help)
            sys.exit(2)
        elif opt in ("-i", "--input"):
            arg_input = arg
        elif opt in ("-o", "--output"):
            arg_output = arg

    if not os.path.exists(arg_input):
        print('input folder path does not exist!')
        print(arg_help)
        sys.exit(2)

    if not os.path.exists(arg_output):
        print('output folder path does not exist!')
        print(arg_help)
        sys.exit(2)

    cwd = os.getcwd()
    for readfile in os.listdir(arg_input):
        print(readfile)
        if readfile.endswith('.csv'):
            input_file = f"{cwd}/{arg_input}/{readfile}"
            print(input_file)
            print(os.path.dirname(__file__))
            filename = os.path.splitext(readfile)[0]
            start_time = datetime.today().strftime('%Y%m%d%H%M%S')
            print(cwd)
            success_file = f"{cwd}/{arg_output}/success/{filename}_{start_time}.csv"
            fail_file = f"{cwd}/{arg_output}/fail/{filename}_{start_time}.csv"
            process_membership(input_file, success_file, fail_file)

    print('Successfully processed membership applications')
    print('done.')


if __name__ == "__main__":
    start_membership(sys.argv)
