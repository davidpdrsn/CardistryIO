FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install -y --no-install-recommends libpq-dev nodejs qt5-default libqt5webkit5-dev

RUN mkdir /app
WORKDIR /app
ENV BUNDLE_PATH /box
COPY . /app/
