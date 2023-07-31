using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Logging;
using Sonorus.AccountAPI.Configuration;
using Sonorus.AccountAPI.Data;
using Sonorus.AccountAPI.Repository;
using Sonorus.AccountAPI.Repository.Interfaces;
using Sonorus.AccountAPI.Services;
using Sonorus.AccountAPI.Services.Interfaces;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

Environment.SetEnvironmentVariable("SECRET_JWT", builder.Configuration["JWTConfigs:Secret"]!);

builder.Services.ConfigureJWT();

// Add services to the container.
builder.Services.AddDbContext<SonorusDbContext>(
    options => options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"))
);

IMapper mapper = MappingConfig.RegisterMaps().CreateMapper();
builder.Services.AddSingleton(mapper);

builder.Services.AddScoped<IUserRepository, UserRepository>();
builder.Services.AddScoped<IUserService, UserService>();

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

WebApplication app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment()) {
    IdentityModelEventSource.ShowPII = true;
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();