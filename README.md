##  `re.hoon`

[An implementation of Perl-compatible regular expressions in Hoon.][UF]

WIP

[UF]: https://urbit.org/grants/regex-library

### Files

- `lib/regex.hoon`:  A regular expressions library.
- `lib/regex-test.hoon`:  A test runner.
- `lib/regex-test-pcre.hoon`:  A test suite derived from the [PCRE repository][PCRE].
- `gen/regex-test.hoon`:  Run a test suite for the regex library.
- `gen/regex-test-pcre.hoon`:  Run the PCRE-derived test suite.

[PCRE]: https://github.com/luvit/pcre

As `lib/regex-test-1.hoon` is a derivative work, it is governed by the same license as PCRE (see [pcre-license.txt](pcre-license.txt)).

### Usage

Include `regex.hoon` with Ford, such as in `/+  regex`.

`++run:regex` takes a regular expression and a target string, returning the first match.  The product is of type `(unit match)`, where `+$match` is a tuple of capture groups:  `num`, a map from group number to captured text; and `nom`, a map from group name to captured text.  (Named captures are unimplemented but forthcoming.) Captured text is represented as a tuple of `pint` (the location of the captured text) and `tape` (the text itself).

In this example, `^(11+)\\1$` tests if a unary number is composite.  Because of the leftmost-longest rule, the capture group `\\1` always refers to the subject's largest prime factor.

  ```
  > (run:regex "^(11+)\\1$" "1111111")
  ~
  > (run:regex "^(11+)\\1$" "11111111")
  /+  regex
  [ ~
    [   num
      { [p=1 q=[p=[p=[p=1 q=1] q=[p=1 q=5]] q="1111"]]
        [p=0 q=[p=[p=[p=1 q=1] q=[p=1 q=9]] q="11111111"]]
      }
      nom={}
    ]
  }
  ```
