# Streampusher API
[![Build Status](https://github.com/datafruits/streampusher-api/workflows/CI/badge.svg)](https://github.com/datafruits/streampusher-api/actions?workflow=CI)

# dev environment

## system dependencies:
* [docker](https://docs.docker.com/engine/installation)
* [docker-compose](https://docs.docker.com/compose/install/)

You can use [docker machine](https://docs.docker.com/engine/installation/windows/) on windows/osx.

You probably want to add your user to the docker group if you haven't already:
```
$ sudo usermod -aG docker myuser
```

# Run streampusher with docker

run `script/setup` to install gems and create database

```
$ ./script/setup
```

run app with docker-compose

```
$ ./script/app
```

You may have to build the streampusher/streampusher container to get the correct
docker group ID from your host machine.

```
docker build \ 
  --build-arg DOCKER_GROUP_ID=`getent group docker | \ 
  cut -d: -f3` -t streampusher/streampusher:latest .
```
