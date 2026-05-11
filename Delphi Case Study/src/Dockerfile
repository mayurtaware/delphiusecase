# Build stage
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS builder
WORKDIR /src

# Copy project file
COPY ["DemoApp.csproj", "./"]

# Restore dependencies
RUN dotnet restore "DemoApp.csproj"

# Copy source code
COPY . .

# Build application
RUN dotnet build "DemoApp.csproj" -c Release -o /app/build

# Publish stage
FROM builder AS publish
RUN dotnet publish "DemoApp.csproj" -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app

# Create non-root user for security
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app

# Copy published application
COPY --from=publish --chown=appuser:appuser /app/publish .

# Set environment variables
ENV ASPNETCORE_URLS=http://+:80
ENV DOTNET_RUNNING_IN_CONTAINER=true

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Run as non-root user
USER appuser

# Start application
ENTRYPOINT ["dotnet", "DemoApp.dll"]
