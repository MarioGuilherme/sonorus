using AutoMapper;
using FluentValidation;
using FluentValidation.AspNetCore;
using Microsoft.Extensions.DependencyInjection;
using Sonorus.Marketplace.Application.Commands.CreateProduct;
using Sonorus.Marketplace.Application.Commands.DeleteProduct;
using Sonorus.Marketplace.Application.Subscribers;
using Sonorus.Marketplace.Application.Validators;
using Sonorus.Marketplace.Application.ViewModels;
using Sonorus.Marketplace.Core.Entities;

namespace Sonorus.Marketplace.Application;

public static class ApplicationModule {
    public static IServiceCollection AddApplication(this IServiceCollection services) {
        services
            .AddMediatR()
            .AddFluentValidation()
            .AddAutoMapper()
            .AddSubscribers();

        return services;
    }

    private static IServiceCollection AddMediatR(this IServiceCollection services) {
        services.AddMediatR(config => config.RegisterServicesFromAssemblyContaining<DeleteProductCommand>());

        return services;
    }

    private static IServiceCollection AddFluentValidation(this IServiceCollection services) {
        services
            .AddFluentValidationAutoValidation(o => o.DisableDataAnnotationsValidation = true)
            .AddValidatorsFromAssemblyContaining<CreateProductInputModelValidator>();

        return services;
    }

    private static IServiceCollection AddAutoMapper(this IServiceCollection services) {
        services.AddSingleton(new MapperConfiguration(config => {
            config.CreateMap<Product, ProductViewModel>();
            config.CreateMap<Media, MediaViewModel>();
        }).CreateMapper());

        return services;
    }

    private static IServiceCollection AddSubscribers(this IServiceCollection services) {
        services.AddHostedService<DeletedUserSubscriber>();

        return services;
    }
}