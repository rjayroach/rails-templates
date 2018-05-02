
## Docker

### Production

The preferred way to run the application in production is as a docker container. The production application
is comprised of three containers: `redis`, `sidekiq` and `app`. Sidekiq and app are based on the
production image. The sidekiq container processes jobs while the app container runs the web server and scheduler.
The production application containers can be started using the docker-compose.yml file.

#### Initialization

Before running the application for the first time the credentials need to be set and the database needs to
be migrated and seeded.

The compose file expects a .env file with sensitive credentials to be available in the root of the
directory. These values are provided to the container. There is a sampele .env file provided

```bash
cp .env.example .env
```

Make any changes necessary for credentials, scheduling and image name and tag then build the image.
After the image is built, run the rake task to migrate and seed the database.

```bash
docker-compose build
docker-compose run app rails db:setup
```

The compose file has environment variables that trigger import and notify jobs to be scheduled at a regular intervals
so simply starting the application is all that is needed. No manual action should be necessary for normal operations.

```bash
docker-compose up -d
```

#### Manually run import

First disable the automatic running of import and notify by removing all ENVs from the docker-compose.yml
file that start with `SCHEDULE_`.

Next, either run a one-off process like so:

```bash
docker-compose run app rails runner 'Repository.first.read'
```

OR start a console on the `app` container like so:

```bash
docker exec -it solar_app_1 rails console
```

From the console you can run one or more commands:

```bash
Repository.first.read
```

If the container is not currently running then you need to start it first:

```bash
docker-compose up -d
```

### Development and Testing

The production application requires an external database and external FTP providers. For development and
testing, the docker-compose-dev.yml file defines two additional containers, a postgres database and a
test FTP server. These containers are linked to the already defined containers to provide a fully self contained
environment.

All of the production steps and commands apply to the development environment so
To run the development application follow the same steps as in production section, but with one change:
provide both the docker-compose.yml and docker-compose-dev.yml when running any compose commands:

```bash
docker-compose -f docker-compose.yml -f docker-compose-dev.yml build
docker-compose -f docker-compose.yml -f docker-compose-dev.yml run app rails db:setup
docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d
```
