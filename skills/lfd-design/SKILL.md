---
name: lfd-design
description: Design a loss function, scoring harness, probes, constraints, and stop conditions for long-running agent work.
---

# Loss Function Design Skill

Use this skill when success is ambiguous, subjective, gradual, adversarial, or easy to overfit.

## Inputs

- objective;
- acceptance criteria;
- known constraints;
- available tests or evals;
- risk level;
- max iterations.

## Outputs

Create or update:

- `goal.md` with target and pass threshold;
- `loss.md` with scoring dimensions;
- `harness/score.sh` or equivalent scorer;
- `harness/probe.sh` or equivalent probes;
- hard-fail conditions;
- anti-cheat rules;
- stop conditions.

## Loss function template

```yaml
score:
  correctness: 40
  robustness: 20
  security_or_privacy: 15
  maintainability: 15
  user_or_developer_experience: 10
pass_threshold: 90
hard_fail:
  - tests_fail
  - critical_security_issue
  - objective_not_met
  - data_loss_risk
```

## Probe examples

- edge-case inputs;
- larger datasets;
- missing data;
- slow or failing dependency;
- alternate viewport sizes;
- repeated webhooks;
- invalid auth;
- old API clients;
- long localized strings.

## Anti-overfitting rules

The agent must not:

- hardcode visible eval answers;
- modify evals to fit the implementation;
- weaken scorers or probes;
- ignore holdout/probe failures;
- optimize only for a screenshot or single example.

## Stop rules

Stop when:

- pass threshold is reached;
- hard-fail conditions are absent;
- probes pass;
- score stalls for two iterations;
- max iterations are reached;
- a human escalation condition appears.
