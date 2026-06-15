# Agent Goal Loop

Agent Goal Loop is a vendor-neutral operating protocol and skill pack for
shipping one non-trivial objective through a gated, measurable, iterative agent
workflow.

It is designed to work across Codex, Claude Code, OpenAI-compatible agents,
Hermes, and other LLM runtimes.

## What Is Included

- `skills/goal-loop/SKILL.md`: main delivery workflow.
- `skills/lfd-design/SKILL.md`: loss-function and probe design helper.
- `protocol/goal-loop.md`: runtime-neutral protocol contract.
- `policies/risk-policy.yaml`: risk classification and escalation rules.
- `policies/auto-approval.yaml`: conditions for safe auto-approval.
- `harness/*.sh`: placeholder lint, score, probe, and status hooks.
- `adapters/`: install instructions for Codex, Claude, generic runtimes, and GitHub publishing with 1Password.
- `examples/`: sample goal definitions for debug, frontend, and full-feature work.

## Core Rule

Deliver exactly one objective. Classify the task and risk, choose the smallest
route, define gates, iterate with evidence, and stop when acceptance criteria and
required checks pass.

## Quick Start

For Codex-style agents, copy the Codex adapter and skill files into a target
project:

```sh
cp adapters/codex/AGENTS.md /path/to/project/AGENTS.md
mkdir -p /path/to/project/.agent/skills /path/to/project/.ai/runs
cp -R skills/goal-loop /path/to/project/.agent/skills/
cp -R skills/lfd-design /path/to/project/.agent/skills/
cp -R policies /path/to/project/
cp -R harness /path/to/project/
```

Then ask the agent:

```text
Use AGENTS.md and the Goal Loop skill. Classify this task, choose the smallest loop, implement, run harness checks, and produce a run log.
```

## Installation Paths

Choose the adapter that matches the runtime:

| Runtime | Instructions | Use when |
| --- | --- | --- |
| Codex | `adapters/codex/INSTALL.md` | The project uses `AGENTS.md` or Codex-style repository instructions. |
| Claude Code | `adapters/claude/INSTALL.md` | The project uses `CLAUDE.md` and Claude skill folders. |
| Generic/OpenAI-compatible | `adapters/generic/INSTALL.md` | The agent can read files or ingest a system prompt, but has no native skill system. |
| GitHub publishing | `adapters/github-1password/INSTALL.md` | A repo should be published without exposing GitHub tokens in chat, shell history, or docs. |

The generic adapter is the starting point for other models and runtimes, including
OpenAI-compatible agents, Hermes, internal orchestrators, and chat-only LLMs.

## Claude Code

See `adapters/claude/INSTALL.md`.

## Generic Runtime

See `adapters/generic/INSTALL.md`.

## Publishing

See `adapters/github-1password/INSTALL.md` and
`scripts/publish-github-from-1password.sh` for a token-safe publishing flow that
reads the GitHub token from 1Password.

## Safety Defaults

Human approval is required for high-risk work, including auth, billing,
permissions, secrets, destructive migrations, data deletion, production deploys,
and high or critical security findings.
