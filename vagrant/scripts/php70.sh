#!/bin/bash
set -eu

PHP_VERSION=7.0.15
XDEBUG_VERSION=2.4.1

install_php () {
  ./configure --with-config-file-path=/etc \
    --with-apxs2=/usr/sbin/apxs \
    --enable-mbstring      \
    --with-libxml-dir      \
    --with-mcrypt          \
    --with-openssl         \
    --with-pcre-regex      \
    --with-zlib            \
    --enable-bcmath        \
    --with-bz2             \
    --with-curl            \
    --enable-exif          \
    --enable-ftp           \
    --with-gd              \
    --with-jpeg-dir        \
    --with-png-dir         \
    --with-zlib-dir        \
    --with-libdir=lib64    \
    --with-xpm-dir=/usr    \
    --with-freetype-dir    \
    --enable-gd-native-ttf \
    --enable-gd-jis-conv   \
    --with-gettext         \
    --enable-intl          \
    --enable-pcntl         \
    --with-pdo-mysql       \
    --enable-mysqlnd       \
    --with-pdo-pgsql=/usr/pgsql-9.5  \
    --with-pgsql=/usr/pgsql-9.5  \
    --with-readline        \
    --enable-sockets       \
    --with-xmlrpc          \
    --with-xsl             \
    --with-vpx-dir         \
    --enable-zip           \
    --enable-opcache

  make && make install
  ln -s /usr/local/lib/php/extensions/*/opcache.so  /usr/local/lib/php/extensions/opcache.so
}
