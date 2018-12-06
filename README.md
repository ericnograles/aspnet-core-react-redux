# Windows-less and Dockerized ASP .Net Core, React + Redux, and SQL Server 2017

## Overview

A sample boilerplate of the .Net Core + React/Redux template for exclusively *nix machines with minimal prerequisites.

## Prerequisites

1. [Docker](https://www.docker.com/get-started)
1. [.Net Core SDK](https://dotnet.microsoft.com/download)
1. [Visual Studio Code](https://code.visualstudio.com/)

## Getting Started

1. Clone this repo
1. Execute this command: `echo 'APP_DB_CONNECTION_STRING=Server=aspnet_core_react_redux-db;Database=AppDB;User=app_service;Password=app(!)STRONG_password;' >> .env`
1. Execute `gem install docker-sync` or `sudo gem install docker-sync`
1. Execute `docker-sync-stack start`
1. Wait for .Net Core to come up, could take several minutes at first run
1. Execute `./docker/initdb`
1. Browse to `http://localhost:5000`
1. Locally, open this repo in VS Code and start developing
1. Press Ctrl + C to bring down the scaffold when you're finished (though, you could keep it running)

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
