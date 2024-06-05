#!/bin/sh

# Fetch tags and ensure the command completes successfully
git fetch --tags origin main || { echo "Failed to fetch tags"; exit 1; }

# Get the latest tag
LAST_TAG="$(git describe --tags --abbrev=0)"
if [ -z "$LAST_TAG" ]; then
  echo "No tags found in the repository"
  exit 1
fi
echo "LAST_TAG: $LAST_TAG"

# Generate the changelog
CHANGE_LOG="$(git log --first-parent --merges --pretty=tformat:"%b (%h)" $LAST_TAG..HEAD | awk '{print "- " $0}')"
if [ -z "$CHANGE_LOG" ]; then
  echo "No merge commits found since $LAST_TAG"
  exit 1
fi
echo "CHANGE_LOG:"
echo "$CHANGE_LOG"

# Append the changelog to the GitHub output file
if [ -z "$GITHUB_OUTPUT" ]; then
  echo "GITHUB_OUTPUT is not set"
  exit 1
fi
{
  echo 'content<<EOF'
  echo "$CHANGE_LOG"
  echo EOF
} >> "$GITHUB_OUTPUT"
