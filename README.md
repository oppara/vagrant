# CentOS PHP

box
<https://github.com/oppara/packer-templates/releases/tag/CentOS-6.6-dev>

デフォルトのDocumentRootは`/srv/httpd/webroot`

`vagrant up`するとcomposerもインストールされます


## 設定

Vagrantfile 内の以下を適宜修正する

- "HOSTNAME" ホスト名（VirtualHostの設定と合わせると幸せになれるかも）
- "IP\_ADDRESS" ローカル確認用のIPアドレス
- "SOURCE" Vagrant同期元ディレクトリ
- "TARGET" Vagrant同期先ディレクトリ
- "PHP\_VERSION" 使用するPHPのバージョン

VirtualHost の設定を適宜変更する

```
vagrant/etc/dev.conf
```


