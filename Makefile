#################
### VARIABLES ###
#################

### MAKE ###
# Default target
# .DEFAULT_GOAL := up
.DEFAULT_GOAL := up_marc

### FILES ###
# Docker
DOCKER_COMPOSE		:= docker-compose.yml
DOCKER_COMPOSE_MARC	:= docker-compose-marc.yml
DOCKER_COMPOSE_DEV	:= docker-compose-dev.yml

###############
### TARGETS ###
###############

up: ## Run the server of production
	docker-compose --file $(DOCKER_COMPOSE) up -d

up_marc: ## Run the server of production on the marc's vps
	docker-compose --file $(DOCKER_COMPOSE_MARC) up -d

dev: ## Run the server of development (rebuild all images necessary) and follow the logs
	docker-compose --file $(DOCKER_COMPOSE_DEV) up -d --build
	docker-compose --file dev.yml logs --follow

down: ## Run down all servers (production and dev)
	docker-compose --file $(DOCKER_COMPOSE) down
	docker-compose --file $(DOCKER_COMPOSE_MARC) down
	docker-compose --file $(DOCKER_COMPOSE_DEV) down

local: ## Run server in local without docker
	pip install -r requirements.txt
	./entrypoint.sh

# Special target help
help: ## Show this help
	@echo 'usage: make [target] ...'
	@echo
	@echo 'targets:	description:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | sed 's/^/\t/' | column -t -c 2 -s ':#'
