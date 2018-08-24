# Needed SHELL since I'm using zsh
SHELL := /bin/bash

include .env

.PHONY: help up down stop prune ps shell rshell version update remove kill list register logs

default: help

#COLORS
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
HELP_FUN = \
	%help; \
	while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
	print "usage: make [target]\n\n"; \
	for (sort keys %help) { \
	print "${WHITE}$$_:${RESET}\n"; \
	for (@{$$help{$$_}}) { \
	$$sep = " " x (32 - length $$_->[0]); \
	print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
	}; \
	print "\n"; }

help: ##@other Show this help.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)
	

up:       ##@manage Start up the GitLab Runner
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose up -d --remove-orphans

upp:      ##@manage Start up the GitLab Runner with Privileges
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose up -d --remove-orphans

down:     ##@manage Bring the GitLab Runner down
down: stop

stop:     ##@manage Identical to 'down'
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose stop

prune:    ##@manage Remove any GitLab Runner container from docker
	@echo "Removing containers for $(PROJECT_NAME)..."
	@docker-compose down -v

ps:       ##@manage Show any active GitLab Runner container
	@docker ps --filter name='$(PROJECT_NAME)*'

update:   ##@manage Update the GitLab Runner with the latest image
	@docker-compose stop
	@docker-compose rm
	docker-compose pull

remove:   ##@manage Stop and remove GitLab Runner from docker
	@docker-compose stop
	@docker-compose rm

logs:     ##@manage Show the logs for the GitLab Runner in question in foreground
	@docker-compose logs -f $(filter-out $@,$(MAKECMDGOALS))

shell:    ##@interaction Bring up a sh into the GitLab Runner
	docker exec -ti -e COLUMNS=$(shell tput cols) -e LINES=$(shell tput lines) $(shell docker ps --filter name='$(PROJECT_NAME)' --format "{{ .ID }}") sh

rshell:   ##@interaction Bring up a root bash into the GitLab Runner
	docker exec -u 0 -ti -e COLUMNS=$(shell tput cols) -e LINES=$(shell tput lines) $(shell docker ps --filter name='$(PROJECT_NAME)' --format "{{ .ID }}") bash

version:  ##@information Show the version of GitLab running
	docker exec $(PROJECT_NAME) gitlab-runner --version

kill:     ##@runners Stop a particular runner
	docker exec $(PROJECT_NAME) gitlab-runner stop --service $(SERVICE)

list:     ##@runners List all runners
	docker exec $(PROJECT_NAME) gitlab-runner list

register: ##@runners Register a runner with GitLab Runner
	docker exec -ti $(PROJECT_NAME) gitlab-runner register


# https://stackoverflow.com/a/6273809/1826109
%:
	@: