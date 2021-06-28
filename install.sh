#!/bin/bash

get_latest_release() {
  # https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
  curl --silent "https://api.github.com/repos/github/codeql-action/releases/latest" |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/'
}

CODEQL_BIN_PATH="/codeql"
CODEQL_CLI_ARCHIVE="/codeql/codeql.tar.gz"
CODEQL_CLI_PATH="$CODEQL_BIN_PATH/bin/codeql"

# https://github.com/github/codeql-action/releases
CODEQL_CLI_LATEST=$(get_latest_release)
CODEQL_CLI_RELEASE_URL="https://github.com/github/codeql-action/releases/download/$CODEQL_CLI_LATEST/codeql-bundle-linux64.tar.gz"

echo "CodeQL URL :: $CODEQL_CLI_RELEASE_URL"
echo "CodeQL CLI Path :: $CODEQL_CLI_PATH"

echo "Creating directory: $CODEQL_BIN_PATH"
mkdir -p $CODEQL_BIN_PATH

echo "Downloading Archive..."
curl -o "$CODEQL_CLI_ARCHIVE" -L $CODEQL_CLI_RELEASE_URL

echo "Extracting Archive..."
tar -xvzf $CODEQL_CLI_ARCHIVE -C $CODEQL_BIN_PATH
# This move is to make path not '/codeql/codeql/codeql' ...
mv /codeql/codeql /codeql/bin

echo "Create bin Symlink..."
ln -s $CODEQL_CLI_PATH /usr/bin/codeql

echo "CodeQL CLI Version"
codeql --version

echo "Cleaning up image..."
rm -f $CODEQL_CLI_ARCHIVE
