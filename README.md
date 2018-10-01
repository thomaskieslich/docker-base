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

All Commands with ```make list```.

## Create Projects
Go to public directory, delete all files and run the commands from 
commandline or if you need a special php Version from inside the container 
after run ```make bash```.

###TYPO3
```
composer create-project typo3/cms-base-distribution . ^8
composer require typo3/cms-introduction:^3.0
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

## Database Snippets

### Mysql / phpmyadmin
.env
```
EXTERNAL_DB_PORT=3306
EXTERNAL_DB_ADMIN_PORT=8080

# db
## mysql postgres mariadb
DB_IMAGE=postgres
DB_TAG=10

DB_DATABASE=app_db
DB_USER=dev
DB_PASSWORD=dev
DB_ROOT_PASSWORD=dev

# phpmyadmin dpage/pgadmin4
DB_ADMIN_IMAGE=phpmyadmin/phpmyadmin
DB_ADMIN_TAG=4.8
```

docker-compose.yml
```yaml
  db:
    image: ${DB_IMAGE}:${DB_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_db
    volumes:
      - ./data/db/:/var/lib/mysql:delegated
    ports:
      - ${EXTERNAL_DB_PORT}:3306
    environment:
      MYSQL_DATABASE: ${DB_DATABASE}
      MYSQL_USER: ${DB_USER}
      MYSQL_PASSWORD: ${DB_PASSWORD}
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
    command: --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

  dbadmin:
    image: ${DB_ADMIN_IMAGE}:${DB_ADMIN_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_dbadmin
    ports:
      - ${EXTERNAL_DB_ADMIN_PORT}:80
    environment:
      - PMA_HOST=db
```

### mariadb / adminer
.env
```
EXTERNAL_DB_PORT=3306
EXTERNAL_DB_ADMIN_PORT=8080

# db
## mysql postgres mariadb
DB_IMAGE=mariadb
DB_TAG=10

DB_DATABASE=app_db
DB_USER=dev
DB_PASSWORD=dev
DB_ROOT_PASSWORD=dev

# phpmyadmin dpage/pgadmin4 adminer
DB_ADMIN_IMAGE=adminer
DB_ADMIN_TAG=4
```

docker-compose.yml
```yaml
  db:
    image: ${DB_IMAGE}:${DB_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_db
    volumes:
      - ./data/db/:/var/lib/mysql:delegated
    ports:
      - ${EXTERNAL_DB_PORT}:3306
    environment:
      MYSQL_DATABASE: ${DB_DATABASE}
      MYSQL_USER: ${DB_USER}
      MYSQL_PASSWORD: ${DB_PASSWORD}
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
    command: --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

  dbadmin:
    image: ${DB_ADMIN_IMAGE}:${DB_ADMIN_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_dbadmin
    ports:
      - ${EXTERNAL_DB_ADMIN_PORT}:8080
```

### postgres / pgadmin

.env
```
EXTERNAL_DB_PORT=5432
EXTERNAL_DB_ADMIN_PORT=8080

# db
## mysql postgres mariadb
DB_IMAGE=postgres
DB_TAG=10

DB_DATABASE=app_db
DB_USER=dev
DB_PASSWORD=dev
DB_ROOT_PASSWORD=dev

# phpmyadmin dpage/pgadmin4
DB_ADMIN_IMAGE=dpage/pgadmin4
DB_ADMIN_TAG=3
```

docker-compose.yml
```yaml
  db:
    image: ${DB_IMAGE}:${DB_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_db
    environment:
      POSTGRES_DB: ${DB_DATABASE}
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    ports:
      - ${EXTERNAL_DB_PORT}:5432
    volumes:
      - ./data/db/:/var/lib/postgresql/data/:delegated

  dbadmin:
    image: ${DB_ADMIN_IMAGE}:${DB_ADMIN_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_dbadmin
    ports:
      - ${EXTERNAL_DB_ADMIN_PORT}:80
    environment:
      PGADMIN_DEFAULT_EMAIL: dev@test
      PGADMIN_DEFAULT_PASSWORD: dev
```

### mongo / mongoclient

.env
```
EXTERNAL_DB_PORT=27017
EXTERNAL_DB_ADMIN_PORT=3000

# db
## mysql postgres mariadb mongo
DB_IMAGE=mongo
DB_TAG=4

DB_DATABASE=app_db
DB_USER=dev
DB_PASSWORD=dev
DB_ROOT_PASSWORD=dev

# phpmyadmin dpage/pgadmin4 mongoclient
DB_ADMIN_IMAGE=mongoclient/mongoclient
DB_ADMIN_TAG=2.2.0
```

docker-compose.yml
```yaml
  db:
    image: ${DB_IMAGE}:${DB_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_db
    ports:
      - ${EXTERNAL_DB_PORT}:27017
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}

  dbadmin:
    image: ${DB_ADMIN_IMAGE}:${DB_ADMIN_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_dbadmin
    ports:
      - ${EXTERNAL_DB_ADMIN_PORT}:3000
```

## Mail Snippets

### mailhog
SMTP Server is mail:1025.  
.env
```
EXTERNAL_MAIL_PORT=8025

# mail
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

## Cache Snippets
### redis / redis-stats
.env
```
EXTERNAL_CACHE_PORT=6379
EXTERNAL_CACHE_STAT_PORT=8081

# cache
CACHE_IMAGE=redis
CACHE_TAG=4

CACHE_STAT_IMAGE=insready/redis-stat
CACHE_STAT_TAG=latest
```

docker-compose.yml
```yaml
  cache:
    image: ${CACHE_IMAGE}:${CACHE_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_cache
    volumes:
      - ./data/cache:/data:delegated
    ports:
      - ${EXTERNAL_CACHE_PORT}:6379
    command: redis-server --appendonly yes

  cache-stat:
    image: ${CACHE_STAT_IMAGE}:${CACHE_STAT_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_cachestat
    ports:
      - ${EXTERNAL_CACHE_STAT_PORT}:63790
    command: --server cache:6379
```

## Search Snippets

### solr / tika
.env
```
EXTERNAL_SOLR_PORT=8983
EXTERNAL_TIKA_PORT=9998

# search
SOLR_IMAGE=solr
SOLR_TAG=6.6.3

TIKA_IMAGE=logicalspark/docker-tikaserver
TIKA_TAG=1.18
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
      - ${EXTERNAL_SOLR_PORT}:8983

  tika:
    image: ${TIKA_IMAGE}:${TIKA_TAG}
    container_name: ${COMPOSE_PROJECT_NAME}_tika
    ports:
      - ${EXTERNAL_TIKA_PORT}:9998
```

### elasticsesarch / kibana
.env
```
EXTERNAL_ELASTICSEARCH_PORT_REST=9200
EXTERNAL_ELASTICSEARCH_PORT_NODES=9300
EXTERNAL_KIBANA_PORT=5601

# search
ELASTICSEARCH_IMAGE=docker.elastic.co/elasticsearch/elasticsearch
ELASTICSEARCH_TAG=5.6.12

KIBANA_IMAGE=docker.elastic.co/kibana/kibana
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