using FluentValidation;
using FluentValidation.AspNetCore;
using MediatR;
using Microsoft.Extensions.DependencyInjection;
using Sonorus.Account.Application.Commands.CreateUser;
using Sonorus.Account.Application.Commands.UpdateUser;
using Sonorus.Account.Application.Queries.GetUserByLogin;
using Sonorus.Account.Application.ViewModels;

namespace Sonorus.Account.Application;

public static class ApplicationModule
{
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        services
            .AddMediatR()
            .AddFluentValidation();

        return services;
    }

    private static IServiceCollection AddMediatR(this IServiceCollection services)
    {
        services.AddMediatR(config => config.RegisterServicesFromAssemblyContaining<GetUserByLoginQuery>());

        services.AddTransient<IPipelineBehavior<CreateUserCommand, TokenViewModel>, Commands.CreateUser.CheckUseOfEmailAndNicknameBehavior>();
        services.AddTransient<IPipelineBehavior<UpdateUserCommand, Unit>, Commands.UpdateUser.CheckUseOfEmailAndNicknameBehavior>();

        return services;
    }

    private static IServiceCollection AddFluentValidation(this IServiceCollection services)
    {
        services
            .AddFluentValidationAutoValidation(o => o.DisableDataAnnotationsValidation = true)
            .AddValidatorsFromAssemblyContaining<GetUserByLoginQuery>();

        return services;
    }
}