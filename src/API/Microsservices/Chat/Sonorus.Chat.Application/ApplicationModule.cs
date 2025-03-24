using AutoMapper;
using FluentValidation;
using FluentValidation.AspNetCore;
using Microsoft.Extensions.DependencyInjection;
using Sonorus.Chat.Application.Commands.AddMessageToChat;
using Sonorus.Chat.Application.Queries.GetAllChatsByUserId;
using Sonorus.Chat.Application.Subscribers;
using Sonorus.Chat.Application.Validators;
using Sonorus.Chat.Application.ViewModels;
using Sonorus.Chat.Core.Entities;

namespace Sonorus.Chat.Application;

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
        services.AddMediatR(config => config.RegisterServicesFromAssemblyContaining<GetAllChatsByUserIdQuery>());

        return services;
    }

    private static IServiceCollection AddFluentValidation(this IServiceCollection services) {
        services
            .AddFluentValidationAutoValidation(o => o.DisableDataAnnotationsValidation = true)
            .AddValidatorsFromAssemblyContaining<AddMessageToChatCommandValidator>();

        return services;
    }

    private static IServiceCollection AddAutoMapper(this IServiceCollection services) {
        services.AddSingleton(new MapperConfiguration(config => {
            config.CreateMap<AddMessageToChatCommand, Message>();
            config.CreateMap<Core.Entities.Chat, ChatViewModel>();
            config.CreateMap<Message, MessageViewModel>();
        }).CreateMapper());

        return services;
    }

    private static IServiceCollection AddSubscribers(this IServiceCollection services) {
        services.AddHostedService<DeletedUserSubscriber>();

        return services;
    }
}