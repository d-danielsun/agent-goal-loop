# Publish with GitHub token stored in 1Password

This adapter explains how to publish this repository, or any repository that uses Agent Goal Loop, to GitHub without pasting tokens into chat, shell history, or documentation.

## Security model

The token must live in 1Password. Agents should only receive a 1Password secret reference such as:

```text
op://Agent Goal Loop/GitHub Publishing/token
```

The actual token value must never be pasted into prompts, issues, PRs, logs, or committed files.

## Required tools

The publishing environment needs:

- `op`, the 1Password CLI;
- `curl`;
- `git`;
- a 1Password account session or `OP_SERVICE_ACCOUNT_TOKEN` configured outside the chat.

`gh` is optional. The provided script uses the GitHub REST API directly so it can work without GitHub CLI.

## Required 1Password item

Create a 1Password item with a token field:

```text
Vault: Agent Goal Loop
Item: GitHub Publishing
Field: token
Secret reference: op://Agent Goal Loop/GitHub Publishing/token
```

The GitHub token should have the minimum permissions needed to create and push to the target repository.

For a fine-grained personal access token, use permissions similar to:

- Repository creation if the script should create the repo;
- Contents: read/write for the target repository;
- Metadata: read.

For an organization repository, the token owner must also have permission to create repositories in that organization.

## Non-interactive agent setup

In CI or an agent container, configure 1Password with a service account token outside the chat:

```bash
export OP_SERVICE_ACCOUNT_TOKEN="...set by secret manager, not by prompt..."
```

Then verify that the secret reference resolves without printing the token:

```bash
op read 'op://Agent Goal Loop/GitHub Publishing/token' >/dev/null
```

## Publish command

From the repository root:

```bash
GITHUB_OWNER='YOUR_ORG_OR_USER' \
GITHUB_REPO='agent-goal-loop' \
OP_GITHUB_TOKEN_REF='op://Agent Goal Loop/GitHub Publishing/token' \
./scripts/publish-github-from-1password.sh
```

Optional settings:

```bash
GITHUB_VISIBILITY='private'   # private or public; default private
GITHUB_CREATE_MODE='user'     # user or org; default user
GIT_BRANCH='work'             # default current branch
```

## What the script does

1. Reads the GitHub token from 1Password using `op read`.
2. Creates the GitHub repository if it does not already exist, either under the authenticated user or under an organization when `GITHUB_CREATE_MODE=org`.
3. Adds or updates the `origin` remote.
4. Pushes the selected branch using a temporary `GIT_ASKPASS` helper.
5. Prints the repository and branch URLs.

## What the script does not do

- It does not print the token.
- It does not write the token to Git config.
- It does not store the token in the remote URL.
- It does not commit secrets.

## Troubleshooting

### `op command not found`

Install the 1Password CLI in the agent environment or use a base image that includes it.

### `OP_SERVICE_ACCOUNT_TOKEN is not set`

Configure a 1Password service account token through the environment, CI secret store, or container secret manager. Do not paste it into chat.

### GitHub API returns 401

The token is missing, expired, revoked, or does not have the required permissions.

### GitHub API returns 403

The token is valid but lacks permission to create or push to the target repository or organization.
