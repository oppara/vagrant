#!/bin/bash
set -eu

COMPOSER_URL="https://getcomposer.org/installer"
COMPOSER_PATH="/usr/bin/composer"

if [[ ! -f ${COMPOSER_PATH} ]]; then
  echo "Insntall composer"
  cd /vagrant
  curl -sSk ${COMPOSER_URL} | /usr/local/bin/php
  chmod +x composer.phar
  mv composer.phar ${COMPOSER_PATH}
fi

exit 0

