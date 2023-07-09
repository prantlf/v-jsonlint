# jsonlint

[JSON]/[JSONC]/[JSON5] validator and pretty-printer.

* Uses a [fast] recursive descent parser written in V.
* Shows detailed [error messages](#errors) with location context.
* Optionally supports [JSONC] - ignores single-line and multi-line JavaScript-style comments treating them as whitespace and also trailing commas in arrays ans objects.
* Partially supports [JSON5] - allows single-quoted strings. (JSON5 is work in progress.)
* Offers both condensed and prettified [JSON] output.

Uses [prantlf.json].

## Synopsis

Check the syntax of a file `config.json`, append a trailing line break to the JSON output, make the output more readable by indentation and overwrite the original file with the formatted output:

    jsonlint config.json -lpw

Check a file read from standard input and print it formatted to standard output, as condensed as possible, no trailing line break:

    cat config.yaml | jsonlint > config.json

## Usage

    jsonlint [options] [<file> ...]

      <file>                read the JSON/JSONC/JSON5 input from a file

    Options:
      -o|--output <file>    write the JSON output to a file
      -m|--mode <mode>      parse in the mode "json", "jsonc", or "json5"
      -w|--overwrite        overwrite the input file with the formatted output
      -k|--check            check the syntax only, no output
      -a|--compact          print error messages on a single line
      -t|--trailing-commas  insert trailing commas to arrays and objects
      -s|--single-quotes    format single-quoted instead of double-quoted strings
      --escape-slashes      escape slashes by by prefixing them with a backslash
      --escape-unicode      escape multibyte Unicode characters with \u literals
      -l|--line-break       append a line break to the JSON output
      -p|--pretty           prints the JSON output with line breaks and indented
      -V|--version          prints the version of the executable and exits
      -h|--help             prints th usage information and exits

    If no input file is specified, it will be read from standard input.
    If multiple files are specified and file overwriting is not enabled,
    the files will be only checked and their names printed out.

## Errors

The error output is based on the [error messages] provided by [prantlf.json]:

    ❯ jsonlint .vscode/launch.json

    .vscode/launch.json:3:3: Expected '"' but got "/" when parsing an object key:
    2 | {
    3 |   // Use IntelliSense …
      |   ^

Compact output when checking many files:

    ❯ v run jsonlint.v .vscode/*.json -a

    .vscode/launch.json:3:3: Expected '"' but got "/" when parsing an object key
    .vscode/settings.json: OK
    .vscode/tasks.json:3:3: Expected '"' but got "/" when parsing an object key

Fixing the errors by enabling [JSONC]:

    ❯ jsonlint .vscode/*.json -m jsonc

    .vscode/launch.json: OK
    .vscode/settings.json: OK
    .vscode/tasks.json: OK

## Build

    v -prod jsonlint.v
    v fmt -w .
    v vet .
    npx conventional-changelog-cli -p angular -i CHANGELOG.md -s

## TODO

This is a work in progress.

* Finish the [JSON5] support.

[prantlf.json]: https://github.com/prantlf/v-json
[JSON]: https://www.json.org/
[JSONC]: https://changelog.com/news/jsonc-is-a-superset-of-json-which-supports-comments-6LwR
[JSON5]: https://spec.json5.org/
[fast]: https://github.com/prantlf/v-json#performance
[error messages]: https://github.com/prantlf/v-json#errors
