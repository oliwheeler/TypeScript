#!/usr/bin/env bash

set -e
set -x
set -u
set -o pipefail

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

# Usage
# $ get_latest_release "creationix/nvm"
# v0.31.4

CURRENT_TAG=$(git describe --tags --abbrev=0)
echo "Current tag is: ${CURRENT_TAG}"

LATEST_TAG="$(get_latest_release microsoft/TypeScript)"
echo "Latest tag is: ${LATEST_TAG}"

if [ "${CURRENT_TAG}" = "$LATEST_TAG" ]; then
  echo "midgard fork is up to date with current release"
  exit 0
fi

# Get latest release of TypeScript
git remote set-url upstream git@github.com:microsoft/TypeScript.git
git fetch upstream

# Rebase forked changes onto new release
git rebase --onto "$LATEST_TAG" "$CURRENT_TAG" midgard

# Push updated fork to midgard branch
git push --force origin midgard midgard:"releases/${LATEST_TAG}-midgard"
