FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /reactive
WORKDIR /reactive
ADD Gemfile /reactive/Gemfile
ADD Gemfile.lock /reactive/Gemfile.lock
RUN bundle install
ADD . /reactive
