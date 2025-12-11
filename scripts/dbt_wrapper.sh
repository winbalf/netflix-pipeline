#!/bin/bash
# Wrapper script for dbt commands that filters out the harmless traceback error
# Usage: dbt_wrapper.sh <dbt_command> [args...]

# Run dbt command and filter out the traceback
cd /app/dbt
dbt "$@" 2>&1 | grep -v -E '(Traceback|File "|^  |^    |TypeError: MessageToJson)'

# Get the exit code from dbt (before filtering)
exit_code=${PIPESTATUS[0]}

# If dbt succeeded, exit with 0
if [ $exit_code -eq 0 ]; then
    exit 0
else
    exit $exit_code
fi

