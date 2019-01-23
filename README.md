# docker-base
Simple Docker boilerplate with .env configuration. Simplify Commands with makefile.  
You should modify the .env and the docker-compose.yml for your project.

First run: 

```make up```

Then:
```
make start
make stop
```

All Commands with only ```make```.

## Create Projects
Go to public directory, delete all files and run the commands from 
commandline or if you need a special php Version from inside the container 
after run ```make bash```.

###TYPO3
```
composer create-project typo3/cms-base-distribution . ^9
composer require typo3/cms-introduction:^4.0
```

### Symfony
```
composer create-project symfony/skeleton .
composer create-project symfony/website-skeleton .
composer create-project symfony/symfony-demo .
```

### Neos
Change WEB_DOCUMENT_ROOT in .env to '/app/Web/'
```
composer create-project neos/neos-base-distribution .
composer create-project --no-dev neos/neos-base-distribution .
```

## Hints
### cron
To run crontabs change the Job in conf/cron/crontab (TYPO3 Scheduler) or add your own.
If possible set you local crontab to read-only (0600) or try ```make crontab```.
Then uncomment this Line in docker-compose.yml.
```yaml
- ./conf/cron/crontab:/var/spool/cron/crontabs/application
```

### ssh key
While Development you need sometimes access to key protected repositories. 
You can add your Keys and .config files to Development/Production ssh Folder.
Then uncomment this Line in docker-compose.yml.
```yaml
- ./conf/${PROVISION_CONTEXT}/ssh:/home/application/.ssh
```

### ssl certs
Default ssl cert are for *.vm. If you need another cert then copy it to the
conf Development/Production ssl Folder.
Then uncomment this Line in docker-compose.yml.
```yaml
- ./conf/${PROVISION_CONTEXT}/ssl:/opt/docker/etc/httpd/ssl/
```
current certs are created with:
```bash
openssl req \
    -newkey rsa:2048 \
    -x509 \
    -nodes \
    -keyout server.key \
    -new \
    -out server.crt \
    -subj /CN=\*.example.org \
    -reqexts SAN \
    -extensions SAN \
    -config <(cat /System/Library/OpenSSL/openssl.cnf \
        <(printf '[SAN]\nsubjectAltName=DNS:\*.example.org')) \
    -sha256 \
    -days 3650
 ``` 

## Database Snippets

### Mysql
.env
```
MYSQL_PORT=3306
MYSQL_IMAGE=mysql
MYSQL_TAG=5.7

MYSQL_DATABASE=app_db
MYSQL_USER=dev
MYSQL_PASSWORD=dev
MYSQL_ROOT_PASSWORD=dev
```

docker-compose.yml
```yaml
  mysql:
      image: ${DB_IMAGE}:${DB_TAG}
      container_name: ${COMPOSE_PROJECT_NAME}_mysql
      volumes:
        - ./data/mysql/:/var/lib/mysql:delegated
      ports:
        - ${EXTERNAL_MYSQL_PORT}:3306
      environment:
        MYSQL_DATABASE: ${MYSQL_DATABASE}
        MYSQL_USER: ${MYSQL_USER}
        MYSQL_PASSWORD: ${MYSQL_PASSWORD}
        MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      command: --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
```

#### Backup/Restore Examples
```bash
mkdir backup

# backup
docker exec -i $(docker-compose ps -q db) mysqldump --all-databases --single-transaction --quick --lock-tables=false -u dev -p > ./backup/all-databases-$(date +"%Y%m%d-%H%M").sql
docker exec -i $(docker-compose ps -q db) mysqldump --single-transaction --quick --lock-tables=false -u dev -p > ./backup/all-databases-$(date +"%Y%m%d-%H%M").sql

docker-compose exec -T db mysqldump --all-databases --single-transaction --quick --lock-tables=false -u dev -p > ./backup/all-databases-$(date +"%Y%m%d-%H%M").sql
docker-compose exec -T db mysqldump --single-transaction --quick --lock-tables=false -u dev -p app_db > ./backup/app_db-$(date +"%Y%m%d-%H%M").sql

docker-compose exec -T db mysqldump --all-databases --single-transaction --quick --lock-tables=false -u dev -p | gzip > ./backup/all-databases-$(date +"%Y%m%d-%H%M").sql.gz
docker-compose exec -T db mysqldump --single-transaction --quick --lock-tables=false -u dev -p app_db | gzip >  ./backup/app_db-$(date +"%Y%m%d-%H%M").sql.gz

# restore
docker exec -i $(docker-compose ps -q db) mysql -uroot -pdev < ./backup/all-databases-###.sql
docker exec -t $(docker-compose ps -q db) mysql -uroot -p app_db < ./backup/app_db-###.sql

gunzip < ./backup/all-###.sql.gz | docker-compose exec -T db mysql -udev -pdev
gunzip < ./backup/app_db-###.sql.gz | docker-compose exec -T db mysql -udev -pdev app_db

```

### mariadb
https://hub.docker.com/_/mariadb

https://mariadb.org/

.env
```
MARIADB_PORT=13306
MARIADB_IMAGE=mysql
MARIADB_TAG=5.7

MARIADB_DATABASE=app_db
MARIADB_USER=dev
MARIADB_PASSWORD=dev
MARIADB_ROOT_PASSWORD=dev
```

docker-compose.yml
```yaml
  mariadb:
    image: ${MARIADB_IMAGE}:${MARIADB_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_mariadb
    volumes:
      - ./data/mariadb/:/var/lib/mysql:delegated
    ports:
      - ${MARIADB_PORT}:3306
    environment:
      MYSQL_DATABASE: ${MARIADB_DATABASE}
      MYSQL_USER: ${MARIADB_USER}
      MYSQL_PASSWORD: ${MARIADB_PASSWORD}
      MYSQL_ROOT_PASSWORD: ${MARIADB_ROOT_PASSWORD}
    command: --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
```

### postgres
https://hub.docker.com/_/postgres

https://www.postgresql.org/

.env
```
POSTGRES_PORT=5432
POSTGRES_IMAGE=postgres
POSTGRES_TAG=11

POSTGRES_DATABASE=app_db
POSTGRES_USER=dev
POSTGRES_PASSWORD=dev
POSTGRES_ROOT_PASSWORD=dev
```

docker-compose.yml
```yaml
  postgres:
    image: ${POSTGRES_IMAGE}:${POSTGRES_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_postgres
    ports:
      - ${POSTGRES_PORT}:5432
    volumes:
      - ./data/postgres/:/var/lib/postgresql/data/:delegated
    environment:
      POSTGRES_DB: ${POSTGRES_DATABASE}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
```

### mongo
https://hub.docker.com/_/mongo

https://www.mongodb.com

.env
```
MONGO_PORT=27017
MONGO_IMAGE=mongo
MONGO_TAG=4

MONGO_ROOT_USER=dev
MONGO_ROOT_PASSWORD=dev
```

docker-compose.yml
```yaml
  mongo:
    image: ${MONGO_IMAGE}:${MONGO_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_mongo
    ports:
      - ${MONGO_PORT}:27017
    volumes:
      - ./data/mongo/:/data/db/:delegated
    environment:
      MONGO_INITDB_ROOT_USERNAME: ${MONGO_ROOT_USER}
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_ROOT_PASSWORD}
```

##Datbase Admin Snippets

### phpmyadmin
.env
```
PHPMYADMIN_PORT=8080
PHPMYADMIN_IMAGE=phpmyadmin/phpmyadmin
PHPMYADMIN_TAG=4.8
```

docker-compose.yml
```yaml
  phpmyadmin:
      image: ${PHPMYADMIN_IMAGE}:${PHPMYADMIN_TAG}
      container_name: ${COMPOSE_PROJECT_NAME}_phpmyadmin
      ports:
        - ${PHPMYADMIN_PORT}:80
      environment:
        PMA_HOST: mysql
```

### Adminer
https://www.adminer.org

https://hub.docker.com/_/adminer

.env
```
ADMINER_PORT=8090
ADMINER_IMAGE=adminer
ADMINER_TAG=4
```

docker-compose.yml
```yaml
  adminer:
      image: ${ADMINER_IMAGE}:${ADMINER_TAG}
      container_name: ${COMPOSE_PROJECT_NAME}_adminer
      ports:
        - ${ADMINER_PORT}:8080
      environment:
        ADMINER_DEFAULT_SERVER: mysql
```

### pgadmin
https://hub.docker.com/r/dpage/pgadmin4

https://www.pgadmin.org/

.env
```
PGADMIN_PORT=8095
PGADMIN_IMAGE=dpage/pgadmin4
PGADMIN_TAG=4
```

docker-compose.yml
```yaml
  pgadmin:
      image: ${PGADMIN_IMAGE}:${PGADMIN_TAG}
      container_name: ${COMPOSE_PROJECT_NAME}_pgadmin
      ports:
        - ${PGADMIN_PORT}:80
      environment:
        - PGADMIN_DEFAULT_EMAIL: dev@test
        - PGADMIN_DEFAULT_PASSWORD: dev
```          
          
### mongoclient
https://hub.docker.com/r/mongoclient/mongoclient

https://www.nosqlclient.com/

.env
```
MONGOCLIENT_PORT=3000
MONGOCLIENT_IMAGE=mongoclient/mongoclient
MONGOCLIENT_TAG=2.2.0
```

docker-compose.yml
```yaml
  mongoclient:
      image: ${MONGOCLIENT_IMAGE}:${MONGOCLIENT_TAG}
      container_name: ${COMPOSE_PROJECT_NAME}_mongoclient
      ports:
        - ${MONGOCLIENT_PORT}:3000
```  

## Mail Snippets

### mailhog
.env
```
MAIL_PORT=8025
MAIL_IMAGE=mailhog/mailhog
MAIL_TAG=v1.0.0
```

docker-compose.yml
```yaml
  mail:
    image: ${MAIL_IMAGE}:${MAIL_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_mail
    ports:
      - ${EXTERNAL_MAIL_PORT}:8025
```

- TYPO3 Mail Settings
'transport' => 'smtp'
'transport_smtp_server' => 'mail:1025'


## Cache Snippets
### redis / redis-stats
https://hub.docker.com/r/insready/redis-stat


.env
```
REDIS_PORT=6379
REDIS_STAT_PORT=8081
REDIS_IMAGE=redis
REDIS_TAG=4

REDIS_STAT_IMAGE=insready/redis-stat
REDIS_STAT_TAG=latest
```

docker-compose.yml
```yaml
  redis:
    image: ${REDIS_IMAGE}:${REDIS_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_redis
    volumes:
      - ./data/redis:/data:delegated
    ports:
      - ${REDIS_PORT}:6379
    command: redis-server --appendonly yes

  redis-stat:
    image: ${REDIS_STAT_IMAGE}:${REDIS_STAT_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_redisstat
    ports:
      - ${REDIS_STAT_PORT}:63790
    command: --server redis:6379
```

## Search Snippets

### solr / tika
- https://hub.docker.com/_/solr
- http://lucene.apache.org/solr/
- https://hub.docker.com/r/logicalspark/docker-tikaserver
- https://tika.apache.org/

.env
```
SOLR_PORT=8983
SOLR_IMAGE=solr
SOLR_TAG=7.5

TIKA_PORT=9998
TIKA_IMAGE=logicalspark/docker-tikaserver
TIKA_TAG=1.20
```

docker-compose.yml
```yaml
  solr:
    image: ${SOLR_IMAGE}:${SOLR_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_solr
    volumes:
      - ./conf/solr/configsets:/opt/solr/server/solr/configsets
      - ./conf/solr/cores:/opt/solr/server/solr/cores
      - ./conf/solr/solr.xml:/opt/solr/server/solr/solr.xml

      - ./data/search:/opt/solr/server/solr/data/:delegated
    ports:
      - ${SOLR_PORT}:8983

  tika:
    image: ${TIKA_IMAGE}:${TIKA_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_tika
    ports:
      - ${TIKA_PORT}:9998
```



### elasticsesarch / kibana
- https://www.docker.elastic.co/

.env
```
ELASTICSEARCH_PORT_REST=9200
ELASTICSEARCH_PORT_NODES=9300
KIBANA_PORT=5601

ELASTICSEARCH_IMAGE=docker.elastic.co/elasticsearch/elasticsearch
ELASTICSEARCH_TAG=6.5.4

KIBANA_IMAGE=docker.elastic.co/kibana/kibana
KIBANA_TAG6.5.4
```

docker-compose.yml
```yaml
  elasticsearch:
    image: ${ELASTICSEARCH_IMAGE}:${ELASTICSEARCH_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_elasticsearch
    ports:
      - ${EXTERNAL_ELASTICSEARCH_PORT_REST}:9200
      - ${EXTERNAL_ELASTICSEARCH_PORT_NODES}:9300
    volumes:
      - ./data/elasticsearch/:/usr/share/elasticsearch/data/:delegated
    environment:
      - xpack.security.enabled=false
      - ES_JAVA_OPTS=-Xms750m -Xmx750m

  kibana:
    image: ${KIBANA_IMAGE}:${ELASTICSEARCH_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_kibana
    ports:
      - ${EXTERNAL_KIBANA_PORT}:5601
    environment:
      - xpack.security.enabled=false
```
