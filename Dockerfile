# Stage 1: Build the app
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# Copy solution and restore dependencies
COPY ./*.sln ./
RUN ls -R ./
COPY Bulky.Models/Bulky.Models.csproj ./Bulky.Models # copies all csproj files from subfolders
RUN for file in ./Bulky.Models/Bulky.Models.csproj
RUN ls -R ./
RUN pwd && ls -R .
# Copy the rest of the source code
WORKDIR /src
COPY ./* ./*
WORKDIR /src/BulkyBookWeb

# Build and publish the solution
RUN dotnet publish BulkyBookWeb.csproj -c Release -o /app/publish

# Stage 2: Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "BulkyBookWeb.dll"]
