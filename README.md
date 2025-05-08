# db_cli_tools

## Description
This is an interactive command line tool for working with databases.
It is a wrapper around the `clickhouse client`, `pgcli`, `mycli`, `mongosh` CLIs.
It provides a simple interface for running queries and viewing results.

## Installation
```bash
git clone https://github.com/feel2code/db_cli_tools.git
./install.sh
```

## Keyboard shortcuts for clickhouse client
`Alt (Option) + Shift + e` - open editor with the current query. It is possible to specify the editor to use with the environment variable EDITOR. By default, vim is used.
`Alt (Option) + #` - comment line.
`Ctrl + r` - fuzzy history search.

## Usage (under development)
```bash
db_cli_tools --help
```

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
