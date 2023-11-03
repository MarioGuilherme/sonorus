using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Sonorus.PostAPI.Data.Context;
using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Data.Entities;
using Sonorus.PostAPI.Services;
using Sonorus.PostAPI.Services.Interfaces;
using Sonorus.PostAPI.Repository.Interfaces;
using Sonorus.PostAPI.Repository;
using Microsoft.OpenApi.Models;

namespace Sonorus.PostAPI.Configuration;

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
            options.SwaggerDoc("v1", new() {
                Title = "Sonorus - Post API",
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

        builder.Services.AddDbContext<PostAPIDbContext>(
            options => options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"))
        );

        builder.Services.AddSingleton(RegisterMaps().CreateMapper());

        builder.Services.AddHttpClient<IPostService, PostService>(
            c => c.BaseAddress = new Uri(builder.Configuration["ServiceUrls:AccountAPI"]!)
        );
        builder.Services.AddHttpClient<ICommentService, CommentService>(
            c => c.BaseAddress = new Uri(builder.Configuration["ServiceUrls:AccountAPI"]!)
        );
        builder.Services.AddScoped<ICommentRepository, CommentRepository>();
        builder.Services.AddScoped<IPostRepository, PostRepository>();
    }

    public static MapperConfiguration RegisterMaps() => new(config => {
        config.CreateMap<Post, PostDTO>().ReverseMap();
        config.CreateMap<Comment, CommentDTO>().ReverseMap();
        config.CreateMap<Interest, InterestDTO>().ReverseMap();
        config.CreateMap<Media, MediaDTO>().ReverseMap();
    });
}