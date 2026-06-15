# Install Agent Goal Loop in Claude Code

This adapter explains how Claude Code can install and use the Goal Loop skill from this repository.

## Installation modes

Choose one:

1. **Copy mode:** copy files from this repository into the target project.
2. **Symlink mode:** symlink files from a shared checkout.
3. **Submodule mode:** add this repository as a git submodule and reference its files.
4. **Prompt-only mode:** paste the protocol into Claude when filesystem installation is unavailable.

## Recommended Claude Code layout

In the target project:

```text
CLAUDE.md
.claude/
  skills/
    goal-loop/
      SKILL.md
    lfd-design/
      SKILL.md
  agents/
    product-reviewer.md
    engineering-reviewer.md
    design-reviewer.md
    security-reviewer.md
    qa-reviewer.md
  settings.json
.ai/
  runs/
```

## Step-by-step install

From the target project root, copy:

```bash
cp /path/to/agent-goal-loop/adapters/claude/CLAUDE.md ./CLAUDE.md
mkdir -p .claude/skills .ai/runs
cp -R /path/to/agent-goal-loop/skills/goal-loop .claude/skills/
cp -R /path/to/agent-goal-loop/skills/lfd-design .claude/skills/
cp -R /path/to/agent-goal-loop/policies ./policies
cp -R /path/to/agent-goal-loop/harness ./harness
```

Then ask Claude:

```text
Read CLAUDE.md. Load /goal-loop. Classify this task, select the smallest route, and follow the Goal Loop Protocol.
```

## Invocation examples

### Full feature

```text
/goal-loop Create user onboarding with progress checklist and next recommended action.
```

### Frontend only

```text
/goal-loop Redesign the pricing page. Use frontend route and design exploration if visual direction is unclear.
```

### Debug

```text
/goal-loop Debug duplicate payment webhook processing. Use debug route and require security review if billing logic is touched.
```

## Claude-specific guidance

- Use `CLAUDE.md` as the persistent project constitution.
- Use `.claude/skills/goal-loop/SKILL.md` for the main skill.
- Use `.claude/skills/lfd-design/SKILL.md` when scoring, probes, or evals are required.
- Use Claude subagents for product, engineering, design, QA, security, and release review when available.
- Use Claude hooks or project scripts to enforce lint, tests, scoring, and probes.

## What Claude should produce per run

Claude should create:

```text
.ai/runs/<task-id>/goal.md
.ai/runs/<task-id>/plan.md
.ai/runs/<task-id>/iteration-log.md
.ai/runs/<task-id>/gate-results.md
.ai/runs/<task-id>/final.md
```

## Safety defaults

Claude must not auto-approve high-risk work. Human approval is required for auth, billing, permissions, production deploys, destructive migrations, secrets, data deletion, and high/critical security findings.
