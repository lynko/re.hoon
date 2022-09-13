:~
::
:^  %has-match  "the quick brown fox"
~["the quick brown fox" "What do you know about the quick brown fox?"]
~["The quick brown fox"]
::
:^  %has-match  "(?i)The quick brown fox"
~["the quick brown fox" "The quick brown FOX" "What do you know about the quick brown fox?" "What do you know about THE QUICK BROWN FOX?"]
~
::
:^  %has-match  "abcd\\t\\n\\r\\f\\a\\e\\071\\x3b\\$\\\\\\?caxyz"
~["abcd\09\0a\0d\0b\07\1b9;$\\?caxyz"]
~
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
:^  %has-match  "^\\ca\\cA\\c[;\\c:"
~["\01\01\1b;z"]
~
::
:^  %has-match  "^[ab\\]cde]"
~["athing" "bthing" "]thing" "cthing" "dthing" "ething"]
~["fthing" "[thing" "\09hing"]
::
:^  %has-match  "^[]cde]"
~["]thing" "cthing" "dthing" "ething"]
~["athing" "fthing"]
::
:^  %has-match  "^[^ab\\]cde]"
~["fthing" "[thing" "\09hing"]
~["athing" "bthing" "]thing" "cthing" "dthing" "ething"]
::
:^  %has-match  "^[^]cde]"
~["athing" "fthing"]
~["]thing" "cthing" "dthing" "ething"]
::
:^  %has-match  "^[0-9]+$"
~["0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "100"]
~["abc"]
::
:^  %has-match  "^.*nter"
~["enter" "inter" "uponter"]
~
::
:^  %has-match  "^xxx[0-9]+$"
~["xxx0" "xxx1234"]
~["xxx"]
::
:^  %has-match  "^.+[0-9][0-9][0-9]$"
~["x123" "x1234" "xx123" "123456"]
~["123"]
::
:^  %has-match  "^.+?[0-9][0-9][0-9]$"
~["x123" "x1234" "xx123" "123456"]
~["123"]
::
:^  %has-match  "^([^!]+)!(.+)=apquxz\\.ixr\\.zzz\\.ac\\.uk$"
~["abc!pqr=apquxz.ixr.zzz.ac.uk"]
~["!pqr=apquxz.ixr.zzz.ac.uk" "abc!=apquxz.ixr.zzz.ac.uk" "abc!pqr=apquxz:ixr.zzz.ac.uk" "abc!pqr=apquxz.ixr.zzz.ac.ukk"]
::
:^  %has-match  ":"
~["Well, we need a colon: somewhere"]
~
::
:^  %has-match  "^(?=ab(de))(abd)(e)"
~["abde"]
~
::
:^  %has-match  "^(?!(ab)de|x)(abd)(f)"
~["abdf"]
~
::
:^  %has-match  "^(?=(ab(cd)))(ab)"
~["abcd"]
~
::
:^  %has-match  "^\\\".*\\\"\\s*(;.*)?$"
~["\"1234\"" "\"abcd\" ;" "\"\" ; rhubarb"]
~["\"1234\" : things"]
::
:^  %has-match  "^$"
~[""]
~
::
:^  %has-match  "^(a(b(c)))(d(e(f)))(h(i(j)))(k(l(m)))$"
~["abcdefhijklm"]
~
::
:^  %has-match  "^[.^$|()*+?\{,}]+"
~[".^$(*+)|\{?,?}"]
~
::
:^  %has-match  "^a*\\w"
~["z" "az" "aaaz" "a" "aa" "aaaa" "a+" "aa+"]
~
::
:^  %has-match  "^a*?\\w"
~["z" "az" "aaaz" "a" "aa" "aaaa" "a+" "aa+"]
~
::
:^  %has-match  "^a+\\w"
~["az" "aaaz" "aa" "aaaa" "aa+"]
~
::
:^  %has-match  "^a+?\\w"
~["az" "aaaz" "aa" "aaaa" "aa+"]
~
::
:^  %has-match  "\\A(abc|def)=(\\1)\{2,3}\\Z"
~["abc=abcabc" "def=defdefdef"]
~["abc=defdef"]
::
:^  %has-match  "(cat(a(ract|tonic)|erpillar)) \\1()2(3)"
~["cataract cataract23" "catatonic catatonic23" "caterpillar caterpillar23"]
~
::
:^  %has-match  "^From +([^ ]+) +[a-zA-Z][a-zA-Z][a-zA-Z] +[a-zA-Z][a-zA-Z][a-zA-Z] +[0-9]?[0-9] +[0-9][0-9]:[0-9][0-9]"
~["From abcd  Mon Sep 01 12:33:02 1997"]
~
::
:^  %has-match  "\\w+(?=\\t)"
~["the quick brown\09 fox"]
~
::
:^  %has-match  "foo(?!bar)(.*)"
~["foobar is foolish see?"]
~
::
:^  %has-match  "^(a)\\1\{2,3}(.)"
~["aaab" "aaaab" "aaaaab" "aaaaaab"]
~
::
:^  %has-match  "(?!^)abc"
~["the abc"]
~["abc"]
::
:^  %has-match  "(?=^)abc"
~["abc"]
~["the abc"]
::
:^  %has-match  "^[ab]\{1,3}(ab*|b)"
~["aabbbbb"]
~
::
:^  %has-match  "^[ab]\{1,3}?(ab*|b)"
~["aabbbbb"]
~
::
:^  %has-match  "^[ab]\{1,3}?(ab*?|b)"
~["aabbbbb"]
~
::
:^  %has-match  "^[ab]\{1,3}(ab*?|b)"
~["aabbbbb"]
~
::
:^  %has-match  "A\\x00\{2,3}Z"
~["The A\00\00Z" "An A\00\00Z"]
~["A\00Z"]
::
:^  %has-match  "^(cow|)\\1(bell)"
~["cowcowbell" "bell"]
~["cowbell"]
::
:^  %has-match  "^\\s"
~["040abc" "x0cabc" "\0aabc" "\0dabc" "\09abc"]
~["abc"]
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
::
:^  %has-match  "^[W-c]+$"
~["WXY_^abc"]
~["wxy"]
::
:^  %has-match  "^[W-c]+$"
~["WXY_^abc" "wxy_^ABC"]
~
::
:^  %has-match  "^[\\x3f-\\x5F]+$"
~["WXY_^abc" "wxy_^ABC"]
~
::
:^  %has-match  "^abc$"
~["abc" "qqq\0aabc" "abc\0azzz" "qqq\0aabc\0azzz"]
~
::
:^  %has-match  "^abc$"
~["abc"]
~["qqq\0aabc" "abc\0azzz" "qqq\0aabc\0azzz"]
::
:^  %has-match  "\\Aabc\\Z"
~["abc" "abc\0a"]
~["qqq\0aabc" "abc\0azzz" "qqq\0aabc\0azzz"]
::
:^  %has-match  "\\A(.)*\\Z"
~
~["abc\0adef"]
::
:^  %has-match  "[-az]+"
~["az-"]
~["b"]
::
:^  %has-match  "[az-]+"
~["za-"]
~["b"]
::
:^  %has-match  "[a\\-z]+"
~["a-z"]
~["b"]
::
:^  %has-match  "[a-z]+"
~["abcdxyz"]
~
::
:^  %has-match  "\\x5c"
~["\\"]
~
::
:^  %has-match  "\\x20Z"
~["the Zoo"]
~["Zulu"]
::
:^  %has-match  "(abc)\\1"
~["abcabc" "ABCabc" "abcABC"]
~
::
:^  %has-match  "ab\{3cd"
~["ab\{3cd"]
~
::
:^  %has-match  "ab\{3,cd"
~["ab\{3,cd"]
~
::
:^  %has-match  "ab\{3,4a}cd"
~["ab\{3,4a}cd"]
~
::
:^  %has-match  "\{4,5a}bc"
~["\{4,5a}bc"]
~
::
:^  %has-match  "abc$"
~["abc" "abc\0a"]
~["abc\0adef"]
::
:^  %has-match  "(abc)\\123"
~["abcx53"]
~
::
:^  %has-match  "(abc)\\223"
~["abcx93"]
~
::
:^  %has-match  "(abc)\\323"
~["abcxd3"]
~
::
:^  %has-match  "(abc)\\100"
~["abcx40" "abc100"]
~
::
:^  %has-match  "^A\\8B\\9C$"
~["A8B9C"]
~["A08B09C"]
::
:^  %has-match  "^(A)(B)(C)(D)(E)(F)(G)(H)(I)\\8\\9$"
~["ABCDEFGHIHI"]
~
::
:^  %has-match  "^[A\\8B\\9C]+$"
~["A8B9C"]
~["A8B9Cx00"]
::
:^  %has-match  "ab\\idef"
~["abidef"]
~
::
:^  %has-match  "a\{0}bc"
~["bc"]
~
::
:^  %has-match  "(a|(bc))\{0,0}?xyz"
~["xyz"]
~
::
:^  %has-match  "abc[\\10]de"
~["abc010de"]
~
::
:^  %has-match  "abc[\\1]de"
~["abc1de"]
~
::
:^  %has-match  "(abc)[\\1]de"
~["abc1de"]
~
::
:^  %has-match  "^([^a])([^\\b])([^c]*)([^d]\{3,4})"
~["baNOTccccd" "baNOTcccd" "baNOTccd" "bacccd"]
~["anything" "b\08c" "baccd"]
::
:^  %has-match  "[^a]"
~["Abc"]
~
::
:^  %has-match  "[^a]"
~["Abc"]
~
::
:^  %has-match  "[^a]+"
~["AAAaAbc"]
~
::
:^  %has-match  "[^a]+"
~["AAAaAbc"]
~
::
:^  %has-match  "[^a]+"
~["bbb\0accc"]
~
::
:^  %has-match  "[^k]$"
~["abc"]
~["abk"]
::
:^  %has-match  "[^k]\{2,3}$"
~["abc" "kbc" "kabc"]
~["abk" "akb" "akk"]
::
:^  %has-match  "(a)\\1\{8,}"
~["aaaaaaaaa" "aaaaaaaaaa"]
~["aaaaaaa"]
::
:^  %has-match  "[^a]"
~["aaaabcd" "aaAabcd"]
~
::
:^  %has-match  "[^a]"
~["aaaabcd" "aaAabcd"]
~
::
:^  %has-match  "[^az]"
~["aaaabcd" "aaAabcd"]
~
::
:^  %has-match  "[^az]"
~["aaaabcd" "aaAabcd"]
~
::
:^  %has-match  "P[^*]TAIRE[^*]\{1,6}?LL"
~["xxxxxxxxxxxPSTAIREISLLxxxxxxxxx"]
~
::
:^  %has-match  "P[^*]TAIRE[^*]\{1,}?LL"
~["xxxxxxxxxxxPSTAIREISLLxxxxxxxxx"]
~
::
:^  %has-match  "\\b(foo)\\s+(\\w+)"
~["Food is on the foo table"]
~
::
:^  %has-match  "foo(.*)bar"
~["The food is under the bar in the barn."]
~
::
:^  %has-match  "foo(.*?)bar"
~["The food is under the bar in the barn."]
~
::
:^  %has-match  "^\\D*(?!123)"
~["ABC123"]
~
::
:^  %has-match  "^[W-]46]"
~["W46]789" "-46]789"]
~["Wall" "Zebra" "42" "[abcd]" "]abcd["]
::
:^  %has-match  "^[W-\\]46]"
~["W46]789" "Wall" "Zebra" "Xylophone" "42" "[abcd]" "]abcd[" "\08ackslash"]
~["-46]789" "well"]
::
:^  %has-match  "^(a)\{0,0}"
~["bcd" "abc" "aab"]
~
::
:^  %has-match  "^(a)\{0,1}"
~["bcd" "abc" "aab"]
~
::
:^  %has-match  "^(a)\{0,2}"
~["bcd" "abc" "aab"]
~
::
:^  %has-match  "^(a)\{0,3}"
~["bcd" "abc" "aab" "aaa"]
~
::
:^  %has-match  "^(a)\{0,}"
~["bcd" "abc" "aab" "aaa" "aaaaaaaa"]
~
::
:^  %has-match  "^(a)\{1,1}"
~["bcd" "abc" "aab"]
~
::
:^  %has-match  "^(a)\{1,2}"
~["bcd" "abc" "aab"]
~
::
:^  %has-match  "^(a)\{1,3}"
~["bcd" "abc" "aab" "aaa"]
~
::
:^  %has-match  "^(a)\{1,}"
~["bcd" "abc" "aab" "aaa" "aaaaaaaa"]
~
::
:^  %has-match  ".*\\.gif"
~["borfle\0abib.gif\0ano"]
~
::
:^  %has-match  ".\{0,}\\.gif"
~["borfle\0abib.gif\0ano"]
~
::
:^  %has-match  ".*\\.gif"
~["borfle\0abib.gif\0ano"]
~
::
:^  %has-match  ".*$"
~["borfle\0abib.gif\0ano"]
~
::
:^  %has-match  ".*$"
~["borfle\0abib.gif\0ano"]
~
::
:^  %has-match  ".*$"
~["borfle\0abib.gif\0ano\0a"]
~
::
:^  %has-match  ".*$"
~["borfle\0abib.gif\0ano\0a"]
~
::
:^  %has-match  "(.*X|^B)"
~["abcde\0a1234Xyz" "BarFoo"]
~["abcde\0aBar"]
::
:^  %has-match  "(.*X|^B)"
~["abcde\0a1234Xyz" "BarFoo" "abcde\0aBar"]
~
::
:^  %has-match  "^.*B"
~
~["abc\0aB"]
::
:^  %has-match  "^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]"
~["123456654321"]
~
::
:^  %has-match  "^[abc]\{12}"
~["abcabcabcabc"]
~
::
:^  %has-match  "^[a-c]\{12}"
~["abcabcabcabc"]
~
::
:^  %has-match  "^(a|b|c)\{12}"
~["abcabcabcabc"]
~
::
:^  %has-match  "^[abcdefghijklmnopqrstuvwxy0123456789]"
~["n"]
~["z"]
::
:^  %has-match  "abcde\{0,0}"
~["abcd"]
~["abce"]
::
:^  %has-match  "ab[cd]\{0,0}e"
~["abe"]
~["abcde"]
::
:^  %has-match  "ab(c)\{0,0}d"
~["abd"]
~["abcd"]
::
:^  %has-match  "a(b*)"
~["a" "ab" "abbbb"]
~["bbbbb"]
::
:^  %has-match  "\"([^\\\\\"]+|\\\\.)*\""
~["abc \"def\" ghi" "\"abc \\\"def\\\" ghi\""]
~
::
:^  %has-match  "a[^a]b"
~["acb" "a\0ab"]
~
::
:^  %has-match  "a.b"
~["acb"]
~["a\0ab"]
::
:^  %has-match  "^(b+?|a)\{1,2}?c"
~["bac" "bbac" "bbbac" "bbbbac" "bbbbbac"]
~
::
:^  %has-match  "^(b+|a)\{1,2}?c"
~["bac" "bbac" "bbbac" "bbbbac" "bbbbbac"]
~
::
:^  %has-match  "(?!\\A)x"
~["x\0ab\0a" "a\08x\0a"]
~
::
:^  %has-match  "\\x0\{ab}"
~["0\{ab}"]
~
::
:^  %has-match  "(A|B)*?CD"
~["CD"]
~
::
:^  %has-match  "(A|B)*CD"
~["CD"]
~
::
:^  %has-match  "(AB)*?\\1"
~["ABABAB"]
~
::
:^  %has-match  "(AB)*\\1"
~["ABABAB"]
~
::
:^  %has-match  "(?<!bar)foo"
~["foo" "catfood" "arfootle" "rfoosh"]
~["barfoo" "towbarfoo"]
::
:^  %has-match  "\\w\{3}(?<!bar)foo"
~["catfood"]
~["foo" "barfoo" "towbarfoo"]
::
:^  %has-match  "(?<=(foo)a)bar"
~["fooabar"]
~["bar" "foobbar"]
::
:^  %has-match  "\\Aabc\\z"
~["abc"]
~["abc\0a" "qqq\0aabc" "abc\0azzz" "qqq\0aabc\0azzz"]
::
:^  %has-match  "a(?-i)b"
~["ab" "Ab"]
~["aB" "AB"]
::
:^  %has-match  "(a(?i)b)c"
~["abc" "aBc"]
~["abC" "aBC" "Abc" "ABc" "ABC" "AbC"]
::
:^  %has-match  "a(?i:b)c"
~["abc" "aBc"]
~["ABC" "abC" "aBC"]
::
:^  %has-match  "a(?i:b)*c"
~["aBc" "aBBc"]
~["aBC" "aBBC"]
::
:^  %has-match  "a(?=b(?i)c)\\w\\wd"
~["abcd" "abCd"]
~["aBCd" "abcD"]
::
:^  %has-match  "(?=a(?i)b)\\w\\wc"
~["abc" "aBc"]
~["Ab" "abC" "aBC"]
::
:^  %has-match  "(?<=a(?i)b)(\\w\\w)c"
~["abxxc" "aBxxc"]
~["Abxxc" "ABxxc" "abxxC"]
::
:^  %has-match  "((?i)blah)\\s+\\1"
~["blah blah" "BLAH BLAH" "Blah Blah" "blaH blaH"]
~["blah BLAH" "Blah blah" "blaH blah"]
::
:^  %has-match  "((?i)blah)\\s+(?i:\\1)"
~["blah blah" "BLAH BLAH" "Blah Blah" "blaH blaH" "blah BLAH" "Blah blah" "blaH blah"]
~
::
:^  %has-match  "(abc|)+"
~["abc" "abcabc" "abcabcabc" "xyz"]
~
::
:^  %has-match  "([a]*)*"
~["a" "aaaaa"]
~
::
:^  %has-match  "([ab]*)*"
~["a" "b" "ababab" "aaaabcde" "bbbb"]
~
::
:^  %has-match  "([^a]*)*"
~["b" "bbbb" "aaa"]
~
::
:^  %has-match  "([^ab]*)*"
~["cccc" "abab"]
~
::
:^  %has-match  "([a]*?)*"
~["a" "aaaa"]
~
::
:^  %has-match  "([ab]*?)*"
~["a" "b" "abab" "baba"]
~
::
:^  %has-match  "([^a]*?)*"
~["b" "bbbb" "aaa"]
~
::
:^  %has-match  "([^ab]*?)*"
~["c" "cccc" "baba"]
~
::
:^  %has-match  "(?<=(foo))bar\\1"
~["foobarfoo" "foobarfootling"]
~["foobar" "barfoo"]
::
:^  %has-match  "(?i:saturday|sunday)"
~["saturday" "sunday" "Saturday" "Sunday" "SATURDAY" "SUNDAY" "SunDay"]
~
::
:^  %has-match  "(a(?i)bc|BB)x"
~["abcx" "aBCx" "bbx" "BBx"]
~["abcX" "aBCX" "bbX" "BBX"]
::
:^  %has-match  "^([ab](?i)[cd]|[ef])"
~["ac" "aC" "bD" "elephant" "Europe" "frog" "France"]
~["Africa"]
::
:^  %has-match  "(?<=foo\\n)^bar"
~["foo\0abar"]
~["bar" "baz\0abar"]
::
:^  %has-match  "(?<=(?<!foo)bar)baz"
~["barbaz" "barbarbaz" "koobarbaz"]
~["baz" "foobarbaz"]
::
:^  %has-match  "^(a\\1?)\{4}$"
~["a" "aa" "aaa" "aaaaa" "aaaaaaa" "aaaaaaaa" "aaaaaaaaa" "aaaaaaaaaa" "aaaaaaaaaaa" "aaaaaaaaaaaa" "aaaaaaaaaaaaa" "aaaaaaaaaaaaaa" "aaaaaaaaaaaaaaa" "aaaaaaaaaaaaaaaa"]
~
::
:^  %has-match  "^(a\\1?)(a\\1?)(a\\2?)(a\\3?)$"
~["a" "aa" "aaa" "aaaa" "aaaaa" "aaaaaa" "aaaaaaa" "aaaaaaaa" "aaaaaaaaa" "aaaaaaaaaa" "aaaaaaaaaaa" "aaaaaaaaaaaa" "aaaaaaaaaaaaa" "aaaaaaaaaaaaaa" "aaaaaaaaaaaaaaa" "aaaaaaaaaaaaaaaa"]
~
::
:^  %has-match  "abc"
~["abc" "xabcy" "ababc"]
~["xbc" "axc" "abx"]
::
:^  %has-match  "ab*c"
~["abc"]
~
::
:^  %has-match  "ab*bc"
~["abc" "abbc" "abbbbc"]
~
::
:^  %has-match  ".\{1}"
~["abbbbc"]
~
::
:^  %has-match  ".\{3,4}"
~["abbbbc"]
~
::
:^  %has-match  "ab\{0,}bc"
~["abbbbc"]
~
::
:^  %has-match  "ab+bc"
~["abbc"]
~["abc" "abq"]
::
:^  %has-match  "ab+bc"
~["abbbbc"]
~
::
:^  %has-match  "ab\{1,}bc"
~["abbbbc"]
~
::
:^  %has-match  "ab\{1,3}bc"
~["abbbbc"]
~
::
:^  %has-match  "ab\{3,4}bc"
~["abbbbc"]
~
::
:^  %has-match  "ab\{4,5}bc"
~
~["abq" "abbbbc"]
::
:^  %has-match  "ab?bc"
~["abbc" "abc"]
~
::
:^  %has-match  "ab\{0,1}bc"
~["abc"]
~
::
:^  %has-match  "ab?c"
~["abc"]
~
::
:^  %has-match  "ab\{0,1}c"
~["abc"]
~
::
:^  %has-match  "^abc$"
~["abc"]
~["abbbbc" "abcc"]
::
:^  %has-match  "^abc"
~["abcc"]
~
::
:^  %has-match  "abc$"
~["aabc"]
~["aabc" "aabcd"]
::
:^  %has-match  "^"
~["abc"]
~
::
:^  %has-match  "$"
~["abc"]
~
::
:^  %has-match  "a.c"
~["abc" "axc"]
~
::
:^  %has-match  "a.*c"
~["axyzc"]
~
::
:^  %has-match  "a[bc]d"
~["abd"]
~["axyzd" "abc"]
::
:^  %has-match  "a[b-d]e"
~["ace"]
~
::
:^  %has-match  "a[b-d]"
~["aac"]
~
::
:^  %has-match  "a[-b]"
~["a-"]
~
::
:^  %has-match  "a[b-]"
~["a-"]
~
::
:^  %has-match  "a]"
~["a]"]
~
::
:^  %has-match  "a[]]b"
~["a]b"]
~
::
:^  %has-match  "a[^bc]d"
~["aed"]
~["abd" "abd"]
::
:^  %has-match  "a[^-b]c"
~["adc"]
~
::
:^  %has-match  "a[^]b]c"
~["adc"]
~["a-c" "a]c"]
::
:^  %has-match  "\\ba\\b"
~["a-" "-a" "-a-"]
~
::
:^  %has-match  "\\by\\b"
~
~["xy" "yz" "xyz"]
::
:^  %has-match  "\\Ba\\B"
~
~["a-" "-a" "-a-"]
::
:^  %has-match  "\\By\\b"
~["xy"]
~
::
:^  %has-match  "\\by\\B"
~["yz"]
~
::
:^  %has-match  "\\By\\B"
~["xyz"]
~
::
:^  %has-match  "\\w"
~["a"]
~
::
:^  %has-match  "\\W"
~["-"]
~["-" "a"]
::
:^  %has-match  "a\\sb"
~["a b"]
~
::
:^  %has-match  "a\\Sb"
~["a-b"]
~["a-b" "a b"]
::
:^  %has-match  "\\D"
~["-"]
~["-" "1"]
::
:^  %has-match  "[\\w]"
~["a"]
~
::
:^  %has-match  "[\\W]"
~["-"]
~["-" "a"]
::
:^  %has-match  "a[\\s]b"
~["a b"]
~
::
:^  %has-match  "a[\\S]b"
~["a-b"]
~["a-b" "a b"]
::
:^  %has-match  "[\\D]"
~["-"]
~["-" "1"]
::
:^  %has-match  "ab|cd"
~["abc" "abcd"]
~
::
:^  %has-match  "()ef"
~["def"]
~
::
:^  %has-match  "a\\(b"
~["a(b"]
~
::
:^  %has-match  "a\\\\b"
~["a\08"]
~
::
:^  %has-match  "((a))"
~["abc"]
~
::
:^  %has-match  "(a)b(c)"
~["abc"]
~
::
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
:^  %has-match  "[^ab]*"
~["cde"]
~
::
:^  %has-match  "abc"
~
~["b"]
::
:^  %has-match  "([abc])*d"
~["abbbcd"]
~
::
:^  %has-match  "([abc])*bcd"
~["abcd"]
~
::
:^  %has-match  "a|b|c|d|e"
~["e"]
~
::
:^  %has-match  "(a|b|c|d|e)f"
~["ef"]
~
::
:^  %has-match  "abcd*efg"
~["abcdefg"]
~
::
:^  %has-match  "ab*"
~["xabyabbbz" "xayabbbz"]
~
::
:^  %has-match  "(ab|cd)e"
~["abcde"]
~
::
:^  %has-match  "[abhgefdc]ij"
~["hij"]
~
::
:^  %has-match  "(abc|)ef"
~["abcdef"]
~
::
:^  %has-match  "(a|b)c*d"
~["abcd"]
~
::
:^  %has-match  "(ab|ab*)bc"
~["abc"]
~
::
:^  %has-match  "a([bc]*)c*"
~["abc"]
~
::
:^  %has-match  "a([bc]*)(c*d)"
~["abcd"]
~
::
:^  %has-match  "a([bc]+)(c*d)"
~["abcd"]
~
::
:^  %has-match  "a([bc]*)(c+d)"
~["abcd"]
~
::
:^  %has-match  "a[bcd]*dcdcde"
~["adcdcde"]
~
::
:^  %has-match  "a[bcd]+dcdcde"
~
~["abcde" "adcdcde"]
::
:^  %has-match  "(ab|a)b*c"
~["abc"]
~
::
:^  %has-match  "((a)(b)c)(d)"
~["abcd"]
~
::
:^  %has-match  "[a-zA-Z_][a-zA-Z0-9_]*"
~["alpha"]
~
::
:^  %has-match  "^a(bc+|b[eh])g|.h$"
~["abh"]
~
::
:^  %has-match  "(bc+d$|ef*g.|h?i(j|k))"
~["effgz" "ij" "reffgz"]
~["effg" "bcdd"]
::
:^  %has-match  "((((((((((a))))))))))"
~["a"]
~
::
:^  %has-match  "((((((((((a))))))))))\\10"
~["aa"]
~
::
:^  %has-match  "(((((((((a)))))))))"
~["a"]
~
::
:^  %has-match  "multiple words of text"
~
~["aa" "uh-uh"]
::
:^  %has-match  "multiple words"
~["multiple words, yeah"]
~
::
:^  %has-match  "(.*)c(.*)"
~["abcde"]
~
::
:^  %has-match  "\\((.*), (.*)\\)"
~["(a, b)"]
~
::
:^  %has-match  "abcd"
~["abcd"]
~
::
:^  %has-match  "a(bc)d"
~["abcd"]
~
::
:^  %has-match  "a[-]?c"
~["ac"]
~
::
:^  %has-match  "(abc)\\1"
~["abcabc"]
~
::
:^  %has-match  "([a-c]*)\\1"
~["abcabc"]
~
::
:^  %has-match  "(a)|\\1"
~["a"]
~["ab" "x"]
::
:^  %has-match  "(([a-c])b*?\\2)*"
~["ababbbcbc"]
~
::
:^  %has-match  "(([a-c])b*?\\2)\{3}"
~["ababbbcbc"]
~
::
:^  %has-match  "((\\3|b)\\2(a)x)+"
~["aaaxabaxbaaxbbax"]
~
::
:^  %has-match  "((\\3|b)\\2(a))\{2,}"
~["bbaababbabaaaaabbaaaabba"]
~
::
:^  %has-match  "abc"
~["ABC" "XABCY" "ABABC"]
~["aaxabxbaxbbx" "XBC" "AXC" "ABX"]
::
:^  %has-match  "ab*c"
~["ABC"]
~
::
:^  %has-match  "ab*bc"
~["ABC" "ABBC"]
~
::
:^  %has-match  "ab*?bc"
~["ABBBBC"]
~
::
:^  %has-match  "ab\{0,}?bc"
~["ABBBBC"]
~
::
:^  %has-match  "ab+?bc"
~["ABBC"]
~
::
:^  %has-match  "ab+bc"
~
~["ABC" "ABQ"]
::
:^  %has-match  "ab+bc"
~["ABBBBC"]
~
::
:^  %has-match  "ab\{1,}?bc"
~["ABBBBC"]
~
::
:^  %has-match  "ab\{1,3}?bc"
~["ABBBBC"]
~
::
:^  %has-match  "ab\{3,4}?bc"
~["ABBBBC"]
~
::
:^  %has-match  "ab\{4,5}?bc"
~
~["ABQ" "ABBBBC"]
::
:^  %has-match  "ab??bc"
~["ABBC" "ABC"]
~
::
:^  %has-match  "ab\{0,1}?bc"
~["ABC"]
~
::
:^  %has-match  "ab??c"
~["ABC"]
~
::
:^  %has-match  "ab\{0,1}?c"
~["ABC"]
~
::
:^  %has-match  "^abc$"
~["ABC"]
~["ABBBBC" "ABCC"]
::
:^  %has-match  "^abc"
~["ABCC"]
~
::
:^  %has-match  "abc$"
~["AABC"]
~
::
:^  %has-match  "^"
~["ABC"]
~
::
:^  %has-match  "$"
~["ABC"]
~
::
:^  %has-match  "a.c"
~["ABC" "AXC"]
~
::
:^  %has-match  "a.*?c"
~["AXYZC"]
~
::
:^  %has-match  "a.*c"
~
~["AABC" "AXYZD"]
::
:^  %has-match  "a[bc]d"
~["ABD"]
~
::
:^  %has-match  "a[b-d]e"
~["ACE"]
~["ABC" "ABD"]
::
:^  %has-match  "a[b-d]"
~["AAC"]
~
::
:^  %has-match  "a[-b]"
~["A-"]
~
::
:^  %has-match  "a[b-]"
~["A-"]
~
::
:^  %has-match  "a]"
~["A]"]
~
::
:^  %has-match  "a[]]b"
~["A]B"]
~
::
:^  %has-match  "a[^bc]d"
~["AED"]
~
::
:^  %has-match  "a[^-b]c"
~["ADC"]
~["ABD" "A-C"]
::
:^  %has-match  "a[^]b]c"
~["ADC"]
~
::
:^  %has-match  "ab|cd"
~["ABC" "ABCD"]
~
::
:^  %has-match  "()ef"
~["DEF"]
~
::
:^  %has-match  "$b"
~
~["A]C" "B"]
::
:^  %has-match  "a\\(b"
~["A(B"]
~
::
:^  %has-match  "a\\\\b"
~["AB"]
~
::
:^  %has-match  "((a))"
~["ABC"]
~
::
:^  %has-match  "(a)b(c)"
~["ABC"]
~
::
:^  %has-match  "a+b+c"
~["AABBABC"]
~
::
:^  %has-match  "a\{1,}b\{1,}c"
~["AABBABC"]
~
::
:^  %has-match  "a.+?c"
~["ABCABC"]
~
::
:^  %has-match  "a.*?c"
~["ABCABC"]
~
::
:^  %has-match  "a.\{0,5}?c"
~["ABCABC"]
~
::
:^  %has-match  "(a+|b)*"
~["AB"]
~
::
:^  %has-match  "(a+|b)\{0,}"
~["AB"]
~
::
:^  %has-match  "(a+|b)+"
~["AB"]
~
::
:^  %has-match  "(a+|b)\{1,}"
~["AB"]
~
::
:^  %has-match  "(a+|b)?"
~["AB"]
~
::
:^  %has-match  "(a+|b)\{0,1}"
~["AB"]
~
::
:^  %has-match  "(a+|b)\{0,1}?"
~["AB"]
~
::
:^  %has-match  "[^ab]*"
~["CDE"]
~
::
:^  %has-match  "([abc])*d"
~["ABBBCD"]
~
::
:^  %has-match  "([abc])*bcd"
~["ABCD"]
~
::
:^  %has-match  "a|b|c|d|e"
~["E"]
~
::
:^  %has-match  "(a|b|c|d|e)f"
~["EF"]
~
::
:^  %has-match  "abcd*efg"
~["ABCDEFG"]
~
::
:^  %has-match  "ab*"
~["XABYABBBZ" "XAYABBBZ"]
~
::
:^  %has-match  "(ab|cd)e"
~["ABCDE"]
~
::
:^  %has-match  "[abhgefdc]ij"
~["HIJ"]
~
::
:^  %has-match  "^(ab|cd)e"
~["ABCDE"]
~
::
:^  %has-match  "(abc|)ef"
~["ABCDEF"]
~
::
:^  %has-match  "(a|b)c*d"
~["ABCD"]
~
::
:^  %has-match  "(ab|ab*)bc"
~["ABC"]
~
::
:^  %has-match  "a([bc]*)c*"
~["ABC"]
~
::
:^  %has-match  "a([bc]*)(c*d)"
~["ABCD"]
~
::
:^  %has-match  "a([bc]+)(c*d)"
~["ABCD"]
~
::
:^  %has-match  "a([bc]*)(c+d)"
~["ABCD"]
~
::
:^  %has-match  "a[bcd]*dcdcde"
~["ADCDCDE"]
~
::
:^  %has-match  "(ab|a)b*c"
~["ABC"]
~
::
:^  %has-match  "((a)(b)c)(d)"
~["ABCD"]
~
::
:^  %has-match  "[a-zA-Z_][a-zA-Z0-9_]*"
~["ALPHA"]
~
::
:^  %has-match  "^a(bc+|b[eh])g|.h$"
~["ABH"]
~
::
:^  %has-match  "(bc+d$|ef*g.|h?i(j|k))"
~["EFFGZ" "IJ" "REFFGZ"]
~["ADCDCDE" "EFFG" "BCDD"]
::
:^  %has-match  "((((((((((a))))))))))"
~["A"]
~
::
:^  %has-match  "((((((((((a))))))))))\\10"
~["AA"]
~
::
:^  %has-match  "(((((((((a)))))))))"
~["A"]
~
::
:^  %has-match  "multiple words of text"
~
~["AA" "UH-UH"]
::
:^  %has-match  "multiple words"
~["MULTIPLE WORDS, YEAH"]
~
::
:^  %has-match  "(.*)c(.*)"
~["ABCDE"]
~
::
:^  %has-match  "\\((.*), (.*)\\)"
~["(A, B)"]
~
::
:^  %has-match  "abcd"
~["ABCD"]
~
::
:^  %has-match  "a(bc)d"
~["ABCD"]
~
::
:^  %has-match  "a[-]?c"
~["AC"]
~
::
:^  %has-match  "(abc)\\1"
~["ABCABC"]
~
::
:^  %has-match  "([a-c]*)\\1"
~["ABCABC"]
~
::
:^  %has-match  "a(?!b)."
~["abad"]
~
::
:^  %has-match  "a(?=d)."
~["abad"]
~
::
:^  %has-match  "a(?=c|d)."
~["abad"]
~
::
:^  %has-match  "((foo)|(bar))*"
~["foobar"]
~
::
:^  %has-match  "^(.+)?B"
~["AB"]
~
::
:^  %has-match  "^([^a-z])|(\\^)$"
~["."]
~
::
:^  %has-match  "^(a\\1?)\{4}$"
~["aaaaaaaaaa"]
~["AB" "aaaaaaaaa" "aaaaaaaaaaa"]
::
:^  %has-match  "(?<=a)b"
~["ab"]
~["cb" "b"]
::
:^  %has-match  "(?<!c)b"
~["ab" "b" "b"]
~
::
:^  %has-match  "^()\{3,5}"
~["abc"]
~
::
:^  %has-match  "^(a+)*ax"
~["aax"]
~
::
:^  %has-match  "^((a|b)+)*ax"
~["aax"]
~
::
:^  %has-match  "^((a|bc)+)*ax"
~["aax"]
~
::
:^  %has-match  "(a|x)*ab"
~["cab"]
~
::
:^  %has-match  "(a)*ab"
~["cab"]
~
::
:^  %has-match  "((?i)a)b"
~["ab"]
~
::
:^  %has-match  "((?i)a)b"
~["Ab"]
~
::
:^  %has-match  "(?i:a)b"
~["ab"]
~
::
:^  %has-match  "((?i:a))b"
~["ab"]
~
::
:^  %has-match  "(?i:a)b"
~["Ab"]
~
::
:^  %has-match  "((?i:a))b"
~["Ab"]
~
::
:^  %has-match  "(?i:a)b"
~
~["aB" "aB"]
::
:^  %has-match  "((?-i)a)b"
~["ab"]
~
::
:^  %has-match  "((?-i)a)b"
~["aB"]
~
::
:^  %has-match  "((?-i)a)b"
~["aB"]
~
::
:^  %has-match  "(?-i:a)b"
~["ab"]
~
::
:^  %has-match  "((?-i:a))b"
~["ab"]
~
::
:^  %has-match  "(?-i:a)b"
~["aB"]
~
::
:^  %has-match  "((?-i:a))b"
~["aB"]
~
::
:^  %has-match  "(?-i:a)b"
~
~["AB" "Ab"]
::
:^  %has-match  "(?-i:a)b"
~["aB"]
~
::
:^  %has-match  "((?-i:a))b"
~["aB"]
~
::
:^  %has-match  "(?-i:a)b"
~
~["Ab" "AB"]
::
:^  %has-match  "((?-i:a.))b"
~
~["AB" "a\0aB"]
::
:^  %has-match  "(?<![cd])b"
~
~["B\0aB" "dbcb"]
::
:^  %has-match  "(?<![cd])[ab]"
~["dbaacb"]
~
::
:^  %has-match  "(?<!(c|d))[ab]"
~["dbaacb"]
~
::
:^  %has-match  "(?<!cd)[ab]"
~["cdaccb"]
~
::
:^  %has-match  "()^b"
~
~["a\0ab\0ac\0a" "a\0ab\0ac\0a"]
::
:^  %has-match  "(?=(a+?))(\\1ab)"
~["aaab"]
~
::
:^  %has-match  "(\\w+:)+"
~["one:"]
~
::
:^  %has-match  "$(?<=^(a))"
~["a"]
~
::
:^  %has-match  "(?=(a+?))(\\1ab)"
~["aaab"]
~
::
:^  %has-match  "^(?=(a+?))\\1ab"
~
~["aaab" "aaab"]
::
:^  %has-match  "([\\w:]+::)?(\\w+)$"
~["abcd" "xy:z:::abcd"]
~
::
:^  %has-match  "^[^bcd]*(c+)"
~["aexycd"]
~
::
:^  %has-match  "(a*)b+"
~["caab"]
~
::
:^  %has-match  "([\\w:]+::)?(\\w+)$"
~["abcd" "xy:z:::abcd"]
~["abcd:" "abcd:"]
::
:^  %has-match  "^[^bcd]*(c+)"
~["aexycd"]
~
::
:^  %has-match  "([[:]+)"
~["a:[b]:"]
~
::
:^  %has-match  "([[=]+)"
~["a=[b]="]
~
::
:^  %has-match  "([[.]+)"
~["a.[b]."]
~
::
:^  %has-match  "a\\Z"
~
~["aaab" "a\0ab\0a"]
::
:^  %has-match  "b\\Z"
~["a\0ab\0a"]
~
::
:^  %has-match  "b\\Z"
~["a\0ab"]
~
::
:^  %has-match  "b\\z"
~["a\0ab"]
~
::
:^  %has-match  "((Z)+|A)*"
~["ZABCDEFG"]
~
::
:^  %has-match  "(Z()|A)*"
~["ZABCDEFG"]
~
::
:^  %has-match  "(Z(())|A)*"
~["ZABCDEFG"]
~
::
:^  %has-match  "[[:space:]]+"
~["> x09x0ax0cx0dx0b<"]
~
::
:^  %has-match  "[[:blank:]]+"
~["> x09x0ax0cx0dx0b<"]
~
::
:^  %has-match  "[\\s]+"
~["> x09x0ax0cx0dx0b<"]
~
::
:^  %has-match  "\\s+"
~["> x09x0ax0cx0dx0b<"]
~
::
:^  %has-match  "(?!\\A)x"
~["a\0axb\0a"]
~
::
:^  %has-match  "(?!^)x"
~["a\0axb\0a"]
~
::
:^  %has-match  "\\Gabc"
~["abc"]
~["xyzabc"]
::
:^  %has-match  "(?i)AB(?-i)C"
~["XabCY"]
~["XabcY"]
::
:^  %has-match  "((?i)AB(?-i)C|D)E"
~["abCE" "DE"]
~["abcE" "abCe" "dE" "De"]
::
:^  %has-match  "[\\z\\C]"
~["z" "C"]
~
::
:^  %has-match  "\\M"
~["M"]
~
::
:^  %has-match  "(a+)*b"
~["aaaaaaaaab"]
~["aaaaaaaaa"]
::
:^  %has-match  "≈жед[а-€ј-я]+"
~["≈жеда" "≈жед€" "≈жедј" "≈жедя"]
~
::
:^  %has-match  "(?<=Z)X."
~["x84XAZXB"]
~
::
:^  %has-match  "(?<![^f]oo)(bar)"
~["foobarX"]
~["boobarX"]
::
:^  %has-match  "(?<![^f])X"
~["offX"]
~["onyX"]
::
:^  %has-match  "(?<=[^f])X"
~["onyX"]
~["offX"]
::
:^  %has-match  "[[,abc,]+]"
~["abc]" "a,b]" "[a,b,c]"]
~
::
:^  %has-match  "a*b*\\w"
~["aaabbbb" "aaaa" "a"]
~
::
:^  %has-match  "a*b?\\w"
~["aaabbbb" "aaaa" "a"]
~
::
:^  %has-match  "a*b\{0,4}\\w"
~["aaabbbb" "aaaa" "a"]
~
::
:^  %has-match  "a*b\{0,}\\w"
~["aaabbbb" "aaaa" "a"]
~
::
:^  %has-match  "^\\w+=.*(\\\\\\n.*)*"
~["abc=xyz\\\0apqr"]
~
::
:^  %has-match  "(?=(\\w+))\\1:"
~["abcd:"]
~
::
:^  %has-match  "^(?=(\\w+))\\1:"
~["abcd:"]
~
::
:^  %has-match  "^(a()*)*"
~["aaaa"]
~
::
:^  %has-match  "^(a()+)+"
~["aaaa"]
~
::
:^  %has-match  "^(?![^\\n]*\\n\\z)"
~["abc" "abc\0a"]
~
::
:^  %has-match  "\\z(?<!\\n)"
~["abc" "abc\0a"]
~
::
:^  %has-match  "(.*(.)?)*"
~["abcd"]
~
::
:^  %has-match  "[[:abcd:xyz]]"
~["a]" ":]"]
~
::
:^  %has-match  "[abc[:x\\]pqr]"
~["a" "[" ":" "]" "p"]
~
::
:^  %has-match  ".*[op][xyz]"
~["fooabcfoo"]
~
::
:^  %has-match  "(?i)a(?-i)b|c"
~["XabX" "XAbX" "CcC"]
~["XABX"]
::
:^  %has-match  "[\\x00-\\xff\\s]+"
~["x0ax0bx0cx0d"]
~
::
:: :^  %has-match  "^\\ c"
::~["?"]
::~
::
:^  %has-match  "(abc)\\1"
~["abc"]
~
::
:^  %has-match  "(abc)\\1"
~["abc"]
~
::
:^  %has-match  "[^a]*"
~["12abc" "12ABC"]
~
::
:^  %has-match  "[^a]*+"
~["12abc" "12ABC"]
~
::
:^  %has-match  "[^a]*?X"
~
~["12abc" "12ABC"]
::
:^  %has-match  "[^a]+?X"
~
~["12abc" "12ABC"]
::
:^  %has-match  "[^a]?X"
~["12aXbcX" "12AXBCX" "BCX"]
~
::
:^  %has-match  "[^a]??X"
~["12aXbcX" "12AXBCX" "BCX"]
~
::
:^  %has-match  "[^a]?+X"
~["12aXbcX" "12AXBCX" "BCX"]
~
::
:^  %has-match  "[^a]\{2,3}"
~["abcdef" "ABCDEF"]
~
::
:^  %has-match  "[^a]\{2,3}?"
~["abcdef" "ABCDEF"]
~
::
:^  %has-match  "[^a]\{2,3}+"
~["abcdef" "ABCDEF"]
~
::
:^  %has-match  "((a|)+)+Z"
~["Z"]
~
::
:^  %has-match  "(a)b|(a)c"
~["ac"]
~
::
:^  %has-match  "(?=(a))ab|(a)c"
~["ac"]
~
::
:^  %has-match  "(?=abc)\{0}xyz"
~["xyz"]
~
::
:^  %has-match  "(?=abc)\{1}xyz"
~
~["xyz"]
::
:^  %has-match  "(?=(a))?."
~["ab" "bc"]
~
::
:^  %has-match  "(?=(a))??."
~["ab" "bc"]
~
::
:^  %has-match  "^(?!a)\{0}\\w+"
~["aaaaa"]
~
::
:^  %has-match  "(?<=(abc))?xyz"
~["abcxyz" "pqrxyz"]
~
::
:^  %has-match  "^[\\g<a>]+"
~["ggg<<<aaa>>>"]
~["\\ga"]
::
:^  %has-match  "^[\\ga]+"
~["gggagagaxyz"]
~
::
:^  %has-match  "^[:a[:digit:]]+"
~["aaaa444:::Z"]
~
::
:^  %has-match  "^[:a[:digit:]:b]+"
~["aaaa444:::bbbZ"]
~
::
:^  %has-match  "[:a]xxx[b:]"
~[":xxx:"]
~
::
:^  %has-match  "(?<=a\{2})b"
~["xaabc"]
~["xabc"]
::
:^  %has-match  "(?<!a\{2})b"
~["xabc"]
~["xaabc"]
::
:^  %has-match  "(?<=a\\h)c"
~["xa c"]
~
::
:^  %has-match  "(?<=[^a]\{2})b"
~["axxbc" "aAAbc"]
~["xaabc"]
::
:^  %has-match  "(?<=[^a]\{2})b"
~["axxbc"]
~["aAAbc" "xaabc"]
::
:^  %has-match  "(?<=a\\H)c"
~["abc"]
~
::
:^  %has-match  "(?<=a\\V)c"
~["abc"]
~
::
:^  %has-match  "(?<=a\\v)c"
~["a\0ac"]
~
::
:^  %has-match  "^(a\{2,3})\{2,}+a"
~["aaaaaaa"]
~["aaaaaa" "aaaaaaaaa"]
::
:^  %has-match  "^(a\{2,3})++a"
~
~["aaaaaa"]
::
:^  %has-match  "^(a\{2,3})*+a"
~
~["aaaaaa"]
::
:^  %has-match  "ab\\Cde"
~["abXde"]
~
::
:^  %has-match  "(?<=ab\\Cde)X"
~["abZdeX"]
~
::
:^  %has-match  "a[\\CD]b"
~["aCb" "aDb"]
~
::
:^  %has-match  "a[\\C-X]b"
~["aJb"]
~
::
:^  %has-match  "\\H\\h\\V\\v"
~["X Xx0a" "Xx09Xx0b"]
~["xa0 Xx0a"]
::
:^  %has-match  "\\H*\\h+\\V?\\v\{3,4}"
~["x09x20xa0Xx0ax0bx0cx0dx0a" "x09x20xa0x0ax0bx0cx0dx0a" "x09x20xa0x0ax0bx0c"]
~["x09x20xa0x0ax0b"]
::
:^  %has-match  "\\H\{3,4}"
~["XY  ABCDE" "XY  PQR ST"]
~
::
:^  %has-match  ".\\h\{3,4}."
~["XY  AB    PQRS"]
~
::
:^  %has-match  "\\h*X\\h?\\H+Y\\H?Z"
~[">XNNNYZ" ">  X NYQZ"]
~[">XYZ" ">  X NY Z"]
::
:^  %has-match  "\\v*X\\v?Y\\v+Z\\V*\\x0a\\V+\\x0b\\V\{2,3}\\x0c"
~[">XYx0aZx0aAx0bNNx0c" ">x0ax0dXx0aYx0ax0bZZZx0aAAAx0bNNNx0c"]
~
::
:^  %has-match  "^(a(b))\\1\\g1\\g\{1}\\g-1\\g\{-1}\\g\{-02}Z"
~["ababababbbabZXXXX"]
~
::
:^  %has-match  "(?<A>tom|bon)-\\g\{A}"
~["tom-tom" "bon-bon"]
~
::
:^  %has-match  "(^(a|b\\g\{-1}))"
~["bacxxx"]
~
::
:^  %has-match  "^(a.)\\g-1Z"
~["aXaXZ"]
~
::
:^  %has-match  "^(a.)\\g\{-1}Z"
~["aXaXZ"]
~
::
:^  %has-match  "^(\\w++|\\s++)*$"
~["now is the time for all good men to come to the aid of the party"]
~["this is not a line with only words and spaces!"]
::
:^  %has-match  "a++b"
~["aaab"]
~
::
:^  %has-match  "(a++b)"
~["aaab"]
~
::
:^  %has-match  "(a++)b"
~["aaab"]
~
::
:^  %has-match  "([^()]++|\\([^()]*\\))+"
~["((abc(ade)ufh()()x"]
~
::
:^  %has-match  "\\(([^()]++|\\([^()]+\\))+\\)"
~["(abc)" "(abc(def)xyz)"]
~["((()aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"]
::
:^  %has-match  "^(a)*+(\\w)"
~["aaaaX" "YZ"]
~["aaaa"]
::
:^  %has-match  "^(a)++(\\w)"
~["aaaaX"]
~["aaaa" "YZ"]
::
:^  %has-match  "^(a)?+(\\w)"
~["aaaaX" "YZ"]
~
::
:^  %has-match  "^(a)\{2,}+(\\w)"
~["aaaaX"]
~["aaa" "YZ"]
::
:^  %has-match  "\\A.*?(a|bc)"
~["ba"]
~
::
:^  %has-match  "\\A.*?(a|bc)++"
~["ba"]
~
::
:^  %has-match  "^\\N+"
~["abc\0adef"]
~
::
:^  %has-match  "^\\N\{1,}"
~["abc\0adef"]
~
::
:^  %has-match  "(another)?(\\1?)test"
~["hello world test"]
~
::
:^  %has-match  "(another)?(\\1+)test"
~["hello world test"]
~
::
:^  %has-match  "a(?=bc).|abd"
~["abd" "abc"]
~
::
:^  %has-match  "^[^b]*\\w\{4}"
~["aaaa" "aaa"]
~
::
:^  %has-match  "^[^b]*\\w\{4}"
~["aaaa" "aaa"]
~
::
:^  %has-match  "^a*\\w\{4}"
~["aaaa" "aaa"]
~
::
:^  %has-match  "^a*\\w\{4}"
~["aaaa" "aaa"]
~
::
:^  %has-match  "^A\\xZ"
~["A0Z"]
~
::
:^  %has-match  "^A\\o\{123}B"
~["A123B"]
~
::
:^  %has-match  "\\sabc"
~["x\{0b}abc"]
~
::
==
