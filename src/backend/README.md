# EditorConfig Preview Backend

ASP.NET Core Minimal API for applying `.editorconfig` rules to sample C# code.

## Prerequisites

- [.NET 10 SDK](https://dotnet.microsoft.com/download) (pinned via `global.json` at repo root)

## Commands

```sh
# Restore dependencies
dotnet restore

# Build
dotnet build

# Run the API (from repo root)
dotnet run --project src/backend/EditorConfigPreview.Api

# Run all tests
dotnet test

# Run integration tests only
dotnet test tests/backend/EditorConfigPreview.Api.IntegrationTests
```

## Project Structure

- `EditorConfigPreview.Api/` — The Minimal API application
- `../../tests/backend/EditorConfigPreview.Api.UnitTests/` — Unit tests (xUnit)
- `../../tests/backend/EditorConfigPreview.Api.IntegrationTests/` — Integration tests using WebApplicationFactory (xUnit)
