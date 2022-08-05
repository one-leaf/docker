#!/bin/sh
IP="192.168.1.1"
PORT=1521
NAME="oracle_$PORT"

# 版本支持 21c, 18c, 11g
# 以下选项11g都无效，11g默认的实例名为XE，用户名sys，密码为$PASS
# 11g 需要使用 sys as SYSDBA 登录后，自行创建用户
# 12c 和 18c 默认实例名 XEPDB1 
DB="XEPDB1"
USER="user"
PASS="123456"

sudo mkdir -p /docker/oracle/data/$NAME
sudo mkdir -p /docker/oracle/backup/$NAME

sudo chown 1000:1000 /docker/oracle/data/$NAME
sudo chown 1000:1000 /docker/oracle/backup/$NAME

# 11g的数据目录为 /u01/app/oracle/oradata
# 如果21c, 18c，则数据目录为 /opt/oracle/oradata ，
# XE版 的限制： 
#   1 最大数据库大小为 11 GB 
#   2 可使用的最大内存是 1G
#   3 一台机器上只能安装一个 XE 实例
#   4 只能使用单 CPU

docker run -d \
    --name $NAME \
    --restart=always \
    --memory="1G" \
    --cpus="1.0" \
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