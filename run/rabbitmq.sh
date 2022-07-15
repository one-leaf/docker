#!/bin/sh
IP="192.168.1.1"
PORT=5189
NAME="rabbitmq"
USER="user"
PASS="123456"

docker run -d \
    --name $NAME \
    --hostname kjds_mq \
    --restart=always \
    --memory="8g" \
    --cpus="8.0" \
    -e TZ=PRC \
    -e RABBITMQ_DEFAULT_USER=$USER \
    -e RABBITMQ_DEFAULT_PASS=$PASS \
    -p $IP:15672:15672 \
    -p $IP:5672:5672 \
    -v /docker/rabbitmq:/var/lib/rabbitmq \
    rabbitmq:3-management
