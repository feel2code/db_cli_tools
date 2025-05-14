#!/bin/bash

OS_NAME=$(uname)

if [[ "$OS_NAME" == "Darwin" || "$OS_NAME" == "Linux" ]]; then

  curl https://clickhouse.com/ | sh
  sudo ./clickhouse install
  pipx install mycli
  pipx install pgcli
  pipx install litecli
  # for mongosh install please visit
  # https://www.mongodb.com/docs/mongodb-shell/install/

else
  curl https://clickhouse.com/ | sh
  sudo ./clickhouse install
  brew install pgcli mycli mongosh litecli

fi
