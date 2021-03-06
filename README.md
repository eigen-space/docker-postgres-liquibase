# About

A base image for Postgres database with Liquibase.

# Usage

1. Create a folder for your project with:
    1. `Dockerfile`
    2. `changes` folder
        1. `master.xml` — aggregates all changes. An example is located here as `master.sample.xml`
        2. `your-change.sql` — one of your changesets. An example is located here as `001--sample-changeset.sql`

2. Build this project into your local registry if you have made some changes here:
    ```
    docker build -t akaeigenspace/docker-postgres-liquibase .
    ```

3. Inherit this base image in the Dockerfile:\
    `FROM akaeigenspace/docker-postgres-liquibase:$version`, where a version is a number or `latest`

4. Build
    ```
    docker build -t hello-world .
    ```

5. Run
    ```
    docker run -it -e POSTGRES_DB=postgres -e POSTGRES_PASSWORD=000000 -e POSTGRES_HOST=localhost -e POSTGRES_PORT=5432 -e POSTGRES_USERNAME=postgres -p 5432:5432 hello-world
    ```

# Linter

It's highly recommended to validate your changes by running this command:\
`docker run --rm -i hadolint/hadolint < Dockerfile`

# Params

| Environment Variable | Purpose | Default |
|----------------------|---------|---------|
| POSTGRES_HOST | Database host to connect to | localhost |
| POSTGRES_PORT | Database port to connect to | 5432 |
| POSTGRES_DB | Database name to connect to | postgres |
| POSTGRES_USERNAME | Username to connect to database as | postgres |
| POSTGRES_PASSWORD | Password for username | postgres |

# Project 

```
/bin
    /*.* - all required binary dependencies
    /start.sh — an entry point which starts Postgres and Liquibase
/changes
    /001--sample-changeset.sql - an example of some changeset
    /master.sample.xml - an example of all changes aggregator 
    /dbchangelog-3.5.xsd — allows us to use the custom XML-tags like include
/liquibase.properties — contains the configuration for Liquibase
```

# Dependencies

* `postgres:10` — a base official image with Postgres DB
* `openjdk-8-jre-headless:8u265-b01-0` — stripped down version of Java, used for Liquibase.
Here "headless" means "without GUI support", so it is our case.
It allows us to use the minimum-weighted java runtime for our purposes.
See the more comments on [stackoverflow issue](https://stackoverflow.com/questions/24280872/difference-between-openjdk-6-jre-openjdk-6-jre-headless-openjdk-6-jre-lib)
* `liquibase:3.6.3` — an executable binary of Liquibase
* `postgresql-jdbc:42.1.4` — a driver which is used for the Postgres DB connection
* `procps:2:3.3.12-3+deb9u1` — used for the killing the Postgres process.
It allows us kill process by name using the command `pkill`, not only by PID 
as the command `kill`
