# streampusher rails app
[![build
status](https://gitlab.com/ci/projects/4542/status.png?ref=master)](https://gitlab.com/ci/projects/4542?ref=master)

#RUNNING

## system dependencies:
* ruby
* postgres
* docker
* docker-compose

## get these repos
* streampusher/docker_stack
* streampusher/stream_pusher

```
$ cd docker_stack
$ docker-compose up
```

Run the rails app like normal:
```
$ rails s
```

and start sidekiq:
```
$ bundle exec sidekiq
```
