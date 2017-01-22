#!/bin/bash
set -eu
/sbin/service postgresql-9.5 restart

HAS_USER=$(psql -U postgres postgres -t -A -c "SELECT COUNT(*) FROM pg_user WHERE usename = '${DB_USER}';";)
if [[ $HAS_USER < 1 ]]; then
  echo "CREATE USER ${DB_USER}"
  /usr/bin/createuser -U postgres -a -d ${DB_USER}
fi

HAS_DB=$(psql -U postgres postgres -t -A -c "SELECT COUNT(*) FROM pg_database WHERE datname = '${DB_NAME}';";)
if [[ $HAS_DB < 1 ]]; then
  echo "CREATE DATABASE ${DB_NAME}"
  /usr/bin/createdb -U postgres -E UTF-8 -T template0 -O ${DB_USER} ${DB_NAME}
fi

HAS_TEST_DB=$(psql -U postgres postgres -t -A -c "SELECT COUNT(*) FROM pg_database WHERE datname = '${TEST_DB_NAME}';";)
if [[ $HAS_TEST_DB < 1 && $TEST_DB_NAME != '' ]]; then
  echo "CREATE DATABASE ${TEST_DB_NAME}"
  /usr/bin/createdb -U postgres -E UTF-8 -T template0 -O ${DB_USER} ${TEST_DB_NAME}
fi

exit 0
