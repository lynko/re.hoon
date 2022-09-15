[An implementation of POSIX Extended Regular Expressions in Hoon.][UF]

[UF]: https://urbit.org/grants/regex-library

Todo:

- Write more cross-cutting tests
- Bugfixing
- Allow to change the subject text of a parsed regular expression


## Files

- `lib/regex.hoon`:  A regular expressions library.
- `lib/regex-test.hoon`:  A test runner.
- `lib/regex-test-ere.hoon`:  A test suite.
- `gen/regex-test-ere.hoon`:  Run the test suite.


## Usage

Include `regex.hoon` with Ford, such as in `/+  regex`.  Create a sample with `=+  sat=(start:regex pattern-tape subject-tape)` and get successive matches with `~(next regex sat)`, or call one of the helper functions directly as in `(run:re pattern-tape subject-tape)`.

Matches produced by `regex.hoon` have the following structure:

  ```
  +$  range  (pair pint tape)
  +$  match  (pair range (map @u range))
  ```

`p.match` refers to the total matched text.  `q.match` is a map of matched subpatterns according to their capture numbers.  (A `pint` is a tuple of hairs recording the start and end positions of matched text.)


### `++run:regex`

Find the first match of a regular expression.

Accepts:  a regular expression and a match target

Produces:  a unit of the first match, or nil if there is no match

Crashes if the regular expression is invalid.

  ```
  > (run:regex "[a-z]+" "Urbit")
  [ ~
    [ p=[p=[p=[p=1 q=2] q=[p=1 q=6]] q="rbit"]
      q={[p=0 q=[p=[p=[p=1 q=2] q=[p=1 q=6]] q="rbit"]]}
    ]
  ]
  > (run:regex "(?i)[a-z]+" "Urbit")
  [ ~
    [ p=[p=[p=[p=1 q=1] q=[p=1 q=6]] q="Urbit"]
      q={[p=0 q=[p=[p=[p=1 q=1] q=[p=1 q=6]] q="Urbit"]]}
    ]
  ]
  ```


### `++all:regex`

Find all matches of a regular expression.

Accepts:  a regular expression and a match target

Produces:  a list of matches

Crashes if the regular expression is invalid.

  ```
  > (all:regex "\\w+" "the quick brown fox")
  ~[
    [ p=[p=[p=[p=1 q=1] q=[p=1 q=4]] q="the"]
      q={[p=0 q=[p=[p=[p=1 q=1] q=[p=1 q=4]] q="the"]]}
    ]
    [ p=[p=[p=[p=1 q=5] q=[p=1 q=10]] q="quick"]
      q={[p=0 q=[p=[p=[p=1 q=5] q=[p=1 q=10]] q="quick"]]}
    ]
    [ p=[p=[p=[p=1 q=11] q=[p=1 q=16]] q="brown"]
      q={[p=0 q=[p=[p=[p=1 q=11] q=[p=1 q=16]] q="brown"]]}
    ]
    [ p=[p=[p=[p=1 q=17] q=[p=1 q=20]] q="fox"]
      q={[p=0 q=[p=[p=[p=1 q=17] q=[p=1 q=20]] q="fox"]]}
    ]
  ]
  ```


### `++sub:regex`

Replace the first match of a regular expression.

Accepts:  a regular expression, a match target, and a replacement string

Produces:  the match target, potentially modified

Crashes if the regular expression is invalid.

  ```
  > (sub:regex "(?i)hoon" "Hoon hoon hoon" "HOON")
  "HOON hoon hoon"
  ```


### `++gsub:regex`

Replace the all matches of a regular expression.

Accepts:  a regular expression, a match target, and a replacement string

Produces:  the match target, potentially modified

Crashes if the regular expression is invalid.

  ```
  > (gsub:regex "(?i)hoon" "Hoon hoon hoon" "HOON")
  "HOON HOON HOON
  ```

### `++start:regex`

Create an initial sample for successive matching.

Accepts:  a regular expression and a match target

Produces:  a sample suitable for use by `++next` (see below)

  ```
  > (start:regex "(abc|def?)+" "abcd abcde abcdef")
  {a sample for the regex door}
  ```


### `++valid:regex`

Unitized version of `++start`; produces nil instead of crashing.

Accepts:  a regular expression and a match target

Produces:  a unit containing a sample for use by `++next` (see below)

  ```
  > (valid:regex "\\w+" "")
  [ ~
    {a sample for the regex door}
  ]
  > (valid:regex "?" "")
  ~
  ```


### `++next:regex`

This arm requires a sample for the `regex` door.

Produces a tuple of the next match, and a new match state.

  ```
  > =r (start:regex "(abc|def?)+" "abcde abcdef")
  > =s ~(next regex r)
  > s
  [ ~
    [   p
      [ p=[p=[p=[p=1 q=1] q=[p=1 q=6]] q="abcde"]
          q
        { [p=1 q=[p=[p=[p=1 q=1] q=[p=1 q=4]] q="abc"]]
          [p=0 q=[p=[p=[p=1 q=1] q=[p=1 q=6]] q="abcde"]]
        }
      ]
        q
      {new sample}
    ]
  ]
  > =t ~(next regex +>.s)
  > t
  [ ~
    [   p
      [ p=[p=[p=[p=1 q=7] q=[p=1 q=13]] q="abcdef"]
          q
        { [p=1 q=[p=[p=[p=1 q=7] q=[p=1 q=10]] q="abc"]]
          [p=0 q=[p=[p=[p=1 q=7] q=[p=1 q=13]] q="abcdef"]]
        }
      ]
        q
      {new sample}
    ]
  ]
  > ~(next regex +>.t)
  ~
  ```


### Regular expression syntax

Same as POSIX Extended Regular Expressions (`grep -E`), with the following extensions:

- Lookaround:  `(?=...)`, `(?!...)`, `(?<=...)`, `(?<!...)`
- Hesitant and possessive repetition:  `...*?`, `...*+`, etc
- Case insensitivity:  `(?i)` to begin, `(?-i)` to end
- Perl-style classes and anchors:  `\w`/`\W`, `\s`/`\S`, `\d`/`\D`, `\u`/`\U`, `\l`/`\L`, `\b`/`\B`
