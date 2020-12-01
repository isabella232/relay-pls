#!/usr/bin/env bash

export TRAVIS_BRANCH="${TRAVIS_BRANCH:-$(git branch | grep \* | cut -d ' ' -f2)}"
export TRAVIS_PULL_REQUEST="${TRAVIS_PULL_REQUEST:-}"
export RELAY_PLS_BUILD_DIR="${RELAY_PLS_BUILD_DIR:-.build}"
export NO_DOCKER_PUSH="${NO_DOCKER_PUSH:-yes}"

export RELAY_PLS_RELEASE_LATEST=
[ "${TRAVIS_BRANCH}" = "main" ] && [ "${TRAVIS_PULL_REQUEST}" = "false" ] && export RELAY_PLS_RELEASE_LATEST=true

DIRTY=
[ -n "$(git status --porcelain --untracked-files=no)" ] && DIRTY="-dirty"

TAG=$(git tag -l --contains HEAD | head -n 1)
if [ -n "${TAG}" ]; then
        export VERSION="${TAG}${DIRTY}"
    else
        export VERSION="$(git rev-parse --short HEAD)${DIRTY}"
fi

if [[ "$TRAVIS_PULL_REQUEST" == "false" ]]; then
        export NO_DOCKER_PUSH=
fi

if [ -n "${DIRTY}" ]; then
    export NO_DOCKER_PUSH=yes
fi

fail() {
    echo "ERROR: ${1}"
    exit 1
}
