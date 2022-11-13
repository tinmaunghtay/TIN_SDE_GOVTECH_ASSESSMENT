#!/bin/bash
# get files from flag -i
while getopts i: opts; do
   case ${opts} in
      i) INPUT_PATH=${OPTARG} ;;
   esac
done

echo "${INPUT_PATH}"
# import the files to db table
for i in "${INPUT_PATH}"/*;
do
  echo "${i##*/}"
  psql -U postgres -h localhost -d sale <<EOF
    BEGIN;
    COPY member_applications(membership_id,firstname,lastname,email,date_of_birth,mobile_no,above_18)
    FROM '/member/files/success/${i##*/}'
    DELIMITER ','
    CSV HEADER;
    COMMIT;
    insert into user_account(user_name, email, first_name, last_name, date_of_birth, mobile, above_18, current_membership_type)
      select COALESCE(firstname, '') || COALESCE(' ' || lastname, ''),email,firstname, lastname, date_of_birth, mobile_no,above_18, 1
        from member_applications
        where not exists(
          select 1 from user_account
          where email = member_applications.email);
    COMMIT;
    insert into user_membership(member_id, status_start_time, status_end_time, user_account_id, membership_type)
      select m.membership_id, CURRENT_TIMESTAMP(2), CURRENT_TIMESTAMP(2) + interval '1 year', u.id, 1
      from member_applications m
      INNER JOIN user_account u on m.email = u.email
      where not exists(
          select 1 from user_membership
          where member_id = m.membership_id);
    COMMIT;
    END;
EOF
  mv
done
