#!/bin/sh
IP="192.168.1.1"
NAME="portainer"

docker run -d \
    --name $NAME \
    --restart=always \
    --memory="256m" \
    --cpus="1.0" \
    -p $IP:9000:9000 \
    -e TZ=PRC \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    docker.io/portainer/portainer