[An implementation of POSIX Extended Regular Expressions in Hoon.][UF]

[UF]: https://urbit.org/grants/regex-library


##  Files

- `lib/regex.hoon`:  A regular expressions library.
- `tests/lib/regex.hoon`:  A test suite for the library.


##  Usage

Import with Ford per usual (`/+  regex`), or try it out in the dojo with `=regex -build-file %/lib/regex/hoon`.  Regex syntax is Posix ERE, with some extensions (see below).

When writing regexes in Hoon, take care to properly escape the characters that need escaping. A regex that matches five characters is written in Hoon as `".\{5}"` to avoid string interpolation; a regex that matches a literal `{` is written as `"\\\{"`.  Some sequences, like the backreference `\2`, can have a deceptive but valid meaning if not escaped:  `"(.(.))\2"` is a syntax error, but `"(.(.))\20"` encodes a space character.  This backrefence should be written as `\\2`.

Regexes involving nested repetition, such as `(\w+\.*)*` (or its tape representation, `"(\\w+\\.*)*"`), can be especially slow to execute because of the combinatorial explosion of valid groupings.  For example, `abcd` could be matched as {`abcd`}, {`abc` `d`}, {`ab` `cd`}, {`ab` `c` `d`}, and so forth.  This can be usually be remedied by turning `*` into `+` within the capture group, preventing overlapping match candidates.


##  Types

Regex operations usually produce either a `$range` (some text and its location within the subject) or a `$match` (a map of ranges by capture number).

  ```
  +$  range  (pair pint tape)
  +$  match  (pair range (map @u range))
  ```

Every function that produces a `$match`, with all subcaptures, has a variant that produces only the total `$range` of matched text.


##  Operations

### `++valid:regex`

Determine if a regular expression is valid.

Accepts:  a regular expression

Produces:  `%.y` if the regex is valid; `%.n` otherwise

  ```
  > (valid:regex "")
  %.y
  > (valid:regex "(?)")
  %.n
  > (valid:regex "[a-b-c]")
  %.n
  ```


### `++run:regex`

Find the first match of a regular expression.

Accepts:  a regular expression and a match target

Produces:  `(unit match)`

Crashes if the regular expression is invalid.

  ```
  > (run:regex ".+" "")
  ~
  > (run:regex "[a-z]+" "Abc")
  [~ {[p=0 q=[p=[p=[p=1 q=2] q=[p=1 q=4]] q="bc"]]}]
  > (run:regex "([a-z])+" "abc")
  [ ~
    { [p=1 q=[p=[p=[p=1 q=3] q=[p=1 q=4]] q="c"]]
      [p=0 q=[p=[p=[p=1 q=1] q=[p=1 q=4]] q="abc"]]
    }
  ]
  ```


### `++ran:regex`

Find the first match crashing if there is none.

Accepts:  a regular expression and a match target

Produces:  `match`

Crashes if the regular expression is invalid or of there is no match.

  ```
  > (ran:regex ".+" "")
  ...
  dojo: hoon expression failed
  > (ran:regex "[a-z]+" "Abc")
  {[p=0 q=[p=[p=[p=1 q=2] q=[p=1 q=4]] q="bc"]]}
  > (ran:regex "([a-z])+" "abc")
  { [p=1 q=[p=[p=[p=1 q=3] q=[p=1 q=4]] q="c"]]
    [p=0 q=[p=[p=[p=1 q=1] q=[p=1 q=4]] q="abc"]]
  }
  ```


### `++rut:regex`

Variant of `+run` that produces `(unit range)` instead of `(unit match)`.


### `++rat:regex`

Variant of `+ran` that produces `range` instead of `match`.


### `++all:regex`

Find all matches of a regular expression.

Accepts:  a regular expression and a match target

Produces:  `(list match)`

Crashes if the regular expression is invalid.

  ```
  > (all:regex "\\w*" "the quick brown fox")
  ~[
    {[p=0 q=[p=[p=[p=1 q=1] q=[p=1 q=4]] q="the"]]}
    {[p=0 q=[p=[p=[p=1 q=5] q=[p=1 q=10]] q="quick"]]}
    {[p=0 q=[p=[p=[p=1 q=11] q=[p=1 q=16]] q="brown"]]}
    {[p=0 q=[p=[p=[p=1 q=17] q=[p=1 q=20]] q="fox"]]}
  ]
  ```

### `++alt:regex`

Variant of `+all` that produces `(list range)` instead of `(list match)`.


### `++sub:regex`

Replace the first match of a regular expression.

Accepts:  a regular expression, a replacement string, and a match target

Produces:  the match target, potentially modified

Crashes if the regular expression is invalid.

  ```
  > (sub:regex "(?i)hoon" "Hoon hoon hoon" "HOON")
  "HOON hoon hoon"
  ```


### `++gsub:regex`

Replace the all matches of a regular expression.

Accepts:  a regular expression, a replacement string, and a match target

Produces:  the match target, potentially modified

Crashes if the regular expression is invalid.

  ```
  > (gsub:regex "(?i)hoon" "Hoon hoon hoon" "HOON")
  "HOON HOON HOON
  ```


###  `++subf:regex`

Variant of `+sub` that accepts a gate from `tape` to `tape` instead of a replacement string, slamming that gate on the text of the first match.


###  `++gsubf:regex`

Variant of `+gsub` that accepts a gate from `tape` to `tape` instead of a replacement string, slamming that gate on the text of each match.


### Regular expression syntax


Same as POSIX Extended Regular Expressions (`grep -E`), with the following extensions:
| Extension        | Syntax       | Example                                              |
|------------------|--------------|------------------------------------------------------|
| Perl classes     | `\w\d\s\u\l` | `\w+\.` (word followed by period)                    |
|                  | `\W\D\S\U\L` | `\d+(\W+\d+)*` (series of numbers)                   |
| Perl anchors     | `\b\B\<\>`   | `\<\w+\>` (any full word)                            |
| Lookahead        | `(?=...)`    | `(?=\u)\w+` (capitalized word)                       |
|                  | `(?!...)`    | `(?!\d)\w+` (word not beginning with number)         |
| Case sensitivity | `(?i)`       | `(?i)(\w+)(\s*\1)+` (repeated word)                  |
|                  | `(?-i)`      | `(?i)(\w+)(?-i)(\s*\1)+` (word repeated in same case) |


These character classes are equivalent:

| Perl class | Posix class    |
|------------|----------------|
| `\w`       | `[[:word:]]`   |
| `\W`       | `[[:^word:]]`  |
| `\d`       | `[[:digit:]]`  |
| `\D`       | `[[:^digit:]]` |
| `\s`       | `[[:space:]]`  |
| `\S`       | `[[:^space:]]` |
| `\u`       | `[[:upper:]]`  |
| `\U`       | `[[:^upper:]]` |
| `\l`       | `[[:lower:]]`  |
| `\L`       | `[[:^lower:]]` |
