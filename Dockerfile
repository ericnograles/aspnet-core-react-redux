FROM microsoft/dotnet:latest
WORKDIR /app
COPY . .
CMD dotnet run
