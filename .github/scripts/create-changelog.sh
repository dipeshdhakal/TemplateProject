#!/bin/sh

git fetch --tags origin main
LAST_TAG="$(git describe --tags --abbrev=0)"
echo "LAST_TAG: $LAST_TAG"

CHANGE_LOG="$(git log --first-parent --merges --pretty=tformat:"%b (%h)" $LAST_TAG..HEAD | awk '$0="- "$0')"
echo "CHANGE_LOG:"
echo "$CHANGE_LOG"

{
  echo 'content<<EOF'
  echo "$CHANGE_LOG"
  echo EOF
} >> "$GITHUB_OUTPUT"
