using AutoMapper;
using FluentValidation;
using FluentValidation.AspNetCore;
using MediatR;
using Microsoft.Extensions.DependencyInjection;
using Sonorus.Account.Application.Commands.AssociateCollectionOfInterests;
using Sonorus.Account.Application.Commands.CreateUser;
using Sonorus.Account.Application.Commands.UpdateUser;
using Sonorus.Account.Application.Queries.GetUserByLogin;
using Sonorus.Account.Application.ViewModels;
using Sonorus.Account.Core.Entities;

namespace Sonorus.Account.Application;

public static class ApplicationModule {
    public static IServiceCollection AddApplication(this IServiceCollection services) {
        services
            .AddMediatR()
            .AddFluentValidation()
            .AddAutoMapper();

        return services;
    }

    private static IServiceCollection AddMediatR(this IServiceCollection services) {
        services.AddMediatR(config => config.RegisterServicesFromAssemblyContaining<GetUserByLoginQuery>());

        services.AddTransient<IPipelineBehavior<CreateUserCommand, TokenViewModel>, Commands.CreateUser.CheckUseOfEmailAndNicknameBehavior>();
        services.AddTransient<IPipelineBehavior<UpdateUserCommand, Unit>, Commands.UpdateUser.CheckUseOfEmailAndNicknameBehavior>();

        return services;
    }

    private static IServiceCollection AddFluentValidation(this IServiceCollection services) {
        services
            .AddFluentValidationAutoValidation(o => o.DisableDataAnnotationsValidation = true)
            .AddValidatorsFromAssemblyContaining<GetUserByLoginQuery>();

        return services;
    }

    private static IServiceCollection AddAutoMapper(this IServiceCollection services) {
        services.AddSingleton(new MapperConfiguration(config => {
            config.CreateMap<CreateUserCommand, User>()
                  .ConstructUsing(u => new(u.Fullname, u.Nickname, u.Email, u.Password));
            config.CreateMap<InterestInputModel, Interest>();
            config.CreateMap<Interest, InterestViewModel>();
            config.CreateMap<User, UserViewModel>();
            config.CreateMap<User, AuthenticatedUserViewModel>();
        }).CreateMapper());

        return services;
    }
}