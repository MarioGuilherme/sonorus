using Azure.Messaging.ServiceBus;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using Sonorus.Account.Core.MessageBroker;
using Sonorus.Account.Core.Repositories;
using Sonorus.Account.Core.Services;
using Sonorus.Account.Infrastructure.MessageBroker;
using Sonorus.Account.Infrastructure.Persistence;
using Sonorus.Account.Infrastructure.Persistence.Repositories;
using Sonorus.Account.Infrastructure.Services;
using System.Text;

namespace Sonorus.Account.Infrastructure;

public static class InfrastructureModule {
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration) {
        services
            .AddMessageBroker(configuration)
            .AddPersistence(configuration)
            .AddRepositories()
            .AddCacheService()
            .AddUnitOfWork()
            .AddAuthentication(configuration)
            .AddFileStorage(configuration);

        return services;
    }

    private static IServiceCollection AddMessageBroker(this IServiceCollection services, IConfiguration configuration) {
        string connectionString = configuration.GetConnectionString("AzureServiceBus")!;

        services.AddSingleton(_ => new ServiceBusClient(connectionString));
        services.AddScoped<IMessageBroker, AzureServiceBus>();

        return services;
    }

    private static IServiceCollection AddPersistence(this IServiceCollection services, IConfiguration configuration) {
        string connectionString = configuration.GetConnectionString("SonorusAccountDb")!;

        services.AddDbContext<SonorusAccountDbContext>(options => options.UseSqlServer(connectionString));

        return services;
    }

    private static IServiceCollection AddRepositories(this IServiceCollection services) {
        services.AddScoped<IInterestRepository, InterestRepository>();
        services.AddScoped<IRefreshTokenRepository, RefreshTokenRepository>();
        services.AddScoped<IUserRepository, UserRepository>();

        return services;
    }

    private static IServiceCollection AddCacheService(this IServiceCollection services) {
        services.AddMemoryCache();
        services.AddScoped<ICacheService, MemoryCacheService>();

        return services;
    }

    private static IServiceCollection AddAuthentication(this IServiceCollection services, IConfiguration configuration) {
        services
            .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(options => {
                options.TokenValidationParameters = new TokenValidationParameters {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = true,
                    ValidateIssuerSigningKey = true,
                    ValidIssuer = configuration["Jwt:Issuer"],
                    ValidAudience = configuration["Jwt:Audience"],
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration["Jwt:Secret"]!))
                };
            });

        services.AddScoped<IAuthService, AuthService>();

        return services;
    }

    private static IServiceCollection AddFileStorage(this IServiceCollection services, IConfiguration configuration) {
        Environment.SetEnvironmentVariable("BlobStorageURL", $"{configuration["BlobStorage:URL"]!}/{configuration["BlobStorage:Container"]!}");

        services.AddSingleton<IFileStorage, AzureStorageService>(_ => {
            string connectionString = configuration["BlobStorage:ConnectionString"]!;
            string containerName = configuration["BlobStorage:Container"]!;
            BlobContainerClient blobContainerClient = new(connectionString, containerName);
            blobContainerClient.CreateIfNotExists(PublicAccessType.Blob);
            return new(connectionString, containerName);
        });

        return services;
    }

    private static IServiceCollection AddUnitOfWork(this IServiceCollection services) {
        services.AddScoped<IUnitOfWork, UnitOfWork>();

        return services;
    }
}