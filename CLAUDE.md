# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

EditorConfig Preview is a web app playground that lets users paste `.editorconfig` content and see how it affects sample C# code. The formatting is performed by `dotnet format` (Roslyn) on the backend — not reimplemented.

## Architecture

- **Frontend**: Vue 3 + TypeScript (Vite), in `frontend/`. Scaffolded with `create-vue`; follows standard Vue project conventions.
- **Backend**: .NET 10 minimal API, in `backend/`

The user edits an `.editorconfig` in the browser, clicks Format, and the backend applies it to fixed sample C# code via `dotnet format`, returning the formatted result.

## Commands

### Backend

```sh
cd backend
dotnet build
dotnet run
```

### Frontend

```sh
cd frontend
npm install
npm run dev
```
