using AutoMapper;
using FluentValidation;
using FluentValidation.AspNetCore;
using Microsoft.Extensions.DependencyInjection;
using Sonorus.Business.Application.Commands.CreateOpportunity;
using Sonorus.Business.Application.Commands.UpdateOpportunity;
using Sonorus.Business.Application.Queries.GetAllOpportunitiesByName;
using Sonorus.Business.Application.Subscribers;
using Sonorus.Business.Application.ViewModels;
using Sonorus.Business.Core.Entities;

namespace Sonorus.Business.Application;

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
        services.AddMediatR(config => config.RegisterServicesFromAssemblyContaining<GetAllOpportunitiesByNameQuery>());

        return services;
    }

    private static IServiceCollection AddFluentValidation(this IServiceCollection services) {
        services
            .AddFluentValidationAutoValidation(o => o.DisableDataAnnotationsValidation = true)
            .AddValidatorsFromAssemblyContaining<CreateOpportunityCommand>();

        return services;
    }

    private static IServiceCollection AddAutoMapper(this IServiceCollection services) {
        services.AddSingleton(new MapperConfiguration(config => {
            config.CreateMap<Opportunity, OpportunityViewModel>();
            config.CreateMap<UpdateOpportunityCommand, Opportunity>();
        }).CreateMapper());

        return services;
    }

    private static IServiceCollection AddSubscribers(this IServiceCollection services) {
        services.AddHostedService<DeletedUserSubscriber>();

        return services;
    }
}