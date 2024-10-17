# Use the official ASP.NET Core runtime as the base image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Use the official SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["SimpleApi.csproj", "./"]
RUN dotnet restore "./SimpleApi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "SimpleApi.csproj" -c Release -o /app/build

# Publish the app
FROM build AS publish
RUN dotnet publish "SimpleApi.csproj" -c Release -o /app/publish

# Use the runtime image to run the app
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SimpleApi.dll"]
