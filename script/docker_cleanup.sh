#!/bin/bash
docker ps -a | grep 'Exit' | awk '{print $1}' | xargs -r docker rm
docker images | grep none | awk '{print $3}' | xargs -r docker rmi

