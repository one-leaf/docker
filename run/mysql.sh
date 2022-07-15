#!/bin/sh
# 注意 server-id 不能和其他主从mysql一样
IP="192.168.1.1"
PORT=3087
NAME="mysql_$PORT"
DB="testdb"
USER="user"
PASS="123456"

sudo mkdir -p /docker/mysql/data/$NAME
sudo mkdir -p /docker/mysql/binlog/$NAME
sudo mkdir -p /docker/mysql/backup/$NAME

sudo chown 999:999 /docker/mysql/data/$NAME
sudo chown 999:999 /docker/mysql/binlog/$NAME
sudo chown 999:999 /docker/mysql/backup/$NAME

docker run -d \
    --name $NAME \
    --restart=always \
    --memory="16g" \
    --cpus="8.0" \
    -p $IP:$PORT:3306 \
    -e MYSQL_USER=$USER \
    -e MYSQL_PASSWORD=$PASS \
    -e MYSQL_DATABASE=$DB \
    -e MYSQL_ROOT_PASSWORD=$PASS \
    -e TZ=PRC \
    -v /docker/mysql/data/$NAME:/var/lib/mysql \
    -v /docker/mysql/binlog/$NAME:/mnt/binlog \
    -v /docker/mysql/backup/$NAME:/mnt/backup \
    mysql:8-oracle \
    --character-set-server=utf8mb4 \
    --collation-server=utf8mb4_unicode_ci \
    --lower-case-table-names=1 \
    --max_connections=3000 \
    --key_buffer_size=2M \
    --join_buffer_size=2M \
    --tmp_table_size=256M \
    --key_buffer_size=256M \
    --read_buffer_size=1M \
    --read_rnd_buffer_size=16M \
    --bulk_insert_buffer_size=64M \
    --innodb_buffer_pool_size=2048M \
    --server-id=$PORT \
    --log-bin=/mnt/binlog/mysql-bin.log \
    --binlog_do_db=$DB


# 备份数据
# docker exec mysql_3087 mysqldump -uroot -p123456 testdb | gzip>testdb.sql.gz
# 还原备份数据
# gunzip -c mysql.sql.gz | docker exec -i mysql_3087 mysql -uroot -p123456 testdb