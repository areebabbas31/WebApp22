# Stage 1: Build the app
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src


COPY ./*.sln ./
COPY BulkyBookWeb/BulkyBookWeb.csproj BulkyBookWeb/BulkyBookWeb.csproj
RUN  dotnet restore ./BulkyBookWeb/BulkyBookWeb.csproj


WORKDIR /src
COPY . ./
RUN  dotnet restore ./Bulky.Models/Bulky.Models.csproj
RUN  dotnet restore ./Bulky.Utility/Bulky.Utility.csproj

# Build and publish the solution
RUN dotnet publish BulkyBookWeb.csproj -c Release -o /app/publish

# Stage 2: Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "BulkyBookWeb.dll"]
