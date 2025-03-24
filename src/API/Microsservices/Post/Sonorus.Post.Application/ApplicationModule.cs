using AutoMapper;
using FluentValidation;
using FluentValidation.AspNetCore;
using Microsoft.Extensions.DependencyInjection;
using Sonorus.Post.Application.Commands.ToggleLikePost;
using Sonorus.Post.Application.Subscribers;
using Sonorus.Post.Application.Validators;
using Sonorus.Post.Application.ViewModels;
using Sonorus.Post.Core.Entities;

namespace Sonorus.Post.Application;

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
        services.AddMediatR(config => config.RegisterServicesFromAssemblyContaining<ToggleLikePostCommand>());

        return services;
    }

    private static IServiceCollection AddFluentValidation(this IServiceCollection services) {
        services
            .AddFluentValidationAutoValidation(o => o.DisableDataAnnotationsValidation = true)
            .AddValidatorsFromAssemblyContaining<CreatePostInputModelValidator>();

        return services;
    }

    private static IServiceCollection AddAutoMapper(this IServiceCollection services) {
        services.AddSingleton(new MapperConfiguration(config => {
            config.CreateMap<Media, MediaViewModel>();
        }).CreateMapper());

        return services;
    }

    private static IServiceCollection AddSubscribers(this IServiceCollection services) {
        services.AddHostedService<DeletedUserSubscriber>();

        return services;
    }
}