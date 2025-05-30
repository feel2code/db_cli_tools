#!/bin/bash
# db_cli_tools interactive DB connector

show_help() {
    echo "Usage: ./db.sh"
    echo
    echo "This interactive script integrates several db cli tools into one."
    echo
    echo "Options:"
    echo "  --help      Show this help message"
    echo
    echo "You can also add <alias db=\"bash ~/db_cli_tools/db.sh\"> to your shell rc file (e.g. .bashrc) to run this script from anywhere."
    echo
}

if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

source $HOME/db_cli_tools/.env

select_db() {
    echo "-----------------------------------"
    echo "    DB interactive shell"
    echo "-----------------------------------"
    echo "1) ClickHouse"
    echo "2) Postgres"
    echo "3) Mongo"
    echo "4) MySQL int"
    echo "5) MySQL ext"
    echo "6) SQLite"
    echo -n "Enter your choice [1-5]: "
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

select_cluster() {
    echo "-----------------------------------"
    echo "    Cluster select"
    echo "-----------------------------------"
    echo "1) Main"
    echo "2) Analytics"
    echo "3) Api"
    echo -n "Enter your choice [1-3]: "
}

while true; do
    select_db
    read db

    if [ $db -eq 1 ]; then choosen_db="clickhouse"
    elif [ $db -eq 2 ]; then choosen_db="postgres"
    elif [ $db -eq 3 ]; then choosen_db="mongo"
    elif [ $db -eq 4 ]; then choosen_db="mysql_int"
    elif [ $db -eq 5 ]; then choosen_db="mysql_ext"
    elif [ $db -eq 6 ]; then choosen_db="sqlite"
    else exit 0
    fi

    select_env
    read env

    if [ $env -eq 1 ]; then choosen_env="integration"
    elif [ $env -eq 2 ]; then choosen_env="staging"
    elif [ $env -eq 3 ]; then choosen_env="production"
    else exit 0
    fi

    if [ $db -eq 1 ]; then
      select_cluster
      read cluster
      if [ $cluster -eq 1 ]; then choosen_cluster="9000"
      elif [ $cluster -eq 2 ]; then choosen_cluster="9001"
      elif [ $cluster -eq 3 ]; then choosen_cluster="9002"
      else exit 0
      fi
    fi

    connection_var="${choosen_db}_${choosen_env}"

    case $choosen_db in
        clickhouse)
            clickhouse client "${!connection_var}":$choosen_cluster -f PrettySpaceNoEscapes
            ;;
        postgres)
            pgcli "${!connection_var}"
            ;;
        mongo)
            mongosh "${!connection_var}"
            ;;
        mysql_int)
            mycli "${!connection_var}"
            ;;
        mysql_ext)
            mycli "${!connection_var}"
            ;;
        sqlite)
            litecli "${!connection_var}"
            ;;
    esac

done
