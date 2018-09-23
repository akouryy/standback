# (?i:standback)
Esolang for TSG Hackathon 2018 Summer

## Spec
[日本語](spec.ja.md)

## Command Line Arguments
`-d` enables debug mode.
```
begin m(1): a1="meow\n" a2=""
begin S(11): a1="meow\n" a2=""
end   S(11): a1="meow\n" a2="meow\n"
end   m(1): a1="meow\n" a2="meow\n"
```
In the example above, `(11)` means the position of command `S`.
