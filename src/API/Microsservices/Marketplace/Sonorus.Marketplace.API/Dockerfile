# Acesse https://aka.ms/customizecontainer para saber como personalizar seu contêiner de depuração e como o Visual Studio usa este Dockerfile para criar suas imagens para uma depuração mais rápida.

# Esta fase é usada durante a execução no VS no modo rápido (Padrão para a configuração de Depuração)
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081


# Esta fase é usada para compilar o projeto de serviço
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["Microsservices/Marketplace/Sonorus.Marketplace.API/Sonorus.Marketplace.API.csproj", "Microsservices/Marketplace/Sonorus.Marketplace.API/"]
COPY ["SharedKernel/Sonorus.SharedKernel/Sonorus.SharedKernel.csproj", "SharedKernel/Sonorus.SharedKernel/"]
COPY ["Microsservices/Marketplace/Sonorus.Marketplace.Application/Sonorus.Marketplace.Application.csproj", "Microsservices/Marketplace/Sonorus.Marketplace.Application/"]
COPY ["Microsservices/Marketplace/Sonorus.Marketplace.Core/Sonorus.Marketplace.Core.csproj", "Microsservices/Marketplace/Sonorus.Marketplace.Core/"]
COPY ["Microsservices/Marketplace/Sonorus.Marketplace.Infrastructure/Sonorus.Marketplace.Infrastructure.csproj", "Microsservices/Marketplace/Sonorus.Marketplace.Infrastructure/"]
RUN dotnet restore "./Microsservices/Marketplace/Sonorus.Marketplace.API/Sonorus.Marketplace.API.csproj"
COPY . .
WORKDIR "/src/Microsservices/Marketplace/Sonorus.Marketplace.API"
RUN dotnet build "./Sonorus.Marketplace.API.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Esta fase é usada para publicar o projeto de serviço a ser copiado para a fase final
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Sonorus.Marketplace.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Esta fase é usada na produção ou quando executada no VS no modo normal (padrão quando não está usando a configuração de Depuração)
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Sonorus.Marketplace.API.dll"]