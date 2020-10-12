FROM postgres:10

LABEL maintainer="hello.boriskas@gmail.com"
LABEL version="1.1"
LABEL description="A base image for Postgres database with Liquibase"

EXPOSE 5432

ENV POSTGRES_HOST=${POSTGRES_HOST:-localhost}\
    POSTGRES_PORT=${POSTGRES_PORT:-5432}\
    POSTGRES_DB=${POSTGRES_DB:-postgres}\
    POSTGRES_USERNAME=${POSTGRES_USERNAME:-postgres}\
    POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-postgres}

RUN apt-get update \
    && apt-get -y -q --no-install-recommends install openjdk-8-jre-headless=8u265-b01-0+deb9u1 procps=2:3.3.12-3+deb9u1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /opt/liquibase /workspace /opt/jdbc /opt/scripts

COPY bin/liquibase-3.6.3.jar /opt/liquibase/liquibase.jar
COPY bin/postgresql-jdbc-42.1.4.jar /opt/jdbc/postgres-jdbc.jar

COPY bin/start.sh /opt/scripts/start.sh
RUN chmod +x /opt/scripts/start.sh

COPY changes /workspace
COPY liquibase.properties /workspace/liquibase.properties

WORKDIR /workspace

ONBUILD COPY changes/* /workspace/changes/

ENTRYPOINT ["/opt/scripts/start.sh"]
