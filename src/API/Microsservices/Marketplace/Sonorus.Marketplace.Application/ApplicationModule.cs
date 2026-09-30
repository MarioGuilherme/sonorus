using FluentValidation;
using FluentValidation.AspNetCore;
using Microsoft.Extensions.DependencyInjection;
using Sonorus.Marketplace.Application.Commands.DeleteProduct;
using Sonorus.Marketplace.Application.Subscribers;
using Sonorus.Marketplace.Application.Validators;

namespace Sonorus.Marketplace.Application;

public static class ApplicationModule
{
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        services
            .AddMediatR()
            .AddFluentValidation()
            .AddSubscribers();

        return services;
    }

    private static IServiceCollection AddMediatR(this IServiceCollection services)
    {
        services.AddMediatR(config => config.RegisterServicesFromAssemblyContaining<DeleteProductCommand>());

        return services;
    }

    private static IServiceCollection AddFluentValidation(this IServiceCollection services)
    {
        services
            .AddFluentValidationAutoValidation(o => o.DisableDataAnnotationsValidation = true)
            .AddValidatorsFromAssemblyContaining<CreateProductInputModelValidator>();

        return services;
    }

    private static IServiceCollection AddSubscribers(this IServiceCollection services)
    {
        services.AddHostedService<DeletedUserSubscriber>();

        return services;
    }
}