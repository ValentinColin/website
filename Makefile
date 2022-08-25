#################
### VARIABLES ###
#################

### MAKE ###
# Default target
.DEFAULT_GOAL := help

### FILES ###
# Docker
DOCKER_COMPOSE		:= docker-compose.yml
DOCKER_COMPOSE_DEV	:= docker-compose-dev.yml
DOCKER_COMPOSE_MARC	:= docker-compose-marc.yml
DOCKER_COMPOSE_MARC_DEV	:= docker-compose-marc-dev.yml

### Django
SECRET_KEY := whatever
HOST       := localhost
PORT       := 9080

###############
### TARGETS ###
###############

up: ## Run the server of production
	docker-compose --file $(DOCKER_COMPOSE) up -d

up_marc: ## Run the server of production on the marc's vps
	docker-compose --file $(DOCKER_COMPOSE_MARC) up -d

dev: ## Run the server of development (rebuild all images necessary) and follow the logs
	docker-compose --file $(DOCKER_COMPOSE_DEV) up -d --build
	docker-compose --file $(DOCKER_COMPOSE_DEV) logs --follow

dev_marc: ## Run the server of development (rebuild all images necessary) and follow the logs
	docker-compose --file $(DOCKER_COMPOSE_MARC_DEV) up -d --build
	docker-compose --file $(DOCKER_COMPOSE_MARC_DEV) logs --follow

down: ## Run down all servers (production and dev)
	docker-compose --file $(DOCKER_COMPOSE) down
	docker-compose --file $(DOCKER_COMPOSE_DEV) down
	docker-compose --file $(DOCKER_COMPOSE_MARC) down
	docker-compose --file $(DOCKER_COMPOSE_MARC_DEV) down

build: ### Build from the ground up
	docker-compose --file $(DOCKER_COMPOSE) build

update:
	pipenv update
	pipenv lock -r > requirements.txt
	SECRET_KEY=$(SECRET_KEY) ./manage.py collectstatic --noinput

dev: ## Run dev server locally without docker
	PRODUCTION=false HOST=$(HOST) PORT=$(PORT) SECRET_KEY=$(SECRET_KEY) ./entrypoint.sh

prod: ## Run prod server locally without docker
	PRODUCTION=true HOST=$(HOST) PORT=$(PORT) SECRET_KEY=$(SECRET_KEY) ./entrypoint.sh


# Special target help
help: ## Show this help
	@echo 'usage: make [target] ...'
	@echo
	@echo 'targets:	description:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | sed 's/^/\t/' | column -t -c 2 -s ':#'
