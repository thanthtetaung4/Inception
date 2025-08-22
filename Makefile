# Makefile for WordPress + Nginx Docker setup

# Colors for output
GREEN := \033[0;32m
NC := \033[0m

all: build up

# Build containers
build:
	@echo "${GREEN}Building all containers...${NC}"
	docker compose build

# Start containers in detached mode
up:
	@echo "${GREEN}Starting containers...${NC}"
	docker compose up -d

# Stop containers
down:
	@echo "${GREEN}Stopping containers...${NC}"
	docker compose down

# Stop containers and remove volumes
clean:
	@echo "${GREEN}Stopping containers and removing volumes...${NC}"
	docker compose down -v --remove-orphans

# Force clean: remove containers, volumes, and images
fclean:
	@echo "${GREEN}Stopping containers, removing volumes and images...${NC}"
	docker compose down -v --rmi all --remove-orphans
	sudo rm -rf /home/taung/data/db_data/* /home/taung/data/wp_data/*

# Rebuild and start fresh
rebuild: clean build up

# Fully rebuild everything from scratch
re: fclean build up

# Help message
help:
	@echo "Makefile commands:"
	@echo "  make build    - Build all containers"
	@echo "  make up       - Start containers in detached mode"
	@echo "  make down     - Stop containers"
	@echo "  make clean    - Stop containers and remove volumes"
	@echo "  make fclean   - Stop containers, remove volumes and images"
	@echo "  make rebuild  - Clean, build, and start containers"
	@echo "  make re       - Force rebuild everything from scratch"

.PHONY: all build up down clean fclean rebuild re help
