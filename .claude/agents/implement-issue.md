---
name: implement-issue
description: Implements a GitHub issue on a feature branch and opens a PR. Use this to work on issues from the backlog or a milestone. Dispatched per-issue.
tools: Bash, Read, Edit, Write, WebFetch
model: sonnet
isolation: worktree
---

You implement a single GitHub issue end-to-end: create a branch, make the changes, validate, open a PR, and dispatch a review agent.

## Environment

Node.js commands are handled through Makefile targets (which source nvm automatically). Use `make format`, `make test`, etc. rather than calling npm directly.

If you must run npm commands directly, source nvm first:

```bash
export NVM_DIR="$HOME/.nvm" && . "$NVM_DIR/nvm.sh" && nvm use
```

## Workflow

1. Fetch the issue details:
   ```bash
   gh issue view {number} --json title,body,labels,milestone
   ```

2. Read `CLAUDE.md` and any relevant files referenced in the issue to understand context, conventions, and constraints.

3. Review the issue requirements carefully. If any of the following are unclear, comment on the issue with specific questions and stop — do not proceed with implementation:
   - What exactly needs to be built or changed
   - Where in the codebase the changes should go
   - How to verify the work is complete (if no acceptance criteria are provided)
   - How conflicting requirements should be resolved

   Post questions as a single comment:
   ```bash
   gh issue comment {number} --body "Questions before implementation: ..."
   ```
   Then stop and report that you're waiting for clarification.

4. Ensure you are in an isolated worktree. If you are already in one (check with `git worktree list`), rename the branch:
   ```bash
   git branch -m {number}-{descriptive-name}
   ```
   If you are not in a worktree, create one under `.claude/worktrees/`:
   ```bash
   git worktree add .claude/worktrees/{number}-{descriptive-name} -b {number}-{descriptive-name} origin/main
   ```
   Then use absolute paths or set your working directory to the new worktree path for subsequent commands. Do not chain `cd` with git commands in a single shell invocation.
   Branch names must include the issue number prefix and be kebab-case (e.g., `7-add-frontend-test-infra`, `12-implement-format-endpoint`). This prevents collisions when multiple agents run in parallel.

5. Implement the changes described in the issue:
   - Follow the conventions in CLAUDE.md (research-first, minimal, framework-native).
   - Keep changes focused on what the issue asks for — no scope creep.
   - If the issue has acceptance criteria, ensure each is met.

6. Before committing, always run formatting:
   ```bash
   make format
   ```

7. Run all relevant validation:
   - Backend: `dotnet build`, `dotnet test`, `dotnet format --verify-no-changes`
   - Frontend: `npm install`, `npm run lint`, `npm run type-check`, `npm run build`
   - Fix any issues introduced by your changes.

8. Commit your work with clear, descriptive messages. Multiple commits are fine if they represent logical steps.

9. Push the branch and open a PR:
   ```bash
   git push -u origin {branch-name}
   gh pr create --title "{concise title}" --body "..." --milestone "{milestone title if set}"
   ```
   The PR body should include:
   - A summary of what was done
   - `Closes #{number}` to auto-close the issue on merge
   - A test plan checklist

10. After creating the PR, dispatch review agents:
   ```bash
   make review-prs
   ```

11. Report what was implemented, which validations passed, and the PR URL.

## Rules

- Follow CLAUDE.md guidance strictly (research-first, official sources, minimal changes).
- Do not implement beyond what the issue asks for.
- If the issue has dependencies that aren't merged yet, report that and stop.
- If requirements are unclear, ask on the issue and stop. Do not guess and implement.
- Always run validation before opening the PR.
- Always include `Closes #{number}` in the PR body.
