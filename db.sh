#!/bin/bash

source $HOME/db_cli_tools/.env

select_db() {
    echo "-----------------------------------"
    echo "    DB interactive shell"
    echo "-----------------------------------"
    echo "1) ClickHouse"
    echo "2) Postgres"
    echo "3) Mongo"
    echo -n "Enter your choice [1-3]: "
}

select_env() {
    echo "-----------------------------------"
    echo "    Env select"
    echo "-----------------------------------"
    echo "1) Integration"
    echo "2) Staging"
    echo "3) Production"
    echo -n "Enter your choice [1-3]: "
}

while true; do
    select_db
    read db
    select_env
    read env

    if [ $db -eq 1 ]; then choosen_db="clickhouse"
    elif [ $db -eq 2 ]; then choosen_db="postgres"
    elif [ $db -eq 3 ]; then choosen_db="mongo"
    else exit 0
    fi

    if [ $env -eq 1 ]; then choosen_env="integration"
    elif [ $env -eq 2 ]; then choosen_env="staging"
    elif [ $env -eq 3 ]; then choosen_env="production"
    else exit 0
    fi

    connection_var="${choosen_db}_${choosen_env}"

    case $choosen_db in
        clickhouse)
            clickhouse-client "${!connection_var}"
            ;;
        postgres)
            psql "${!connection_var}"
            ;;
        mongo)
            mongosh "${!connection_var}"
            ;;
    esac

done
