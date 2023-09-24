using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Sonorus.AccountAPI.Data;
using Sonorus.AccountAPI.Repository.Interfaces;
using Sonorus.AccountAPI.Repository;
using Sonorus.AccountAPI.Services.Interfaces;
using Sonorus.AccountAPI.Services;
using Sonorus.AccountAPI.DTO;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Sonorus.AccountAPI.Data.Context;

namespace Sonorus.AccountAPI.Configuration;

public static class ConfigureApplication {
    public static void ConfigureHost(this WebApplicationBuilder builder) {
        Environment.SetEnvironmentVariable("SECRET_JWT", builder.Configuration["JWTConfigs:Secret"]!);
        Environment.SetEnvironmentVariable("ConnectionStringBlobStorage", builder.Configuration["ConnectionStringBlobStorage"]!);

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

        builder.Services.AddDbContext<AccountAPIDbContext>(
            options => options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"))
        );

        builder.Services.AddSingleton(RegisterMaps().CreateMapper());

        builder.Services.AddSingleton<TokenService>();
        builder.Services.AddScoped<IUserService, UserService>();
        builder.Services.AddScoped<IInterestService, InterestService>();
        builder.Services.AddScoped<IUserRepository, UserRepository>();
        builder.Services.AddScoped<IInterestRepository, InterestRepository>();
    }

    public static MapperConfiguration RegisterMaps() => new(config => {
        config.CreateMap<User, UserRegisterDTO>().ReverseMap();
        config.CreateMap<User, UserLoginDTO>().ReverseMap();
        config.CreateMap<Interest, InterestDTO>().ReverseMap();
    });
}