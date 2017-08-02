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

run `script/setup` to install gems and create database

```
$ ./script/setup
```

run app with docker-compose

```
$ ./script/app
```

## without docker

You can run the app without docker, you won't be able to run the actual
liquidsoap/icecast instances however. Here is how you would do that.

Install ruby with rbenv or something.

#### system deps
* ruby (2.3 or higher)
* bundler
* node
* postgresql
* redis

* taglib-dev
```
sudo apt-get install libtag1-dev
```

##### setup
```
$ cp config/database.example.yml config/database.yml
$ bundle install
$ bundle exec rake db:create
$ bundle exec rake db:migrate
```

If you want to work on the ember sections of the app you will need to install
the npm dependencies with this command.
```
$ bundle exec rake ember:install
```

Make sure redis is running somewhere.
```
$ redis-server
```

Start the rails app.
```
$ rails s
```

It should be accessible on localhost:3000 now.

Start sidekiq to process background jobs.
```
$ bundle exec sidekiq
```
