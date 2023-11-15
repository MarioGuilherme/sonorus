using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Microsoft.OpenApi.Models;
using Sonorus.BusinessAPI.Data.Context;
using Sonorus.BusinessAPI.Data.Entities;
using Sonorus.BusinessAPI.DTO;
using Sonorus.BusinessAPI.Services.Interfaces;
using Sonorus.BusinessAPI.Services;
using Sonorus.BusinessAPI.Repository.Interfaces;

namespace Sonorus.BusinessAPI.Configuration;

public static class ConfigureApplication {
    public static void ConfigureHost(this WebApplicationBuilder builder) {
        Environment.SetEnvironmentVariable("SECRET_JWT", builder.Configuration["JWTConfigs:Secret"]!);

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
            options.SwaggerDoc("v1", new() {
                Title = "Sonorus - Business API",
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

        builder.Services.AddDbContext<BusinessAPIDbContext>(
            options => options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"))
        );

        builder.Services.AddSingleton(RegisterMaps().CreateMapper());

        builder.Services.AddHttpClient<IOpportunityService, OpportunityService>(
            c => c.BaseAddress = new Uri(builder.Configuration["ServiceUrls:AccountAPI"]!)
        );
        builder.Services.AddScoped<IOpportunityRepository, OpportunityRepository>();
    }

    public static MapperConfiguration RegisterMaps() => new(config => {
        config.CreateMap<Opportunity, OpportunityDTO>().ReverseMap();
        config.CreateMap<Opportunity, OpportunityRegisterDTO>().ReverseMap();
    });
}