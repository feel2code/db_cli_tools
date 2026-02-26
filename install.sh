#!/bin/bash

OS_NAME=$(uname)

if [[ "$OS_NAME" == "Darwin" || "$OS_NAME" == "Linux" ]]; then
  pipx install mycli
  pipx install pgcli
  pipx install litecli
  pipx install clickhouse-cli
  # if brew exists let's install mongosh with brew, otherwise skip it and user install it by themselves
    if command -v brew &> /dev/null; then
      brew install mongosh
    else
      echo "Homebrew is not installed. For mongosh install please visit https://www.mongodb.com/docs/mongodb-shell/install/"
    fi

else
  brew install pgcli mycli mongosh litecli clickhouse-cli
fi
