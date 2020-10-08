#!/bin/sh

run_postgres() {
  # The entry point of Postgres from the base image
  docker-entrypoint.sh postgres
}

run_liquibase() {
  # Default flag of Postgres to check whether it's ready or not.
  # https://www.postgresql.org/docs/9.3/app-pg-isready.html
  until pg_isready
  do
    echo "waiting for postgres"
    sleep 1;
  done

  # Liquibase is the second background process. During any patching errors,
  # it won't affect the docker container at all. That's why we have to kill
  # the main connected process - Postgres.
  java -jar /opt/liquibase/liquibase.jar \
    --username $POSTGRES_USERNAME \
    --password $POSTGRES_PASSWORD \
    --url jdbc:postgresql://$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB \
    update \
    || pkill postgres;
}

# 1. Run liquibase in the background process since the start
# 2. Run the main process in the foreground
# 3. We will patch the database from the background when it has been ready
run_liquibase &
run_postgres
