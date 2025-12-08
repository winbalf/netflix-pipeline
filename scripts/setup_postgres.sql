-- Initial Postgres setup script
-- Run this script to set up the Postgres environment
-- Note: Database must be created separately before running this script
-- CREATE DATABASE netflix_analytics;

-- Create schemas
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS intermediate;
CREATE SCHEMA IF NOT EXISTS analytics;

-- Grant privileges on schemas
GRANT ALL PRIVILEGES ON SCHEMA raw TO CURRENT_USER;
GRANT ALL PRIVILEGES ON SCHEMA staging TO CURRENT_USER;
GRANT ALL PRIVILEGES ON SCHEMA intermediate TO CURRENT_USER;
GRANT ALL PRIVILEGES ON SCHEMA analytics TO CURRENT_USER;

-- Show created objects
SELECT schema_name FROM information_schema.schemata WHERE schema_name IN ('raw', 'staging', 'intermediate', 'analytics');

