.PHONY: mock format-backend

mock: ## Start mock API server from OpenAPI spec
	npx @stoplight/prism-cli mock openapi.yaml

format-backend: ## Format backend code with dotnet format
	dotnet format EditorConfigPreview.sln
