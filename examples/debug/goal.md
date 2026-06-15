# Example: Debug Goal

## Objective

Fix duplicate payment webhook handling.

## Acceptance criteria

1. Duplicate webhook deliveries do not create duplicate charges or orders.
2. Out-of-order webhook delivery does not corrupt state.
3. A regression test covers the duplicate delivery case.
4. Billing behavior is not weakened.

## Suggested route

`debug` route with high-risk billing escalation:

1. reproduce;
2. isolate;
3. regression test;
4. minimal patch;
5. probes for duplicate and out-of-order events;
6. security/billing review;
7. human approval before ship.

## Hard fails

- Duplicate charge remains possible.
- Signature validation is weakened.
- Test coverage is missing.
