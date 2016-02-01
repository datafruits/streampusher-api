# streampusher rails app
[![build
status](https://gitlab.com/ci/projects/4542/status.png?ref=master)](https://gitlab.com/ci/projects/4542?ref=master)

# dev environment

## system dependencies:
* [docker](https://docs.docker.com/engine/installation)
* [docker-compose](https://docs.docker.com/compose/install/)

You can use [docker machine](https://docs.docker.com/engine/installation/windows/) on windows/osx.

run `script/setup` to install gems and create database

```
$ ./script/setup
```

run app with docker-compose

```
$ ./script/app
```

