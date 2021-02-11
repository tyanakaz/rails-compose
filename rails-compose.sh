#!/bin/sh

touch .env

touch Gemfile.lock

# Full stack
# docker-compose run api rails new . --database=mysql

# API
docker-compose run api rails new . --database=mysql --api

sleep 5

docker-compose build

sleep 5

docker-compose exec db mysql -hdb -e "ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'password';"

sed -ie 's/password:/password: password/g' config/database.yml
sed -ie 's/host: localhost/host: db/g' config/database.yml

aleep 10

docker-compose up -d && docker-compose exec api rake db:create

echo "# Mysql DB Volume" >> .gitignore
echo "mysql/volumes/*" >> .gitignore
