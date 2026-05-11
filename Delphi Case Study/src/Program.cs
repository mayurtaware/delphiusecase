using Microsoft.ApplicationInsights;
using Swashbuckle.AspNetCore.SwaggerUI;

var builder = WebApplication.CreateBuilder(args);

// Add Application Insights
builder.Services.AddApplicationInsightsTelemetry();

// Add services
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "Delphi Demo API v1");
        c.DocumentTitle = "Delphi Demo API";
    });
}

// Health check endpoint
app.MapGet("/health", () => 
{
    return Results.Ok(new 
    { 
        status = "Healthy",
        timestamp = DateTime.UtcNow,
        environment = app.Environment.EnvironmentName,
        version = "1.0.0"
    });
})
.WithName("Health")
.WithOpenApi()
.Produces(200);

// Info endpoint
app.MapGet("/info", () => 
{
    var hostName = System.Environment.MachineName;
    return Results.Ok(new 
    { 
        application = "Delphi Demo App",
        version = "1.0.0",
        environment = app.Environment.EnvironmentName,
        hostname = hostName,
        timestamp = DateTime.UtcNow,
        framework = ".NET 7.0"
    });
})
.WithName("Info")
.WithOpenApi()
.Produces(200);

app.UseHttpsRedirection();
app.UseRouting();
app.MapControllers();

// Add swagger at root for easier access
app.MapGet("/", () => Results.Redirect("/swagger", true)).Produces(301);

// Log application startup
var logger = app.Services.GetRequiredService<ILogger<Program>>();
logger.LogInformation("Delphi Demo Application starting...");

app.Run();
