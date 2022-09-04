##  `re.hoon`

[An implementation of Perl-compatible regular expressions in Hoon.][UF]

WIP

[UF]: https://urbit.org/grants/regex-library

Files:

- `lib/re.hoon`:  A regular expressions library.
- `lib/l10n.hoon`:  Dependency.  A localization library from [https://github.com/sigilante/l10n].
- `gen/re.hoon`:  A convenience generator that produces the library.
- `gen/re-test.hoon`:  A test suite for `lib/re.hoon`.

Working:

- Alternation
- Repetition (greedy, possessive, bounded)
- Anchors `^` and `$`
- Character classes (except POSIX classes like `[:lower:]`)
- Capture groups
- Backreferences
- Lookaround (forward, backward, positive, negative)

Unimplemented:

- Repetition (non-greedy)
- Case-insensitive matching
- Leftmost-longest selection
- Pretty much every escape code
