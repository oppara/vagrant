# vagrant-centos-6.6-php

PHP開発用


## Box

<https://github.com/oppara/packer-templates/releases/tag/CentOS-6.6-dev>



## Plugin

```shell
$ vagrant plugin install dotenv
```

[dotenvを利用して環境ごとでVagrantfileの設定値を変更してみる](http://blog.glidenote.com/blog/2014/02/26/vagrant-dotenv/)



## Usage

```shell
$ wget https://github.com/oppara/vagrant-centos-6.6-php/archive/master.zip
$ unzip vagrant-centos-6.6-php-master.zip
$ mv vagrant-centos-6.6-php-master project
$ cd project/vagrant
$ echo "VAGRANT_IP_ADDRESS=192.168.100.100" > .env
$ vagrant up
```


## Vagrantfile

定数

- HOSTNAME = "foobar"
  - ホスト名 & VM名
- IP_ADDRESS = "192.168.33.30"
  - プライベートネットワークIPアドレス
  - dotenv VAGRANT_IP_ADDRESS で上書き可
- PHP_VERSION = "55"
  - 使用するPHPのバージョン
  - (53|54|55|56)
- PHP_PACKAGES = %w(php ...)
  - インストールするPHPのパッケージ
- SOURCE = "../src"
  - 同期元ディレクトリ (host)
- TARGET = "/srv/httpd/"
  - 同期先ディレクトリ (guest)



## Config file

- Apache
  - vagrant/etc/dev.conf
  - DocumentRoot "/srv/httpd/webroot"
- PHP
  - vagrant/etc/php.ini(53|54|55|56)


