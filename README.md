##  `re.hoon`

[An implementation of perl-compatible regular expressions in Hoon.][UF]

[UF]: https://urbit.org/grants/regex-library

To use the regular expressions library, `|%commit` the contents of `gen`
and `lib` and then run `=re +re` to bind the library to the `re` face.
To test the library, run `+re-test`.

The current interface is:

- `(parse:re pattern=cord)` returning an `ast`
- `(start:re =ast subject=cord)` returning a `state`
- `(next:re =state)` returning a `(unit [match state])`
- `(first:re pattern=cord subject=cord)` returning a `(unit match)`
- `(all:re pattern=cord subject=cord)` return a `(list match)`

See [NOTES](notes.md).
