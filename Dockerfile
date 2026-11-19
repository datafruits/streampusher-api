# Keep TagLib 1.x for rupeepeethree's taglib-ruby 1.x dependency.
FROM ubuntu:24.04

# locale
# RUN locale-gen ja_JP.UTF-8 && \
#     locale-gen en_US.UTF-8
# ENV LANG en_US.UTF-8

ENV DEBIAN_FRONTEND=noninteractive
ARG DOCKER_GROUP_ID

RUN apt update
RUN apt upgrade -y
RUN apt-get install -y build-essential libtag1-dev libffi-dev \
  xvfb firefox git curl sox libsox-fmt-mp3 libpq-dev imagemagick sudo postgresql-client

# for ruby
RUN apt-get install -y --force-yes autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev


# RUN apt-get clean

# Reuse Ubuntu's default account to keep UID/GID 1000 for bind mounts.
RUN if getent passwd ubuntu >/dev/null; then \
      groupmod --new-name rails ubuntu && \
      usermod --login rails --home /home/rails --move-home --shell /bin/bash ubuntu; \
    else \
      groupadd --gid 1000 rails && \
      useradd --create-home --shell /bin/bash --uid 1000 --gid rails rails; \
    fi && adduser rails sudo
RUN echo "Defaults    !requiretty" >> /etc/sudoers
RUN echo "%sudo ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN if [ -n "$DOCKER_GROUP_ID" ]; then \
      groupadd -g "$DOCKER_GROUP_ID" docker; \
    else \
      groupadd docker; \
    fi
RUN gpasswd -a rails docker

USER rails
ENV HOME=/home/rails
# Install rbenv and ruby-build
ENV RUBY_VERSION=3.4.13
RUN git clone https://github.com/rbenv/rbenv.git /home/rails/.rbenv
RUN git clone https://github.com/rbenv/ruby-build.git /home/rails/.rbenv/plugins/ruby-build
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/rails/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> /home/rails/.bashrc
ENV PATH=/home/rails/.rbenv/shims:/home/rails/.rbenv/bin:$PATH

ENV CONFIGURE_OPTS=--disable-install-doc
RUN rbenv install $RUBY_VERSION
RUN rbenv global $RUBY_VERSION
RUN echo 'gem: --no-rdoc --no-ri' >> /home/rails/.gemrc
RUN rbenv exec gem update --system
RUN rbenv exec gem install bundler -v 2.5.22
RUN rbenv rehash
RUN rbenv exec bundle config --global github.https true

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
