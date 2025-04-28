FROM mysql:latest
ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_DATABASE=bigdata_energia
ENV MYSQL_USER=testuser
ENV MYSQL_PASSWORD=testpass

COPY ./init.sql /docker-entrypoint-initdb.d/