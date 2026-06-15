# Goal Loop Protocol

This document is the vendor-neutral operating contract for the Agent Goal Loop. Any LLM agent can implement it, regardless of model provider or runtime.

## Required inputs

Every non-trivial run must start with:

- `objective`: one clear outcome;
- `acceptance_criteria`: testable conditions;
- `task_type`: full_feature, frontend_only, backend_only, debug, docs, devex, security, release, or unknown;
- `risk_level`: low, medium, high, or critical;
- `max_iterations`: default 5;
- `allowed_tools`: tools the agent may use;
- `human_escalation_rules`: conditions that require a person.

## Task classification

Classify the task before planning.

| Task type | Use when | Typical route |
| --- | --- | --- |
| `full_feature` | Product behavior changes across multiple layers | clarify → loss function → plan → review → build → QA → security → ship |
| `frontend_only` | UI, UX, visual design, accessibility, browser behavior | clarify → design route → implement → browser QA → ship |
| `backend_only` | Services, data flow, APIs, jobs, integrations | clarify → engineering plan → implement → tests → review → ship |
| `debug` | Something is broken or regressed | reproduce → isolate → regression test → patch → probe → ship |
| `docs` | Documentation, guides, examples | devex review → generate/update docs → verify examples → ship |
| `devex` | API, SDK, CLI, platform experience | devex plan → implementation → examples/tests → devex review |
| `security` | Auth, permissions, secrets, abuse, privacy | security review → constrained patch → verification → human approval |
| `release` | Shipping, canary, rollback, deployment | release checklist → risk review → rollout → retro |

## Loop phases

### 1. Clarify

Resolve ambiguity before coding.

Output:

- problem statement;
- user or system story;
- acceptance criteria;
- non-goals;
- risk classification.

### 2. Design loss function

Use this phase when success is not purely binary, when quality can improve gradually, or when the agent might overfit visible tests.

Output:

- `goal.md`;
- scoring dimensions;
- hard-fail conditions;
- probes;
- constraints;
- stop conditions.

### 3. Route skills

Select the smallest applicable skill route. Do not use every skill by default.

### 4. Plan

Create an implementation plan with:

- ordered steps;
- expected files or modules;
- tests;
- risks;
- rollback plan;
- gates required before shipping.

### 5. Review plan

Use reviewers appropriate to the task:

- product reviewer;
- engineering reviewer;
- design reviewer;
- devex reviewer;
- security reviewer.

### 6. Implement

Implement only the approved scope. If implementation reveals new scope, return to planning.

### 7. Score

Run objective checks:

- tests;
- lint;
- type checks;
- score script;
- eval harness;
- quality checks.

### 8. Probe

Run variant or adversarial cases to detect overfitting and edge-case failure.

### 9. Review

Perform code, design, devex, QA, and security reviews as required.

### 10. Ship

Prepare release notes, rollback instructions, feature flags, and monitoring.

### 11. Retro

Record what worked, what failed, and which policies or examples should be updated.

## Completion criteria

A run is complete only when:

- all acceptance criteria pass;
- hard-fail conditions are absent;
- required tests/checks pass;
- required gates approve;
- score threshold is met when a loss function exists;
- probes do not reveal unacceptable overfitting;
- release checklist is complete when shipping is requested.

## Stop and escalation rules

Stop and ask for human help when:

- max iterations are reached;
- the same gate fails twice;
- the objective changes materially;
- high-risk files or systems are touched;
- tests, scoring, or gates would need weakening;
- auth, billing, permissions, data deletion, secrets, or production deploys are involved;
- a high or critical security finding remains.

## Required run log

Create `.ai/runs/<task-id>/` and record:

- `goal.md`;
- `plan.md`;
- `loss.md`, if used;
- `iteration-log.md`;
- `gate-results.md`;
- `final.md`.

Each iteration should include:

- hypothesis;
- change made;
- score before and after;
- checks run;
- gate results;
- next decision.
