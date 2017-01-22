#!/bin/bash
set -eu

PATH="/usr/local/bin/:$PATH"
ROOT="/srv/httpd"
APP="${ROOT}/app"
CONFIG="${APP}/Config"

CORE_PHP=${CONFIG}/core.php
BOOTSTRAP_PHP=${CONFIG}/bootstrap.php
DATABASE_PHP=${CONFIG}/database.php

if [[ -e ${ROOT}/composer.lock ]]; then
  exit 0
fi

rm -rf "${ROOT}/*"
find ${ROOT} -type f | xargs --no-run-if-empty rm -rf

cp /vagrant/etc/cakephp2_composer.json ${ROOT}/composer.json
cd ${ROOT}
/usr/bin/composer install

${ROOT}/Vendor/bin/cake bake project app << END_OF_INPUT
y
END_OF_INPUT


# http://book.cakephp.org/2.0/ja/installation/advanced-installation.html#cakephp
for php in index.php test.php
do
  path=${APP}/webroot/${php}
  pattern="define('CAKE_CORE_INCLUDE_PATH',  ROOT . DS . APP_DIR . DS . 'Vendor' . DS . 'cakephp' . DS . 'cakephp' . DS . 'lib');"
  replacement="define('CAKE_CORE_INCLUDE_PATH',  ROOT . DS . 'Vendor' . DS . 'cakephp' . DS . 'cakephp' . DS . 'lib');"
  sed -i -e "s/${pattern}/${replacement}/g" ${path}
done

cat << 'EOF' > ${BOOTSTRAP_PHP}.tmp
<?php
// Composer の autoload を読み込み
require ROOT . DS . 'Vendor/autoload.php';

// CakePHP のオートローダーをいったん削除し、Composer より先に評価されるように先頭に追加する
// http://goo.gl/kKVJO7 を参照
spl_autoload_unregister(array('App', 'load'));
spl_autoload_register(array('App', 'load'), true, true);
EOF

cat ${BOOTSTRAP_PHP} | sed 's/<?php//' >> ${BOOTSTRAP_PHP}.tmp
mv ${BOOTSTRAP_PHP}.tmp ${BOOTSTRAP_PHP}

cat << 'EOF' >> ${BOOTSTRAP_PHP}

// Pluginのロード
App::build(array('Plugin' => array(ROOT . DS . 'Plugin' . DS)));
CakePlugin::loadAll();
EOF

cp -f /vagrant/etc/cakephp2_database.php ${DATABASE_PHP}
rm ${CONFIG}/database.php.default

sed -i -e "s@'login' => 'user',@'login' => '${DB_USER}',@g" ${DATABASE_PHP}
sed -i -e "s@'password' => 'password',@'password' => '${DB_PASS}',@g" ${DATABASE_PHP}
sed -i -e "s@'database' => 'database_name',@'database' => '${DB_NAME}',@" ${DATABASE_PHP}
sed -i -e "s@'database' => 'test_database_name',@'database' => '${TEST_DB_NAME}',@" ${DATABASE_PHP}
if [[ ${USE_POSTGRES} == 1 ]]; then
  sed -i -e "s@'datasource' => 'Database/Mysql',@'datasource' => 'Database/Postgres',@g" ${DATABASE_PHP}
  sed -i -e "s@'encoding' => 'utf8mb4'@'encoding' => 'utf8'@g" ${DATABASE_PHP}
fi

sed -i -e "s@//date_default_timezone_set('UTC');@date_default_timezone_set('Asia/Tokyo');@" ${CORE_PHP}


find ${APP} -type f | grep -v -e 'cake$' | xargs chmod 0644
cp -f /vagrant/etc/cakephp.gitignore ${ROOT}/.gitignore

find ${APP}/tmp -type d | xargs chmod 0777
find ${APP}/tmp -type d -empty -not -path './.git*' -exec touch {}\/empty \;


