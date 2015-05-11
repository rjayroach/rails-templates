FROM ruby:2.2
RUN apt-get update && apt-get install mysql-client --yes && apt-get clean
RUN mkdir /app
WORKDIR /app
ADD Gemfile* /app/
RUN bundle config mirror.https://rubygems.org http://172.17.42.1:9000
RUN bundle install --without development --deployment
ADD . /app
EXPOSE 3000
CMD bundle exec rackup -p 3000 -o 0.0.0.0
