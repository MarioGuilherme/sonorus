using Azure.Messaging.ServiceBus;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Http;
using Microsoft.Azure.Cosmos;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Primitives;
using Microsoft.IdentityModel.Tokens;
using Sonorus.Chat.Core.Repositories;
using Sonorus.Chat.Infrastructure;
using Sonorus.Chat.Infrastructure.Persistence.Repositories;
using System.Text;

namespace Sonorus.Chat.Infrastructure;

public static class InfrastructureModule {
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration) {
        services
            .AddMessageBroker(configuration)
            .AddApiGateway(configuration)
            .AddNoSQL(configuration)
            .AddRepositories()
            .AddAuthentication(configuration);

        return services;
    }

    private static IServiceCollection AddMessageBroker(this IServiceCollection services, IConfiguration configuration) {
        string connectionString = configuration.GetConnectionString("AzureServiceBus")!;

        ServiceBusClient serviceBusClient = new(connectionString);

        services.AddSingleton(serviceBusClient.CreateProcessor("deleted-users_microservice-chat"));

        return services;
    }

    private static IServiceCollection AddApiGateway(this IServiceCollection services, IConfiguration configuration) {
        services.AddHttpClient("API_GATEWAY", c => c.BaseAddress = new Uri(configuration["ApiGateway:Url"]!));

        return services;
    }

    private static IServiceCollection AddNoSQL(this IServiceCollection services, IConfiguration configuration) {
        string databaseName = configuration["AzureCosmoDB:DatabaseName"]!;
        string connectionString = configuration["AzureCosmoDB:ConnectionString"]!;

        CosmosClient cosmosClient = new(connectionString);
        Database database = cosmosClient.CreateDatabaseIfNotExistsAsync(databaseName).GetAwaiter().GetResult()!;

        services.AddSingleton(cosmosClient);
        services.AddSingleton(database);

        return services;
    }

    private static IServiceCollection AddRepositories(this IServiceCollection services) {
        services.AddScoped<IChatRepository, ChatRepository>();
        services.AddScoped<IConnectionRepository, ConnectionRepository>();

        return services;
    }

    private static IServiceCollection AddAuthentication(this IServiceCollection services, IConfiguration configuration) {
        services
            .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(options => {
                options.Events = new JwtBearerEvents {
                    OnMessageReceived = context => {
                        StringValues accessToken = context.Request.Query["access_token"];
                        PathString path = context.HttpContext.Request.Path;
                        if (!string.IsNullOrEmpty(accessToken) && path.StartsWithSegments("/chatHub")) {
                            context.Token = accessToken;
                        }
                        return Task.CompletedTask;
                    }
                };

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
}