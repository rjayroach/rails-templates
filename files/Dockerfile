FROM ruby:2.2
RUN apt-get update && apt-get install mysql-client --yes && apt-get clean
RUN mkdir -p /app/vendor/cache
WORKDIR /app
COPY Gemfile* /app/
COPY vendor/cache vendor/cache/
RUN bundle install --local --without development:test --deployment
COPY . /app
RUN bundle exec rake assets:precompile
EXPOSE 3000
CMD bundle exec rackup -p 3000 -o 0.0.0.0

# Before running docker build
# bundle package --all

# Build the container
# docker build -t rjayroach/dashboard .

# Run the container on dev machine connecting to dashboard_development database on localhost
# docker run -i -t --rm --name dashboard -e RAILS_ENV=development -e DATABASE_HOST=172.17.42.1 -e DATABASE_NAME=dashboard_development -e DATABASE_USER=perx -e DATABASE_PASSWORD=12345 -p 3000:3000 rjayroach/dashboard

# Push the container
# docker push
