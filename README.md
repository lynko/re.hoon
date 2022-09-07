##  `re.hoon`

[An implementation of Perl-compatible regular expressions in Hoon.][UF]

WIP

[UF]: https://urbit.org/grants/regex-library

### Files

- `lib/re.hoon`:  A regular expressions library.
- `lib/l10n.hoon`:  Dependency.  A localization library from [https://github.com/sigilante/l10n].
- `lib/regex-test-1.hoon`:  A test suite derived from the [PCRE repository][PCRE].
- `gen/re.hoon`:  A convenience generator that produces the library.
- `gen/re-test.hoon`:  Run a test suite for `lib/re.hoon`.
- `gen/regex-test-1.hoon`:  Run the PCRE-derived test suite.

[PCRE]: https://github.com/luvit/pcre

As `lib/regex-test-1.hoon` is a derivative work, it is governed by the same license as PCRE (see [pcre-license.txt]).

### Usage

  ```
  /+  re
  ...
    ...
    =/  m=(unit match:re)
      (run:re "reg.u(lar)+ expr*ssion(s|$)*" target-text)
    ?~  m  ...  :: match not found
    :: match found
  ```

`match:re` is a type containing capture groups and a copy of the text  that was matched.

  ```
  +$  match  [p=(map @ud [p=pint q=tape]) q=[p=pint q=tape]]
  ```

### Features

Working:

- Alternation
- Repetition (greedy, possessive, bounded)
- Anchors `^` and `$`
- Character classes (but missing some POSIX classes)
- Capture groups
- Backreferences
- Lookaround (forward, backward, positive, negative)
- Most escape codes

Unimplemented:

- Non-greedy matching
- Case-insensitive matching
- Leftmost-longest selection

Note that other than nongreedy tests, most tests that fail revolve around features that won't be implemented, such as non-backtracking patterns `(?>...)` or octal sequences like `\377`.  Some bugs have been exposed though, and I'm cleaning them up as I find them.
