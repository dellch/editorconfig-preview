# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

EditorConfig Preview is a web app playground that lets users paste `.editorconfig` content and see how it affects sample C# code. The formatting is performed by `dotnet format` (Roslyn) on the backend — not reimplemented.

## Architecture

- **Frontend**: Vue 3 + TypeScript (Vite). Scaffolded with `create-vue`; follows standard Vue project conventions.
- **Backend**: .NET 10 minimal API.

The user edits an `.editorconfig` in the browser, clicks Format, and the backend applies it to fixed sample C# code via `dotnet format`, returning the formatted result.

## Folder Structure

```
src/
├── backend/
│   └── App.Api/
└── frontend/
tests/
└── backend/
    └── App.Api.Tests/
```

## Commands

### Backend

```sh
cd src/backend/App.Api
dotnet build
dotnet run
```

### Frontend

```sh
cd src/frontend
npm install
npm run dev
```

### Tests

```sh
cd tests/backend/App.Api.Tests
dotnet test
```

## Git Worktrees

Use git worktrees for parallel work. Each feature or task should be developed in its own worktree so multiple Claude Code agents (or a developer and an agent) can work simultaneously without conflicts.

```sh
# Create a worktree for a new branch
git worktree add ../editorconfig-preview-<branch-name> -b <branch-name>

# List active worktrees
git worktree list

# Remove a worktree after merging
git worktree remove ../editorconfig-preview-<branch-name>
```

When using Claude Code's agent isolation (`isolation: "worktree"`), worktrees are managed automatically.

## Branching and Pull Requests

All work must be done on feature branches. Push branches to origin and create a pull request to integrate with `main`. Do not commit directly to `main`.

## Changelog

This repository maintains a `CHANGELOG.md` in the repo root. When preparing a release, update it with a summary of changes included in that release. Follow [Keep a Changelog](https://keepachangelog.com/) format.

## MCP Servers

Four MCP servers are configured in `.mcp.json` (project-scoped, shared with the team).

### Microsoft Learn

- **Purpose**: Search and fetch Microsoft documentation (articles and code samples).
- **Transport**: Remote HTTP (`https://learn.microsoft.com/api/mcp`)
- **Auth**: None required.

### NuGet

- **Purpose**: Search NuGet packages, check vulnerabilities, update package versions.
- **Transport**: Local stdio via `dnx NuGet.Mcp.Server`
- **Prerequisites**: .NET 10 SDK (provides the `dnx` command).

### Playwright

- **Purpose**: Browser automation for testing and inspecting the web app. Headed mode by default.
- **Transport**: Local stdio via `npx @playwright/mcp@latest`
- **Prerequisites**: Node.js/npm. To run headless, add `"--headless"` to args in `.mcp.json`.

### Context7

- **Purpose**: Query up-to-date open source library documentation.
- **Transport**: Remote HTTP (`https://mcp.context7.com/mcp`)
- **Auth**: Optional. Set `CONTEXT7_API_KEY` env var for higher rate limits.

### Verifying

Restart your Claude Code session after changes to `.mcp.json`, then run `/mcp` to confirm all servers connect.

## Technical Decision-Making

### Research first

Before making decisions about framework setup, package configuration, project structure, testing, build tooling, or security-sensitive implementation, consult current authoritative documentation. Do not rely solely on training data for tooling defaults, APIs, or best practices.

Prefer sources in this order:

1. Official product/framework documentation
2. Official GitHub repositories or organization-maintained config packages
3. Release notes and migration guides from the maintainer
4. High-quality secondary sources only when primary sources are insufficient

Use available MCP servers (Microsoft Learn, NuGet, Context7) and web fetch to verify current behavior rather than assuming.

### Prefer official baselines over copied config

When adopting ecosystem conventions:

- Use official presets, recommended scaffolding, or documented configuration paths when available.
- Do not copy configuration from a framework's own monorepo unless it is clearly appropriate for an application repo.
- When borrowing from an upstream project, distinguish between general ecosystem guidance and configuration specific to maintaining that upstream project itself.

### Keep changes minimal and intentional

- Start with the smallest setup that satisfies the request.
- Do not add libraries, abstractions, folder structures, or custom configuration without a clear reason.
- Do not build speculative architecture for features that do not exist yet.
- Prefer conventions that are easy for future contributors to understand.
- When making non-obvious choices, briefly state the rationale in the summary or a short inline comment.

## Validation

After making code or configuration changes, run the relevant checks that are available:

- `dotnet build` / `dotnet test` / `dotnet format --verify-no-changes`
- `npm install` / `npm run lint` / `npm run type-check` / `npm run build`

Requirements:

- Report which validation commands were run and whether they passed.
- Fix problems introduced by your own changes where practical.
- State clearly when a command could not be run and why.

## Documentation

Keep repository documentation aligned with the actual developer workflow. When adding tooling, scripts, or setup conventions, update the relevant docs (README or CLAUDE.md) with:

- Prerequisites
- Install/setup commands
- Local development commands
- Lint/format/type-check/test/build commands
- Any unusual decisions contributors need to know

Documentation should be concise, direct, and accurate. Remove stale content rather than leaving it alongside corrections.

## API Conventions

All API error responses must use the [RFC 7807 Problem Details](https://datatracker.ietf.org/doc/html/rfc7807) format. .NET's built-in Problem Details support should be used on the backend.

## Code and Configuration Quality

- Clear naming and explicit intent over clever brevity.
- Framework-native patterns over custom abstractions.
- Consistency across files — do not mix competing conventions.
- Enforceable conventions (linters, formatters, CI checks) over honor-system rules.
- No dead configuration, stale comments, or duplicated settings.
- Do not silently introduce conflicting conventions.
