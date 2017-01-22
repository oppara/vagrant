# vagrant-centos-php

php version: 5.3.29, 5.4.45, 5.5.38, 5.6.30, 7.0.15

box: [oppara/CentOS-6.7-dev](https://atlas.hashicorp.com/oppara/boxes/CentOS-6.7-dev)

## Plugin

```bash
$ vagrant plugin install dotenv
```

[dotenvを利用して環境ごとでVagrantfileの設定値を変更してみる](http://blog.glidenote.com/blog/2014/02/26/vagrant-dotenv/)



## Usage

```bash
$ wget https://github.com/oppara/vagrant-centos-php/archive/master.zip
$ unzip master.zip
$ mv vagrant-centos-php-master project
$ cd project/vagrant
$ echo "VAGRANT_IP_ADDRESS=192.168.100.100" > .env
$ vagrant up
```

[MailCatcher](https://mailcatcher.me/)
`http://VAGRANT_IP_ADDRESS:1080`



