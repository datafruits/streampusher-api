FROM ruby:2.2.3

RUN apt-get update -qq && apt-get install -y build-essential libtag1-dev libqtwebkit-dev qt4-qmake
