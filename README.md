# db_cli_tools

version: 1.0.0

## Description
This is an interactive command line tool for working with databases.
It is a wrapper around the `clickhouse-cli`, `pgcli`, `mycli`, `mongosh`, `litecli` interactive CLIs.
It provides a simple interface for running queries and viewing results.

## Changelog:
- v1.0.0 clickhouse client replaced with clickhouse-cli, because of lack of HTTP protocol. native client supports only native protocol, unfortunately.

## Installation
```bash
git clone https://github.com/feel2code/db_cli_tools.git && cd db_cli_tools && chmod +x install.sh && ./install.sh
```

Then you will need to prepare URIs for database connections in .env file. There is an example `env-template` file exists in this repo.

## Usage
```bash
./db.sh             starts the interactive CLI tool
```
```bash
./db.sh --help      shows the help message
```
```bash
./db.sh --version   shows the version of the tool
```

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
