FROM ruby:2.3.0
RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends \
  libpq-dev \
  qt5-default \
  libqt5webkit5-dev \
  nodejs

RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/
COPY Gemfile.lock /app/
RUN bundle install
COPY . /app/
