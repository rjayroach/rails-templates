# NOTES:
# to build just the build-stage: docker build --target build-env -t tag_name:build-env .
# to build the final stage: docker build -t tag_name .
ARG rails_env = production


FROM ruby:2.5.1-stretch as build-stage
# NOTE: For some reason the user needs to be set in this context as well as in final build context
RUN useradd -ms /bin/bash rails \
 && mkdir /home/rails/app \
 && chown -R rails:rails /home/rails \
 && chown -R rails /usr/local/bundle

# To be more sure that permissions are working, install gems as the user rails
USER rails:rails

RUN gem install \
    msgpack:1.2.4 \
    nokogiri:1.8.2 \
    ffi:1.9.23 \
    nio4r:2.3.0 \
    puma:3.11.3 \
    sqlite3:1.3.13 \
    therubyracer:0.12.3 \
    grpc grpc-tools protobuf-activerecord \
 && find /usr/local/bundle -iname '*.o' -exec rm -rf {} \; \
 && find /usr/local/bundle -iname '*.a' -exec rm -rf {} \;

# NOTE: WORKDIR needs to be the same as in the final base image or compiled gems will point to an invalid directory
WORKDIR /home/rails/app
COPY Gemfile ./
# NOTE: Don't use the --deployment flag since this is a container. See: http://bundler.io/man/bundle-install.1.html#DEPLOYMENT-MODE
RUN bundle install --without development test


# The actual container to be built
FROM ruby:2.5.1-slim-stretch

# Root operations
RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
    sqlite3 \
 && apt-get clean \
 && useradd -ms /bin/bash rails \
 && echo 'set editing-mode vi' > /home/rails/.inputrc

# RUN apt-get update && apt-get install sudo vim tree less postgresql-contrib postgresql-client --yes --no-install-recommends && apt-get clean
COPY --from=build-stage /usr/local/bundle /usr/local/bundle

# Rails operations
USER rails:rails
WORKDIR /home/rails/app
COPY --chown=rails:rails . ./

# RUN sudo chown -R rails:rails /home/rails && mkdir -p tmp/pids # && ln -s /home/rails/app/aliases /home/rails/.bash_aliases
# ENV HOME /home/rails RAILS_ENV=production TERM=xterm RAILS_LOG_TO_STDOUT=yes
ENV RAILS_ENV=${rails_env} TERM=xterm RAILS_LOG_TO_STDOUT=yes
<% if app.applied.include?(:grpc) -%>
EXPOSE 3000 50051
<% else -%>
EXPOSE 3000
<% end -%>

# Boot the application; Override this from the command line in order to run other tools
# docker run --env-file .env -e APPLICATION_NAME=device -e API_HOST=172.17.0.1 -e WORKERS=Device::NotificationWorker quay.io/getperx/device  bundle exec rake sneakers:run
# CMD bundle exec rackup -p 3000 -o 0.0.0.0
CMD bundle exec puma config.ru
