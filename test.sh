#!/bin/sh

set -e

test() {
  if [ "$2" != "" ]; then
    echo "----------------------------------------"
  fi
  echo "$1"
  echo "----------------------------------------"
}

test "help"
./jsonlint -h

test "version" 1
./jsonlint -V

test "stdin and stdout" 1
cat .vscode/settings.json | ./jsonlint > /dev/null

test "file input and output"
./jsonlint .vscode/settings.json -lp -o settings.json

test "overwrite input"
./jsonlint settings.json -tw

test "check jsonc"
./jsonlint settings.json -k -m jsonc
rm settings.json

echo "done"
