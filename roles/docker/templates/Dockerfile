# NOTES:
# There are three build arguments which are all set to production values, so to build the production image:
# docker build -t repo/project:version .
# To build the development image, pass values for bundle_string, rails_env and os_packages:
# docker build --build-arg bundle_string='' --build-arg rails_env=development -t repo/project:version-dev .

# Build the 'base' container
FROM ruby:2.5.1-stretch as base

# WORKDIR needs to be the same as in the final base image or compiled gems will point to an invalid directory
RUN mkdir -p /home/rails
WORKDIR /home/rails

# Install gems that need compiling first b/c they can take a long time to compile
RUN gem install \
    nokogiri:1.8.2 \
    ffi:1.9.23 \
    nio4r:2.3.0 \
    puma:3.11.4 \
    sqlite3:1.3.13

# Don't use the --deployment flag since this is a container. See: http://bundler.io/man/bundle-install.1.html#DEPLOYMENT-MODE
COPY Gemfile* ./
ARG bundle_string='--without development test'
RUN bundle install ${bundle_string} \
 && find /usr/local/bundle -iname '*.o' -exec rm -rf {} \; \
 && find /usr/local/bundle -iname '*.a' -exec rm -rf {} \;


# Runtime container
FROM ruby:2.5.1-slim-stretch
COPY --from=base /usr/local/bundle /usr/local/bundle

# Install OS packages and create a non-root user to run the application
# To compile pg gem: libpq-dev
# To install pg client to run via bash: postgresql-client
<% if app.postgres? -%>
ARG os_packages='libpq5'
<% else -%>
ARG os_packages='sqlite3'
<% end -%>

RUN useradd -ms /bin/bash rails \
 && apt-get update \
 && apt-get install --yes --no-install-recommends ${os_packages} \
 && apt-get clean

# Rails operations
WORKDIR /home/rails
COPY --chown=rails:rails . ./

# ln -s /home/rails/app/aliases /home/rails/.bash_aliases
ARG rails_env=production
ENV RAILS_ENV=${rails_env} TERM=xterm RAILS_LOG_TO_STDOUT=yes
<% if app.grpc? -%>
EXPOSE 3000 50051
<% else -%>
EXPOSE 3000
<% end -%>

USER rails:rails
# RUN bundle exec rails assets:precompile
# Boot the application; Override this from the command line in order to run other tools
# docker run --env-file .env -e APPLICATION_NAME=device -e API_HOST=172.17.0.1 -e WORKERS=Device::NotificationWorker quay.io/getperx/device  bundle exec rake sneakers:run
# CMD bundle exec rackup -p 3000 -o 0.0.0.0
CMD bundle exec puma config.ru
