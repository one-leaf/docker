#!/bin/sh
IP="192.168.1.1"
NAME="ibmmq"
PASS="passw0rd"

sudo mkdir -p /docker/mq/
sudo chown 1001:1001 /docker/mq/

docker run -d \
    --name $NAME \
    --restart=always \
    --memory="8g" \
    --cpus="8.0" \
    -e TZ=PRC \
    -e LICENSE=accept \
    -e MQ_QMGR_NAME=QM1 \
    -e MQ_ADMIN_PASSWORD=$PASS \
    -p $IP:1414:1414 \
    -p $IP:9443:9443 \
    -v /docker/mq:/mnt/mqm \
    ibmcom:mq
