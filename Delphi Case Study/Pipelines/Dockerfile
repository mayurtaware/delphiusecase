# Stage 1: Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS builder

WORKDIR /src

# Copy project files first for layer caching
COPY ["src/Delphi.Api/Delphi.Api.csproj", "Delphi.Api/"]
COPY ["src/Delphi.Core/Delphi.Core.csproj", "Delphi.Core/"]
COPY ["src/Delphi.Data/Delphi.Data.csproj", "Delphi.Data/"]

# Restore dependencies
RUN dotnet restore "Delphi.Api/Delphi.Api.csproj"

# Copy source code and publish
COPY ["src/", "."]
RUN dotnet publish "Delphi.Api/Delphi.Api.csproj" -c Release -o /app/publish --no-restore

# Stage 2: Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS runtime

# Install curl for healthcheck and create non-root user
RUN apk add --no-cache curl && \
    addgroup -g 1000 appuser && \
    adduser -D -u 1000 -G appuser appuser && \
    chown -R appuser:appuser /app

WORKDIR /app

COPY --from=builder --chown=appuser:appuser /app/publish .

USER appuser

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:80/health/live || exit 1

ENTRYPOINT ["dotnet", "Delphi.Api.dll"]

LABEL maintainer="DevOps Team"
LABEL version="1.0"
LABEL description="Delphi Application - Production Build"