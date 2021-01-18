#!/usr/bin/env bash

set -eu
set -o pipefail
set -x

RELEASE_BRANCH="$1"

TS_VERSION=$(echo "${RELEASE_BRANCH}" | sed -E 's/^refs\/heads\/releases\/(.*)-midgard/\1/')

# Find the latest tag

LATEST_TAG_EXIT_CODE=0
LATEST_TAG=$(git ls-remote  --exit-code --tags --refs --sort=-version:refname origin "${TS_VERSION}-midgard.*" | head -n 1 | sed -r 's/^.*refs\/tags\/(.*)/\1/' ) || LATEST_TAG_EXIT_CODE=$?
if [[ "$LATEST_TAG_EXIT_CODE" = 0 ]]; then
  PREV_PATCH=$(echo "$LATEST_TAG" | sed -r 's/.*-midgard\.(.+)/\1/')
  PATCH_VERSION=$(($PREV_PATCH + 1 ))
else
  echo "Creating first release of fork on TS verion: ${TS_VERSION}"
  PATCH_VERSION=0
fi

# Build
npm install
npm run jake LKG
git add .
git commit -m "Update LKG"

# Update name.
sed -i -E "s/\"name\": \"typescript\"/\"name\": \"@msfast\/typescript-platform-resolution\"/" package.json
git commit -a -m "Update name to @msfast/typescript-platform-resolution"

# Set Midgard fork version

NEXT_VERSION="${TS_VERSION}-midgard.${PATCH_VERSION}"
echo "New midgard version is: ${NEXT_VERSION}"
npm version "$NEXT_VERSION"

# Push midgard fork release
git push origin --tags
