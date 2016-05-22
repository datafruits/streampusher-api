You can run the app without docker, but you be able to start the
icecast/liquidsoap containers to run your radio.

install rbenv and ruby 2.3.1
```
$ brew update
$ brew install rbenv
$ rbenv install 2.3.1
```

Add rbenv to your ~/.bash_profile to have it always loaded.
```
$ echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
```

install postgresql
```
$ brew install postgresql
```

install redis
```
$ brew install redis
```

You will need node and npm to run the ember app.

```
$ brew install node
```

```
$ bundle install
$ bundle exec rake db:create
$ bundle exec rake db:migrate
$ bundle exec rake ember:install
```

If everything went well, you should be able to start the rails server:
```
./bin/rails s
```

Then go to `localhost:3000` and see the app running.
