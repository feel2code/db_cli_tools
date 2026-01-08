#!/bin/bash
# db_cli_tools interactive DB connector
set -e

original_window_name=$(tmux display-message -p '#{window_name}')

cleanup() {
    tmux rename-window "$original_window_name"
}
trap cleanup EXIT

# colors setup
RD='\033[31m'
GR='\033[32m'
BLD='\033[1m'
NC='\033[0m'

# functions def
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

# sourcing for creds
source $HOME/db_cli_tools/.env

eof_check() {
    local __resultvar=$1
    if ! read input; then
        echo "Exiting... Bye! 🙌"
        exit 0
    fi
    printf -v "$__resultvar" '%s' "$input"
}

select_db() {
    echo -e "${GR}-----------------------------------"
    echo -e "    DB interactive shell 🔥"
    echo -e "-----------------------------------${NC}"
    echo "1) ClickHouse"
    echo "2) ClickHouse AWS"
    echo "3) Postgres"
    echo "4) Mongo"
    echo "5) MySQL int"
    echo "6) MySQL ext"
    echo "7) SQLite"
    echo -ne "${GR}Enter your choice [1-6]: ${NC}"
    eof_check db
}


select_env() {
    echo -e "${GR}-----------------------------------"
    echo -e "    Env select ✨"
    echo -e "-----------------------------------${NC}"
    echo "1) Integration"
    echo "2) Staging"
    echo "3) Production"
    echo -ne "${GR}Enter your choice [1-4]: ${NC}"
    eof_check env
}


select_cluster() {
    echo -e "${GR}-----------------------------------"
    echo "    Cluster select ⚡️"
    echo -e "-----------------------------------${NC}"
    echo "1) Main"
    echo "2) Analytics"
    echo "3) Api"
    echo -ne "${GR}Enter your choice [1-4]: ${NC}"
    eof_check cluster
}

invalid_choice() {
    echo -e "${RD}${BLD}Invalid choice, please try again. 🥲${NC}"
}


# main
while true; do
    while true; do
        select_db
        if [ $db -eq 1 ]; then choosen_db="clickhouse"
        elif [ $db -eq 2 ]; then choosen_db="aws"
        elif [ $db -eq 3 ]; then choosen_db="postgres"
        elif [ $db -eq 4 ]; then choosen_db="mongo"
        elif [ $db -eq 5 ]; then choosen_db="mysql_int"
        elif [ $db -eq 6 ]; then choosen_db="mysql_ext"
        elif [ $db -eq 7 ]; then choosen_db="sqlite"
        else 
            invalid_choice
            continue
        fi
        break
    done

    while true; do
        select_env
        if [ $env -eq 1 ]; then choosen_env="integration"
        elif [ $env -eq 2 ]; then choosen_env="staging"
        elif [ $env -eq 3 ]; then choosen_env="production"
        else 
            invalid_choice
            continue
        fi
        break
    done

    while true; do
        if [ $db -eq 1 ]; then
          select_cluster
          if [ $cluster -eq 1 ]; then choosen_cluster="9000"
          elif [ $cluster -eq 2 ]; then choosen_cluster="9001"
          elif [ $cluster -eq 3 ]; then choosen_cluster="9002"
          else 
            invalid_choice
            continue
          fi
          break
        elif [ $db -eq 2 ]; then
          select_cluster
          if [ $cluster -eq 1 ]; then choosen_cluster="main"
          elif [ $cluster -eq 2 ]; then choosen_cluster="analytics"
          elif [ $cluster -eq 3 ]; then choosen_cluster="api"
          else 
            invalid_choice
            continue
          fi
          break
        fi
        break
    done

    connection_var="${choosen_db}_${choosen_env}"
    connection_full_var="${choosen_db}_${choosen_env}_${choosen_cluster}"

    declare -A cluster_name_map=(
        [9000]="main"
        [9001]="analytics"
        [9002]="api"
    )

    clear
    case $choosen_db in
        clickhouse)
            echo -e "${GR}Connecting to ClickHouse ${choosen_env}, cluster ${cluster_name_map[${choosen_cluster}]}...${NC}"
            echo -ne "\033]0;${choosen_db} ${choosen_env} ${cluster_name_map[$choosen_cluster]}\007"
            if [ -n "$TMUX" ]; then
                tmux rename-window "${choosen_db}.${choosen_env}.${cluster_name_map[$choosen_cluster]}"
            fi
            clickhouse client "${!connection_var}":$choosen_cluster -f PrettySpaceNoEscapes
            ;;
        aws)
            echo -e "${GR}Connecting to ClickHouse AWS ${choosen_env}, cluster ${choosen_cluster}...${NC}"
            echo -ne "\033]0;${choosen_db} ${choosen_env} \007"
            if [ -n "$TMUX" ]; then
                tmux rename-window "${choosen_db}.${choosen_env}.${choosen_cluster}"
            fi
            connection_value="${!connection_full_var}"
            connection_array=($connection_value)
            clickhouse client "${connection_array[@]}" -f PrettySpaceNoEscapes
            ;;
        postgres)
            echo -e "${GR}Connecting to Postgres ${choosen_env}...${NC}"
            echo -ne "\033]0;${choosen_db} ${choosen_env}\007"
            if [ -n "$TMUX" ]; then
                tmux rename-window "${choosen_db}.${choosen_env}"
            fi
            pgcli "${!connection_var}"
            ;;
        mongo)
            echo -e "${GR}Connecting to MongoDB ${choosen_env}...${NC}"
            echo -ne "\033]0;${choosen_db} ${choosen_env} \007"
            if [ -n "$TMUX" ]; then
                tmux rename-window "${choosen_db}.${choosen_env}"
            fi
            mongosh "${!connection_var}"
            ;;
        mysql_int)
            echo -e "${GR}Connecting to MySQL internal ${choosen_env}...${NC}"
            echo -ne "\033]0;${choosen_db} ${choosen_env} \007"
            if [ -n "$TMUX" ]; then
                tmux rename-window "${choosen_db}.${choosen_env}"
            fi
            mycli "${!connection_var}"
            ;;
        mysql_ext)
            echo -e "${GR}Connecting to MySQL external ${choosen_env}...${NC}"
            echo -ne "\033]0;${choosen_db} ${choosen_env} \007"
            if [ -n "$TMUX" ]; then
                tmux rename-window "${choosen_db}.${choosen_env}"
            fi
            mycli "${!connection_var}"
            ;;
        sqlite)
            echo -e "${GR}Connecting to SQLite ${choosen_env}...${NC}"
            echo -ne "\033]0;${choosen_db} ${choosen_env} \007"
            if [ -n "$TMUX" ]; then
                tmux rename-window "${choosen_db}.${choosen_env}"
            fi
            litecli "${!connection_var}"
            ;;
    esac

done
