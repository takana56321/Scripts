# [概要]
## プロジェクトの説明

このプロジェクトは、Dockerを使用してLaravel環境を構築し、簡単に開発環境を整えることを目的としています。以下のスクリプトを使用して、必要なセットアップを自動化しています:

- `docker_setup.sh`: Docker環境のセットアップ
- `laravel_setup.sh`: Laravelプロジェクトのセットアップ

## 使用方法

### 前提条件

- Dockerがインストールされていること
- Docker Composeがインストールされていること

### インストール手順

 **リポジトリをクローンする**:

   ```
  $ git clone https://github.com/takana56321/Script.git
   ```

## 環境
- Docker 3.8
- MySQL 8.0.29
- Laravel 9
## 環境構築手順
### Docker環境のセットアップ

docker_setup.sh スクリプトを実行して、Docker環境をセットアップします。

コードを実行する

```
$ ./docker_setup.sh フォルダ名
```
#### ./docker_setup.shスクリプト内容
このスクリプトは、指定されたフォルダを作成し、Docker Compose設定ファイルを作成します。また、必要なディレクトリとファイルも生成されます。

#### デフォルトのポート設定
MySQL: 3306:3306

### Laravelプロジェクトのセットアップ
laravel_setup.sh スクリプトを実行して、Laravelプロジェクトをセットアップします。

コードを実行する
```
$ ./laravel_setup.sh プロジェクト名 データベース名
```

#### laravel_setup.shスクリプト内容
このスクリプトは、指定されたプロジェクト名でLaravelプロジェクトを作成し、データベースの設定を行います。さらに、Laravel BreezeとBreezejpパッケージをインストールして設定しています。

### バージョン変更
Laravelのバージョンを変更したい場合は、
スクリプト内の12行目を任意のバージョンに変更してください。<span style="color: red; ">赤文字</span>
| 変更行数 | デフォルト | 変更場所 |
| :---: | :---: | :---: |
| 12行目 | 'composer create-project "laravel/laravel=9.*" "$PROJECT_NAME"' | 'composer create-project <span style="color: red; ">"laravel/laravel=9.*"</span> "$PROJECT_NAME"' |

### MySQLのパス変更
21行目はXAMPPのMySQLに移動するコマンドです。使用者のMySQLのbinディレクトリに合わせて書き換えてください。
```
 cd /c/xampp/mysql/bin || exit
```
### MySQLのユーザーとパスワード変更
以下の行を使用者の環境に合わせて変更してください。

24行目:
```
 echo "CREATE DATABASE $DATABASE_NAME;" | ./mysql -u root -p"パスワード"
```
32行目:
```
 sed -i "s/DB_USERNAME=.*/DB_USERNAME="ユーザーネーム"/" .env
```
33行目:
```
 sed -i "s/DB_PASSWORD=.*/DB_PASSWORD="パスワード"/" .env
```
このREADMEに従ってスクリプトを実行することで、Docker環境およびLaravelプロジェクトのセットアップが簡単に行えます。


| バージョン変更 | TH 中央寄せ | TH 左寄せ |
| :---: | :---: | :--- |
| 12行目 | 'composer create-project "laravel/laravel=9.*" "$PROJECT_NAME"' |
| TD | TD | TD |


| TH 左寄せ | TH 中央寄せ | TH 右寄せ |
| :--- | :---: | ---: |
| TD | TD | TD |
| TD | TD | TD |
