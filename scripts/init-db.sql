-- Initialize database schemas
-- This script runs automatically when Postgres container starts for the first time

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

-- Create raw tables
CREATE TABLE IF NOT EXISTS raw.netflix_titles (
    show_id VARCHAR(50),
    type VARCHAR(20),
    title VARCHAR(500),
    director VARCHAR(500),
    "cast" VARCHAR(5000),
    country VARCHAR(500),
    date_added VARCHAR(50),
    release_year INTEGER,
    rating VARCHAR(10),
    duration VARCHAR(50),
    listed_in VARCHAR(500),
    description VARCHAR(5000),
    _load_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS raw.netflix_ratings (
    rating_id VARCHAR(50),
    user_id VARCHAR(50),
    title_id VARCHAR(50),
    rating DECIMAL(3,2),
    rating_date DATE,
    review_text VARCHAR(5000),
    _load_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS raw.netflix_viewing_history (
    viewing_id VARCHAR(50),
    user_id VARCHAR(50),
    title_id VARCHAR(50),
    watch_date TIMESTAMP,
    watch_duration_minutes INTEGER,
    completion_percentage DECIMAL(5,2),
    device_type VARCHAR(50),
    _load_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_netflix_titles_show_id ON raw.netflix_titles(show_id);
CREATE INDEX IF NOT EXISTS idx_netflix_ratings_rating_id ON raw.netflix_ratings(rating_id);
CREATE INDEX IF NOT EXISTS idx_netflix_ratings_title_id ON raw.netflix_ratings(title_id);
CREATE INDEX IF NOT EXISTS idx_netflix_viewing_history_viewing_id ON raw.netflix_viewing_history(viewing_id);
CREATE INDEX IF NOT EXISTS idx_netflix_viewing_history_title_id ON raw.netflix_viewing_history(title_id);

-- Grant necessary permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA raw TO CURRENT_USER;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA raw TO CURRENT_USER;

