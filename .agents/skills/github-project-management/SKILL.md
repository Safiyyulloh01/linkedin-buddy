---
name: github-project-management
description: >-
  Industry-standard GitHub project management, repository hygiene, issue triage,
  PR lifecycle, Project V2 boards, and release engineering. Use when managing
  GitHub issues, organizing milestones, drafting releases, reviewing pull requests,
  or orchestrating repository workflows via gh CLI and GitHub MCP server.
---

# GitHub Project Management Skill

This skill provides an industry-standard operational framework for managing GitHub repositories, project boards, issue trackers, pull requests, and automated release cycles.

---

## 1. Authentication & Environment Pre-Flight

Before performing any repository modifications, verify active credentials and repository binding:

```bash
# 1. Verify GitHub CLI authentication
gh auth status

# 2. Verify repository remote context
gh repo view --json nameWithOwner,defaultBranchRef,isPrivate
```

When using GitHub MCP tools, verify access via `search_repositories` or `get_file_contents`.

---

## 2. Issue Tracking & Triage Standard

### Issue Label Taxonomy
Maintain consistency across repository issues with standard prefixes:
* `type:bug` — Unexpected failure, regression, or crash.
* `type:feat` — New capability or improvement.
* `type:chore` — Maintenance, tooling, dependency update, or refactoring.
* `type:docs` — Documentation, README, or architectural updates.
* `priority:critical` — High-severity blocker affecting main workflows.
* `priority:high` — Major issue planned for current milestone.
* `priority:medium` — Standard backlog item.
* `status:blocked` — Waiting on external dependency or design decision.

### Creating Well-Structured Issues
```bash
# Create an issue with labels and assignee
gh issue create \
  --title "feat(inbox): support threaded conversation export" \
  --body "### Problem Statement\n...\n### Acceptance Criteria\n- [ ] Criteria 1\n- [ ] Criteria 2" \
  --label "type:feat,priority:high" \
  --assignee "@me"
```

### Searching & Listing
```bash
# List open issues by milestone or label
gh issue list --state open --label "priority:high" --json number,title,labels,assignees
```

---

## 3. Branching & Trunk Protection Rules

Never commit unverified code directly to `main`. Follow this branch model:

1. **Naming Standard:**
   * Features: `feat/<subsystem>-<short-description>`
   * Bug Fixes: `fix/<subsystem>-<bug-description>`
   * Maintenance: `chore/<description>`
2. **Safe Pre-Edit Checkpointing:**
   Before running heavy refactoring or rebase operations, tag a local checkpoint:
   ```bash
   git tag -a checkpoint/pre-<feature> -m "Backup before <feature> edits"
   ```
3. **Synchronization with Main:**
   ```bash
   git fetch origin
   git rebase origin/main
   ```

---

## 4. Pull Request Lifecycle & Review Gate

Every PR must satisfy quality gates before merging into the default branch.

### Creating a Pull Request
Always provide clear context, reproduction/testing steps, and a link to the corresponding issue:
```bash
gh pr create \
  --title "feat(core): add two-phase commit verification pipeline" \
  --body "### Summary\n- Implements two-phase commit contract\n\n### Fixes\nCloses #12\n\n### Verification\n- [x] npm run verify passed\n- [x] Unit tests: 100% green" \
  --base main
```

### Monitoring CI / Check Runs
Before approving or merging, inspect status checks:
```bash
# Check status of PR checks
gh pr checks <pr-number>

# View recent GitHub Actions workflow runs
gh run list --limit 5
gh run view <run-id>
```

### Clean Squash & Merge
When merging, maintain clean conventional commit history:
```bash
gh pr merge <pr-number> --squash --delete-branch
```

---

## 5. GitHub Projects (V2) Board Orchestration

For repositories utilizing GitHub Projects (V2) for kanban, sprint planning, and roadmap tracking:

```bash
# List organization/user projects
gh project list --owner "@me"

# List items inside a project board
gh project item-list <project-number> --owner "@me" --format json

# Add an issue or pull request to a project
gh project item-add <project-number> --owner "@me" --url "<issue-or-pr-url>"

# View custom fields (Status, Priority, Sprint)
gh project field-list <project-number> --owner "@me"

# Edit field value on an item (e.g. move to Done)
gh project item-edit --project-id "<project-id>" --id "<item-id>" --field-id "<field-id>" --value "<value>"
```

---

## 6. Release Engineering & Semantic Versioning

Follow Semantic Versioning (`MAJOR.MINOR.PATCH`):
* `PATCH`: Bug fixes, selector updates, and non-breaking security patches.
* `MINOR`: Backward-compatible new features and tooling additions.
* `MAJOR`: Breaking API or architectural contract changes.

### Release Workflow:
1. Ensure `main` is completely synced and CI is 100% green:
   ```bash
   git checkout main && git pull origin main
   ```
2. Verify local quality gates:
   ```bash
   npm run verify # (lint, typecheck, build)
   ```
3. Generate changelog and draft GitHub release:
   ```bash
   gh release create "v0.1.0" \
     --title "v0.1.0 — Initial Stable Release" \
     --generate-notes \
     --notes "Detailed release highlights..."
   ```

---

## 7. Dual Tool Integration (CLI + MCP)

* **Use `github-mcp-server`** when operating via structured AI tool calls (`create_issue`, `get_pull_request`, `list_commits`, `search_code`).
* **Use `gh` CLI** for batch operations, CI monitoring (`gh run list`, `gh pr checks`), and project board v2 management (`gh project`).
