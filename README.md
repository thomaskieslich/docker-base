# docker-base
Simple Docker boilerplate with .env configuration. Simplify Commands with makefile.  
You should modify the .env and the docker-compose.yml for your project.

First run: 

```make init```

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

composer create-project typo3/cms-base-distribution . ^9
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

## Database

### Mysql
```
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
    volumes:
      - dbadmin:/sessions:delegated
    ports:
      - ${EXTERNAL_DB_ADMIN_PORT}:80
    environment:
      - PMA_HOST=db
volumes:
  dbadmin:
```

### postgres
```
db:
    build:
        context: docker/postgres
        args:
            POSTGRES_VERSION: ${POSTGRES_VERSION}
    container_name: ${COMPOSE_PROJECT_NAME}_postgres
    environment:
        POSTGRES_DATABASE: ${POSTGRES_DATABASE}
        POSTGRES_USER: ${POSTGRES_USER}
        POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    ports:
        - ${EXTERNAL_POSTGRES_PORT}:5432
    volumes:
        - ./data/postgres/_db:/var/lib/postgresql/data/:delegated
```