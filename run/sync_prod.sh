#!/usr/bin/env bash

## !! PLEASE SET TO THE RIGHT VALUES !!
DB_CONTAINER="mysql"
TYPO3_CONTEXT="Development"

SSH_HOST="hcp"

PUBLIC_DIR="/usr/home/user/public_html/www-root/public/"
BACKUP_DIR="/usr/home/user/backup/"

DB_NAME="***"
DB_USER="dev***"
DB_PW="***"
DB_HOST="127.0.0.1"

set -x

rsync -av -e ssh --delete ${SSH_HOST}:${PUBLIC_DIR}fileadmin/ ./app/public/fileadmin/

ssh ${SSH_HOST} "rm ${BACKUP_DIR}${DB_NAME}-sync.sql.gz"

ssh ${SSH_HOST} "mysqldump --single-transaction --quick --lock-tables=false -u${DB_USER} -p${DB_PW} -h${DB_HOST} ${DB_NAME} | gzip > ${BACKUP_DIR}${DB_NAME}-sync.sql.gz"

scp ${SSH_HOST}:${BACKUP_DIR}${DB_NAME}-sync.sql.gz ./backup/

docker-compose exec -T ${DB_CONTAINER} mysqldump --single-transaction --quick --lock-tables=false -u dev -pdev app_db > ./backup/app_db.sql
gzip -f  ./backup/app_db.sql

gunzip < ./backup/${DB_NAME}-sync.sql.gz | docker-compose exec -T ${DB_CONTAINER} mysql -udev -pdev app_db

docker-compose exec --user application app /bin/bash -c "TYPO3_CONTEXT=${TYPO3_CONTEXT} ./typo3cms cache:flush"

docker-compose restart
