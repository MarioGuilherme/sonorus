using Microsoft.EntityFrameworkCore;
using Sonorus.Business.API.ExceptionHandler;
using Sonorus.Business.Application;
using Sonorus.Business.Infrastructure;
using Sonorus.Business.Infrastructure.Persistence;
using Sonorus.SharedKernel;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

builder.AddServiceDefaults();

builder.Services
    .AddInfrastructure(builder.Configuration)
    .AddApplication();

builder.Services
    .AddControllers(options => options.Filters.Add<ValidationFilter>())
    .ConfigureApiBehaviorOptions(options => options.SuppressModelStateInvalidFilter = true);

builder.Services.AddExceptionHandler<ApiExceptionHandler>();
builder.Services.AddProblemDetails();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSharedSwaggerGen(webServiceName: "Business");

WebApplication app = builder.Build();

#region Cria o banco de dados na inicialização
using AsyncServiceScope asyncServiceScope = app.Services.CreateAsyncScope();
IServiceProvider services = asyncServiceScope.ServiceProvider;
SonorusBusinessDbContext context = services.GetRequiredService<SonorusBusinessDbContext>();
if ((await context.Database.GetPendingMigrationsAsync()).Any())
    await context.Database.MigrateAsync();
#endregion

app.MapDefaultEndpoints();

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