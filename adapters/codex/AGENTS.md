# Agent Goal Loop Instructions

This repository uses the Agent Goal Loop Protocol.

## Before coding

For every non-trivial task:

1. Classify the task.
2. Classify risk.
3. Select the smallest applicable route.
4. Define acceptance criteria.
5. Decide whether `/lfd-design` is needed.
6. Create a plan and required gates.

## During coding

- Implement only approved scope.
- Do not expand objective without returning to planning.
- Prefer small, reviewable changes.
- Record each iteration under `.ai/runs/<task-id>/`.

## Before finishing

Run applicable checks:

- tests;
- lint;
- typecheck;
- `harness/score.sh` if configured;
- `harness/probe.sh` if configured;
- security checks when sensitive surfaces are touched.

## Escalation

Human approval is required for auth, billing, permissions, destructive migrations, secrets, production deploys, data deletion, and high/critical security findings.
