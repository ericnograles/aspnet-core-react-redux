# Windows-less and Dockerized ASP .Net Core, React + Redux, and SQL Server 2017

## Overview

A sample boilerplate of the .Net Core + React/Redux template for exclusively *nix machines with minimal prerequisites.

## Prerequisites

1. [Docker](https://www.docker.com/get-started)
1. [.Net Core SDK](https://dotnet.microsoft.com/download)
1. [Visual Studio Code](https://code.visualstudio.com/)

## Instructions

### Scaffolding

1. Clone this repo
1. Execute this command: `echo 'APP_DB_CONNECTION_STRING=Data Source=aspnet_core_react_redux-db,1433;Initial Catalog=AppDB;User ID=app_service;Password=app(!)STRONG_password;' >> .env`
1. Execute `gem install docker-sync` or `sudo gem install docker-sync`
1. Execute `docker-sync-daemon start && docker-compose up -d`
1. In a separate terminal, execute `docker-compose logs -f` and wait for .Net Core to come up, could take a minute or two at first run.
1. Execute `./docker/initdb`
1. Browse to `http://localhost:5000`
1. Locally, open this repo in VS Code and start developing

### Teardown

`docker-compose down && docker-sync-daemon stop`

### Logging

`docker-compose logs && docker-sync-daemon logs`

### Troubleshooting

I've seen docker-sync get 😎 out of sync at times. This is generally solved by restarting Docker altogether and following the instructions from Step 4 above in `Scaffolding/Development`

## Development Process

### Coding

- Any changes made to the project's directories will reflect automatically in the container
- This container runs `dotnet watch run` which will keep track of both the SPA (under `ClientApp` and .Net Code)
  - I'd recommend executing a `docker-compose logs -f` to keep an eye on both the .Net and SQL Server container

### Dependency Management

- You can open a bash into the .Net container by executing `./docker/dotnet/bash`. From there, execute any `dotnet add package` commands you need
  - Your container should automatically restart/rebuild
  - On your host machine, VS Code may ask to Restore Dependencies when you add/remove dependencies. Feel free to have VS Code update the dependencies on your host machine as well

### Entity Framework Migrations

- There is a convenience script: `./docker/dotnet/migrate`.  To use, simply execute `./docker/dotnet/migrate MyMigrationName`.
  - This will execute `dotnet ef migrations add MyMigrationName` and `dotnet ef database update` in your .Net container

### Connecting to SQL Server from Host

- As specified in the .env file you created when scaffolding, the Connection String is `APP_DB_CONNECTION_STRING=Data Source=aspnet_core_react_redux-db,1433;Initial Catalog=AppDB;User ID=app_service;Password=app(!)STRONG_password;`

## What About SQL Server Management Studio?

Being an ex-SQL Server guy, I know how good SSMS is -- I always argue it's one of the best database GUI's I've ever seen.  However, in *nix world, we don't have the option of SSMS for convenience.  What to do?

It turns out, jetBrains, the makers of the hugely popular ReSharper, WebStorm, and IntelliJ products have created a database GUI on top of IntelliJ called [DataGrip](https://www.jetbrains.com/datagrip/). Coming from an ex-SSMS addict, I can safely say this is at parity with SSMS, and is in some cases superior to it!

## Under the Hood

### Docker

This boilerplate uses Docker (specifically `docker-compose`) to install all infrastructure and prereqs that otherwise would take quite a bit of time to setup locally.

If you peek at the `docker-compose.yml` file, you'll see that we have Dockerfiles for .Net Core and SQL Server sitting in the `/docker` folder.

#### /docker/dotnet

This custom Dockerfile for .Net Core brings in the latest LTS Node.js as of this writing (10.14.1) on top of the standard .Net Docker image.

This is important, as React needs Node.js installed to work properly.

#### /docker/sql-server

This custom Dockerfile helps scaffold SQL Server with defaults to get going.  You'll notice the username and password from the connection string we `echo`'d into the `.env` file on the root.  Feel free to change the values to whatever you feel like.

#### /docker/initdb

This is simply an executable that launches a corresponding `initdb` under the `sql-server` folder. This creates the app DB, login, and user + dbo privileges via the `sqlcmd` utility

### docker-sync

You'll notice the `gem install docker-sync` as part of the initialization.  In case you're curious, [docker-sync](http://docker-sync.io/) is a utility that allows your host's filesystem (i.e. your dev machine) perform at native speed in a Docker container.

Without this utility, `dotnet watch` would execute file polling for changes, and would consume all of your container's resources. You may have seen this problem if you've tried Docker development using `webpack-dev-server`.
