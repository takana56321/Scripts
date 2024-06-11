# [概要]

このプロジェクトは、Docker環境とLaravelプロジェクトを簡単にセットアップするためのスクリプトを提供します。以下の手順に従って、環境構築を行ってください。

環境
Docker 3.8
MySQL 8.0.29
Laravel 9
環境構築手順
Docker環境のセットアップ
docker_setup.sh スクリプトを実行して、Docker環境をセットアップします。

コードをコピーする

```
 ./docker_setup.sh フォルダ名
```
スクリプト内容
このスクリプトは、指定されたフォルダを作成し、Docker Compose設定ファイルを作成します。また、必要なディレクトリとファイルも生成されます。
デフォルトのポート設定
MySQL: 3306:3306
Laravelプロジェクトのセットアップ
laravel_setup.sh スクリプトを実行して、Laravelプロジェクトをセットアップします。

コードをコピーする
```
 ./laravel_setup.sh プロジェクト名 データベース名
```
スクリプト内容
このスクリプトは、指定されたプロジェクト名でLaravelプロジェクトを作成し、データベースの設定を行います。さらに、Laravel BreezeとBreezejpパッケージをインストールして設定します。

バージョン変更
Laravelのバージョンを変更したい場合は、スクリプト内の12行目を任意のバージョンに変更してください。

 composer create-project "laravel/laravel=9.*" "$PROJECT_NAME"

MySQLのパス変更
21行目はXAMPPのMySQLに移動するコマンドです。使用者のMySQLのbinディレクトリに合わせて書き換えてください。
`
 cd /c/xampp/mysql/bin || exit

MySQLのユーザーとパスワード変更
以下の行を使用者の環境に合わせて変更してください。

24行目:

 echo "CREATE DATABASE $DATABASE_NAME;" | ./mysql -u root -p

32行目:

 sed -i "s/DB_USERNAME=.*/DB_USERNAME=root/" .env

33行目:

 sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=/" .env

このREADMEに従ってスクリプトを実行することで、Docker環境およびLaravelプロジェクトのセットアップが簡単に行えます。






