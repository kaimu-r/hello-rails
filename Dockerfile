FROM ruby:3.2.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /myapp

WORKDIR /myapp

ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock

RUN bundle install

ADD . /myapp
