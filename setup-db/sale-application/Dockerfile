FROM postgres
ENV POSTGRES_PASSWORD docker
ENV POSTGRES_DB sale
RUN mkdir -p /member/files/success
RUN mkdir -p /member/files/archive
COPY sale-schema.sql /docker-entrypoint-initdb.d