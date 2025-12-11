#!/bin/bash
# Setup dbt profiles automatically from environment variables
# Supports both Docker and local environments

# Check if we're running in Docker (Docker sets POSTGRES_HOST=postgres)
# If so, use Docker environment variables directly and skip .env file
if [ "${POSTGRES_HOST}" = "postgres" ]; then
    echo "✓ Running in Docker - using Docker environment variables"
else
    # Load .env file if it exists (for local development)
    if [ -f .env ]; then
        set -a
        source .env
        set +a
        echo "✓ Loaded environment variables from .env file"
    fi
fi

# Set defaults if environment variables are not set
DBT_TARGET=${DBT_TARGET:-dev}
POSTGRES_HOST=${POSTGRES_HOST:-localhost}
POSTGRES_USER=${POSTGRES_USER:-postgres}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-postgres}
POSTGRES_PORT=${POSTGRES_PORT:-5432}
POSTGRES_DATABASE=${POSTGRES_DATABASE:-${POSTGRES_DB:-netflix_analytics}}
DBT_DEV_SCHEMA=${DBT_DEV_SCHEMA:-dev}
DBT_PROD_SCHEMA=${DBT_PROD_SCHEMA:-prod}
DBT_DEV_THREADS=${DBT_DEV_THREADS:-4}
DBT_PROD_THREADS=${DBT_PROD_THREADS:-8}

mkdir -p ~/.dbt

cat > ~/.dbt/profiles.yml << EOF
netflix_analytics:
  target: ${DBT_TARGET}
  outputs:
    dev:
      type: postgres
      host: ${POSTGRES_HOST}
      user: ${POSTGRES_USER}
      password: ${POSTGRES_PASSWORD}
      port: ${POSTGRES_PORT}
      dbname: ${POSTGRES_DATABASE}
      schema: ${DBT_DEV_SCHEMA}
      threads: ${DBT_DEV_THREADS}
      keepalives_idle: 0
    
    prod:
      type: postgres
      host: ${POSTGRES_HOST}
      user: ${POSTGRES_USER}
      password: ${POSTGRES_PASSWORD}
      port: ${POSTGRES_PORT}
      dbname: ${POSTGRES_DATABASE}
      schema: ${DBT_PROD_SCHEMA}
      threads: ${DBT_PROD_THREADS}
      keepalives_idle: 0
EOF

echo "✓ dbt profiles.yml created at ~/.dbt/profiles.yml"
echo ""
echo "Configuration:"
echo "  Target: ${DBT_TARGET}"
echo "  Host: ${POSTGRES_HOST}"
echo "  Port: ${POSTGRES_PORT}"
echo "  Database: ${POSTGRES_DATABASE}"
echo "  User: ${POSTGRES_USER}"
echo ""
echo "You can now run:"
echo "  cd dbt && dbt debug"
echo "  cd dbt && dbt run"

