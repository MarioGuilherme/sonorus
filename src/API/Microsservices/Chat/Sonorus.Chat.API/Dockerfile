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
COPY ["Microsservices/Chat/Sonorus.Chat.API/Sonorus.Chat.API.csproj", "Microsservices/Chat/Sonorus.Chat.API/"]
COPY ["SharedKernel/Sonorus.SharedKernel/Sonorus.SharedKernel.csproj", "SharedKernel/Sonorus.SharedKernel/"]
COPY ["Microsservices/Chat/Sonorus.Chat.Application/Sonorus.Chat.Application.csproj", "Microsservices/Chat/Sonorus.Chat.Application/"]
COPY ["Microsservices/Chat/Sonorus.Chat.Core/Sonorus.Chat.Core.csproj", "Microsservices/Chat/Sonorus.Chat.Core/"]
COPY ["Microsservices/Chat/Sonorus.Chat.Infrastructure/Sonorus.Chat.Infrastructure.csproj", "Microsservices/Chat/Sonorus.Chat.Infrastructure/"]
RUN dotnet restore "./Microsservices/Chat/Sonorus.Chat.API/Sonorus.Chat.API.csproj"
COPY . .
WORKDIR "/src/Microsservices/Chat/Sonorus.Chat.API"
RUN dotnet build "./Sonorus.Chat.API.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Esta fase é usada para publicar o projeto de serviço a ser copiado para a fase final
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Sonorus.Chat.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Esta fase é usada na produção ou quando executada no VS no modo normal (padrão quando não está usando a configuração de Depuração)
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Sonorus.Chat.API.dll"]