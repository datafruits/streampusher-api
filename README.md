#RUNNING

## system dependencies:
* ruby
* postgres
* docker
* fig

## get these repos
* streampusher/docker_stack
* streampusher/stream_pusher

```
$ cd docker_stack
$ fig up
```

Run the rails app like normal:
```
$ rails s
```

and start sidekiq:
```
$ bundle exec sidekiq
```
