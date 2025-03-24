IDistributedApplicationBuilder builder = DistributedApplication.CreateBuilder(args);

builder.AddProject<Projects.Sonorus_Account_API>("sonorus-account-api");

builder.AddProject<Projects.Sonorus_ApiGateway>("sonorus-apigateway", "http");

builder.AddProject<Projects.Sonorus_Business_API>("sonorus-business-api");

builder.AddProject<Projects.Sonorus_Post_API>("sonorus-post-api");

builder.AddProject<Projects.Sonorus_Marketplace_API>("sonorus-marketplace-api");

builder.AddProject<Projects.Sonorus_Chat_API>("sonorus-chat-api", "http");

builder.Build().Run();
