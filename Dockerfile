FROM ubuntu:14.04

# locale
RUN locale-gen ja_JP.UTF-8 && \
    locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential libtag1-dev libqtwebkit-dev qt4-qmake \
  xvfb firefox git curl sox libsox-fmt-mp3 libpq-dev imagemagick

# for ruby
RUN apt-get install -y --force-yes libssl-dev libreadline-dev

# node
RUN apt-get install -y nodejs npm

RUN apt-get clean

# add user
RUN groupadd -g 1000 rails && useradd --create-home -s /bin/bash -u 1000 -g 1000 rails ;\
 adduser rails sudo
RUN echo "Defaults    !requiretty" >> /etc/sudoers
RUN echo "%sudo ALL=NOPASSWD: ALL" >> /etc/sudoers

USER rails
ENV HOME /home/rails
# Install rbenv and ruby-build
RUN git clone https://github.com/rbenv/rbenv.git /home/rails/.rbenv
RUN git clone https://github.com/rbenv/ruby-build.git /home/rails/.rbenv/plugins/ruby-build
RUN echo "export RBENV_ROOT=/usr/local/rbenv" >> /home/rails/.bashrc
RUN echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /home/rails/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> /home/rails/.bashrc
ENV PATH /home/rails/.rbenv/bin:$PATH
ENV RBENV_ROOT /home/rails/.rbenv

ENV CONFIGURE_OPTS --disable-install-doc
RUN rbenv install 2.3.0
RUN rbenv global 2.3.0
RUN echo 'gem: --no-rdoc --no-ri' >> /home/rails/.gemrc
RUN rbenv exec gem install bundler

# Configure the main working directory. This is the base
# # directory used in any further RUN, COPY, and ENTRYPOINT
# # commands.
RUN mkdir -p /home/rails/app
WORKDIR /home/rails/app

# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3000

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
