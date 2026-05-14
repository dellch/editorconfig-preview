.PHONY: mock

mock: ## Start mock API server from OpenAPI spec
	npx @stoplight/prism-cli mock openapi.yaml
