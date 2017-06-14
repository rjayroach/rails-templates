FROM ruby:2.4.1
RUN apt-get update && apt-get install sudo vim tree less postgresql-contrib postgresql-client --yes --no-install-recommends && apt-get clean
RUN touch /usr/local/bundle/config && chmod a+w /usr/local/bundle/config && \
  useradd -ms /bin/bash rails && echo 'rails ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
  mkdir -p /home/rails/gems /home/rails/app/vendor/cache && \
  echo 'set editing-mode vi' > /home/rails/.inputrc && \
  chown -R rails:rails /home/rails

USER rails
ENV HOME /home/rails
WORKDIR /home/rails/app

COPY Gemfile* /home/rails/app/
RUN bundle install #--local --path /home/rails/gems --without development:test --deployment

# Copy in the application code
COPY . /home/rails/app
RUN sudo chown -R rails:rails /home/rails

ENV RAILS_ENV=production TERM=xterm RAILS_LOG_TO_STDOUT=yes
# What port to run on
EXPOSE 3000

# Boot the application; Override this from the command line in order to run other tools
# docker run --env-file .env -e APPLICATION_NAME=device -e API_HOST=172.17.0.1 -e WORKERS=Device::NotificationWorker quay.io/getperx/device  bundle exec rake sneakers:run
# CMD bundle exec rackup -p 3000 -o 0.0.0.0
RUN mkdir -p tmp/pids && ln -s /home/rails/app/.aliases /home/rails/.bash_aliases
CMD bundle exec puma config.ru
