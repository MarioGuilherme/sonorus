using Azure.Messaging.ServiceBus;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using Sonorus.Marketplace.Core.Repositories;
using Sonorus.Marketplace.Core.Services;
using Sonorus.Marketplace.Infrastructure;
using Sonorus.Marketplace.Infrastructure.Persistence;
using Sonorus.Marketplace.Infrastructure.Persistence.Repositories;
using Sonorus.Marketplace.Infrastructure.Services;
using System.Text;

namespace Sonorus.Marketplace.Infrastructure;

public static class InfrastructureModule {
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration) {
        services
            .AddMessageBroker(configuration)
            .AddApiGateway(configuration)
            .AddPersistence(configuration)
            .AddRepositories()
            .AddUnitOfWork()
            .AddAuthentication(configuration)
            .AddServices(configuration);

        return services;
    }

    private static IServiceCollection AddMessageBroker(this IServiceCollection services, IConfiguration configuration) {
        string connectionString = configuration.GetConnectionString("AzureServiceBus")!;

        ServiceBusClient serviceBusClient = new(connectionString);

        services.AddSingleton(serviceBusClient.CreateProcessor("deleted-users_microservice-marketplace"));

        return services;
    }

    private static IServiceCollection AddApiGateway(this IServiceCollection services, IConfiguration configuration) {
        services.AddHttpClient("API_GATEWAY", c => c.BaseAddress = new Uri(configuration["ApiGateway:Url"]!));

        return services;
    }

    private static IServiceCollection AddPersistence(this IServiceCollection services, IConfiguration configuration) {
        string connectionString = configuration.GetConnectionString("SonorusMarketplaceDb")!;

        services.AddDbContext<SonorusMarketplaceDbContext>(options => options.UseSqlServer(connectionString));

        return services;
    }

    private static IServiceCollection AddRepositories(this IServiceCollection services) {
        services.AddScoped<IProductRepository, ProductRepository>();

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

        return services;
    }

    private static IServiceCollection AddServices(this IServiceCollection services, IConfiguration configuration) {
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