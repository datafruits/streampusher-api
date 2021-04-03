# Comment on bounty
Everything that requires an AWS key doesn't run. Every error related to '''collect_stats_spec''' , is because i don't have ICECAST_STATS_HOST in .env.
Every other error is a mail error, if you run the test on your machine it should work, since it's looking for user.subscription in the database.
# streampusher rails app
[![build
status](https://gitlab.com/ci/projects/4542/status.png?ref=master)](https://gitlab.com/ci/projects/4542?ref=master)

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
