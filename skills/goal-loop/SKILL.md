---
name: goal-loop
description: Deliver one non-trivial objective through a gated, measurable, iterative agent workflow that works across Claude, Codex, OpenAI-compatible agents, Hermes, and other LLM runtimes.
---

# Goal Loop Skill

Use this skill when the user asks an agent to complete a non-trivial task, create a feature, debug a complex issue, improve UI, ship a release, or coordinate multiple review gates.

## Prime directive

Deliver exactly one objective. Do not expand scope without returning to planning and review.

## Step 1: classify the task

Choose one:

- `full_feature`
- `frontend_only`
- `backend_only`
- `debug`
- `docs`
- `devex`
- `security`
- `release`
- `unknown`

If unknown, ask only the minimum clarifying questions needed, then classify.

## Step 2: classify risk

Use `policies/risk-policy.yaml`.

Default to higher risk when uncertain.

## Step 3: select the smallest route

### Full feature route

Use when the task changes product behavior across multiple layers.

1. Clarify objective and acceptance criteria.
2. Use `/lfd-design` when success is ambiguous, subjective, or prone to overfitting.
3. Create plan.
4. Run product, engineering, design, devex, or security review as applicable.
5. Implement only approved scope.
6. Run tests, score, lint, and probes.
7. Review implementation.
8. Run QA/security gates.
9. Ship only when gates pass.
10. Record retro.

### Frontend route

Use when UI/UX/visual behavior is central.

1. Clarify user journey and acceptance criteria.
2. Identify whether a design system exists.
3. Use design exploration when visual direction is unclear.
4. Implement approved direction.
5. Run browser QA, accessibility checks, responsive probes, and design review.
6. Ship with screenshots or visual evidence when possible.

### Debug route

Use when something is broken.

1. Reproduce the bug.
2. Isolate likely cause.
3. Add or identify a failing regression test.
4. Apply the smallest safe patch.
5. Probe adjacent cases.
6. Run review and ship.

### Docs/devex route

Use when changing docs, API, SDK, CLI, examples, or developer workflows.

1. Clarify target developer.
2. Review desired developer experience.
3. Update docs/examples/tests.
4. Verify examples are runnable or clearly marked.
5. Run devex review.

### Security route

Use when touching auth, permissions, privacy, secrets, abuse, payments, or sensitive data.

1. Define threat model.
2. Restrict scope.
3. Implement minimal patch.
4. Run security checks.
5. Require human approval for high-risk outcomes.

## Step 4: define gates

Every route must define required gates before implementation.

Gate result format:

```yaml
gate: engineering-review
status: approved | rejected | needs_human
evidence:
  - item
blocking_issues:
  - issue
required_changes:
  - change
next_action: continue | revise_plan | reimplement | escalate
```

## Step 5: iterate

For each iteration:

1. State hypothesis.
2. Make the smallest change likely to improve the score or pass the gate.
3. Run checks.
4. Record evidence.
5. Decide continue, revise, ship, or escalate.

Default max iterations: 5.

## Step 6: completion

Finish only when:

- acceptance criteria pass;
- required checks pass;
- gates approve;
- score threshold passes if a loss function exists;
- probes pass;
- no escalation condition remains.

## Forbidden shortcuts

Do not:

- weaken tests to pass;
- weaken score scripts to pass;
- remove gates to ship faster;
- hardcode visible eval cases;
- hide failing checks;
- expand scope without approval;
- auto-approve high-risk work.

## Final response requirements

When reporting back, include:

- summary of changes or decisions;
- task classification;
- risk classification;
- gates used;
- checks run;
- remaining risks;
- whether human approval is required.
