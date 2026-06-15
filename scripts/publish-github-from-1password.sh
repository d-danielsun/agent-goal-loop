#!/usr/bin/env bash
set -euo pipefail

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "error: required command '$1' is not installed" >&2
    exit 1
  fi
}

require_env() {
  if [ -z "${!1:-}" ]; then
    echo "error: required environment variable '$1' is not set" >&2
    exit 1
  fi
}

require_cmd git
require_cmd curl
require_cmd op

require_env GITHUB_OWNER
require_env GITHUB_REPO

OP_GITHUB_TOKEN_REF="${OP_GITHUB_TOKEN_REF:-op://Agent Goal Loop/GitHub Publishing/token}"
GITHUB_VISIBILITY="${GITHUB_VISIBILITY:-private}"
GITHUB_CREATE_MODE="${GITHUB_CREATE_MODE:-user}"
GIT_BRANCH="${GIT_BRANCH:-$(git branch --show-current)}"

if [ -z "$GIT_BRANCH" ]; then
  echo "error: could not determine current git branch; set GIT_BRANCH explicitly" >&2
  exit 1
fi

if [ "$GITHUB_VISIBILITY" != "private" ] && [ "$GITHUB_VISIBILITY" != "public" ]; then
  echo "error: GITHUB_VISIBILITY must be 'private' or 'public'" >&2
  exit 1
fi

if [ "$GITHUB_CREATE_MODE" != "user" ] && [ "$GITHUB_CREATE_MODE" != "org" ]; then
  echo "error: GITHUB_CREATE_MODE must be 'user' or 'org'" >&2
  exit 1
fi

echo "Reading GitHub token from 1Password reference: $OP_GITHUB_TOKEN_REF" >&2
GITHUB_TOKEN="$(op read "$OP_GITHUB_TOKEN_REF")"

if [ -z "$GITHUB_TOKEN" ]; then
  echo "error: 1Password returned an empty token" >&2
  exit 1
fi

repo_api="https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}"
if [ "$GITHUB_CREATE_MODE" = "org" ]; then
  create_api="https://api.github.com/orgs/${GITHUB_OWNER}/repos"
else
  create_api="https://api.github.com/user/repos"
fi
private_json=false
if [ "$GITHUB_VISIBILITY" = "private" ]; then
  private_json=true
fi

status_code="$(curl -sS -o /tmp/goal-loop-gh-repo.json -w '%{http_code}' \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H 'Accept: application/vnd.github+json' \
  -H 'X-GitHub-Api-Version: 2022-11-28' \
  "$repo_api")"

if [ "$status_code" = "404" ]; then
  echo "Repository ${GITHUB_OWNER}/${GITHUB_REPO} not found; creating it." >&2
  status_code="$(curl -sS -o /tmp/goal-loop-gh-create.json -w '%{http_code}' \
    -X POST \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H 'Accept: application/vnd.github+json' \
    -H 'X-GitHub-Api-Version: 2022-11-28' \
    "$create_api" \
    -d "{\"name\":\"${GITHUB_REPO}\",\"private\":${private_json}}")"

  if [ "$status_code" -lt 200 ] || [ "$status_code" -ge 300 ]; then
    echo "error: failed to create GitHub repository; API returned HTTP $status_code" >&2
    cat /tmp/goal-loop-gh-create.json >&2
    exit 1
  fi
elif [ "$status_code" -lt 200 ] || [ "$status_code" -ge 300 ]; then
  echo "error: failed to inspect GitHub repository; API returned HTTP $status_code" >&2
  cat /tmp/goal-loop-gh-repo.json >&2
  exit 1
else
  echo "Repository ${GITHUB_OWNER}/${GITHUB_REPO} already exists." >&2
fi

remote_url="https://github.com/${GITHUB_OWNER}/${GITHUB_REPO}.git"
if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$remote_url"
else
  git remote add origin "$remote_url"
fi

askpass_file="$(mktemp)"
cleanup() {
  rm -f "$askpass_file"
  unset GITHUB_TOKEN
}
trap cleanup EXIT

cat >"$askpass_file" <<'ASKPASS'
#!/usr/bin/env bash
case "$1" in
  *Username*) printf '%s\n' 'x-access-token' ;;
  *Password*) printf '%s\n' "$GITHUB_TOKEN" ;;
  *) printf '\n' ;;
esac
ASKPASS
chmod 700 "$askpass_file"

echo "Pushing branch ${GIT_BRANCH} to ${remote_url}" >&2
GIT_ASKPASS="$askpass_file" GITHUB_TOKEN="$GITHUB_TOKEN" git push -u origin "$GIT_BRANCH"

repo_url="https://github.com/${GITHUB_OWNER}/${GITHUB_REPO}"
branch_url="${repo_url}/tree/${GIT_BRANCH}"

echo "Repository URL: ${repo_url}"
echo "Branch URL: ${branch_url}"
