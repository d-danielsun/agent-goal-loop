# Install Agent Goal Loop in Codex

This adapter explains how to install the Goal Loop protocol for Codex-style coding agents.

## Recommended layout

```text
AGENTS.md
.agent/
  skills/
    goal-loop/SKILL.md
    lfd-design/SKILL.md
.ai/
  runs/
harness/
policies/
```

## Step-by-step install

From the target project root:

```bash
cp /path/to/agent-goal-loop/adapters/codex/AGENTS.md ./AGENTS.md
mkdir -p .agent/skills .ai/runs
cp -R /path/to/agent-goal-loop/skills/goal-loop .agent/skills/
cp -R /path/to/agent-goal-loop/skills/lfd-design .agent/skills/
cp -R /path/to/agent-goal-loop/policies ./policies
cp -R /path/to/agent-goal-loop/harness ./harness
```

## Invocation examples

Ask Codex:

```text
Use AGENTS.md and the Goal Loop skill. Classify this task, choose the smallest loop, implement, run harness checks, and produce a run log.
```

## Codex-specific guidance

- `AGENTS.md` is the persistent operating contract.
- The agent should inspect applicable instructions before touching files.
- The agent should run project checks before finishing.
- The agent should commit or open PRs only when the host environment requires it.
- The agent must not call high-risk work complete without human approval.
