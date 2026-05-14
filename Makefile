.PHONY: mock format-backend test-backend format-frontend review-prs implement-issues implement-issue

mock: ## Start mock API server from OpenAPI spec
	npx @stoplight/prism-cli mock openapi.yaml

format-backend: ## Format backend code with dotnet format
	dotnet format EditorConfigPreview.sln

test-backend: ## Run backend tests with code coverage
	dotnet test EditorConfigPreview.sln --collect:"XPlat Code Coverage"

format-frontend: ## Format frontend code with Prettier
	cd src/frontend && npm run format

review-prs: ## Dispatch address-reviews agents for open PRs
	./scripts/dispatch-pr-agents.sh

implement-issues: ## Dispatch agents for all open issues in a milestone (default: MVP)
	./scripts/dispatch-issue-agents.sh

implement-issue: ## Dispatch an agent for a specific issue: make implement-issue ISSUE=7
	@test -n "$(ISSUE)" || (echo "Usage: make implement-issue ISSUE=<number>" && exit 1)
	claude --agent implement-issue --bg "Implement issue #$(ISSUE) in repository dellch/editorconfig-preview."
