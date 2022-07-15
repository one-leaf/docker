#!/bin/sh
curl -s -X POST -u elastic:password -H "Content-Type: application/json" http://192.168.1.1:9200/_security/user/kibana_system/_password -d "{\"password\":\"password\"}"
chown -R 1000 ./elasticsearch/data