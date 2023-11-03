using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Sonorus.AccountAPI.Repository.Interfaces;
using Sonorus.AccountAPI.Repository;
using Sonorus.AccountAPI.Services.Interfaces;
using Sonorus.AccountAPI.Services;
using Sonorus.AccountAPI.DTO;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Sonorus.AccountAPI.Data.Context;
using Sonorus.AccountAPI.Data.Entities;
using Microsoft.OpenApi.Models;

namespace Sonorus.AccountAPI.Configuration;

public static class ConfigureApplication {
    public static void ConfigureHost(this WebApplicationBuilder builder) {
        Environment.SetEnvironmentVariable("SECRET_JWT", builder.Configuration["JWTConfigs:Secret"]!);
        Environment.SetEnvironmentVariable("StorageBaseURL", builder.Configuration["AzureBlobStorage:BaseURL"]!);
        Environment.SetEnvironmentVariable("StorageConnectionString", builder.Configuration["AzureBlobStorage:ConnectionString"]!);
        Environment.SetEnvironmentVariable("StorageContainer", builder.Configuration["AzureBlobStorage:Container"]!);

        byte[] key = Encoding.ASCII.GetBytes(Environment.GetEnvironmentVariable("SECRET_JWT")!);

        builder.Services.AddAuthentication(options => {
            options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
            options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
        })
        .AddJwtBearer(options => {
            options.RequireHttpsMetadata = false;
            options.TokenValidationParameters = new() {
                RequireExpirationTime = true,
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(key),
                ValidateIssuer = false,
                ValidateAudience = false
            };
        });

        builder.Services.AddSwaggerGen(options => {
            options.SwaggerDoc("v1", new () {
                Title = "Sonorus - Account API",
                Description = "Developed by Mário Guilherme de Andrade Rodrigues",
                Version = "v1",
                Contact = new() {
                    Name = "Mário Guilherme de Andrade Rodrigues",
                    Email = "marioguilhermedev@gmail.com"
                },
                License = new() {
                    Name = "MIT",
                    Url = new("https://opensource.org/licenses/MIT")
                }
            });
            options.AddSecurityDefinition("Bearer", new() {
                Name = "Authorization",
                Type = SecuritySchemeType.ApiKey,
                Scheme = "Bearer",
                BearerFormat = "JWT",
                In = ParameterLocation.Header,
                Description = "Insira o token JWT desta maneira: Bearer {seu token}"
            });
            options.AddSecurityRequirement(new() { {
                new() {
                    Reference = new() {
                        Type = ReferenceType.SecurityScheme,
                        Id = "Bearer"
                    }
                },
                Array.Empty<string>()
            }});
        });

        builder.Services.AddDbContext<AccountAPIDbContext>(
            options => options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"))
        );

        builder.Services.AddSingleton(RegisterMaps().CreateMapper());

        builder.Services.AddSingleton<TokenService>();
        builder.Services.AddScoped<IUserService, UserService>();
        builder.Services.AddScoped<IInterestService, InterestService>();
        builder.Services.AddScoped<IUserRepository, UserRepository>();
        builder.Services.AddScoped<IInterestRepository, InterestRepository>();
        builder.Services.AddScoped<IRefreshTokenRepository, RefreshTokenRepository>();
    }

    public static MapperConfiguration RegisterMaps() => new(config => {
        config.CreateMap<User, UserDTO>().ReverseMap();
        config.CreateMap<User, UserRegisterDTO>().ReverseMap();
        config.CreateMap<User, UserLoginDTO>().ReverseMap();
        config.CreateMap<Interest, InterestDTO>().ReverseMap();
    });
}