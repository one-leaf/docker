#!/bin/sh

IP="192.168.1.1"
PORT=27017
NAME="mongodb_$PORT"
USER="root"
PASS="123456"

sudo mkdir -p /docker/mongo/data/$NAME
sudo mkdir -p /docker/mongo/backup/$NAME

sudo chown 999:999 /docker/mongo/data/$NAME
sudo chown 999:999 /docker/mongo/backup/$NAME

docker run -d \
    --name $NAME \
    --restart=always \
    --memory="2g" \
    --cpus="1.0" \
    -p $IP:$PORT:27017 \
    -e MONGODB_INITDB_ROOT_USERNAME=$USER \
    -e MONGODB_INITDB_ROOT_PASSWORD=$PASS \
    -e TZ=PRC \
    -v /docker/mongo/data/$NAME:/data/db \
    -v /docker/mongo/backup/$NAME:/mnt/backup \
    mongo:5

# mongodb 客户端
# docker exec -it mongodb_27017 mongo

# 备份 mongodb ，备份文件在主机的 /docker/mongo/backup/ 目录
# docker exec -it mongodb_27017 mongodump --gzip --archive=/mnt/backup/mongo.`date "+%Y-%m-%d"`.gz

# 还原 mongodb 需要将备份文件 mongo.2022-01-01.gz 复制到主机 /docker/mongo/backup/ 目录下 
# docker exec -it mongodb_27017 mongorestore --gzip --archive=/mnt/backup/mongo.2022-01-01.gz