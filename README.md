# Netflix Analytics Pipeline

A comprehensive data engineering project for processing Netflix analytics data using Postgres, Python, and dbt for transformations.

## 📋 Overview

This project provides:
- ✅ Docker-based Postgres database setup
- ✅ Database schema initialization (raw, staging, intermediate, analytics)
- ✅ Raw data tables for Netflix titles, ratings, and viewing history
- ✅ **dbt integration** for data transformations with staging models
- ✅ Python scripts for database operations and sample data generation
- ✅ Docker Compose setup for easy development
- ✅ Automated dbt profile configuration
- ✅ Data quality tests with dbt

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
    └──────┬────────┘
           │
           │ dbt transformations
           ▼
    ┌───────────────┐
    │  Postgres     │
    │ STAGING Schema│
    │               │
    │  • stg_netflix│
    │    _titles    │
    │  • stg_netflix│
    │    _ratings   │
    │  • stg_netflix│
    │    _viewing_  │
    │    history    │
    └──────┬────────┘
           │
           │ (Future: intermediate & marts)
           ▼
    ┌───────────────┐
    │  Postgres     │
    │ INTERMEDIATE  │
    │   & MARTS     │
    │   Schemas     │
    │               │
    │  (Ready for   │
    │   models)     │
    └───────────────┘
```

## 📁 Project Structure

```
nexflix-pipeline/
│
├── 📄 README.md                    # Main project documentation
├── 📄 RUNNABILITY_CHECK.md         # Project runnability status
├── 📄 requirements.txt             # Python dependencies (includes dbt)
├── 📄 Dockerfile                   # Docker image definition
├── 📄 docker-compose.yml           # Docker Compose configuration
├── 📄 Makefile                     # Common commands
├── 📄 .gitignore                   # Git ignore rules
├── 📄 .dockerignore                # Docker ignore rules
│
├── 📁 dbt/                         # dbt Project
│   ├── 📄 dbt_project.yml          # dbt project configuration
│   ├── 📄 packages.yml             # dbt package dependencies
│   ├── 📄 profiles.yml.template    # dbt profiles template
│   │
│   ├── 📁 models/                  # dbt Models
│   │   ├── 📁 staging/             # Staging models (views)
│   │   │   ├── 📄 sources.yml      # Source definitions & tests
│   │   │   ├── 📄 stg_netflix_titles.sql
│   │   │   ├── 📄 stg_netflix_ratings.sql
│   │   │   └── 📄 stg_netflix_viewing_history.sql
│   │   ├── 📁 intermediate/        # Intermediate models (ready for use)
│   │   └── 📁 marts/               # Mart models (ready for use)
│   │
│   ├── 📁 macros/                  # dbt Macros
│   ├── 📁 dbt_packages/            # Installed dbt packages
│   └── 📁 target/                  # dbt compilation artifacts
│
├── 📁 scripts/                     # Setup & Utility Scripts
│   ├── 📜 setup_postgres.sql       # Postgres schema setup
│   ├── 📜 init-db.sql              # Postgres initialization script (Docker)
│   ├── 🐍 run_postgres_sql.py      # Python script to run SQL files
│   ├── 🐍 sample_data_generator.py # Generate test data
│   ├── 🔧 dbt_wrapper.sh           # dbt command wrapper (filters errors)
│   └── 🔧 setup_dbt_profiles.sh    # Auto-generate dbt profiles.yml
│
└── 📁 data/                        # Data Files (gitignored)
```

## 🚀 Getting Started

### Prerequisites

- Docker and Docker Compose installed
- (Optional) Python 3.11+ and dbt for local development

### Quick Start with Docker (Recommended)

1. **Clone the repository:**
```bash
git clone <your-repo-url>
cd nexflix-pipeline
```

2. **Make scripts executable:**
```bash
chmod +x scripts/*.sh
```

3. **Start the services:**
```bash
make docker-up
# or
docker-compose up -d
```

4. **Setup dbt profiles:**
```bash
make docker-setup-dbt
# or from inside container:
docker-compose exec app bash scripts/setup_dbt_profiles.sh
```

5. **Verify Postgres is running:**
```bash
# From inside the container or host
docker-compose exec -T postgres psql -U postgres -d netflix_analytics -c "\dn"
```

You should see the schemas: `raw`, `staging`, `intermediate`, `analytics`

6. **Check raw tables:**
```bash
docker-compose exec -T postgres psql -U postgres -d netflix_analytics -c "\dt raw.*"
```

7. **Test dbt connection:**
```bash
make docker-dbt-debug
# or from inside container:
docker-compose exec app bash scripts/dbt_wrapper.sh debug
```

8. **Run dbt models:**
```bash
make docker-dbt-run
# or from inside container:
docker-compose exec app bash scripts/dbt_wrapper.sh run
```

9. **Verify staging models were created:**
```bash
docker-compose exec -T postgres psql -U postgres -d netflix_analytics -c "\dt staging.*"
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
cd dbt && dbt deps
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

3. **Setup dbt profiles:**
```bash
bash scripts/setup_dbt_profiles.sh
# or create ~/.dbt/profiles.yml manually
```

4. **Test dbt connection:**
```bash
cd dbt && dbt debug
```

5. **Run dbt models:**
```bash
cd dbt && dbt run
```

## 📊 Database Schema

### Raw Schema

The `raw` schema contains the initial data tables:

- **netflix_titles** - Netflix titles catalog
- **netflix_ratings** - User ratings data
- **netflix_viewing_history** - Viewing history data

All tables include a `_load_timestamp` column that tracks when records were loaded.

### Staging Schema (dbt)

The `staging` schema contains transformed views created by dbt:

- **stg_netflix_titles** - Cleaned and renamed titles data
- **stg_netflix_ratings** - Cleaned ratings data
- **stg_netflix_viewing_history** - Cleaned viewing history data

These are materialized as views and transform raw data with proper naming conventions and data cleaning.

### Intermediate & Analytics Schemas

- **intermediate** - Ready for intermediate transformation models
- **analytics** - Ready for final marts/models (materialized as tables)

## 🔧 dbt Configuration

### dbt Project

The dbt project is configured in `dbt/dbt_project.yml`:
- **Profile**: `netflix_analytics`
- **Staging models**: Materialized as views in `staging` schema
- **Intermediate models**: Materialized as views in `intermediate` schema
- **Marts models**: Materialized as tables in `analytics` schema

### dbt Packages

The project uses:
- **dbt-labs/dbt_utils** (v1.1.1) - Utility macros for common transformations

### Source Definitions

Sources are defined in `dbt/models/staging/sources.yml` with:
- Source tables from `raw` schema
- Column descriptions
- Data quality tests (unique, not_null)

### Running dbt Commands

**In Docker:**
```bash
make docker-dbt-run      # Run all models
make docker-dbt-test     # Run all tests
make docker-dbt-debug    # Test connection
make docker-dbt-deps     # Install packages
make docker-dbt-docs     # Generate documentation
```

**Locally:**
```bash
cd dbt
dbt run                  # Run all models
dbt run --select staging # Run only staging models
dbt test                 # Run all tests
dbt debug                # Test connection
dbt deps                 # Install packages
dbt docs generate        # Generate documentation
dbt docs serve           # Serve documentation
```

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
docker-compose exec app bash
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

### Docker Commands
```bash
make docker-up           # Start Docker containers
make docker-down         # Stop Docker containers
make docker-shell        # Access application container shell
make docker-logs         # View container logs
make docker-build        # Rebuild Docker containers
```

### Docker dbt Commands
```bash
make docker-setup-dbt    # Setup dbt profiles
make docker-dbt-deps     # Install dbt package dependencies
make docker-dbt-debug    # Test dbt connection
make docker-dbt-run      # Run dbt models
make docker-dbt-test     # Run dbt tests
make docker-dbt-docs     # Generate dbt documentation
```

### Local Commands
```bash
make help                # Show all available commands
make install             # Install Python dependencies
make setup               # Run initial Postgres setup
make generate-data       # Generate sample data
make test                # Run dbt tests
make run                 # Run dbt models
make run-staging         # Run only staging models
make docs                # Generate and serve dbt documentation
make clean               # Clean dbt artifacts
make full-pipeline       # Run install, setup, run, test, docs
```

## 🔄 Workflow

### Complete Pipeline Workflow

1. **Start Services**: Use `make docker-up` to start Postgres and the app container
2. **Setup dbt**: Run `make docker-setup-dbt` to configure dbt profiles
3. **Load Raw Data**: Load raw data into the `raw` schema tables
   - Optionally use `make generate-data` to create test data
4. **Run dbt Transformations**: Use `make docker-dbt-run` to create staging models
5. **Run Tests**: Use `make docker-dbt-test` to validate data quality
6. **Query Data**: Access Postgres to query and analyze the data
7. **Generate Documentation**: Use `make docker-dbt-docs` to create dbt docs

### Typical Development Workflow

```bash
# 1. Start everything
make docker-up
make docker-setup-dbt

# 2. Load or generate data
make generate-data  # If needed

# 3. Run transformations
make docker-dbt-run

# 4. Test data quality
make docker-dbt-test

# 5. Query results
docker-compose exec postgres psql -U postgres -d netflix_analytics
```

## 🧪 Data Quality Tests

The project includes dbt tests defined in `dbt/models/staging/sources.yml`:

- **Unique tests**: Ensure primary keys are unique
- **Not null tests**: Ensure required fields are present

Run tests with:
```bash
make docker-dbt-test
# or
cd dbt && dbt test
```

## ⚠️ Known Issues

### Port 5432 Already in Use

**Issue:** Error: `bind: address already in use` when starting Postgres container.

**Solution:** The default port is already set to 5433 to avoid conflicts. If you still get this error:
1. Check if port 5433 is available: `lsof -i :5433`
2. Change the port in `.env`: `POSTGRES_PORT=5434`
3. Or stop your local Postgres: `sudo service postgresql stop`

### Scripts Not Executable

**Issue:** Permission denied when running shell scripts.

**Solution:**
```bash
chmod +x scripts/*.sh
```

### dbt Connection Issues

**Issue:** dbt debug fails with connection errors.

**Solution:**
1. Ensure Docker containers are running: `make docker-up`
2. Run setup script: `make docker-setup-dbt`
3. Verify environment variables are set correctly
4. Check Postgres is healthy: `docker-compose ps`

## 📚 Additional Resources

- **RUNNABILITY_CHECK.md** - Detailed project runnability status and verification
- **dbt Documentation**: https://docs.getdbt.com/
- **dbt Postgres Adapter**: https://docs.getdbt.com/reference/warehouse-profiles/postgres-profile

## 📄 License

MIT License

## 👤 Author

Edwin Bueno
