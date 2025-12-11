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
	@echo "Docker dbt Commands:"
	@echo "  make docker-setup-dbt - Setup dbt profiles"
	@echo "  make docker-dbt-deps  - Install dbt package dependencies"
	@echo "  make docker-dbt-debug - Test dbt connection"
	@echo "  make docker-dbt-run   - Run dbt models"
	@echo "  make docker-dbt-test  - Run dbt tests"
	@echo "  make docker-dbt-docs  - Generate dbt documentation"
	@echo ""
	@echo "Local Commands:"
	@echo "  make install        - Install Python dependencies"
	@echo "  make setup          - Run initial setup (Postgres, S3)"
	@echo "  make test           - Run dbt tests"
	@echo "  make run            - Run dbt models"
	@echo "  make docs           - Generate and serve dbt documentation"
	@echo "  make clean          - Clean dbt artifacts"
	@echo "  make generate-data   - Generate sample data"

install:
	pip install -r requirements.txt
	cd dbt && dbt deps

setup:
	@echo "Setting up Postgres..."
	@if command -v psql >/dev/null 2>&1; then \
		echo "Note: Create database first with: CREATE DATABASE netflix_analytics;"; \
		psql -U postgres -d netflix_analytics -f scripts/setup_postgres.sql; \
	else \
		echo "psql not found. Using Python alternative..."; \
		python scripts/run_postgres_sql.py scripts/setup_postgres.sql; \
	fi

test:
	cd dbt && dbt test

run:
	cd dbt && dbt run

run-staging:
	cd dbt && dbt run --select staging

docs:
	cd dbt && dbt docs generate && dbt docs serve

clean:
	cd dbt && dbt clean

generate-data:
	python scripts/sample_data_generator.py

full-pipeline: install setup run test docs

# Docker commands
docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

docker-shell:
	docker-compose exec app bash

docker-logs:
	docker-compose logs -f

docker-build:
	docker-compose build --no-cache

docker-dbt-debug:
	@echo "Recommended: docker-compose exec app bash scripts/dbt_wrapper.sh debug"
	@docker-compose exec -T app bash scripts/dbt_wrapper.sh debug

docker-dbt-run:
	@docker-compose exec -T app bash scripts/dbt_wrapper.sh run

docker-dbt-test:
	@docker-compose exec -T app bash scripts/dbt_wrapper.sh test

docker-dbt-docs:
	@docker-compose exec -T app bash scripts/dbt_wrapper.sh docs generate

docker-setup-dbt:
	docker-compose exec -T app bash scripts/setup_dbt_profiles.sh

docker-dbt-deps:
	@docker-compose exec -T app bash -c "cd /app/dbt && dbt deps"


