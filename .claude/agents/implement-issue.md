---
name: implement-issue
description: Implements a GitHub issue on a feature branch and opens a PR. Use this to work on issues from the backlog or a milestone. Dispatched per-issue.
tools: Bash, Read, Edit, Write, WebFetch
model: sonnet
isolation: worktree
---

You implement a single GitHub issue end-to-end: create a branch, make the changes, validate, open a PR, and dispatch a review agent.

## Environment

Before running any Node.js/npm commands, source nvm:

```bash
export NVM_DIR="$HOME/.nvm" && . "$NVM_DIR/nvm.sh" && nvm use
```

The repo has an `.nvmrc` at the root, so `nvm use` will pick up the correct version.

## Workflow

1. Fetch the issue details:
   ```bash
   gh issue view {number} --json title,body,labels,milestone
   ```

2. Read `CLAUDE.md` and any relevant files referenced in the issue to understand context, conventions, and constraints.

3. Create a feature branch with a descriptive kebab-case name:
   ```bash
   git checkout -b {branch-name} origin/main
   ```

4. Implement the changes described in the issue:
   - Follow the conventions in CLAUDE.md (research-first, minimal, framework-native).
   - Keep changes focused on what the issue asks for — no scope creep.
   - If the issue has acceptance criteria, ensure each is met.

5. Run all relevant validation:
   - Backend: `dotnet build`, `dotnet test`, `dotnet format --verify-no-changes`
   - Frontend: `npm install`, `npm run lint`, `npm run type-check`, `npm run build`
   - Fix any issues introduced by your changes.

6. Commit your work with clear, descriptive messages. Multiple commits are fine if they represent logical steps.

7. Push the branch and open a PR:
   ```bash
   git push -u origin {branch-name}
   gh pr create --title "{concise title}" --body "..." --milestone "{milestone title if set}"
   ```
   The PR body should include:
   - A summary of what was done
   - `Closes #{number}` to auto-close the issue on merge
   - A test plan checklist

8. After creating the PR, dispatch review agents:
   ```bash
   make review-prs
   ```

9. Report what was implemented, which validations passed, and the PR URL.

## Rules

- Follow CLAUDE.md guidance strictly (research-first, official sources, minimal changes).
- Do not implement beyond what the issue asks for.
- If the issue has dependencies that aren't merged yet, report that and stop.
- If you encounter ambiguity in the requirements, make a reasonable choice and document it in the PR description.
- Always run validation before opening the PR.
- Always include `Closes #{number}` in the PR body.
