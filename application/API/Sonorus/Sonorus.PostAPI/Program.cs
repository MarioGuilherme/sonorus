using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Logging;
using Sonorus.PostAPI.Configuration;
using Sonorus.PostAPI.Data;
using Sonorus.PostAPI.Repository;
using Sonorus.PostAPI.Repository.Interfaces;
using Sonorus.PostAPI.Service;
using Sonorus.PostAPI.Service.Interfaces;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

Environment.SetEnvironmentVariable("SECRET_JWT", builder.Configuration["JWTConfigs:Secret"]!);

builder.Services.ConfigureJWT();

// Add services to the container.
builder.Services.AddDbContext<SonorusDbContext>(
    options => options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"))
);

IMapper mapper = MappingConfig.RegisterMaps().CreateMapper();
builder.Services.AddSingleton(mapper);

builder.Services.AddScoped<IPostRepository, PostRepository>();
builder.Services.AddScoped<IPostService, PostService>();
builder.Services.AddScoped<ICommentService, CommentService>();
builder.Services.AddScoped<ICommentRepository, CommentRepository>();

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
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