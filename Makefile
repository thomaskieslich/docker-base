MAKEFLAGS += --silent


list:
	sh -c "echo; $(MAKE) -p no_targets__ | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | grep -v 'Makefile'| sort"

#############################
# Docker machine states
#############################
build:
	docker-compose build

init:
	docker-compose up -d

rebuild:
	docker-compose stop
	docker-compose pull --ignore-pull-failures
	docker-compose rm --force
	docker-compose build --no-cache --pull
	docker-compose up -d --force-recreate --remove-orphans

start:
	docker-compose start

stop:
	docker-compose stop

restart: stop start

kill:
	docker-compose stop
	docker-compose rm --force

state:
	docker-compose ps

#############################
# bash
#############################

run:
	docker run --rm -it  --user application tkieslich/docker-slim:1.0.0 bash

bash:
	docker-compose exec --user application app /bin/bash

root:
	docker-compose exec --user root app /bin/bash


#############################
# Argument fix workaround
#############################
%:
	@:
