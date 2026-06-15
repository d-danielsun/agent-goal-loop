# Claude Project Instructions: Agent Goal Loop

This project uses the Agent Goal Loop Protocol.

## Default behavior

Before any non-trivial implementation:

1. Classify the task.
2. Classify risk.
3. Select the smallest applicable route.
4. Define acceptance criteria.
5. Use `/lfd-design` when success is ambiguous, subjective, gradual, adversarial, or easy to overfit.
6. Implement only approved scope.
7. Run checks and record evidence.
8. Escalate high-risk changes.

## Skills

Use these skills when installed:

- `/goal-loop`: main delivery protocol.
- `/lfd-design`: loss function, scoring, probes, constraints, and stop conditions.

## Human approval required

Never auto-approve:

- auth changes;
- billing changes;
- permission changes;
- destructive migrations;
- secret handling;
- production deploy;
- data deletion;
- high or critical security findings.

## Required evidence

Final answers must include:

- task classification;
- risk classification;
- gates used;
- checks run;
- remaining risks;
- human approval requirement if any.
