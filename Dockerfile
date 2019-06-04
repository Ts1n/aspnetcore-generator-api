# Build stage
FROM mcr.microsoft.com/dotnet/core/sdk:2.2 as build-env

WORKDIR /generator

# Restore
COPY api/api.csproj ./api/
RUN dotnet restore api/api.csproj

COPY tests/tests.csproj ./tests/
RUN dotnet restore tests/tests.csproj

# Copy src
COPY . .

# Test
RUN dotnet test --verbosity normal tests/tests.csproj

# Publish
RUN dotnet publish api/api.csproj -o /publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2
COPY --from=build-env /publish /publish

WORKDIR /publish
ENTRYPOINT ["dotnet", "api.dll"]
