#!/bin/bash
set -eu

PATH="/usr/local/bin/:$PATH"
ROOT="/srv/httpd"
CONFIG="${ROOT}/config"
BOOTSTRAP="${CONFIG}/bootstrap.php"
DEVELOPMENT="${CONFIG}/development.php"

if [[ -e ${ROOT}/composer.lock ]]; then
  exit 0
fi

rm -rf "${ROOT}/*"
find ${ROOT} -type f | xargs --no-run-if-empty rm -rf


composer -q self-update && composer -q create-project --prefer-dist "cakephp/app=3.*" ${ROOT} << END_OF_INPUT
y
END_OF_INPUT

cd ${ROOT}
composer require --dev -q phpunit/phpunit


cp -f /vagrant/etc/cakephp3_database.php ${DEVELOPMENT}
sed -i -e "s@'username' => 'my_app',@'username' => '${DB_USER}',@g" ${DEVELOPMENT}
sed -i -e "s@'password' => 'secret',@'password' => '${DB_PASS}',@g" ${DEVELOPMENT}
sed -i -e "s@'database' => 'my_app',@'database' => '${DB_NAME}',@g" ${DEVELOPMENT}
sed -i -e "s@'database' => 'test_myapp',@'database' => '${TEST_DB_NAME}',@g" ${DEVELOPMENT}
if [[ ${USE_POSTGRES} == 1 ]]; then
  sed -i -e "s@'driver' => 'Cake\\Database\\Driver\\Mysql',@'driver' => 'Cake\\Database\\Driver\\Postgres',@g" ${DEVELOPMENT}
  sed -i -e "s@'encoding' => 'utf8mb4'@'encoding' => 'utf8'@g" ${DEVELOPMENT}
fi


sed -i -e "s@date_default_timezone_set('UTC');@date_default_timezone_set('Asia/Tokyo');@" ${BOOTSTRAP}
sed -i -e "s@//Configure::load('app_local', 'default');@//Configure::load('app_local', 'default');\nConfigure::load('development', 'default');@" ${BOOTSTRAP}


find ${CONFIG} -type f | xargs chmod 0644
find ${ROOT}/logs -type d | xargs --no-run-if-empty chmod 0777
find ${ROOT}/tmp -type d | xargs --no-run-if-empty chmod 0777
