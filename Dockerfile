# Keep TagLib 1.x for rupeepeethree's taglib-ruby 1.x dependency.
FROM ubuntu:24.04

ARG RUBY_VERSION=3.3.10

ENV DEBIAN_FRONTEND=noninteractive
ARG DOCKER_GROUP_ID

ENV APP_HOME=/home/rails/app \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    LANG=C.UTF-8

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
      ca-certificates \
      curl \
      imagemagick \
      libpq5 \
      libtag1v5 \
      libyaml-0-2 \
      postgresql-client \
      shared-mime-info \
      sox \
      libsox-fmt-mp3 \
      webp && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd --gid 1000 rails && \
    useradd --create-home --uid 1000 --gid 1000 --shell /bin/bash rails && \
    mkdir -p "${APP_HOME}" "${BUNDLE_PATH}" && \
    chown rails:rails "${APP_HOME}" "${BUNDLE_PATH}"

WORKDIR ${APP_HOME}


# Installs native build dependencies and produces the production bundle/assets.
FROM base AS build

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

CMD ["bundle", "exec", "falcon", "host", "config/falcon.rb"]


# Local development target. Source and gems remain bind-mounted by Compose.
FROM base AS development

ARG DOCKER_GROUP_ID
ARG BUNDLER_VERSION=2.5.22

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
      build-essential \
      firefox-esr \
      git \
      libffi-dev \
      libgdbm-dev \
      libgmp-dev \
      libpq-dev \
      libssl-dev \
      libtag1-dev \
      libyaml-dev \
      pkg-config \
      rustc \
      sudo \
      xvfb \
      zlib1g-dev && \
    rm -rf /var/lib/apt/lists/* && \
    if [ -n "${DOCKER_GROUP_ID}" ]; then groupadd --gid "${DOCKER_GROUP_ID}" docker; else groupadd docker; fi && \
    usermod --append --groups docker,sudo rails && \
    printf '%%sudo ALL=(ALL) NOPASSWD: ALL\n' >/etc/sudoers.d/rails && \
    gem install bundler --version "${BUNDLER_VERSION}" --no-document

USER rails

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
