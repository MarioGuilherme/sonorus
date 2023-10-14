using AutoMapper;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Microsoft.OpenApi.Models;
using Sonorus.ChatAPI.Services.Interfaces;
using Sonorus.ChatAPI.Services;
using Sonorus.ChatAPI.Repository.Interfaces;
using Sonorus.ChatAPI.Repository;
using Sonorus.ChatAPI.DTO;
using Sonorus.ChatAPI.Data.Write;

namespace Sonorus.ChatAPI.Configuration;

public static class ConfigureApplication {
    public static void ConfigureHost(this WebApplicationBuilder builder) {
        Environment.SetEnvironmentVariable("SECRET_JWT", builder.Configuration["JWTConfigs:Secret"]!);
        Environment.SetEnvironmentVariable("COSMOS_DB_PRIMARY_KEY", builder.Configuration["AzureCosmoDB:PrimaryKey"]!);
        Environment.SetEnvironmentVariable("COSMOS_DB_ENDPOINT_URI", builder.Configuration["AzureCosmoDB:EndPointUri"]!);
        Environment.SetEnvironmentVariable("COSMOS_DB_NAME", builder.Configuration["AzureCosmoDB:Database"]!);

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
                Title = "Sonorus - Chat API",
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

        //builder.Services.AddDbContext<ChatAPIDbContext>(
        //    options => options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"))
        //);

        builder.Services.AddSingleton(RegisterMaps().CreateMapper());

        builder.Services.AddScoped<IChatService, ChatService>();
        builder.Services.AddSingleton<IChatRepository, ChatRepository>();
    }

    public static MapperConfiguration RegisterMaps() => new(config => {
        config.CreateMap<Message, MessageDTO>().ReverseMap();
    });
}