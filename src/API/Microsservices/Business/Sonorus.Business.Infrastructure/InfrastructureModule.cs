using Azure.Messaging.ServiceBus;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using Sonorus.Business.Core.Repositories;
using Sonorus.Business.Infrastructure.Persistence;
using Sonorus.Business.Infrastructure.Persistence.Repositories;
using System.Text;

namespace Sonorus.Business.Infrastructure;

public static class InfrastructureModule {
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration) {
        services
            .AddMessageBroker(configuration)
            .AddApiGateway(configuration)
            .AddPersistence(configuration)
            .AddRepositories()
            .AddUnitOfWork()
            .AddAuthentication(configuration);

        return services;
    }

    private static IServiceCollection AddMessageBroker(this IServiceCollection services, IConfiguration configuration) {
        string connectionString = configuration.GetConnectionString("AzureServiceBus")!;

        ServiceBusClient serviceBusClient = new(connectionString);

        services.AddSingleton(serviceBusClient.CreateProcessor("deleted-users_microservice-business"));

        return services;
    }

    private static IServiceCollection AddApiGateway(this IServiceCollection services, IConfiguration configuration) {
        services.AddHttpClient("API_GATEWAY", c => c.BaseAddress = new Uri(configuration["ApiGateway:Url"]!));

        return services;
    }

    private static IServiceCollection AddPersistence(this IServiceCollection services, IConfiguration configuration) {
        string connectionString = configuration.GetConnectionString("SonorusBusinessDb")!;

        services.AddDbContext<SonorusBusinessDbContext>(options => options.UseSqlServer(connectionString));

        return services;
    }

    private static IServiceCollection AddRepositories(this IServiceCollection services) {
        services.AddScoped<IOpportunityRepository, OpportunityRepository>();

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

    private static IServiceCollection AddUnitOfWork(this IServiceCollection services) {
        services.AddScoped<IUnitOfWork, UnitOfWork>();

        return services;
    }
}