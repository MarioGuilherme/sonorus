using Microsoft.EntityFrameworkCore;
using Sonorus.Account.API.ExceptionHandler;
using Sonorus.Account.Application;
using Sonorus.Account.Infrastructure;
using Sonorus.Account.Infrastructure.Persistence;
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
builder.Services.AddSharedSwaggerGen(webServiceName: "Account");

WebApplication app = builder.Build();

#region Cria o banco de dados na inicialização
using AsyncServiceScope asyncServiceScope = app.Services.CreateAsyncScope();
IServiceProvider services = asyncServiceScope.ServiceProvider;
SonorusAccountDbContext context = services.GetRequiredService<SonorusAccountDbContext>();
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