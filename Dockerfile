# Stage 1: Build the app
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# Copy solution and restore dependencies
COPY ./*.sln ./
COPY ./*.csproj ./  # copies all csproj files from subfolders
RUN for file in ./*.csproj; do dotnet restore "$file"; done

# Copy the rest of the source code
COPY ./* ./*
WORKDIR /src

# Build and publish the solution
RUN dotnet publish bulky.sln -c Release -o /app/publish

# Stage 2: Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "WebApp.dll"]
