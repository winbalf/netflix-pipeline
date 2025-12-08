# Netflix Analytics Pipeline

A data engineering project for processing Netflix analytics data using Postgres and Python.

## 📋 Overview

This project provides:
- ✅ Docker-based Postgres database setup
- ✅ Database schema initialization (raw, staging, intermediate, analytics)
- ✅ Raw data tables for Netflix titles, ratings, and viewing history
- ✅ Python scripts for database operations and sample data generation
- ✅ Docker Compose setup for easy development

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    DATA PIPELINE ARCHITECTURE                   │
└─────────────────────────────────────────────────────────────────┘

    ┌───────────────┐
    │  Raw CSV/JSON │
    │     Files     │
    └──────┬────────┘
           │
           │ Load data
           ▼
    ┌───────────────┐
    │  Postgres     │
    │  RAW Schema   │
    │               │
    │  • netflix_   │
    │    titles     │
    │  • netflix_   │
    │    ratings    │
    │  • netflix_   │
    │    viewing_   │
    │    history    │
    └───────────────┘
           │
           │ (Future: dbt transformations)
           ▼
    ┌───────────────┐
    │  Postgres     │
    │ STAGING Schema│
    │               │
    │  (Future)     │
    └───────────────┘
```

## 📁 Project Structure

```
netflix-pipeline/
│
├── 📄 README.md                    # Main project documentation
├── 📄 requirements.txt             # Python dependencies
├── 📄 Dockerfile                   # Docker image definition
├── 📄 docker-compose.yml           # Docker Compose configuration
├── 📄 Makefile                     # Common commands
├── 📄 .gitignore                   # Git ignore rules
├── 📄 .dockerignore                # Docker ignore rules
│
├── 📁 scripts/                     # Setup & Utility Scripts
│   ├── 📜 setup_postgres.sql       # Postgres schema setup
│   ├── 📜 init-db.sql              # Postgres initialization script (Docker)
│   ├── 🐍 run_postgres_sql.py      # Python script to run SQL files
│   └── 🐍 sample_data_generator.py # Generate test data
│
└── 📁 data/                        # Data Files (gitignored)
```

## 🚀 Getting Started

### Prerequisites

- Docker and Docker Compose installed

### Quick Start with Docker (Recommended)

1. **Clone the repository:**
```bash
git clone <your-repo-url>
cd nexflix-pipeline
```

2. **Start the services:**
```bash
make docker-up
# or
docker-compose up -d
```

3. **Access the application container:**
```bash
make docker-shell
# or
docker-compose exec netflix-pipeline-app bash
```

4. **Verify Postgres is running:**
```bash
# From inside the container or host
docker-compose exec -T postgres psql -U postgres -d netflix_analytics -c "\dn"
```

You should see the schemas: `raw`, `staging`, `intermediate`, `analytics`

5. **Check raw tables:**
```bash
docker-compose exec -T postgres psql -U postgres -d netflix_analytics -c "\dt raw.*"
```

### Manual Installation (Without Docker)

**Prerequisites:**
- Postgres database (local or remote)
- Python 3.11+
- psql CLI (or use the Python alternative script)

1. **Install Python dependencies:**
```bash
make install
# or
pip install -r requirements.txt
```

2. **Set up Postgres database:**

   **First, create the database:**
   ```bash
   # Connect to Postgres (using default postgres database)
   psql -U postgres
   
   # In psql, create the database:
   CREATE DATABASE netflix_analytics;
   \q
   ```

   **Then set up schemas using Python script:**
   
   Set environment variables with your Postgres credentials:
   ```bash
   export POSTGRES_HOST="localhost"
   export POSTGRES_PORT="5432"
   export POSTGRES_DATABASE="netflix_analytics"
   export POSTGRES_USER="your_username"
   export POSTGRES_PASSWORD="your_password"
   
   # Run the setup script
   python scripts/run_postgres_sql.py scripts/setup_postgres.sql
   ```

   This script will create:
   - Schemas: `raw`, `staging`, `intermediate`, `analytics`
   - Raw tables: `netflix_titles`, `netflix_ratings`, `netflix_viewing_history`

## 📊 Database Schema

### Raw Schema

The `raw` schema contains the initial data tables:

- **netflix_titles** - Netflix titles catalog
- **netflix_ratings** - User ratings data
- **netflix_viewing_history** - Viewing history data

All tables include a `_load_timestamp` column that tracks when records were loaded.

## 🐳 Docker Commands

> **Note:** The default Postgres port is set to 5433 to avoid conflicts with local Postgres instances.

### Start services
```bash
make docker-up
# or
docker-compose up -d
```

### Stop services
```bash
make docker-down
# or
docker-compose down
```

### Access the application container
```bash
make docker-shell
# or
docker-compose exec netflix-pipeline-app bash
```

### Access Postgres directly
```bash
# From inside container
docker-compose exec postgres psql -U postgres -d netflix_analytics

# From host machine (if you have psql installed)
psql -h localhost -p 5433 -U postgres -d netflix_analytics
```

### View logs
```bash
make docker-logs
# or
docker-compose logs -f app
docker-compose logs -f postgres
```

### Rebuild containers
```bash
make docker-build
# or
docker-compose build --no-cache
docker-compose up -d
```

### Clean up volumes (⚠️ deletes all data)
```bash
docker-compose down -v
```

## 📝 Makefile Commands

```bash
make help              # Show all available commands
make install           # Install Python dependencies
make setup             # Run initial Postgres setup
make generate-data      # Generate sample data
make docker-up         # Start Docker containers
make docker-down       # Stop Docker containers
make docker-shell      # Access application container shell
make docker-logs       # View container logs
make docker-build      # Rebuild Docker containers
```

## 🔄 Workflow

1. **Start Services**: Use `make docker-up` to start Postgres and the app container
2. **Load Data**: Load raw data into the `raw` schema tables
3. **Generate Sample Data**: Use `make generate-data` to create test data
4. **Query Data**: Access Postgres to query and analyze the data

## ⚠️ Known Issues

### Port 5432 Already in Use

**Issue:** Error: `bind: address already in use` when starting Postgres container.

**Solution:** The default port is already set to 5433 to avoid conflicts. If you still get this error:
1. Check if port 5433 is available: `lsof -i :5433`
2. Change the port in `.env`: `POSTGRES_PORT=5434`
3. Or stop your local Postgres: `sudo service postgresql stop`

## 📄 License

MIT License

## 👤 Author

Your Name
