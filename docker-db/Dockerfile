FROM mysql:8.0.37
WORKDIR /
ENV MYSQL_ROOT_PASSWORD=remoteguard
COPY ./src/ /docker-entrypoint-initdb.d/
EXPOSE 3306
