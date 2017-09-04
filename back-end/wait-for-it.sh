#!/bin/bash
echo "Trying to wait postgres"

until psql -h "db" -p 5432 -U "postgres" -c '\l'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up..."

echo "Creating database and tables..."
psql -h "db" -U "postgres" -p 5432 -a -q -f data/database.sql
psql -h "db" -U "postgres" -p 5432 -a -q -f data/functions.sql
echo "done"
npm install
node server.js
