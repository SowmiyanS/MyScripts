#!/usr/bin/env bash

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

if [ -z "$BRANCH" ]; then
    # not a repo
    exit 0
fi

# check for uncommited changes ( M - modified, A - added)
STATUS=""
if git status --procelain 2>/dev/null | grep -q '^\s*[^?]\s'; then
    STATUS="*" # mark with a star if there are tracked, uncommited changes
fi

# check for untracked files
if git status --procelain 2>/dev/null | grep -q '^\?\?'; then
    STATUS="${STATUS}?" # add a question mark if there are untracked files
fi

# check for remote tracking status (U - ahead, D - behind, B - both)
REMOTE_STATUS=""
# count commits ahead
AHEAD=$(git rev-list --count @{u}..HEAD 2>/dev/null)
# count commits behind
BEHIND=$(git rev-list --count HEAD..@{u} 2>/dev/null)

if [ "$AHEAD" -gt 0 ]; then
    REMOTE_STATUS="$AHEAD"
fi

if [ "$BEHIND" -gt 0 ]; then
    REMOTE_STATUS="${REMOTE_STATUS} $BEHIND"
fi

# output the result: [branch] status remote_status
echo " #[fg=green, bold]($BRANCH)#[default]${STATUS}#[fg=yellow]${REMOTE_STATUS}#[default] "
