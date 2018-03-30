ARG MYSQL_VERSION

FROM mysql:$MYSQL_VERSION

ADD conf/mysql-docker.cnf /etc/mysql/conf.d/z99-docker.cnf
RUN chown mysql:mysql /etc/mysql/conf.d/z99-docker.cnf \
    && chmod 0644 /etc/mysql/conf.d/z99-docker.cnf

