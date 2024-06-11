#!/bin/bash

# 1. Laravelプロジェクトを作成（PJ名前は引数で指定）
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "使用方法: $0 プロジェクト名 データベース名"
  exit 1
fi

PROJECT_NAME=$1
DATABASE_NAME=$2

composer create-project "laravel/laravel=9.*" "$PROJECT_NAME"

# 2. ↑のフォルダに移動
cd "$PROJECT_NAME" || exit

# 3. php artisan serveをバックグラウンドで実行
php artisan serve &

# 4. xamppのMySQLに移動
cd /c/xampp/mysql/bin || exit

# 5. MySQLに接続し、データベースを作成
echo "CREATE DATABASE $DATABASE_NAME;" | ./mysql -u root -p

# 6. プロジェクト元に戻る
cd /c/xampp/htdocs/laravel3/docker_my_project/"$PROJECT_NAME" || exit

# 7. .envファイルを開き、データベース名、ユーザー名、パスワードを更新
sed -i "s/DB_DATABASE=.*/DB_DATABASE=$DATABASE_NAME/" .env
sed -i "s/DB_USERNAME=.*/DB_USERNAME=root/" .env
sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=" .env

# 8. php artisan migrateを実行
php artisan migrate || { echo 'Migration failed'; exit 1; }

# 9. Laravel Breezeをインストール
composer require laravel/breeze --dev || { echo 'Breeze installation failed'; exit 1; }
npm install || { echo 'npm install failed'; exit 1; }

# 10. Breezeをインストールし、Bladeスタックを選択
expect << EOF
spawn php artisan breeze:install
expect "Which stack would you like to install?"
send "0\r"
expect eof
EOF

# 11. askdkc/breezejpをインストール
composer require askdkc/breezejp --dev || { echo 'Breezejp installation failed'; exit 1; }
php artisan breezejp --langswitch || { echo 'Breezejp langswitch command failed'; exit 1; }

# 12. php artisan serveを再度実行
php artisan serve || { echo 'Artisan serve failed'; exit 1; }