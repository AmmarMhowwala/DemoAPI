FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

ENV ASPNETCORE_URLS=http://*:80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["DemoApi.csproj", "./"]
RUN dotnet restore "DemoApi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DemoApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DemoApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DemoApi.dll"]
