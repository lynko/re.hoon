:~
::
::::
  ::  Empty matches
::::
::
:^  %has-match  ""
~["" "a" "1234567890" "\0a"]
~
::
:^  %has-match  "(a?)b\\1c"
~["abc" "abac" "bc"]
~["bac"]
::
::::
  ::  Basic text matching
::::
::
:^  %has-match  "quick brown fox"
~["quick brown fox" "the quick brown fox"]
~["Quick brown fox"]
::
:^  %has-match  "^\\^\\$\\.\\|\\?\\+\\*\\(\\)\\[\\]\\\{\\}\\\\$"
~["^$.|?+*()[]\{}\\"]
~["^$.|?+*()[]\{}\\\\"]
::
::::
  ::  Allow unmatched right braces
::::
::
:^  %has-match  "abc)+def"
~["abc)def" "abc))def" "abc)))def"]
~["abcdef"]
::
:^  %has-match  "(?<=abc))+def"
~["abc)def" "abc))def" "abc)))def"]
~["abcdef"]
::
:^  %has-match  "(?i)(?<=abc))+def"
~["ABC)DEF" "ABC))DEF" "ABC)))DEF"]
~["ABCDEF"]
::
:^  %has-match  "\\([()]\\).*(?i)(?<=abc))+def"
~["(()ABC)DEF" "(()ABC))DEF" "(()ABC)))DEF"]
~["(()ABCDEF"]
::
:^  %has-match  "a]x"
~["a]x"]
~["ax"]
::
:^  %has-match  "a}x"
~["a}x"]
~["ax"]
::
::::
  ::  Dot
::::
::
:^  %has-match  "."
~["." "a" "^" "$" "(" ")" "\0a"]
~["\00"]
::
:^  %has-match  "a.c"
~["abc" "a-c" "a\\c"]
~["a\00c"]
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
  ::  Repetition
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
:^  %has-match  "^(a|)+"
~["" "a" "aa" "aaa" "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"]
~
::
:^  %has-match  "a++a"
~
~["a" "aa" "aaa" "aaaa" "aaaaa"]
::
:^  %has-match  "a++b"
~["aaaab"]
~
::
:^  %has-match  "(a++)*(ba)"
~["aaaaba"]
~
::
:^  %has-match  "(a++|x)*(ba)\\1"
~["aaxaaxbaa" "aaxaaxbaaa"]
~
::
:^  %has-match  "(a++|x)*((ba))\\1\\3"
~["aaxaxbaaaba"]
~["baaba"]
::
:^  %has-match  "fo?+ob"
~["foob"]
~["fob"]
::
:^  %has-match  "fo*+ob"
~
~["foo" "fob" "foob"]
::
:^  %has-match  "foo*"
~["foo" "foofoofoo"]
~
::
:^  %has-match  "(foo|ba.)+"
~["barbaz"]
~
::
:^  %has-match  "o\{3}"
~["fooobar"]
~["foobar"]
::
:^  %has-match  "a*abc?xyz+pqr\{3}ab\{2,}xy\{4,5}pq\{0,6}AB\{0,}zz"
~["abxyzpqrrrabbxyyyypqAzz" "abxyzpqrrrabbxyyyypqAzz" "aabxyzpqrrrabbxyyyypqAzz" "aaabxyzpqrrrabbxyyyypqAzz" "aaaabxyzpqrrrabbxyyyypqAzz" "abcxyzpqrrrabbxyyyypqAzz" "aabcxyzpqrrrabbxyyyypqAzz" "aaabcxyzpqrrrabbxyyyypAzz" "aaabcxyzpqrrrabbxyyyypqAzz" "aaabcxyzpqrrrabbxyyyypqqAzz" "aaabcxyzpqrrrabbxyyyypqqqAzz" "aaabcxyzpqrrrabbxyyyypqqqqAzz" "aaabcxyzpqrrrabbxyyyypqqqqqAzz" "aaabcxyzpqrrrabbxyyyypqqqqqqAzz" "aaaabcxyzpqrrrabbxyyyypqAzz" "abxyzzpqrrrabbxyyyypqAzz" "aabxyzzzpqrrrabbxyyyypqAzz" "aaabxyzzzzpqrrrabbxyyyypqAzz" "aaaabxyzzzzpqrrrabbxyyyypqAzz" "abcxyzzpqrrrabbxyyyypqAzz" "aabcxyzzzpqrrrabbxyyyypqAzz" "aaabcxyzzzzpqrrrabbxyyyypqAzz" "aaaabcxyzzzzpqrrrabbxyyyypqAzz" "aaaabcxyzzzzpqrrrabbbxyyyypqAzz" "aaaabcxyzzzzpqrrrabbbxyyyyypqAzz" "aaabcxyzpqrrrabbxyyyypABzz" "aaabcxyzpqrrrabbxyyyypABBzz" ">>>aaabxyzpqrrrabbxyyyypqAzz" ">aaaabxyzpqrrrabbxyyyypqAzz" ">>>>abcxyzpqrrrabbxyyyypqAzz"]
~["abxyzpqrrabbxyyyypqAzz" "abxyzpqrrrrabbxyyyypqAzz" "abxyzpqrrrabxyyyypqAzz" "aaaabcxyzzzzpqrrrabbbxyyyyyypqAzz" "aaaabcxyzzzzpqrrrabbbxyyypqAzz" "aaabcxyzpqrrrabbxyyyypqqqqqqqAzz"]
::
:^  %has-match  "^(abc)\{1,2}zz"
~["abczz" "abcabczz"]
~["zz" "abcabcabczz" ">>abczz"]
::
:^  %has-match  "^(b+?|a)\{1,2}?c"
~["bc" "bbc" "bbbc" "bac" "bbac" "aac" "abbbbbbbbbbbc" "bbbbbbbbbbbac"]
~["aaac" "abbbbbbbbbbbac"]
::
:^  %has-match  "^(b+|a)\{1,2}c"
~["bc" "bbc" "bbbc" "bac" "bbac" "aac" "abbbbbbbbbbbc" "bbbbbbbbbbbac"]
~["aaac" "abbbbbbbbbbbac"]
::
:^  %has-match  "^(b+|a)\{1,2}?bc"
~["bbc"]
~
::
:^  %has-match  "^(b*|ba)\{1,2}?bc"
~["babc" "bbabc" "bababc"]
~["bababbc" "babababc"]
::
:^  %has-match  "^(ba|b*)\{1,2}?bc"
~["babc" "bbabc" "bababc"]
~["bababbc" "babababc"]
::
:^  %has-match  "A\\x00\{2,3}Z"
~["The A\00\00Z" "An A\00\00\00Z"]
~["A\00Z"]
::
:^  %has-match  "ab\{1,3}bc"
~["abbbbc" "abbbc" "abbc"]
~["abc" "abbbbbc"]
::
:^  %has-match  "([^.]*)\\.([^:]*):[T ]+(.*)"
~["track1.title:TBlah blah blah"]
~
::
:^  %has-match  "([^.]*)\\.([^:]*):[T ]+(.*)"
~["track1.title:TBlah blah blah"]
~
::
:^  %has-match  "(?i)([^.]*)\\.([^:]*):[t ]+(.*)"
~["track1.title:TBlah blah blah"]
~
:^  %has-match  "a+b+c"
~["aabbabc"]
~
::
:^  %has-match  "a\{1,}b\{1,}c"
~["aabbabc"]
~
::
:^  %has-match  "a.+?c"
~["abcabc"]
~
::
:^  %has-match  "(a+|b)*"
~["ab"]
~
::
:^  %has-match  "(a+|b)\{0,}"
~["ab"]
~
::
:^  %has-match  "(a+|b)+"
~["ab"]
~
::
:^  %has-match  "(a+|b)\{1,}"
~["ab"]
~
::
:^  %has-match  "(a+|b)?"
~["ab"]
~
::
:^  %has-match  "(a+|b)\{0,1}"
~["ab"]
~
::
::::
  ::  Character classes
::::
::
:^  %has-match  "[.]"
~["." "a."]
~["a" "b" "c" "\0a"]
::
:^  %has-match  "[^.]"
~["a" "b" "c" "\0a" ".a"]
~["."]
::
:^  %has-match  "^[X-c]+$"
~["XYZ_^abc"]
~["xyz_^ABC" "xyz" "ABC"]
::
:^  %has-match  "(?i)^[X-c]+$"
~["XYZ_^abc" "xyz_^ABC" "xyz" "ABC"]
~["!" "\"" "#" "$" "%" "&" "'" "(" ")" "+" "," "-" "." "/"]
::
:^  %has-match  "^[[:ascii:]]+$"
~["\00\0aabc\7f"]
~["\80"]
::
:^  %has-match  "^[[:alnum:]]+$"
~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"]
~["-" "." "~" "\0a" "\09"]
::
:^  %has-match  "^[[:alpha:]]+$"
~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"]
~["-" "." "~" "\0a" "\09" "0" "9"]
::
:^  %has-match  "^[[:blank:]]+$"
~[" \09"]
~["\0a" "\0d"]
::
:^  %has-match  "^[[:cntrl:]]+$"
~["\00\01\02\03\04\05\06\07\08\09\0a\0b\0c\0d\0e\0f\10\11\12\13\14\15\16\17\18\19\1a\1b\1c\1d\1e\1f\7f"]
~[" " "a" "\7e" "\ff"]
::
:^  %has-match  "^[[:digit:]]+$"
~["0123456789"]
~["a"]
::
:^  %has-match  "^\\d+$"
~["0123456789"]
~["a"]
::
:^  %has-match  "^\\D+$"
~["abcdef"]
~["0" "9" "a123456789"]
::
:^  %has-match  "^[\\d]+$"
~["0123456789"]
~["a"]
::
:^  %has-match  "^[\\D]+$"
~["abcdef"]
~["0" "9" "a123456789"]
::
:^  %has-match  "^[[:graph:]]+$"
~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`\{|}~"]
~["\00" "\09" "\0a"]
::
:^  %has-match  "^[[:lower:]]+$"
~["abcdefghijklmnopqrstuvwxyz"]
~["A"]
::
:^  %has-match  "^\\l+$"
~["abcdefghijklmnopqrstuvwxyz"]
~["A"]
::
:^  %has-match  "\\L"
~["A"]
~["abcdefghijklmnopqrstuvwxyz"]
::
:^  %has-match  "^[\\l]+$"
~["abcdefghijklmnopqrstuvwxyz"]
~["A"]
::
:^  %has-match  "[\\L]"
~["A"]
~["abcdefghijklmnopqrstuvwxyz"]
::
:^  %has-match  "^[[:print:]]+$"
~["abcdef "]
~["\00" "\0a"]
::
:^  %has-match  "^[[:punct:]]+$"
~["!\"#$%&'()*+,-./:;<=>?@[\\]^_`\{|}~"]
~["a" "b" "c" "\00" "\0a"]
::
:^  %has-match  "^[[:space:]]+$"
~[" \09\0a\0b\0c\0d"]
~["A" "a"]
::
:^  %has-match  "^\\s+$"
~[" \09\0a\0b\0c\0d"]
~["A" "a"]
::
:^  %has-match  "\\S"
~["A" "a"]
~[" \09\0a\0b\0c\0d"]
::
:^  %has-match  "^[\\s]+$"
~[" \09\0a\0b\0c\0d"]
~["A" "a"]
::
:^  %has-match  "[\\S]"
~["A" "a"]
~[" \09\0a\0b\0c\0d"]
::
:^  %has-match  "^[[:upper:]]+$"
~["ABCDEFGHIJKLMNOPQRSTUVWXYZ"]
~["a"]
::
:^  %has-match  "^\\u+$"
~["ABCDEFGHIJKLMNOPQRSTUVWXYZ"]
~["a"]
::
:^  %has-match  "\\U"
~["a"]
~["ABCDEFGHIJKLMNOPQRSTUVWXYZ"]
::
:^  %has-match  "^[\\u]+$"
~["ABCDEFGHIJKLMNOPQRSTUVWXYZ"]
~["a"]
::
:^  %has-match  "[\\U]"
~["a"]
~["ABCDEFGHIJKLMNOPQRSTUVWXYZ"]
::
:^  %has-match  "^[[:xdigit:]]+$"
~["ABCDEFabcdef0123456789"]
~["G" "g" "\00" "\0a"]
::
:^  %has-match  "^[[:word:]]+$"
~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"]
~["-" "." "~" "\0a" "\09"]
::
:^  %has-match  "^[\\w]+$"
~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"]
~["-" "." "~" "\0a" "\09"]
::
:^  %has-match  "[\\W]"
~["-" "." "~" "\0a" "\09"]
~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"]
::
:^  %has-match  "^[[:alpha:][:digit:]]+$"
~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"]
~["-" "." "~" "\0a" "\09"]
::
:^  %has-match  "^[[:alpha::digit:]]+$"
~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"]
~["-" "." "~" "\0a" "\09"]
::
:^  %has-match  "[[:^alpha:]]"
~["-" "." "~" "\0a" "\09" "1" "2" "3"]
~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"]
::
:^  %has-match  "[[:^alpha:][:digit:]]"
~["-" "." "~" "\0a" "\09" "1" "2" "3"]
~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"]
::
:^  %has-match  "[[:^alpha::digit:]]"
~["-" "." "~" "\0a" "\09" "1" "2" "3"]
~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"]
::
:^  %has-match  "^[\\U\\L]+$"
~["ABC" "abc" "0123456789" "-"]
~[""]
::
:^  %has-match  "(?i)^[[:upper:]]+$"
~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"]
~
::
:^  %has-match  "(?i)^[[:lower:]]+$"
~["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"]
~
::
:^  %has-match  "^[:alpha:]+$"
~[":alpha:" "aaaa:aaaa:aaaa:aaaa"]
~["abc" "[alpha]"]
::
:^  %has-match  "^[abc\\]def]+$"
~["abc]def"]
~["[abc\\]def]"]
::
:^  %has-match  "^[]^$.|?+*()[\{}\\\\]+$"
~["^$.|?+*()[]\{}\\"]
~
::
:^  %has-match  "^[\\^$.|?+*()[\{}\\\\\\]]+$"
~["^$.|?+*()[]\{}\\"]
~
::
:^  %has-match  "[^]^$.|?+*()[\{}\\\\]"
~["^$.|?+*()[]\{}\\a"]
~["^$.|?+*()[]\{}\\"]
::
:^  %has-match  "\\a\\t\\n\\v\\f\\r\\e"
~["\07\09\0a\0b\0c\0d\1b"]
~
::
:^  %has-match  "[\\a][\\b][\\t][\\n][\\v][\\f][\\r][\\e]"
~["\07\08\09\0a\0b\0c\0d\1b"]
~
::
:^  %has-match  "^[\\x00-\\b]+$"
~["\00" "\00\01\02\03\04\05\06\07\08"]
~["\09" "\0a"]
::
:^  %has-match  "^[ --]+$"
~[" !\"#$%&'()+,-"]
~["." "/" "a" "b" "c"]
::
:^  %has-match  "[-ac]"
~["-" "a" "c"]
~["b"]
::
:^  %has-match  "[ac-]"
~["-" "a" "c"]
~["b"]
::
:^  %has-match  "[-ac-]"
~["-" "a" "c"]
~["b"]
::
:^  %has-match  "[-a-c-]"
~["-" "a" "b" "c"]
~
::
:^  %has-match  "[---]"
~["-"]
~["+" "," "." "/"]
::
[%parse-failure "[a--]"]
[%parse-failure "[a--z]"]
[%parse-failure "[a-[:digit:]]"]
[%parse-failure "[a-\\w]"]
[%parse-failure "[[:digit:]-a]"]
[%parse-failure "[a-m-o]"]
::
::::
  ::  Anchors
::::
::
:^  %has-match  "^abc$"
~["abc"]
~["xabc" "abcy" "x\0aabc" "x\0aabc\0ay" "abc\0ay"]
::
:^  %has-match  "^$"
~[""]
~["a" "\0a" "a\0a" "a\0a\0ab" "a\0ab"]
::
:^  %has-match  "(abc|^)def"
~["abcdef" "def"]
~["bcdef"]
::
:^  %has-match  "\\ba\\b"
~["a-" "-a" "-a-"]
~["a_" "_a" "_a_"]
::
:^  %has-match  "\\by\\b"
~
~["xy" "yz" "xyz"]
::
:^  %has-match  "\\Ba\\B"
~["_a_"]
~["a_" "_a" "a-" "-a" "-a-"]
::
:^  %has-match  "\\By\\b"
~["xy"]
~["xyz"]
::
:^  %has-match  "\\by\\B"
~["yz"]
~["xyz"]
::
:^  %has-match  "\\By\\B"
~["xyz"]
~["yz"]
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
:^  %has-match  "(((((((((a|)))))))))\\8\\9"
~["" "a" "aa" "aaa"]
~
::
:^  %has-match  "(a)(b)(c)(d)(e)(f)(g)(h)(i)\\8\\9"
~["abcdefghihi"]
~["abcdefgh"]
::
:^  %has-match  "(foo|ba.)\\1"
~["foofoo" "barbar" "bazbaz"]
~["foobar" "barbaz"]
::
:^  %has-match  "^(11+)\\1+$"
~["1111" "111111" "11111111" "111111111" "1111111111" "111111111111"]
~["1" "11" "111" "11111" "1111111" "11111111111" "1111111111111"]
::
:^  %has-match  "^(a|)\\1*b"
~["ab" "aaaab" "b"]
~["acb"]
::
:^  %has-match  "^(a|)\\1+b"
~["aab" "aaaab" "b"]
~["ab"]
::
:^  %has-match  "^(a|)\\1?b"
~["ab" "aab" "b"]
~["acb"]
::
:^  %has-match  "^(a|)\\1\{2}b"
~["aaab" "b"]
~["ab" "aab" "aaaab"]
::
:^  %has-match  "^(a|)\\1\{2,3}b"
~["aaab" "aaaab" "b"]
~["ab" "aab" "aaaaab"]
::
::::
  ::  Lookaround
::::
::
:^  %has-match  "(?=abc)abc"
~["abc"]
~["ABC"]
::
:^  %has-match  "(?=(?i)abc)abc"
~["abc"]
~["ABC"]
::
:^  %has-match  "(?i)(?=ABC)abc"
~["abc" "ABC"]
~
::
:^  %has-match  "(?<=abc)def"
~["abcdef" " abcdef"]
~["def" "bcdef" "abc def"]
::
:^  %has-match  "(?<!abc)def"
~["def" "bcdef" "abc def"]
~["abcdef" " abcdef"]
::
:^  %has-match  "(?=abc(?!abcdef))(abc)\\1"
~["abcabc" "abcabcde" "abcabc def"]
~["abcabcdef"]
::
:^  %has-match  "(?=def(?<!abcdef))defghi"
~["defghi" "bcdefghi" "abc defghi"]
~["abcdefghi"]
::
:^  %has-match  "(?=o(?<!o+(oo|o)))oi"
~["oi"]
~["i" "ooi" "oooi" "ooooi" "oooooi"]
::
:^  %has-match  "(?<!abc|def)ghi"
~["ghi" "abc ghi" "def ghi" "bcghi" "efghi"]
~["abcghi" "defghi" "abcdefghi" " abcghi" " defghi" " abcdefghi"]
::
:^  %has-match  "(?<!a(?=boot$))boo"
~["aboo" "aboota" "boot" "boota"]
~["aboot"]
::
:^  %has-match  "(?<!a(?=boo$))boo"
~["aboot" "boo" "boot"]
~["aboo"]
::
:^  %has-match  "(?<!^(b+?|a)\{1,2}?)c"
~["aaac" "abbbbbbbbbbbac"]
~["bc" "bbc" "bbbc" "bac" "bbac" "aac" "abbbbbbbbbbbc" "bbbbbbbbbbbac"]
::
:^  %has-match  "(?<!^(b+|a)\{1,2})c"
~["aaac" "abbbbbbbbbbbac"]
~["bc" "bbc" "bbbc" "bac" "bbac" "aac" "abbbbbbbbbbbc" "bbbbbbbbbbbac"]
::
:^  %has-match  "(?<!^(b+|a)\{1,2}?)bc"
~["c"]
~["bbc"]
::
:^  %has-match  "(?<!^(b*|ba)\{1,2}?)bc"
~["bababbc" "babababc"]
~["babc" "bbabc" "bababc"]
::
:^  %has-match  "(?<!^(ba|b*)\{1,2}?)bc"
~["bababbc" "babababc"]
~["babc" "bbabc" "bababc"]
::
::::
  ::  Capture groups with leftmost-longest rule
::::
::
:^  %capture-groups  "(foo)"  "foo"
~[[0 "foo"] [1 "foo"]]
::
:^  %capture-groups  "a|b+"  "abbb"
~[[0 "a"]]
::
:^  %capture-groups  "(a|b+)"  "abbb"
~[[0 "a"] [1 "a"]]
::
:^  %capture-groups  "(bb|bbb)bb"  "bbbb"
~[[0 "bbbb"] [1 "bb"]]
::
:^  %capture-groups  "(bb|bbb)bb"  "bbbbb"
~[[0 "bbbbb"] [1 "bbb"]]
::
:^  %capture-groups  "^(a*?)*$"  "aaaaaaaaaa"
~[[0 "aaaaaaaaaa"] [1 ""]]
::
:^  %capture-groups  "^(a+?)*$"  "aaaaaaaaaa"
~[[0 "aaaaaaaaaa"] [1 "a"]]
::
:^  %capture-groups  "^(a*+)+$"  "aaaaaaaaaa"
~[[0 "aaaaaaaaaa"] [1 "aaaaaaaaaa"]]
==
