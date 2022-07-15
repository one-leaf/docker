#!/bin/sh
IP="192.168.1.1"
# 注意多个zookeeper 的群集修改 ID 为 1、2、3
ZOO_MY_ID=1
NAME="zookeeper_$ZOO_MY_ID"
ZOO_SERVERS="server.1=192.168.1.1:2888:3888;2181 server.2=192.168.1.2:2888:3888;2181 server.3=192.168.1.3:2888:3888;2181"

sudo mkdir -p /docker/zookeeper/data
sudo mkdir -p /docker/zookeeper/datalog
sudo mkdir -p /docker/zookeeper/logs

sudo chown 1000:1000 /docker/zookeeper/data
sudo chown 1000:1000 /docker/zookeeper/datalog
sudo chown 1000:1000 /docker/zookeeper/logs

docker run -d \
    --name $NAME \
    --restart=always \
    --memory="2g" \
    --cpus="1.0" \
    -p $IP:2181:2181 \
    -p $IP:2888:2888 \
    -p $IP:3888:3888 \
    -e TZ=PRC \
    -e ZOO_MY_ID="$ZOO_MY_ID" \
    -e ZOO_SERVERS="$ZOO_SERVERS" \
    -e ZOO_4LW_COMMANDS_WHITELIST="*" \
    -e ZOO_CFG_EXTRA="quorumListenOnAllIPs=true" \
    -v /docker/zookeeper/data:/data \
    -v /docker/zookeeper/datalog:/datalog \
    -v /docker/zookeeper/logs:/logs \
    zookeeper:3.8