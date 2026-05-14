MILESTONE := v0.1.0 - MVP

.PHONY: help mock format format-backend test-backend format-frontend review-prs implement-issues implement-issue list-issues

help: ## Show this help message
	@echo
	@echo "Available targets:"
	@sed -n 's/^\([a-zA-Z_-]*\):.*##\s*\(.*\)/\1:\2/p' $(MAKEFILE_LIST) | column -t -s ':' | sed -e 's/^/  /'
	@echo

mock: ## Start mock API server from OpenAPI spec
	npx --yes @stoplight/prism-cli@5.15.10 mock openapi.yaml

format: ## Format all code (backend + frontend)
	$(MAKE) format-backend
	$(MAKE) format-frontend

format-backend: ## Format backend code with dotnet format
	dotnet format EditorConfigPreview.sln

test-backend: ## Run backend tests with code coverage
	dotnet test EditorConfigPreview.sln --collect:"XPlat Code Coverage"

format-frontend: ## Format frontend code with Prettier
	cd src/frontend && npm run format

review-prs: ## Dispatch address-reviews agents for open PRs
	./scripts/dispatch-pr-agents.sh

implement-issues: ## Dispatch agents for all open issues in the active milestone
	./scripts/dispatch-issue-agents.sh "$(MILESTONE)"

implement-issue: ## Dispatch an agent for a specific issue: make implement-issue ISSUE=7
	@test -n "$(ISSUE)" || (echo "Usage: make implement-issue ISSUE=<number>" && exit 1)
	claude --agent implement-issue --bg "Implement issue #$(ISSUE) in repository dellch/editorconfig-preview."

list-issues: ## List open issues in the active milestone
	@gh issue list --repo dellch/editorconfig-preview --milestone "$(MILESTONE)" --state open --json number,title,labels --template '{{range .}}#{{.number}}	{{.title}}	{{range .labels}}[{{.name}}] {{end}}{{"\n"}}{{end}}' | column -t -s '	'
