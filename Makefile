.PHONY: mock format-backend test-backend

mock: ## Start mock API server from OpenAPI spec
	npx @stoplight/prism-cli mock openapi.yaml

format-backend: ## Format backend code with dotnet format
	dotnet format EditorConfigPreview.sln

test-backend: ## Run backend tests with code coverage
	dotnet test EditorConfigPreview.sln --collect:"XPlat Code Coverage"
