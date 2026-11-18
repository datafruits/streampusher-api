# syntax=docker/dockerfile:1.7

ARG RUBY_VERSION=3.3.10

FROM ruby:${RUBY_VERSION}-slim-bookworm AS base

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

ARG BUNDLER_VERSION=2.5.22

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
      build-essential \
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
      zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./

RUN gem install bundler --version "${BUNDLER_VERSION}" --no-document && \
    bundle config set without "development test" && \
    bundle install && \
    rm -rf /root/.bundle "${BUNDLE_PATH}"/ruby/*/cache

COPY . .

# Rails can compile assets without production credentials or a live database.
RUN SECRET_KEY_BASE_DUMMY=1 RAILS_ENV=production bundle exec rails assets:precompile && \
    rm -rf tmp/cache


# Immutable deployment image. It contains the application, bundle, and assets.
FROM base AS production

ENV RAILS_ENV=production \
    RACK_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    FALCON_BIND=http://0.0.0.0:3000 \
    BUNDLE_WITHOUT="development:test"

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build --chown=rails:rails ${APP_HOME} ${APP_HOME}

RUN mkdir -p log storage tmp/pids tmp/cache && \
    chown -R rails:rails log storage tmp

USER rails

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
