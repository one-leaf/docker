#!/bin/sh
IP="192.168.1.1"
PORT=1521
NAME="oracle_$PORT"

# 以下选项11g都无效，11g默认的实例名为XE
DB="XEPDB1"
USER="user"
PASS="123456"

sudo mkdir -p /docker/oracle/data/$NAME
sudo mkdir -p /docker/oracle/backup/$NAME

sudo chown 1000:1000 /docker/oracle/data/$NAME
sudo chown 1000:1000 /docker/oracle/backup/$NAME

# 如果版本大于11g，则数据目录为 /opt/oracle/oradata

docker run -d \
    --name $NAME \
    --restart=always \
    --memory="4G" \
    --cpus="2.0" \
    -p $IP:$PORT:1521 \
    -e TZ=PRC \
    -e ORACLE_DATABASE=$DB \
    -e ORACLE_PASSWORD=$PASS \
    -e APP_USER=$USER \
    -e APP_USER_PASSWORD=$PASS \
    --restart=always \
    -v /docker/oracle/data/$NAME:/u01/app/oracle/oradata \
    -v /docker/oracle/backup/$NAME:/mnt/backup \
    gvenzl/oracle-xe:11 \
    --health-cmd healthcheck.sh \
    --health-interval 10s \
    --health-timeout 5s \
    --health-retries 10

# 创建用户
# docker exec <container name|id> createAppUser <your app user> <your app user password> [<your target PDB>]
# 修改sys和system的密码
# docker exec <container name|id> resetPassword <your password>