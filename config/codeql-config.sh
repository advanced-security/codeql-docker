#!/bin/bash

export CODEQL_BIN_PATH="/codeql"
export CODEQL_CLI_PATH="$CODEQL_BIN_PATH/bin/codeql"

export CODEQL_DATABASES="/codeql/databases"
export CODEQL_RESULTS="/codeql/results"
# `code-scanning` (default), `security-extended`, or `security-and-quality`
export CODEQL_SUITE="code-scanning"

mkdir -p $CODEQL_DATABASES
mkdir -p $CODEQL_RESULTS

# Git Based metadata
export GIT_HASH=$(git rev-parse HEAD)
# Dynamically find the ref / branch to use
if [[ -z "$GITHUB_REF" ]]; then
    export GIT_REF="$GITHUB_REF"
else
    # Assumes that this is scanning a branch, not a Pull Request
    #   https://docs.github.com/en/code-security/secure-coding/configuring-codeql-code-scanning-in-your-ci-system#scanning-pull-requests
    export GIT_REF="refs/heads/$(git branch --show-current)"
fi
