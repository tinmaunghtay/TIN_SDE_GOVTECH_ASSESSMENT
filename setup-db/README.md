# Section 2 Setup Docker Postgres DB & Import Data Files
This module will setup and launch postgres database inside a docker container.
The container will initialise with defined sale schema. Schema will include several tables to support e-commerce site. 

Imported membership applications (successful) will land in member_applications table first.
Once data is imported, files will be moved to archive location.
---

## Setup Docker Postgres Container
Docker image will preload with Sale db schema using sale-schema.sql. Upon docker run, the schema and tables will created.

Create docker image using the command below. Docker containter image will be posted with name "sde-postgres-db".
- Copy setup-db/sale-application/Dockerfile to deployment directory
- Run the following command from deployment directory:
```
    docker build -t sde-postgres-db ./
```

---
## Launch Docker Postgres Container

Launch the container by following command:
```
    docker run -d --name sde-postgresdb-container -p 5432:5432 -v <host-input-file-path>:/member/files/success sde-postgres-db
```
Note: Replace <input-file-path> with actual file path from host or other instance

## Import Data from CSV
All imported csv files will be moved to archive location.

Put sale_csv_psql.sh file inside deployment directory.  Provide chmod +x as necessary.

Import successful membership applications from csv with the following command:
```
     bash sale_csv_psql.sh -i <input-file-path>
```
Note: Replace <input-file-path> with the path which contains csv files


