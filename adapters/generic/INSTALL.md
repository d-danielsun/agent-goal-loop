# Install Agent Goal Loop in a Generic LLM Runtime

Use this adapter for OpenAI-compatible agents, Hermes, internal agent platforms, chat-only LLMs, or runtimes without a native skill system.

## Required files to ingest

The agent should read these files in order:

1. `README.md`
2. `protocol/goal-loop.md`
3. `skills/goal-loop/SKILL.md`
4. `skills/lfd-design/SKILL.md`
5. `policies/risk-policy.yaml`
6. `policies/auto-approval.yaml`
7. `adapters/generic/SYSTEM_PROMPT.md`

## Runtime contract

The runtime must provide or simulate:

- file read/write access, or a workspace abstraction;
- command execution for tests and harness checks, when available;
- persistent run logs;
- a way to escalate to a human;
- a way to block high-risk auto-approval.

## Prompt-only installation

If the agent cannot read local files, paste this instruction:

```text
You are running the Agent Goal Loop Protocol.
Use one objective, explicit acceptance criteria, task/risk classification, the smallest applicable route, measurable gates, loss function design when needed, max 5 iterations, and human escalation for high-risk changes. Never weaken tests, scorers, probes, or gates to pass. Record decisions and evidence.
```

## API orchestration pattern

A platform can implement the loop externally:

```text
orchestrator classifies task
→ agent plans
→ verifier runs checks
→ reviewer gate decides
→ agent iterates
→ release gate approves or escalates
```

Keep the orchestrator responsible for state, iteration limits, and policy enforcement. Do not rely on the model alone to enforce critical safety rules.
