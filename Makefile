
# DOCKER_REGISTRY := docker.io 
DOCKER_REPOSITORY:= mjcramer/kubernetes-toolbox
DOCKER_TAG := $(shell git describe --tags) 
DOCKER_IMAGE := ${DOCKER_REPOSITORY}:${DOCKER_TAG}

# Mac or Linux?
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    OSFLAG := Darwin
endif

ifeq ($(UNAME_S),Linux)
    OSFLAG := Linux
endif

#
# Pre-checks
#

# make sure docker is installed
DOCKER_EXISTS := @echo "Found docker..."
DOCKER_WHICH := $(shell which docker)
ifeq ($(strip $(DOCKER_WHICH)),)
	DOCKER_EXISTS := @echo "\nERROR: docker not found.\nSee: https://docs.docker.com/" && exit 1
endif

#
# Targets
#

default: up

.PHONY: check build tag push shutdown debug shell clean

check:
	$(DOCKER_EXISTS)

build: check
	docker build -t $(DOCKER_IMAGE)

run:
	docker run --rm -it $(DOCKER_IMAGE):$(DOCKER_TAG)
	# docker run --rm --name $(DOCKER_INSTANCE) -it $(DOCKER_IMAGE):$(DOCKER_TAG)

# stop:
# 	docker stop $(DOCKER_INSTANCE)
# 	docker rm $(DOCKER_INSTANCE)
#
# shutdown:
# 	docker stop $$(docker ps -a -q)
# 	docker rm $$(docker ps -a -q)
# 	docker-machine stop $(DOCKER_MACHINE)

tag:
ifdef (DOCKER_REGISTRY)
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_REGISTRY)/$(DOCKER_REPOSITORY):$(DOCKER_TAG)
else
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_REPOSITORY):$(DOCKER_TAG)
endif

push: tag
ifdef (DOCKER_REGISTRY)
	docker push $(DOCKER_REGISTRY)/$(DOCKER_REPOSITORY):$(DOCKER_TAG)
else
	docker push $(DOCKER_REPOSITORY):$(DOCKER_TAG)
endif

debug:
	docker run -it --rm --name $(DOCKER_INSTANCE) -v $(shell pwd)$(APP_DIR):$(APP_PATH) --net=host -e ENVDEVDB=$(ENVDEVDB) $(DOCKER_IMAGE)

status:
	@echo "\n *** DOCKER MACHINE ***\n"
	@docker-machine ls
	@echo "\n *** DOCKER CONTAINERS ***\n"
	@docker ps -a
	@echo

shell:
	docker exec -it $(DOCKER_INSTANCE) /bin/bash

clean:
	docker rm $(shell docker ps -a -q)

