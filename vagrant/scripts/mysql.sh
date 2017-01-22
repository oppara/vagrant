#!/bin/bash
set -eu

cp -f /vagrant/etc/my.cnf /etc/my.cnf
/sbin/service mysqld restart

HAS_USER=$(mysql -u root --skip-column-names -e "SELECT COUNT(*) FROM mysql.user WHERE user = '${DB_USER}';";)
if [[ $HAS_USER < 1 ]]; then
  echo "CREATE USER ${DB_USER}"
  mysql -u root -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
  mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'localhost';"
  mysql -u root -e "CREATE USER '${DB_USER}'@'127.0.0.1' IDENTIFIED BY '${DB_PASS}';"
  mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'127.0.0.1';"
  mysql -u root -e "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';"
  mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'%';"
fi

HAS_DB=$(cat <(mysql -u root -s --skip-column-names -e "SHOW DATABASES;" | grep ${DB_NAME}))
if [[ $HAS_DB = '' ]]; then
  echo "CREATE DATABASE ${DB_NAME}"
  mysql -u root -e "CREATE DATABASE ${DB_NAME}"
fi

HAS_TEST_DB=$(cat <(mysql -u root -s --skip-column-names -e "SHOW DATABASES;" | grep ${TEST_DB_NAME}))
if [[ $HAS_TEST_DB = '' && $TEST_DB_NAME != '' ]]; then
    echo "CREATE DATABASE ${TEST_DB_NAME}"
    mysql -u root -e "CREATE DATABASE ${TEST_DB_NAME}"
fi

exit 0

