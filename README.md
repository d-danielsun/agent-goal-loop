# Agent Goal Loop

Agent Goal Loop is a vendor-neutral operating protocol and skill pack for
shipping one non-trivial objective through a gated, measurable, iterative agent
workflow.

It gives coding agents a repeatable way to decide:

- what the user is actually asking for;
- which route is small enough for the task;
- which checks and review gates are required;
- when to keep iterating;
- when to stop and ask a human.

It is designed for Codex, Claude Code, OpenAI-compatible agents, Hermes, internal
agent runtimes, and chat-only LLM workflows.

## Core Rule

Deliver exactly one objective. Classify the task and risk, choose the smallest
route, define gates, iterate with evidence, and stop when acceptance criteria and
required checks pass.

Do not turn every request into a heavyweight process. The loop exists to make
agent work safer and more measurable, not slower by default.

## What Is Included

| Path | What it does | When to use it |
| --- | --- | --- |
| [`skills/goal-loop/SKILL.md`](skills/goal-loop/SKILL.md) | Main delivery workflow. | Use for non-trivial feature, bug, docs, devex, security, or release work. |
| [`skills/lfd-design/SKILL.md`](skills/lfd-design/SKILL.md) | Loss-function and probe design helper. | Use when success is subjective, gradual, adversarial, or easy to overfit. |
| [`protocol/goal-loop.md`](protocol/goal-loop.md) | Runtime-neutral protocol contract. | Use when implementing the loop in your own agent runtime. |
| [`policies/risk-policy.yaml`](policies/risk-policy.yaml) | Risk levels and human escalation triggers. | Use before deciding whether the agent can continue autonomously. |
| [`policies/auto-approval.yaml`](policies/auto-approval.yaml) | Conditions for safe auto-approval. | Use before letting an agent mark work complete without a human. |
| [`harness/*.sh`](harness/) | Placeholder lint, score, probe, and status hooks. | Replace these with project-specific checks. |
| [`adapters/`](adapters/) | Installation instructions for different runtimes. | Use the adapter that matches your agent environment. |
| [`examples/`](examples/) | Sample goal definitions. | Use as starting templates for your own `.ai/runs/<task-id>/goal.md` files. |

## 5-Minute Install for Codex

From this repository, copy the Codex adapter and shared files into the project
where the agent will work:

```sh
cp adapters/codex/AGENTS.md /path/to/project/AGENTS.md
mkdir -p /path/to/project/.agent/skills /path/to/project/.ai/runs
cp -R skills/goal-loop /path/to/project/.agent/skills/
cp -R skills/lfd-design /path/to/project/.agent/skills/
cp -R policies /path/to/project/
cp -R harness /path/to/project/
```

Then ask Codex:

```text
Use AGENTS.md and the Goal Loop skill.
Objective: add a saved search feature for invoices.
Acceptance criteria:
- users can save the current invoice filters;
- saved searches appear in a dropdown;
- selecting one restores the filters;
- existing invoice search behavior still works.
Classify the task and risk, choose the smallest route, implement it, run the required checks, and write the run log.
```

Expected result:

- the agent classifies the task, usually `full_feature` or `backend_only`;
- the agent decides whether `lfd-design` is needed;
- the agent implements only the approved scope;
- the agent runs project checks and harness hooks;
- the agent records evidence under `.ai/runs/<task-id>/`.

## Installation by Runtime

Choose one adapter. You usually do not need all of them in the same project.

| Runtime | Install guide | Example invocation |
| --- | --- | --- |
| Codex | [`adapters/codex/INSTALL.md`](adapters/codex/INSTALL.md) | `Use AGENTS.md and the Goal Loop skill. Debug the failing checkout test and produce a run log.` |
| Claude Code | [`adapters/claude/INSTALL.md`](adapters/claude/INSTALL.md) | `/goal-loop Create user onboarding with a progress checklist and next recommended action.` |
| Generic/OpenAI-compatible | [`adapters/generic/INSTALL.md`](adapters/generic/INSTALL.md) | `Run the Agent Goal Loop Protocol for this objective. Use the docs route and verify all examples.` |
| GitHub publishing | [`adapters/github-1password/INSTALL.md`](adapters/github-1password/INSTALL.md) | `Publish this repository using the 1Password GitHub token reference. Do not print or store the token.` |

The generic adapter is the starting point for OpenAI-compatible agents, Hermes,
internal orchestrators, and chat-only LLMs that do not have native skill folders.

## How to Use Each Route

The route is the smallest workflow that can safely complete the objective.
Classify the route before planning.

### `full_feature`

Use when product behavior changes across multiple layers, such as UI plus API
plus persistence.

```text
Use the Goal Loop full_feature route.
Objective: add a team invitation flow.
Acceptance criteria:
- admins can invite a user by email;
- invited users receive an invitation link;
- accepted invitations add the user to the correct team;
- expired invitations cannot be used;
- existing team members are not duplicated.
Run product, engineering, security, and QA gates as applicable.
```

Expected gates:

- acceptance criteria are testable;
- security is reviewed if invitations affect access;
- regression tests cover duplicate, expired, and invalid invitations;
- release notes or rollout notes exist when shipping is requested.

### `frontend_only`

Use when the main risk is UX, layout, accessibility, browser behavior, or visual
quality.

```text
Use the Goal Loop frontend_only route.
Objective: improve the invoice table toolbar for high-volume finance users.
Acceptance criteria:
- search, date filter, status filter, export, and bulk actions are visible on desktop;
- mobile keeps the primary search and moves secondary actions into a menu;
- keyboard focus order is logical;
- no text overlaps at 375px, 768px, and 1440px widths.
Run browser QA and include screenshot evidence.
```

Expected gates:

- visual behavior is checked across target viewports;
- accessibility basics are verified;
- the design follows the existing design system;
- screenshots or browser evidence are recorded when available.

### `backend_only`

Use when the work is mostly services, jobs, APIs, data flow, integrations, or
server-side behavior.

```text
Use the Goal Loop backend_only route.
Objective: add idempotency to payment webhook processing.
Acceptance criteria:
- repeated webhook deliveries do not create duplicate payments;
- invalid signatures are rejected;
- processing is safe under concurrent delivery;
- existing successful payment flow still works.
Use the security gate because billing is touched.
```

Expected gates:

- failure modes are identified before implementation;
- tests cover retries and duplicate delivery;
- sensitive surfaces such as billing, auth, or permissions require human
  approval before completion.

### `debug`

Use when something is broken and the first job is to reproduce it.

```text
Use the Goal Loop debug route.
Bug: users sometimes see duplicate notifications after reconnecting.
Acceptance criteria:
- reproduce or explain why reproduction is not possible;
- isolate the likely cause;
- add or identify a regression test;
- apply the smallest safe fix;
- probe reconnect, refresh, and multi-tab cases.
```

Expected gates:

- the bug is reproduced or bounded with evidence;
- the fix is minimal;
- adjacent cases are probed;
- the agent does not hide or skip failing checks.

### `docs`

Use for documentation, guides, examples, READMEs, runbooks, or onboarding text.

```text
Use the Goal Loop docs route.
Objective: improve the README for a CLI library.
Acceptance criteria:
- explain who the library is for;
- show install commands;
- include one quick-start example;
- include examples for each supported command;
- verify that all command names match the source.
```

Expected gates:

- examples match real files, commands, or APIs;
- placeholders are clearly marked;
- docs explain both the happy path and common failure cases.

### `devex`

Use when the output is a better developer experience: SDK, CLI, API ergonomics,
local setup, examples, diagnostics, or test harnesses.

```text
Use the Goal Loop devex route.
Objective: make local setup for this repo one-command.
Acceptance criteria:
- a new contributor can install dependencies with one documented command;
- missing environment variables produce clear errors;
- the health check reports dependency, config, and test status;
- setup docs match the actual scripts.
```

Expected gates:

- the setup path is tested or dry-run where possible;
- error messages are actionable;
- docs and scripts stay in sync.

### `security`

Use when touching auth, permissions, privacy, secrets, abuse, payments, or
sensitive data.

```text
Use the Goal Loop security route.
Objective: restrict invoice export to finance admins.
Acceptance criteria:
- non-admin users receive a 403;
- finance admins can still export;
- audit logs record export attempts;
- tests cover allowed and denied users.
Human approval is required before marking complete.
```

Expected gates:

- threat model is explicit;
- scope is constrained;
- tests prove denied and allowed paths;
- high-risk completion requires human approval.

### `release`

Use when the task is to ship, deploy, roll back, canary, or prepare a release.

```text
Use the Goal Loop release route.
Objective: release version 1.4.0.
Acceptance criteria:
- changelog is updated;
- tests and lint pass;
- rollback instructions are written;
- canary or smoke checks are defined;
- production deploy waits for human approval.
```

Expected gates:

- the release checklist is explicit;
- rollback path is known;
- production changes are not auto-approved unless local policy allows it.

## How to Use `lfd-design`

Use `lfd-design` when "done" is not binary. Examples:

- improve a landing page;
- reduce support triage mistakes;
- rank search results better;
- generate higher-quality sales follow-ups;
- make an agent less likely to overfit visible tests.

Prompt example:

```text
Use lfd-design before implementation.
Objective: improve support ticket triage quality.
Acceptance criteria:
- urgent billing issues are never marked low priority;
- spam is separated from real customer issues;
- confidence below 0.75 triggers human review;
- results are measured on visible examples and holdout probes.
Create a loss function, hard-fail conditions, probes, and stop rules.
```

Typical output:

```yaml
score:
  correctness: 45
  urgency_detection: 20
  false_positive_control: 15
  explainability: 10
  maintainability: 10
pass_threshold: 90
hard_fail:
  - urgent_billing_marked_low
  - spam_sent_to_human_queue_without_reason
  - tests_fail
```

## Customizing the Harness

The files in [`harness/`](harness/) are placeholders. Replace them with the
checks that matter in the target project.

Example `harness/lint.sh` for a TypeScript project:

```sh
#!/usr/bin/env bash
set -euo pipefail
npm run lint
npm run typecheck
```

Example `harness/score.sh` for an eval-backed workflow:

```sh
#!/usr/bin/env bash
set -euo pipefail
python scripts/eval_support_triage.py --threshold 0.90
```

Example `harness/probe.sh` for edge cases:

```sh
#!/usr/bin/env bash
set -euo pipefail
python scripts/probe_support_triage.py \
  --case missing-email \
  --case long-portuguese-message \
  --case repeated-webhook
```

The agent should not weaken these scripts to pass. If a check is wrong, the
agent must explain why and ask for approval before changing the gate.

## Run Logs

Every non-trivial run should write evidence under:

```text
.ai/runs/<task-id>/
  goal.md
  plan.md
  loss.md
  iteration-log.md
  gate-results.md
  final.md
```

Minimum useful `final.md`:

```md
# Final

Task classification: debug
Risk classification: medium

Checks run:
- npm test
- harness/lint.sh
- harness/probe.sh

Gates:
- engineering-review: approved
- qa-review: approved

Remaining risks:
- Could not test Safari locally.

Decision:
- Complete. Acceptance criteria passed.
```

## Safety Defaults

Human approval is required for high-risk work, including auth, billing,
permissions, secrets, destructive migrations, data deletion, production deploys,
and high or critical security findings.

The agent must not:

- weaken tests, scorers, probes, or gates to pass;
- hardcode visible eval cases;
- hide failing checks;
- auto-approve high-risk changes;
- expand the objective without returning to planning.

## Publishing This Repository

Use [`adapters/github-1password/INSTALL.md`](adapters/github-1password/INSTALL.md)
and [`scripts/publish-github-from-1password.sh`](scripts/publish-github-from-1password.sh)
for a token-safe publishing flow that reads the GitHub token from 1Password.

Example:

```sh
GITHUB_OWNER='YOUR_ORG_OR_USER' \
GITHUB_REPO='agent-goal-loop' \
OP_GITHUB_TOKEN_REF='op://Agent Goal Loop/GitHub Publishing/token' \
./scripts/publish-github-from-1password.sh
```

Do not paste GitHub tokens into prompts, issues, PRs, logs, shell history, or
committed files.
