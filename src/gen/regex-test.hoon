/+  regex-test

:-  %say
|=  *
:-  %noun

%-  run:regex-test
:~
::
::::
  ::  Empty regular expression
::::
::
:^  %has-match  ""
~["" "a" "1234567890" "\0a"]
~
::
::::
  ::  Text matching
::::
::
:^  %has-match  "quick brown fox"
~["quick brown fox" "the quick brown fox"]
~["Quick brown fox"]
::
:^  %has-match  "ệ"
~["ệ"]
~["e"]
::
::::
  ::  Dot
::::
::
:^  %has-match  "."
~["." "a" "^" "$" "(" ")" "\0d"]
~["" "\0a"]
::
:^  %has-match  "^.$"
~["\c7\a3" "\d0\09\cc\84" "ệ"]
~["" "\0a"]
::
::::
  ::  Anchor
::::
::
:^  %has-match  "^abc$"
~["abc" "x\0aabc" "x\0aabc\0ay" "abc\0ay"]
~["xabc" "abcy"]
::
:^  %has-match  "\\Aabc\\Z"
~["abc"]
~["xabc" "abcy" "abc\0a" "abc\0d"]
::
:^  %has-match  "\\Aabc\\z"
~["abc" "abc\0a"]
~["xabc" "abcy" "abc\0a\0a" "abc\0d"]
::
:^  %has-match  "^$"
~["" "a\0a" "a\0a\0ab"]
~["a" "a\0ab"]
::
::::
  ::  Alternation
::::
::
:^  %has-match  "((a|bc)d)|xyz"
~["ad" "bcd" "xyz"]
~["abc" "abcxy"]
::
:^  %has-match  "(a|^)bc(d|$)"
~["bc" "xabc" "bcdy" "xabcdy"]
~["xbc" "bcy" "xbcy" "xabcy"]
::
::::
  ::  Repetition (eager)
::::
::
:^  %has-match  "^a*b"
~["b" "ab" "aab" "aab"]
~["xb" "axb" "axab"]
::
:^  %has-match  "^(a|ab)+$"
~["a" "ab" "aababaaaaaababaab"]
~["b" "abb" "aaaaabbaa"]
::
:^  %has-match  "^a+(abcd|xy)$"
~["aabcd" "aaabcd" "axy" "aaxy"]
~["abcd" "xy"]
::
:^  %has-match  "^(foo|ba.)+$"
~["foobarbaz"]
~["" "fodbar"]
::
:^  %has-match  "^(abc|)*xyz$"
~["xyz" "abcxyz" "abcabcxyz"]
~["abccxyz"]
::
:^  %has-match  "^(abc|)+xyz$"
~["xyz" "abcxyz" "abcabcxyz"]
~["abccxyz"]
::
::::
  ::  Repetition (hesitant)
::::
::
::  :: todo: test what gets captured
:^  %has-match  "^a??b"
~["b" "ab"]
~["aab"]
::
:^  %has-match  "^a*?b"
~["b" "ab" "aab" "aaab"]
~
::
:^  %has-match  "^a+?b"
~["ab" "aab" "aaab"]
~["b"]
::
::::
  ::  Repetition (possessive)
::::
::
:^  %has-match  "^a++a"
~
~["a" "aa" "aaa" "aaaa" "aaaaa"]
::
:^  %has-match  "^a++(abcd|xy)"
~["aaxy"]
~["aabcd"]
::
::::
  ::  Empty repetition
::::
::
:^  %has-match  "^(a|)+"
~["" "a" "aa" "aaa" "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"]
~
::
::::
  ::  Backreferences
  ::
::::
::
:^  %has-match  "(abc|xyz)\\1"
~["abcabc" "xyzxyz"]
~["abcxyz" "xyzabc"]
::
:^  %has-match  "(a)(b)(c)(d)(e)(f)(g)(h)(i)\\8\\9"
~["abcdefghihi"]
~["abcdefgh"]
::Test for:
::- Correct capture groups
::- Alternation with leftmost-longest rule
::- Repetition (various kinds)
::- Character classes
::- Escape characters
::- Lookaround
::
::Implement:
::- Character classes
::- Word boundaries
::- Full-string anchors (`\A` `\Z` `\z`)
::- Case insensitivity (`(?i)`)
[%has-match "a++a" ~ ~["a" "aa" "aaa" "aaaa" "aaaaa"]]
[%has-match "a++b" ~["aaaab"] ~]
[%has-match "(a++)*(ba)" ~["aaaaba"] ~]
[%has-match "(a++|x)*(ba)\\1" ~["aaxaaxbaa" "aaxaaxbaaa"] ~]
[%has-match "(a++|x)*((ba))\\1\\3" ~["aaxaxbaaaba"] ~["baaba"]]
[%has-match "(?<!a(?=boot$))boo" ~["aboo" "aboota"] ~["aboot"]]
[%has-match "(?<!a(?=boo$))boo" ~["aboot"] ~["aboo"]]
[%has-match "fo?+ob" ~["foob"] ~["fob"]]
[%has-match "fo*+ob" ~ ~["foo" "fob" "foob"]]
[%has-match "foo*" ~["foo" "foofoofoo"] ~]
[%has-match "(foo|ba.)+" ~["barbaz"] ~]
[%has-match "o\{3}" ~["fooobar"] ~["foobar"]]
::
:^  %has-match  "(foo|ba.)\\1"
~["foofoo" "barbar" "bazbaz"]
~["foobar" "barbaz"]
::
:-  %has-match  :-  "^(11+)\\1+$"
:-  ~["1111" "111111" "11111111" "111111111" "1111111111"]
~["1" "11" "111" "11111" "1111111" "11111111111" "1111111111111"]
::
==
