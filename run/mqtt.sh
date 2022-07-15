#!/bin/sh
IP="192.168.1.1"
NAME="mqtt"

docker run -d \
        --name $NAME \
        --restart=always \
        --memory="4g" \
        --cpus="4.0" \
        -e TZ=PRC \
        -p $IP:1883:1883 \
        -p $IP:9001:9001 \
        -v /docker/mqtt/config:/mosquitto/config \
        -v /docker/mqtt/log:/mosquitto/log \
        -v /docker/mqtt/data/:/mosquitto/data/ \
        eclipse-mosquitto:2

# 1883 是 tcp 端口 9001 是 ws 端口
# 出于安全考虑，需要创建用户， 用户名 mqtt ，密码 123456 
# docker exec -it mqtt mosquitto_passwd -c /mosquitto/config/pwfile mqtt 123456
