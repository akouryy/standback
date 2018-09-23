# (?i:standback)
Esolang for TSG Hackathon 2018 Summer

## Spec
There is no English version at the moment.

[日本語版](spec.ja.md)

## Debug Mode
Debug mode is enabled if:
* `-d` option is specified for ruby.
* `-d` option is specified for standback.rb.
* env variable `debug` or `DEBUG` exists.
* the code has a line starting with `#@DEBUG`.

Example output to stderr:
```
begin m(1): a1="meow\n" a2=""
begin S(11): a1="meow\n" a2=""
end   S(11): a1="meow\n" a2="meow\n"
end   m(1): a1="meow\n" a2="meow\n"
```
In the example above, `(11)` means the position of command `S`.
