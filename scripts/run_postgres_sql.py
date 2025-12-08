#!/usr/bin/env python3
"""
Alternative to psql CLI for running SQL files against Postgres.
Uses psycopg2 to execute SQL scripts.

Usage:
    python scripts/run_postgres_sql.py <sql_file>
    
Environment variables required:
    POSTGRES_HOST
    POSTGRES_PORT
    POSTGRES_DATABASE
    POSTGRES_USER
    POSTGRES_PASSWORD
"""

import os
import sys
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
from pathlib import Path


def get_postgres_connection():
    """Create a Postgres connection using environment variables."""
    required_vars = ['POSTGRES_HOST', 'POSTGRES_DATABASE', 'POSTGRES_USER', 'POSTGRES_PASSWORD']
    missing_vars = [var for var in required_vars if not os.getenv(var)]
    
    if missing_vars:
        print(f"Error: Missing required environment variables: {', '.join(missing_vars)}")
        print("\nPlease set the following environment variables:")
        print("  - POSTGRES_HOST")
        print("  - POSTGRES_PORT (optional, defaults to 5432)")
        print("  - POSTGRES_DATABASE")
        print("  - POSTGRES_USER")
        print("  - POSTGRES_PASSWORD")
        sys.exit(1)
    
    conn_params = {
        'host': os.getenv('POSTGRES_HOST'),
        'port': os.getenv('POSTGRES_PORT', '5432'),
        'database': os.getenv('POSTGRES_DATABASE'),
        'user': os.getenv('POSTGRES_USER'),
        'password': os.getenv('POSTGRES_PASSWORD'),
    }
    
    try:
        conn = psycopg2.connect(**conn_params)
        return conn
    except Exception as e:
        print(f"Error connecting to Postgres: {e}")
        sys.exit(1)


def split_sql_statements(sql_content):
    """Split SQL content into individual statements."""
    # Remove comments and split by semicolon
    statements = []
    current_statement = []
    in_string = False
    string_char = None
    
    for line in sql_content.split('\n'):
        # Skip comment-only lines
        stripped = line.strip()
        if stripped.startswith('--') and not in_string:
            continue
        
        # Track string literals to avoid splitting on semicolons inside strings
        i = 0
        while i < len(line):
            char = line[i]
            if char in ("'", '"') and (i == 0 or line[i-1] != '\\'):
                if not in_string:
                    in_string = True
                    string_char = char
                elif char == string_char:
                    in_string = False
                    string_char = None
            i += 1
        
        current_statement.append(line)
        
        # Check if line ends with semicolon (and we're not in a string)
        if ';' in line and not in_string:
            statement = '\n'.join(current_statement).strip()
            if statement:
                statements.append(statement)
            current_statement = []
    
    # Add any remaining statement
    if current_statement:
        statement = '\n'.join(current_statement).strip()
        if statement:
            statements.append(statement)
    
    return statements


def execute_sql_file(conn, sql_file_path):
    """Execute SQL statements from a file."""
    sql_file = Path(sql_file_path)
    
    if not sql_file.exists():
        print(f"Error: SQL file not found: {sql_file_path}")
        sys.exit(1)
    
    print(f"Executing SQL file: {sql_file_path}")
    print("-" * 60)
    
    with open(sql_file, 'r') as f:
        sql_content = f.read()
    
    statements = split_sql_statements(sql_content)
    
    cursor = conn.cursor()
    executed_count = 0
    
    try:
        for i, statement in enumerate(statements, 1):
            if not statement.strip():
                continue
            
            try:
                print(f"\n[{i}/{len(statements)}] Executing statement...")
                cursor.execute(statement)
                executed_count += 1
                
                # Try to fetch results if it's a SELECT statement
                if statement.strip().upper().startswith('SELECT'):
                    results = cursor.fetchall()
                    if results:
                        print(f"Results ({len(results)} rows):")
                        for row in results[:10]:  # Show first 10 rows
                            print(f"  {row}")
                        if len(results) > 10:
                            print(f"  ... and {len(results) - 10} more rows")
                
                # Commit after each statement
                conn.commit()
                
            except Exception as e:
                print(f"Error executing statement {i}: {e}")
                print(f"Statement: {statement[:100]}...")
                conn.rollback()
                # Continue with next statement
                continue
        
        print(f"\n{'=' * 60}")
        print(f"Successfully executed {executed_count}/{len(statements)} statements")
        
    finally:
        cursor.close()


def main():
    if len(sys.argv) < 2:
        print("Usage: python scripts/run_postgres_sql.py <sql_file>")
        sys.exit(1)
    
    sql_file = sys.argv[1]
    
    print("Connecting to Postgres...")
    conn = get_postgres_connection()
    
    try:
        execute_sql_file(conn, sql_file)
    finally:
        conn.close()
        print("\nConnection closed.")


if __name__ == '__main__':
    main()

