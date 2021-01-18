#!/usr/bin/env bash

set -e
set -x
set -u
set -o pipefail

CURRENT_TAG=$(git describe --tags --abbrev=0)
echo "Current tag is: ${CURRENT_TAG}"

# Get latest release of TypeScript
LATEST_UPSTREAM_TAG=$(git ls-remote  --exit-code --tags --refs --sort=-version:refname upstream | sed -r 's/^.*refs\/tags\/(.*)/\1/' | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | head -n 1)
echo "Latest tag is: ${LATEST_UPSTREAM_TAG}"

if [ "${CURRENT_TAG}" = "$LATEST_UPSTREAM_TAG" ]; then
  echo "midgard fork is up to date with current release"
  exit 0
fi

# Rebase forked changes onto new release
git rebase --onto "$LATEST_UPSTREAM_TAG" "$CURRENT_TAG" midgard

# Push updated fork to midgard branch
git push --force origin midgard midgard:"releases/${LATEST_UPSTREAM_TAG}-midgard"
