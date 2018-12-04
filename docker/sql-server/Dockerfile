FROM mcr.microsoft.com/mssql/server:latest

ENV ACCEPT_EULA Y
ENV SA_PASSWORD one(!)STRONG_password
ENV DB_NAME AppDB

COPY docker/sql-server/initdb /usr/local/bin/initdb

CMD [ "/opt/mssql/bin/sqlservr" ]