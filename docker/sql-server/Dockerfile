FROM mcr.microsoft.com/mssql/server:latest

ENV ACCEPT_EULA Y
ENV SA_PASSWORD one(!)STRONG_password
ENV APP_DB AppDB
ENV APP_DB_ACCOUNT app_service
ENV APP_DB_ACCOUNT_PASSWORD app(!)STRONG_password

COPY docker/sql-server/initdb /usr/local/bin/initdb

CMD [ "/opt/mssql/bin/sqlservr" ]