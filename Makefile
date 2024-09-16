#---VARIABLES---------------------------------#
#--CONTAINERS--#
DJANGO_CONTAINER = django


#---DOCKER---#
DOCKER = docker
DOCKER_RUN = $(DOCKER) run
DOCKER_COMPOSE = docker compose
DOCKER_COMPOSE_UP = $(DOCKER_COMPOSE) up -d
DOCKER_COMPOSE_STOP = $(DOCKER_COMPOSE) down
DOCKER_COMPOSE_RUN = $(DOCKER_COMPOSE) run --rm
DOCKER_COMPOSE_EXEC = $(DOCKER_COMPOSE) exec
#------------#
#---DJANGO--#
DJANGO_ADMIN = $(DOCKER_COMPOSE_RUN) $(DJANGO_CONTAINER) django-admin
DJANGO_MANAGE = $(DOCKER_COMPOSE_EXEC) $(DJANGO_CONTAINER) python manage.py


#---PIP-#
PIP = $(DOCKER_COMPOSE_EXEC) $(DJANGO_CONTAINER) pip

#---PyTest---#
COVERAGE = $(DOCKER_COMPOSE_EXEC) $(DJANGO_CONTAINER) coverage run --source='.' manage.py


## === 🆘  HELP ==================================================
help: ## Show this help.
	@echo "Django-And-Docker-Makefile"
	@echo "---------------------------"
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
#---------------------------------------------#

## === 🐋  DOCKER ================================================
docker-up: ## Start docker containers.
	$(DOCKER_COMPOSE_UP)
.PHONY: docker-up

docker-stop: ## Stop docker containers.
	$(DOCKER_COMPOSE_STOP)
.PHONY: docker-stop

docker-build: ## Build docker containers.
	$(DOCKER) build . -f ./docker/Dockerfile
.PHONY: docker-build

docker-push: ## Push docker containers.
	$(DOCKER) push 
.PHONY: docker-push

dcr: ## Run docker-compose run on symfony container.
	$(DOCKER_COMPOSE_RUN) symfony $(filter-out $@,$(MAKECMDGOALS))
.PHONY: dcr
#---------------------------------------------#

## === 🎛️  DJANGO ===============================================

django-admin: ## Run django-admin command.
	$(DJANGO_ADMIN) $(filter-out $@,$(MAKECMDGOALS))
.PHONY: django-admin

django-manage: ## Run manage.py command.
	$(DJANGO_MANAGE) $(filter-out $@,$(MAKECMDGOALS))
.PHONY: django-manage

django-shell: ## Run django shell.
	$(DJANGO_MANAGE) shell
.PHONY: django-shell

django-makemigrations: ## Run django makemigrations.
	$(DJANGO_MANAGE) makemigrations
.PHONY: django-makemigrations

django-migrate: ## Run django migrate.
	$(DJANGO_MANAGE) migrate
.PHONY: django-migrate

django-createsuperuser: ## Run django createsuperuser.
	$(DJANGO_MANAGE) createsuperuser
.PHONY: django-createsuperuser

django-collectstatic: ## Run django collectstatic.
	$(DJANGO_MANAGE) collectstatic
.PHONY: django-collectstatic

django-test: ## Run django test.
	$(DJANGO_MANAGE) test
.PHONY: django-test

django-change-password: ## Run django change password <username>.
	$(DJANGO_MANAGE) changepassword $(filter-out $@,$(MAKECMDGOALS))
.PHONY: django-change-password

django-runserver: ## Run django runserver.
	$(DJANGO_MANAGE) runserver
.PHONY: django-runserver

## === ⭐  OTHER =================================================
start-project: ## Start new project.
	$(DJANGO_ADMIN) startproject $(filter-out $@,$(MAKECMDGOALS)) .

first-install: ## First install.
	cp compose.dist.yaml compose.yaml
	cp .env.dist .env
	$(DOCKER_COMPOSE) up -d
	$(DJANGO_MANAGE) migrate
	$(DJANGO_MANAGE) createsuperuser
.PHONY: first-install

reset-database: ## Reset database.
	$(eval CONFIRM := $(shell read -p "Are you sure you want to reset the database? [y/N] " CONFIRM && echo $${CONFIRM:-N}))
	@if [ "$(CONFIRM)" = "y" ]; then \
		$(DOCKER_COMPOSE) exec django python manage.py flush; \
	fi
.PHONY: reset-database

## === 🧹  CLEAN ================================================
clean: ## Clean all.
	$(DOCKER_COMPOSE) down
.PHONY: clean
#---------------------------------------------#