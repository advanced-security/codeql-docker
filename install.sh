#!/bin/bash

INSTALL_GITHUB_CLI=0

for i in "$@"; do
  case $i in
    --github-cli)
      INSTALL_GITHUB_CLI=1
      shift # past argument with no value
      ;;
    -*|--*)
      echo "Unknown option $i"
      exit 1
      ;;
    *)
      ;;
  esac
done

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

if [[ $INSTALL_GITHUB_CLI = "1" ]]; then
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt update
  sudo apt install gh
fi
