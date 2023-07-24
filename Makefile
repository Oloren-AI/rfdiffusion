# Variables
EXTENSION_NAME = "[NAME]"
DOCKER_IMAGE = ${EXTENSION_NAME}:latest
PORT = 8077

# Phony targets
.PHONY: docker docker-build docker-run

# Default target
all: docker

# Docker target: build and run Docker image
docker: docker-build docker-run

# Docker build target: builds Docker image
docker-build:
	@echo "Building Docker image $(DOCKER_IMAGE)"
	docker build -t $(DOCKER_IMAGE) .

# Docker run target: runs Docker container
docker-run:
	@echo "Running Docker container $(DOCKER_IMAGE)"
	@echo "Open http://localhost:$(PORT) in your browser"
	docker run -it -p $(PORT):80 -v $(pwd):/app $(DOCKER_IMAGE)

# Docker exec target: opens a bash terminal inside of a running container for this image
docker-exec:
	@echo "Docker container id: $(shell docker ps -aqf "ancestor=$(DOCKER_IMAGE)")"
	docker exec -it $(shell docker ps -aqf "ancestor=$(DOCKER_IMAGE)") /bin/bash
