.PHONY: help
.DEFAULT_GOAL := help

## from https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

#############################
# Docker container states
#############################
up: ## Build Docker Containers for the first Time
	docker-compose up -d

start: ## start Containers
	docker-compose start

stop: ## stop Containers
	docker-compose stop

restart: stop start ## restart Containers

rebuild: ## Stop, remove and rebuild all Containers
	docker-compose stop
	docker-compose pull --ignore-pull-failures
	docker-compose rm --force
	docker-compose build --no-cache --pull
	docker-compose up -d --force-recreate --remove-orphans

kill: ## Stop and remove all Containers
	docker-compose stop
	docker-compose rm --force

ps: ## show current state of Containers from this project
	docker-compose ps

#############################
# bash
#############################

bash: ## open a bash inside the app Container with User application
	docker-compose exec --user application app /bin/bash

ci: ## run composer install inside the app Container
	docker-compose exec --user application app composer install

cu: ## run composer update inside the app Container
	docker-compose exec --user application app composer update

cu: ## run composer dump -a inside the app Container
	docker-compose exec --user application app composer dump -a

crontab: ## make crontab readonly
	docker-compose exec --user root app /bin/bash -c "chmod 0600 /var/spool/cron/crontabs/application"
	docker-compose stop
	docker-compose start

root: ## open a bash inside the app Container with User root
	docker-compose exec --user root app /bin/bash
