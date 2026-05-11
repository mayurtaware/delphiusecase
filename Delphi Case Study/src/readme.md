# Delphi Demo Application

A sample ASP.NET Core 7.0 web application for demonstrating deployment to Azure App Service.

## Overview

This is a containerized .NET 7.0 application with RESTful API endpoints, Swagger documentation, and integration with Azure Application Insights.

## Features

- **REST API**: Full CRUD operations on demo items
- **Health Check**: `/health` endpoint for monitoring
- **Info Endpoint**: `/info` for application information
- **Swagger/OpenAPI**: Interactive API documentation at `/swagger`
- **Application Insights**: Integrated telemetry and monitoring
- **Docker Support**: Multi-stage Docker build for efficient containerization
- **Security**: Runs as non-root user in container

## Project Structure

```
src/
├── Controllers/
│   └── DemoController.cs      # API endpoints
├── DemoApp.csproj             # Project file
├── Program.cs                 # Application startup
├── appsettings.json           # Configuration
├── appsettings.Development.json
├── Dockerfile                 # Container definition
└── .dockerignore              # Docker build exclusions
```

## Running Locally

### Prerequisites
- .NET 7.0 SDK
- Visual Studio Code or Visual Studio 2022

### Build and Run

```bash
cd src

# Restore dependencies
dotnet restore

# Build
dotnet build

# Run
dotnet run

# Application runs on http://localhost:5000
# Swagger UI: http://localhost:5000/swagger
```

### Docker

```bash
# Build image
docker build -f src/Dockerfile -t delphi-demo:latest .

# Run container
docker run -p 80:80 \
  -e ASPNETCORE_ENVIRONMENT=Production \
  delphi-demo:latest
```

## API Endpoints

### Health Check
- **GET** `/health` - Returns application health status

### Info
- **GET** `/info` - Returns application information

### Demo Items (CRUD Operations)
- **GET** `/api/demo` - Get all items
- **GET** `/api/demo/{id}` - Get item by ID
- **GET** `/api/demo/count` - Get item count
- **POST** `/api/demo` - Create new item
  ```json
  {
    "name": "Item Name",
    "description": "Item Description"
  }
  ```
- **PUT** `/api/demo/{id}` - Update item
  ```json
  {
    "name": "Updated Name",
    "description": "Updated Description"
  }
  ```
- **DELETE** `/api/demo/{id}` - Delete item

## Configuration

Environment variables:
- `ASPNETCORE_ENVIRONMENT` - Environment name (Development/Production)
- `ASPNETCORE_URLS` - URLs to bind (default: http://+:80)
- `APPINSIGHTS_INSTRUMENTATIONKEY` - Application Insights key

## Deployment

See the CI/CD pipeline configuration in `Pipelines/app-build-and-deploy.yml` for automated deployment to Azure App Service.

## App Service Configuration

- **Plan**: Delphi App Plan (S2 SKU)
- **Name**: delphi-app-service
- **Runtime**: ASP.NET Core 7.0
- **Instances**: 2 (with autoscaling)

## Monitoring

Application Insights integration provides:
- Request/response telemetry
- Performance monitoring
- Custom event tracking
- Dependency monitoring

Access AI data through Azure Portal or Application Insights dashboard.

## Contributing

For changes, ensure:
1. Code builds successfully: `dotnet build`
2. Tests pass (if applicable)
3. Docker image builds: `docker build -f src/Dockerfile -t delphi-demo:test .`

## License

Internal use only - Delphi Case Study
