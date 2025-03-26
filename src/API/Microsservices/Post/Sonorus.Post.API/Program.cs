using Microsoft.EntityFrameworkCore;
using Sonorus.Post.API.ExceptionHandler;
using Sonorus.Post.Application;
using Sonorus.Post.Infrastructure;
using Sonorus.Post.Infrastructure.Persistence;
using Sonorus.SharedKernel;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

builder.Services
    .AddInfrastructure(builder.Configuration)
    .AddApplication();

builder.Services
    .AddControllers(options => options.Filters.Add<ValidationFilter>())
    .ConfigureApiBehaviorOptions(options => options.SuppressModelStateInvalidFilter = true);

builder.Services.AddExceptionHandler<ApiExceptionHandler>();
builder.Services.AddProblemDetails();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSharedSwaggerGen(webServiceName: "Post");

WebApplication app = builder.Build();

#region Cria o banco de dados na inicialização
using AsyncServiceScope asyncServiceScope = app.Services.CreateAsyncScope();
IServiceProvider services = asyncServiceScope.ServiceProvider;
SonorusPostDbContext context = services.GetRequiredService<SonorusPostDbContext>();
if ((await context.Database.GetPendingMigrationsAsync()).Any())
    await context.Database.MigrateAsync();
#endregion

if (app.Environment.IsDevelopment()) {
    app.MapOpenApi();
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseExceptionHandler();

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();