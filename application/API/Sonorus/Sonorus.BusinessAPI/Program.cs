using Microsoft.IdentityModel.Logging;
using Sonorus.BusinessAPI.Configuration;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

builder.ConfigureHost();

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

WebApplication app = builder.Build();

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