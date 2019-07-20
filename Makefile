.PHONY: help
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

#############################
# Docker container states
#############################
build: ## Build Docker Containers for the first Time
	docker-compose up -d
	docker-compose run -u root --rm node /bin/bash -c "chown -R node:node /app"
	docker-compose exec --user root app chown -R application:application /app

rebuild: ## Stop, remove and rebuild all Containers
	docker-compose down
	docker-compose pull --ignore-pull-failures
	docker-compose build --no-cache --pull
	docker-compose up -d --force-recreate --remove-orphans
	docker-compose run -u root --rm node /bin/bash -c "chown -R node:node /app"
	docker-compose exec --user root app chown -R application:application /app

start: ## start Containers
	docker-compose start
up: start

stop: ## stop Containers
	docker-compose stop
down: stop

restart: ## restart Containers
	docker-compose restart
rs: restart

reload: ## reload Containers with up -d
	docker-compose kill
	docker-compose up -d
rl: reload

kill: ## Stop and remove containers, networks, images, and volumes
	docker-compose down
rm: kill

state: ## show current state of Containers from this project
	docker-compose ps
ps: state

#############################
# bash
#############################
bash: ## open a bash inside the app Container with User application
	docker-compose exec --user application app /bin/bash

root: ## open a bash inside the app Container with User root
	docker-compose exec --user root app /bin/bash

ci: ## run composer install inside the app Container
	docker-compose exec --user application app composer install
	cd app && composer update && cd ..

cind: ## run composer install inside the app Container no-dev
	docker-compose exec --user application app composer install
	cd app && composer update && cd ..

cu: ## run composer update inside the app Container
	docker-compose exec --user application app composer update
	cd app && composer update && cd ..

cund: ## run composer update inside the app Container no-dev
	docker-compose exec --user application app composer update --no-dev
	cd app && composer update && cd ..

cd: ## run composer dump -a inside the app Container
	docker-compose exec --user application app composer dump -a
	cd app && composer update && cd ..

crontab: ## make crontab readonly
	docker-compose exec --user root app /bin/bash -c "chmod 0600 /var/spool/cron/crontabs/application"
	docker-compose restart

http2: ## enable http2 in apache
	docker-compose exec --user root app /bin/bash -c "a2enmod http2 && service apache2 restart"

#############################
# TYPO3
#############################
t3cf: ## ./typo3cms cache:flush
	docker-compose exec --user application app /bin/bash -c "TYPO3_CONTEXT=Development/Local ./typo3cms cache:flush"

t3refupd: ## ./typo3cms cache:flush
	docker-compose exec --user application app /bin/bash -c "TYPO3_CONTEXT=Development/Local ./typo3cms cleanup:updatereferenceindex"

#t3geo:
#	docker-compose exec --user application app /bin/bash -c "PHP_IDE_CONFIG=serverName=frosta9x-de.l.test XDEBUG_CONFIG=idekey=PHPSTORM TYPO3_CONTEXT=Development/Local ./typo3cms importstores:geocode"

#############################
# BACKUP
#############################
backup-mysql: ## backup TYPO3 DB
	docker-compose exec -T mysql mysqldump --single-transaction --quick --lock-tables=false -u dev -pdev app_db | gzip >  ./backup/app_db.sql.gz

restore-mysql: ## restore TYPO3 DB
	gunzip < ./backup/app_db.sql.gz | docker-compose exec -T mysql mysql -udev -pdev app_db

backup-fileadmin: ## backup fileadmin
	docker-compose exec --user application app /bin/bash -c "tar -czvf fileadmin.tar.gz public/fileadmin"
	mv ./app/fileadmin.tar.gz ./backup/fileadmin.tar.gz

restore-fileadmin: ## restore fileadmin
	cp ./backup/fileadmin.tar.gz ./app/fileadmin.tar.gz
	docker-compose exec --user application app /bin/bash -c "tar -xzvf fileadmin.tar.gz"
	rm ./app/fileadmin.tar.gz

#############################
# node
#############################
node: ## open a bash inside the app Container with User application
	docker-compose run -u node --rm node /bin/bash

npm-install: ## run npm install in src folder
	docker-compose run -u node --rm node /bin/bash -c "cd src && npm install"

npm-rbsass: ## rebuild node saas
	docker-compose run -u node --rm node /bin/bash -c "cd src && npm rebuild node-sass"

npm-watch: ## run npm watch in src folder
	docker-compose run -u node --rm node /bin/bash -c "cd src && npm run watch"

npm-build: ## complete build
	docker-compose run -u node --rm node /bin/bash -c "cd src && npm run build"

npm-prod: ## complete build for production
	docker-compose run -u node --rm node /bin/bash -c "cd src && npm run buildProd"

npm-sl: ## run stylelint to stylelint-report.txt with
	docker-compose run -u node --rm node /bin/bash -c "cd src && npm run lint:scss"

npm-slf: ## run stylelint to stylelint-report.txt with --fix
	docker-compose run -u node --rm node /bin/bash -c "cd src && npm run lint:scss-fix"
