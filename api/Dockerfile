######################
# Stage: Builder
FROM ruby:2.6.3-alpine as Builder

ARG FOLDERS_TO_REMOVE
ARG BUNDLE_WITHOUT

RUN apk add --update --no-cache \
    build-base \
    postgresql-dev \
    postgresql-client \
    tzdata \
    openssh-client

WORKDIR /usr/src

# Install gems
ADD Gemfile* /usr/src/
RUN bundle config --global frozen 1 \
 && bundle install -j4 --retry 3 \
 # Remove unneeded files (cached *.gem, *.o, *.c)
 && rm -rf /usr/local/bundle/cache/*.gem \
 && find /usr/local/bundle/gems/ -name "*.c" -delete \
 && find /usr/local/bundle/gems/ -name "*.o" -delete

# Add the Rails app
ADD . /usr/src

# Remove folders not needed in resulting image
RUN rm -rf $FOLDERS_TO_REMOVE

###############################
# Stage Final
FROM ruby:2.6.3-alpine

# Add Alpine packages
RUN apk add --update --no-cache \
    build-base \
    postgresql-dev \
    postgresql-client \
    tzdata \
    openssh-client

# Copy app with gems from former Builder stage
COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=Builder /usr/src /usr/src

ENV RAILS_LOG_TO_STDOUT true

WORKDIR /usr/src

RUN chmod +x ./docker/*.sh
