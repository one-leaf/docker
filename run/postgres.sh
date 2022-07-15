#!/bin/sh
IP="192.168.1.1"
PORT=5189
NAME="postgres_$PORT"
DB="testdb"
USER="user"
PASS="123456"

sudo mkdir -p /docker/postgres/data/$NAME
sudo mkdir -p /docker/postgres/wal/$NAME
sudo mkdir -p /docker/postgres/backup/$NAME

sudo chown 70:70 /docker/postgres/data/$NAME
sudo chown 70:70 /docker/postgres/wal/$NAME
sudo chown 70:70 /docker/postgres/backup/$NAME

docker run -d \
    --name $NAME \
    --restart=always \
    --memory="32g" \
    --cpus="8.0" \
    -p $IP:$PORT:5432 \
    -e POSTGRES_USER=$USER \
    -e POSTGRES_PASSWORD=$PASS \
    -e POSTGRES_DB=$DB \
    -e TZ=PRC \
    -v /docker/postgres/data/$NAME:/var/lib/postgresql/data \
    -v /docker/postgres/wal/$NAME:/mnt/wal \
    -v /docker/postgres/backup/$NAME:/mnt/backup \
    postgres:14-alpine \
        -c track_activity_query_size=16384 \
        -c shared_buffers=1024MB \
        -c max_connections=200 \
        -c archive_mode=on \
        -c archive_command='gzip < %p > /mnt/wal/%f'

# 备份数据
# docker exec postgres_5189 pg_dump -U user -d testdb | gzip -c>db.sql.gz
# 还原备份数据
# gunzip < db.20220419.sql.gz | docker exec -i postgres_5189 psql -U user -d testdb