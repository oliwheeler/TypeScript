#!/usr/bin/bash

set -e
set -u


# Get latest release of TypeScript
git remote set-url upstream git@github.com:microsoft/TypeScript.git
git fetch upstream
LATEST_TAG=$(git describe --tags $(git rev-list --tags --max-count=1))
echo "Latest tag is: ${LATEST_TAG}"

VERSION=$(npm run env | grep npm_package_version | sed 's/npm_package_version=//')
echo "Current version is: ${VERSION}"
CURRENT_TAG=$(git describe --tags)
echo "Current tag is: ${CURRENT_TAG}"
# Set Midgard fork version
# npm version "${VERSION}-midgard"

# Rebase forked changes onto new release
# git rebase --onto "$LATEST_TAG" 
