include .env

.PHONY: up down stop prune ps shell rshell version update remove stoprunner listrunner logs

default: up

up:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose up -d --remove-orphans

down: stop

stop:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose stop

prune:
	@echo "Removing containers for $(PROJECT_NAME)..."
	@docker-compose down -v

ps:
	@docker ps --filter name='$(PROJECT_NAME)*'

shell:
	docker exec -ti -e COLUMNS=$(shell tput cols) -e LINES=$(shell tput lines) $(shell docker ps --filter name='$(PROJECT_NAME)' --format "{{ .ID }}") sh

rshell: # Root Shell
	docker exec -u 0 -ti -e COLUMNS=$(shell tput cols) -e LINES=$(shell tput lines) $(shell docker ps --filter name='$(PROJECT_NAME)' --format "{{ .ID }}") bash

version:
	docker exec $(PROJECT_NAME) gitlab-runner --version

stoprunner:
	docker exec $(PROJECT_NAME) gitlab-runner stop --service $(SERVICE)

listrunner:
	docker exec $(PROJECT_NAME) gitlab-runner list

regrunner:
	docker exec $(PROJECT_NAME) gitlab-runner register

update:
	@docker-compose stop
	@docker-compose rm
	docker-compose pull

remove:
	@docker-compose stop
	@docker-compose rm

logs:
	@docker-compose logs -f $(filter-out $@,$(MAKECMDGOALS))
  

# https://stackoverflow.com/a/6273809/1826109
%:
	@: