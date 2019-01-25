.PHONY: help
.DEFAULT_GOAL := help

## from https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

#############################
# Docker container states
#############################
build: ## Build Docker Containers for the first Time
	docker-compose up -d

rebuild: ## Stop, remove and rebuild all Containers
	docker-compose down
	docker-compose pull --ignore-pull-failures
	docker-compose build --no-cache --pull
	docker-compose up -d --force-recreate --remove-orphans

start: ## start Containers
	docker-compose start
up: start

stop: ## stop Containers
	docker-compose stop
down: stop

restart: ## restart Containers
	docker-compose restart
rs: restart

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

cind: ## run composer install inside the app Container no-dev
	docker-compose exec --user application app composer install

cu: ## run composer update inside the app Container
	docker-compose exec --user application app composer update

cund: ## run composer update inside the app Container no-dev
	docker-compose exec --user application app composer update --no-dev

cd: ## run composer dump -a inside the app Container
	docker-compose exec --user application app composer dump -a

crontab: ## make crontab readonly
	docker-compose exec --user root app /bin/bash -c "chmod 0600 /var/spool/cron/crontabs/application"
	docker-compose stop
	docker-compose start

#############################
# TYPO3
#############################
t3cf: ## ./typo3cms cache:flush
	docker-compose exec --user application app ./typo3cms cache:flush