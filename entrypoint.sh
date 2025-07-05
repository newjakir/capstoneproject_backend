#!/bin/bash
set -e

# Activate virtualenv by setting PATH manually (better in Docker)
export PATH="/app/venv1/bin:$PATH"

# Dump data from SQLite to JSON
python manage.py dumpdata --database=sqlite --natural-primary --natural-foreign --indent 2 > /tmp/sqlite_data.json

# Apply migrations
python manage.py migrate

python manage.py loaddata /tmp/sqlite_data.json || echo "Data may have already been loaded or encountered an error."

# Optional: create superuser (won’t fail if user exists)
if [[ "$CREATE_SUPERUSER" == "1" ]]; then
  python manage.py createsuperuser --noinput || true
fi

# Start server
exec python manage.py runserver 0.0.0.0:8000
