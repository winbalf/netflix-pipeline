.PHONY: help install setup test run docs clean docker-up docker-down docker-shell docker-logs docker-build

help:
	@echo "Netflix Analytics Pipeline - Makefile Commands"
	@echo ""
	@echo "Docker Commands:"
	@echo "  make docker-up      - Start Docker containers"
	@echo "  make docker-down    - Stop Docker containers"
	@echo "  make docker-shell   - Access application container shell"
	@echo "  make docker-logs    - View container logs"
	@echo "  make docker-build   - Rebuild Docker containers"
	@echo ""
	@echo "Local Commands:"
	@echo "  make install        - Install Python dependencies"
	@echo "  make setup          - Run initial setup (Postgres, S3)"
	@echo "  make generate-data   - Generate sample data"

install:
	pip install -r requirements.txt

setup:
	@echo "Setting up Postgres..."
	@if command -v psql >/dev/null 2>&1; then \
		echo "Note: Create database first with: CREATE DATABASE netflix_analytics;"; \
		psql -U postgres -d netflix_analytics -f scripts/setup_postgres.sql; \
	else \
		echo "psql not found. Using Python alternative..."; \
		python scripts/run_postgres_sql.py scripts/setup_postgres.sql; \
	fi

generate-data:
	python scripts/sample_data_generator.py

# Docker commands
docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

docker-shell:
	docker-compose exec netflix-pipeline-app bash

docker-logs:
	docker-compose logs -f

docker-build:
	docker-compose build --no-cache


