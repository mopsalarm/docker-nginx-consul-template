#!/bin/sh

set -e

docker build -t mopsalarm/nginx-consul-template .
docker push mopsalarm/nginx-consul-template
