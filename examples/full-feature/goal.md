# Example: Full Feature Goal

## Objective

Create an onboarding checklist that helps new users complete setup.

## Acceptance criteria

1. New users see a checklist after signup.
2. Checklist items persist across sessions.
3. Completed items show progress.
4. Users can dismiss the checklist.
5. Existing users are not disrupted.

## Suggested route

`full_feature` route:

1. clarify;
2. lfd-design;
3. product review;
4. engineering review;
5. design review;
6. implementation;
7. score/probe;
8. QA;
9. ship.

## Hard fails

- Existing users are blocked.
- Progress state is lost.
- Checklist appears for wrong account.
- Tests fail.
