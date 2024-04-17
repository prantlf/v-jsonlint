import os
import prantlf.cargs
import prantlf.json { JsonError, ParseOpts, StringifyOpts, parse_opt, stringify_opt }

const version = '0.3.2'

const usage = 'JSON/JSONC/JSON5 validator and pretty-printer.

Usage: jsonlint [options] [<file> ...]

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
	--escape-unicode      escape multibyte Unicode characters with \\u literals
  -l|--line-break       append a line break to the JSON output
  -p|--pretty           print the JSON output with line breaks and indented
  -V|--version          print the version of the executable and exit
  -h|--help             print the usage information and exit

If no input file is specified, it will be read from standard input.
If multiple files are specified and file overwriting is not enabled,
the files will be only checked and their names printed out.

Examples:
  $ jsonlint config.json -lpw
  $ cat config.json | jsonlint > config2.json'

enum Mode {
	json
	jsonc
	json5
}

struct Opts {
mut:
	output          string
	mode            Mode
	overwrite       bool
	check           bool
	compact         bool
	trailing_commas bool
	single_quotes   bool
	escape_slashes  bool
	escape_unicode  bool
	line_break      bool
	pretty          bool
}

fn check_one(file string, names_only bool, opts &Opts) ! {
	input := if file.len > 0 {
		os.read_file(file)!
	} else {
		os.get_raw_lines_joined()
	}

	jsonc := opts.mode == Mode.jsonc
	json5 := opts.mode == Mode.json5
	src := parse_opt(input, &ParseOpts{
		ignore_comments: jsonc || json5
		ignore_trailing_commas: jsonc || json5
		allow_single_quotes: json5
	}) or {
		if err is JsonError {
			if file.len > 0 {
				msg := if opts.compact {
					err.reason
				} else {
					err.msg_full()
				}
				eprintln('${file}:${err.line}:${err.column}: ${msg}')
				return
			}
			msg := if opts.compact {
				err.msg()
			} else {
				err.msg_full()
			}
			eprintln(msg)
			return
		}
		eprintln('${file}: ${err.msg()}')
		return
	}

	mut dst := stringify_opt(src, &StringifyOpts{
		pretty: opts.pretty
		trailing_commas: opts.trailing_commas
		single_quotes: opts.single_quotes
		escape_slashes: opts.escape_slashes
		escape_unicode: opts.escape_unicode
	})

	if !opts.check {
		if opts.line_break {
			dst += '\n'
		}
		if opts.output.len > 0 {
			os.write_file(opts.output, dst)!
		} else if opts.overwrite && file.len > 0 {
			os.write_file(file, dst)!
		} else if names_only {
			println('${file}: OK')
		} else {
			print(dst)
		}
	}
}

fn check() ! {
	opts, args := cargs.parse[Opts](usage, cargs.Input{ version: version })!

	if args.len > 0 {
		names_only := args.len > 1 && !opts.overwrite
		for arg in args {
			check_one(arg, names_only, opts)!
		}
	} else {
		check_one('', false, opts)!
	}
}

fn main() {
	check() or {
		eprintln(err.msg())
		exit(1)
	}
}
