:~
:^  %has-match  "the quick brown fox"
~["the quick brown fox" "What do you know about the quick brown fox?"]
~["The quick brown FOX" "What do you know about THE QUICK BROWN FOX?"]
::
:^  %has-match  "abcd\\t\\n\\r\\f\\a\\e\\x39\\x3b\\$\\\\\\?caxyz"
~["abcd\09\0a\0d\0c\07\1b9;\\$\\?caxyz"]
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
:::^  %has-match  "^(b+?|a)\{1,2}?c"  todo
::~["bc" "bbc" "bbbc" "bac" "bbac" "aac" "abbbbbbbbbbbc" "bbbbbbbbbbbac"]
::~["aaac" "abbbbbbbbbbbac"]
::
:^  %has-match  "^(b+|a)\{1,2}c"
~["bc" "bbc" "bbbc" "bac" "bbac" "aac" "abbbbbbbbbbbc" "bbbbbbbbbbbac"]
~["aaac" "abbbbbbbbbbbac"]
::
:::^  %has-match  "^(b+|a)\{1,2}?bc"  todo
::~["bbc"]
::~
::::
:::^  %has-match  "^(b*|ba)\{1,2}?bc"
::~["babc" "bbabc" "bababc"]
::~["bababbc" "babababc"]
::::
:::^  %has-match  "^(ba|b*)\{1,2}?bc"
::~["babc" "bbabc" "bababc"]
::~["bababbc" "babababc"]
::::
:::^  %has-match  "^\\ca\\ca\\c[;\\c:"
::~["\01\01\1b;z"]
::~
::
:^  %has-match  "^[ab\\]cde]"
~["athing" "bthing" "]thing" "cthing" "dthing" "ething"]
~["fthing" "[thing" "\\09hing"]
::
:^  %has-match  "^[]cde]"
~["]thing" "cthing" "dthing" "ething"]
~["athing" "fthing"]
::
:^  %has-match  "^[^ab\\]cde]"
~["fthing" "[thing" "\\09hing"]
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
:::^  %has-match  "^.+[0-9][0-9][0-9]$"  todo
::~["x123" "xx123" "123456"]
::~["123" "x1234"]
::::
:::^  %has-match  "^.+?[0-9][0-9][0-9]$"
::~["x123" "xx123" "123456"]
::~["123" "x1234"]
::
:^  %has-match  "^([^!]+)!(.+)=apquxz\\.ixr\\.zzz\\.ac\\.uk$"
~["abc!pqr=apquxz.ixr.zzz.ac.uk"]
~["!pqr=apquxz.ixr.zzz.ac.uk" "abc!=apquxz.ixr.zzz.ac.uk" "abc!pqr=apquxz:ixr.zzz.ac.uk" "abc!pqr=apquxz.ixr.zzz.ac.ukk"]
::
:^  %has-match  ":"
~["Well, we need a colon: somewhere"]
~["*** Fail if we don't"]
::
:^  %has-match  "([\\da-f:]+)$/"
~["0abc" "abc" "fed" "E" "::" "5f03:12C0::932e" "fed def" "Any old stuff"]
~["0zzz" "gzzz" "fed\10" "Any old rubbish"]
::
:^  %has-match  "^.*\\.(\\d\{1,3})\\.(\\d\{1,3})\\.(\\d\{1,3})$"
~[".1.2.3" "A.12.123.0"]
~[".1.2.3333" "1.2.3" "1234.2.3"]
::
:^  %has-match  "^(\\d+)\\s+IN\\s+SOA\\s+(\\S+)\\s+(\\S+)\\s*\\(\\s*$"
~["1 IN SOA non-sp1 non-sp2(" "1    IN    SOA    non-sp1    non-sp2   ("]
~["1IN SOA non-sp1 non-sp2("]
::
:^  %has-match  "^[a-zA-Z\\d][a-zA-Z\\d\\-]*(\\.[a-zA-Z\\d][a-zA-z\\d\\-]*)*\\.$"
~["a." "Z." "2." "ab-c.pq-r." "sxk.zzz.ac.uk." "x-.y-."]
~["-abc.peq."]
::
:^  %has-match  "^\\*\\.[a-z]([a-z\\-\\d]*[a-z\\d]+)?(\\.[a-z]([a-z\\-\\d]*[a-z\\d]+)?)*$"
~["*.a" "*.b0-a" "*.c3-b.c" "*.c-a.b-c"]
~["*.0" "*.a-" "*.a-b.c-" "*.c-a.0-c"]
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
:^  %has-match  "^(a(b(c)))(d(e(f)))(h(i(j)))(k(l(m)))$"
~["abcdefhijklm"]
~
::
:^  %has-match  "^(?:a(b(c)))(?:d(e(f)))(?:h(i(j)))(?:k(l(m)))$"
~["abcdefhijklm"]
~
::
:^  %has-match  "^[\\w][\\W][\\s][\\S][\\d][\\D][\\b][\\n][\\c]][\\12]"
~["a+ Z0+\008\0a\01d\0a"]
~
::
:^  %has-match  "^[.^$|()*+?\{,}]+"
~[".^\\$(*+)|\{?,?}"]
~
::
:^  %has-match  "^a*\\w"
~["z" "az" "aaaz" "a" "aa" "aaaa" "a+" "aa+"]
~
::
:::^  %has-match  "^a*?\\w"  todo
::~["z" "az" "aaaz" "a" "aa" "aaaa" "a+" "aa+"]
::~
::
:^  %has-match  "^a+\\w"
~["az" "aaaz" "aa" "aaaa" "aa+"]
~
::
:::^  %has-match  "^a+?\\w"  todo
::~["az" "aaaz" "aa" "aaaa" "aa+"]
::~
::
:^  %has-match  "^\\d\{8}\\w\{2,}"
~["1234567890" "12345678ab" "12345678__"]
~["1234567"]
::
:^  %has-match  "^[aeiou\\d]\{4,5}$"
~["uoie" "1234" "12345" "aaaaa"]
~["123456"]
::
:::^  %has-match  "^[aeiou\\d]\{4,5}?"  todo
::~["uoie" "1234" "12345" "aaaaa" "123456"]
::~
::
:^  %has-match  "\\A(abc|def)=(\\01)\{2,3}\\Z"
~["abc=abcabc" "def=defdefdef"]
~["abc=defdef"]
::
:^  %has-match  "^(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)(k)\\09*(\\03\\04)\\01(?#)2$"
~["abcdefghijkcda2" "abcdefghijkkkkcda2"]
~
::
:^  %has-match  "(cat(a(ract|tonic)|erpillar)) \\01()2(3)"
~["cataract cataract23" "catatonic catatonic23" "caterpillar caterpillar23"]
~
:^  %has-match  "(cat(a(ract|tonic)|erpillar)) \\01()2(3)"
~["cataract cataract23" "catatonic catatonic23" "caterpillar caterpillar23"]
~
::
:^  %has-match  "^From +([^ ]+) +[a-zA-Z][a-zA-Z][a-zA-Z] +[a-zA-Z][a-zA-Z][a-zA-Z] +[0-9]?[0-9] +[0-9][0-9]:[0-9][0-9]"
~["From abcd  Mon Sep 01 12:33:02 1997"]
~
::
:^  %has-match  "^From\\s+\\S+\\s+([a-zA-Z]\{3}\\s+)\{2}\\d\{1,2}\\s+\\d\\d:\\d\\d"
~["From abcd  Mon Sep 01 12:33:02 1997" "From abcd  Mon Sep  1 12:33:02 1997"]
~["From abcd  Sep 01 12:33:02 1997"]
::
:^  %has-match  "^12.34"
~["12\0a34" "12\0d34"]
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
:^  %has-match  "(?:(?!foo)...|^.\{0,2})bar(.*)"
~["foobar crowbar etc" "barrel" "2barrel" "A barrel"]
~
::
:^  %has-match  "^(\\D*)(?=\\d)(?!123)"
~["abc456"]
~["abc123"]
::
:^  %has-match  "^1234(?# test newlines"
~
~
::
:^  %has-match  "^1234 #comment in extended re"
~
~
::
:^  %has-match  "#rhubarb"
~
~
::
:^  %has-match  "^abcd#rhubarb/"
~["abcd"]
~
::
:^  %has-match  "^(a)\\01\{2,3}(.)"
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
:::^  %has-match  "^[ab]\{1,3}?(ab*|b)"  todo
::~["aabbbbb"]
::~
::::
:::^  %has-match  "^[ab]\{1,3}?(ab*?|b)"
::~["aabbbbb"]
::~
::::
:::^  %has-match  "^[ab]\{1,3}(ab*?|b)"
::~["aabbbbb"]
::~
::
:^  %has-match  "abc\\00def\\00pqr\\00xyz\\000AB"
~["abc\00def\00pqr\00xyz\000AB" "abc456 abc\00def\00pqr\00xyz\000ABCDE"]
~
::
:^  %has-match  "abc\\00def\\00pqr\\00xyz\\000AB"
~["abc\00def\00pqr\00xyz\000AB" "abc456 abc\00def\00pqr\00xyz\000ABCDE"]
~
::
:^  %has-match  "^[\\00-\\1f]"
~["\00A" "\01B" "\1fC"]
~
::
:^  %has-match  "\\00*"
~["\00\00\00\00"]
~
::
:^  %has-match  "A\\00\{2,3}Z"
~["The A\00\00Z" "An A\00\00\00Z"]
~["A\00Z" "A\00\00\00\00Z"]
::
:^  %has-match  "^(cow|)\\01(bell)"
~["cowcowbell" "bell"]
~["cowbell"]
::
:^  %has-match  "^\\s"
~["\20abc" "\00cabc" "\0aabc" "\0dabc" "\09abc"]
~["abc"]
::
:^  %has-match  "^a\09b"
~
~
::
:^  %has-match  "^(a|)\\01*b"
~["ab" "aaaab" "b"]
~["acb"]
::
:^  %has-match  "^(a|)\\01+b"
~["aab" "aaaab" "b"]
~["ab"]
::
:^  %has-match  "^(a|)\\01?b"
~["ab" "aab" "b"]
~["acb"]
::
:^  %has-match  "^(a|)\\01\{2}b"
~["aaab" "b"]
~["ab" "aab" "aaaab"]
::
:^  %has-match  "^(a|)\\01\{2,3}b"
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
:^  %has-match  "([^.]*)\\.([^:]*):[T ]+(.*)/"
~["track1.title:TBlah blah blah"]
~
::
:^  %has-match  "([^.]*)\\.([^:]*):[t ]+(.*)/"
~["track1.title:TBlah blah blah"]
~
::
:^  %has-match  "^[W-c]+$"
~["WXY_^abc"]
~["wxy"]
::
:^  %has-match  "^[W-c]+$/"
~["WXY_^abc" "wxy_^ABC"]
~
::
:^  %has-match  "^[\\03f-\\05F]+$/"
~["WXY_^abc" "wxy_^ABC"]
~
::
:^  %has-match  "^abc$/"
~["abc" "qqq\0aabc" "abc\0azzz" "qqq\0aabc\0azzz"]
~
::
:^  %has-match  "^abc$"
~["abc"]
~["qqq\0aabc" "abc\0azzz" "qqq\0aabc\0azzz"]
::
::
:^  %has-match  "\\A(.)*\\Z/"
~["abc\0adef"]
~
::
:^  %has-match  "\\A(.)*\\Z/"
~
~["abc\0adef"]
::
:^  %has-match  "(?:b)|(?::+)"
~["b::c" "c::b"]
~
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
:^  %has-match  "[\\d-]+"
~["12-34"]
~["aaa"]
::
:^  %has-match  "[\\d-z]+"
~["12-34z"]
~["aaa"]
::
:^  %has-match  "\\05c"
~["\\"]
~
::
:^  %has-match  "\\10Z"
~["the Zoo"]
~["Zulu"]
::
:^  %has-match  "(abc)\\01/"
~["abcabc" "ABCabc" "abcABC"]
~
::
:^  %has-match  "ab\\\{3cd"
~["ab\{3cd"]
~
::
:^  %has-match  "ab\\\{3,cd"
~["ab\{3,cd"]
~
::
:^  %has-match  "ab\\\{3,4a}cd"
~["ab\{3,4a}cd"]
~
::
:^  %has-match  "\\\{4,5a}bc"
~["\{4,5a}bc"]
~
::
:^  %has-match  "abc$"
~["abc" "abc\0a"]
~["abc\0adef"]
::
:::^  %has-match  "(abc)\\53"
::~["abc\2b"]
::~
::
:::^  %has-match  "(abc)\\d3"
::~["abc\d3"]
::~
::
:^  %has-match  "^(A)(B)(C)(D)(E)(F)(G)(H)(I)\\8\\9$"
~["ABCDEFGHIHI"]
~
::
:::^  %has-match  "^[A\\8b\\9c]+$"
::~["A8B9C"]
::~["A8B9C\00"]
::
:^  %has-match  "(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)(k)(l)\\0a\\53"
~["abcdefghijkllS"]
~
::
:^  %has-match  "(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)(k)\\0a\\53"
~["abcdefghijk\0aS"]
~
::
:^  %has-match  "ab\\idef"
~["abidef"]
~
::
:^  %has-match  "a\{0}bc"
~["bc"]
~
::
:::^  %has-match  "(a|(bc))\{0,0}?xyz"  todo
::~["xyz"]
::~
::
:^  %has-match  "abc[\\08]de"
~["abc\08de"]
~
::
:^  %has-match  "abc[\\01]de"
~["abc\01de"]
~
::
:^  %has-match  "(abc)[\\01]de"
~["abc\01de"]
~
::
:^  %has-match  "(?s)a.b"
~["a\0ab"]
~
::
:^  %has-match  "^([^a])([^\\b])([^c]*)([^d]\{3,4})"
~["baNOTccccd" "baNOTcccd" "baNOTccd" "bacccd"]
~["anything" "b\08c   " "baccd"]
::
::
:^  %has-match  "[^a]/"
~["Abc "]
~
::
::
:^  %has-match  "[^a]+/"
~["AAAaAbc "]
~
::
::
::
:^  %has-match  "[^k]\{2,3}$"
~["abc" "kbc" "kabc"]
~["abk" "akb" "akk"]
::
:^  %has-match  "^\\d\{8,}\\@.+[^k]$"
~["12345678@a.b.c.d" "123456789@x.y.z"]
~["12345678@x.y.uk" "1234567@a.b.c.d       "]
::
:^  %has-match  "(a)\\01\{8,}"
~["aaaaaaaaa" "aaaaaaaaaa"]
~["aaaaaaa"]
::
:^  %has-match  "[^a]"
~["aaaabcd" "aaAabcd "]
~
::
:^  %has-match  "\\00\\01\\02\\03\\04\\05\\06\\07\\08\\09\\0a\\0b\\0c\\0d\\0e\\0f\\10\\11\\12\\13\\14\\15\\16\\17\\18\\19\\1a\\1b\\1c\\1d\\1e\\1f\\20\\21\\22\\23\\24\\25\\26\\27\\28\\29\\2a\\2b\\2c\\2d\\2e\\2f\\30\\31\\32\\33\\34\\35\\36\\37\\38\\39\\3a\\3b\\3c\\3d\\3e\\3f\\40\\41\\42\\43\\44\\45\\46\\47\\48\\49\\4a\\4b\\4c\\4d\\4e\\4f\\50\\51\\52\\53\\54\\55\\56\\57\\58\\59\\5a\\5b\\5c\\5d\\5e\\5f\\60\\61\\62\\63\\64\\65\\66\\67\\68\\69\\6a\\6b\\6c\\6d\\6e\\6f\\70\\71\\72\\73\\74\\75\\76\\77\\78\\79\\7a\\7b\\7c\\7d\\7e\\7f\\80\\81\\82\\83\\84\\85\\86\\87\\88\\89\\8a\\8b\\8c\\8d\\8e\\8f\\90\\91\\92\\93\\94\\95\\96\\97\\98\\99\\9a\\9b\\9c\\9d\\9e\\9f\\a0\\a1\\a2\\a3\\a4\\a5\\a6\\a7\\a8\\a9\\aa\\ab\\ac\\ad\\ae\\af\\b0\\b1\\b2\\b3\\b4\\b5\\b6\\b7\\b8\\b9\\ba\\bb\\bc\\bd\\be\\bf\\c0\\c1\\c2\\c3\\c4\\c5\\c6\\c7\\c8\\c9\\ca\\cb\\cc\\cd\\ce\\cf\\d0\\d1\\d2\\d3\\d4\\d5\\d6\\d7\\d8\\d9\\da\\db\\dc\\dd\\de\\df\\e0\\e1\\e2\\e3\\e4\\e5\\e6\\e7\\e8\\e9\\ea\\eb\\ec\\ed\\ee\\ef\\f0\\f1\\f2\\f3\\f4\\f5\\f6\\f7\\f8\\f9\\fa\\fb\\fc\\fd\\fe\\ff"
~["\00\01\02\03\04\05\06\07\08\09\0a\0b\0c\0d\0e\0f\10\11\12\13\14\15\16\17\18\19\1a\1b\1c\1d\1e\1f\20\21\22\23\24\25\26\27\28\29\2a\2b\2c\2d\2e\2f\30\31\32\33\34\35\36\37\38\39\3a\3b\3c\3d\3e\3f\40\41\42\43\44\45\46\47\48\49\4a\4b\4c\4d\4e\4f\50\51\52\53\54\55\56\57\58\59\5a\5b\5c\5d\5e\5f\60\61\62\63\64\65\66\67\68\69\6a\6b\6c\6d\6e\6f\70\71\72\73\74\75\76\77\78\79\7a\7b\7c\7d\7e\7f\80\81\82\83\84\85\86\87\88\89\8a\8b\8c\8d\8e\8f\90\91\92\93\94\95\96\97\98\99\9a\9b\9c\9d\9e\9f\070\071\072\073\074\075\076\077\078\079\07a\07b\07c\07d\07e\07f\b0\b1\b2\b3\b4\b5\b6\b7\b8\b9\ba\bb\bc\bd\be\bf\c0\c1\c2\c3\c4\c5\c6\c7\c8\c9\ca\cb\cc\cd\ce\cf\d0\d1\d2\d3\d4\d5\d6\d7\d8\d9\da\db\dc\dd\de\df\1b0\1b1\1b2\1b3\1b4\1b5\1b6\1b7\1b8\1b9\1ba\1bb\1bc\1bd\1be\1bf\0c0\0c1\0c2\0c3\0c4\0c5\0c6\0c7\0c8\0c9\0ca\0cb\0cc\0cd\0ce\0cf"]
~
::
:::^  %has-match  "P[^*]TAIRE[^*]\{1,6}?LL"
::~["xxxxxxxxxxxPSTAIREISLLxxxxxxxxx"]
::~
::::
:::^  %has-match  "P[^*]TAIRE[^*]\{1,}?LL"
::~["xxxxxxxxxxxPSTAIREISLLxxxxxxxxx"]
::~
::::
:::^  %has-match  "foo(.*?)bar/  "
::~
::~
::::
:::^  %has-match  "(.*?)(\\d*)"
::~["I have 2 numbers: 53147"]
::~
::::
:::^  %has-match  "(.*?)(\\d+)"
::~["I have 2 numbers: 53147"]
::~
::::
:::^  %has-match  "(.*)(\\d+)$"
::~["I have 2 numbers: 53147"]
::~
::::
:::^  %has-match  "(.*?)(\\d+)$"
::~["I have 2 numbers: 53147"]
::~
::::
:::^  %has-match  "(.*)\\b(\\d+)$"
::~["I have 2 numbers: 53147"]
::~
::::
:::^  %has-match  "(.*\\D)(\\d+)$"
::~["I have 2 numbers: 53147"]
::~
::::
::::
::::
::::
::::
:::^  %has-match  "\\d\\d\\/\\d\\d\\/\\d\\d\\d\\d"
::~["01/01/2000"]
::~
::::
:::^  %has-match  "word (?:[a-zA-Z0-9]+ )\{0,10}otherword"
::~["word cat dog elephant mussel cow horse canary baboon snake shark otherword" "word cat dog elephant mussel cow horse canary baboon snake shark"]
::~
::::
:::^  %has-match  "word (?:[a-zA-Z0-9]+ )\{0,300}otherword"
::~["word cat dog elephant mussel cow horse canary baboon snake shark the quick brown fox and the lazy dog and several other words getting close to thirty by now I hope"]
::~
::::
:::^  %has-match  "^(a)\{0,0}"
::~["bcd" "abc" "aab     "]
::~
::::
:::^  %has-match  "^(a)\{0,1}"
::~["bcd" "abc" "aab  "]
::~
::::
:::^  %has-match  "^(a)\{0,2}"
::~["bcd" "abc" "aab  "]
::~
::::
:::^  %has-match  "^(a)\{0,3}"
::~["bcd" "abc" "aab" "aaa   "]
::~
::::
:::^  %has-match  "^(a)\{0,}"
::~["bcd" "abc" "aab" "aaa" "aaaaaaaa    "]
::~
::::
:::^  %has-match  "^(a)\{1,1}"
::~["bcd" "abc" "aab  "]
::~
::::
:::^  %has-match  "^(a)\{1,2}"
::~["bcd" "abc" "aab  "]
::~
::::
:::^  %has-match  "^(a)\{1,3}"
::~["bcd" "abc" "aab" "aaa   "]
::~
::::
:::^  %has-match  "^(a)\{1,}"
::~["bcd" "abc" "aab" "aaa" "aaaaaaaa    "]
::~
::::
:::^  %has-match  ".*\\.gif"
::~["borfle\0abib.gif\0ano"]
::~
::::
:::^  %has-match  ".\{0,}\\.gif"
::~["borfle\0abib.gif\0ano"]
::~
::::
:::^  %has-match  ".*\\.gif"
::~["borfle\0abib.gif\0ano"]
::~
::::
:::^  %has-match  ".*\\.gif"
::~["borfle\0abib.gif\0ano"]
::~
::::
::::
:::^  %has-match  ".*$"
::~["borfle\0abib.gif\0ano"]
::~
::::
:::^  %has-match  "(.*X|^B)"
::~["abcde\0a1234Xyz" "BarFoo" "abcde\0aBar"]
::~
::::
:::^  %has-match  "^\\d\\d\\d\\d\\d\\d\\d\\d\\d\\d\\d\\d"
::~["123456654321"]
::~
::::
:::^  %has-match  "^(a|b|c)\{12}"
::~["abcabcabcabc "]
::~
::::
:::^  %has-match  "^[abcdefghijklmnopqrstuvwxy0123456789]"
::~["n"]
::~["z"]
::::
:::^  %has-match  "abcde\{0,0}"
::~["abcd"]
::~["abce"]
::::
::::
:::^  %has-match  "ab(c)\{0,0}d"
::~["abd"]
::~["abcd"]
::::
::::
::::
:::^  %has-match  "\"([^\\\\\"]+|\\\\.)*\""
::~["the \"quick\" brown fox" "\"the \\\"quick\\\" brown fox\" "]
::~
::::
:::^  %has-match  ""
::~["abc"]
::~
::::
:::::^  %has-match  "<tr([\\w\\W\\s\\d][^<>]\{0,})><TD([\\w\\W\\s\\d][^<>]\{0,})>([\\d]\{0,}\\.)(.*)((<BR>([\\w\\W\\s\\d][^<>]\{0,})|[\\s]\{0,}))<\\/a><\\/TD><TD([\\w\\W\\s\\d][^<>]\{0,})>([\\w\\W\\s\\d][^<>]\{0,})<\\/TD><TD([\\w\\W\\s\\d][^<>]\{0,})>([\\w\\W\\s\\d][^<>]\{0,})<\\/TD><\\/TR>"
::::~["<TR BGCOLOR='#DBE9E9'><TD align=left valign=top>43.<a href='joblist.cfm?JobID=94 6735&Keyword='>Word Processor<BR>(N-1286)</a></TD><TD align=left valign=top>Lega lstaff.com</TD><TD align=left valign=top>CA - Statewide</TD></TR>"]
::::~
::::::
:::::^  %has-match  "a.b"
::::~["acb" "a\0ab"]
::::~
::::::
:::::^  %has-match  "^(b+?|a)\{1,2}?c"
::::~["bac" "bbac" "bbbac" "bbbbac" "bbbbbac "]
::::~
::::::
:::::^  %has-match  "\\00\{ab}"
::::~["\00\{ab} "]
::::~
::::
:::^  %has-match  "(A|B)*CD"
::~["CD "]
::~
::::
:::^  %has-match  "(AB)*?\\01"
::~["ABABAB"]
::~
::::
:::^  %has-match  "(?<!bar)foo"
::~["foo" "catfood" "arfootle" "rfoosh"]
::~["barfoo" "towbarfoo"]
::::
:::^  %has-match  "\\w\{3}(?<!bar)foo"
::~["catfood"]
::~["foo" "barfoo" "towbarfoo"]
::::
:::^  %has-match  "\\Aabc\\z/"
::~["abc"]
::~["abc\0a   " "qqq\0aabc" "abc\0azzz" "qqq\0aabc\0azzz"]
::::
:::^  %has-match  "(?>.*/)foo"
::~["/this/is/a/very/long/line/in/deed/with/very/many/slashes/in/and/foo"]
::~["/this/is/a/very/long/line/in/deed/with/very/many/slashes/in/it/you/see/"]
::::
:::^  %has-match  "(?>(\\.\\d\\d[1-9]?))\\d+"
::~["1.230003938" "1.875000282"]
::~["1.235 "]
::::
::::
:::^  %has-match  "(\\d+)(\\w)"
::~["12345a" "12345+ "]
::~
::
:::^  %has-match  "((?>\\d+))(\\w)"
::~["12345a"]
::~["12345+ "]
::::
:::^  %has-match  "(?>a+)b"
::~["aaab"]
::~
::::
:::^  %has-match  "((?>a+)b)"
::~["aaab"]
::~
::::
:::^  %has-match  "(?>(a+))b"
::~["aaab"]
::~
::::
:::^  %has-match  "(?>b)+"
::~["aaabbbccc"]
::~
::::
:::^  %has-match  "(?>a+|b+|c+)*c"
::~["aaabbbbccccd"]
::~
::::
::::
:::^  %has-match  "\\(((?>[^()]+)|\\([^()]+\\))+\\)/ "
::~
::~["((()aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa   "]
::::
::::
::::
:::^  %has-match  "(a b(?x)c d (?-x)e f)"
::~["a bcde f"]
::~["abcdef  "]
::::
::::
::::
::::
::::
:::^  %has-match  "(?s-i:more.*than).*million/"
::~["more than million" "more than MILLION" "more \0a than Million "]
::~["MORE THAN MILLION    " "more \0a than \0a million "]
::::
::::
::::
::::
:::^  %has-match  "(?<=a(?i)b)(\\w\\w)c"
::~["abxxc" "aBxxc"]
::~["Abxxc" "ABxxc" "abxxC      "]
::::
:::^  %has-match  "(?:(a)|b)(?(1)A|B)"
::~["aA" "bB"]
::~["aB" "bA    "]
::::
:::^  %has-match  "^(a)?(?(1)a|b)+$"
::~["aa" "b" "bb  "]
::~["ab   "]
::::
:::^  %has-match  "^(?(?=abc)\\w\{3}:|\\d\\d)$"
::~["abc:" "12"]
::~["123" "xyz    "]
::::
::::
:::^  %has-match  "(?(?<=foo)bar|cat)"
::~["foobar" "cat" "fcat" "focat   "]
::~["foocat  "]
::::
:::^  %has-match  "(?(?<!foo)cat|bar)"
::~["foobar" "cat" "fcat" "focat   "]
::~["foocat  "]
::::
:::^  %has-match  "( \\( )? [^()]+ (?(1) \\) |) /"
::~["abcd" "(abcd)" "the quick (abcd) fox" "(abcd   "]
::~
::::
:::^  %has-match  "( \\( )? [^()]+ (?(1) \\) ) /"
::~["abcd" "(abcd)" "the quick (abcd) fox" "(abcd   "]
::~
::::
:::^  %has-match  "^(?(2)a|(1)(2))+$"
::~["12" "12a" "12aa"]
::~["1234    "]
::::
:::^  %has-match  "((?i)blah)\\s+\\01"
::~["blah blah" "BLAH BLAH" "Blah Blah" "blaH blaH"]
::~["blah BLAH" "Blah blah      " "blaH blah "]
::::
:::^  %has-match  "((?i)blah)\\s+(?i:\\01)"
::~["blah blah" "BLAH BLAH" "Blah Blah" "blaH blaH" "blah BLAH" "Blah blah      " "blaH blah "]
::~
::::
::::
:::^  %has-match  "(abc|)+"
::~["abc" "abcabc" "abcabcabc" "xyz      "]
::~
::::
::::
::::
::::
::::
::::
::::
::::
::::
::::
::::
:::^  %has-match  "((?>a*?))*"
::~["aaaaa" "aabbaa "]
::~
::::
::::
:::^  %has-match  "(?<=(foo))bar\\01"
::~["foobarfoo" "foobarfootling "]
::~["foobar" "barfoo   "]
::::
::::
:::^  %has-match  "(a(?i)bc|BB)x"
::~["abcx" "aBCx" "bbx" "BBx"]
::~["abcX" "aBCX" "bbX" "BBX               "]
::::
:::^  %has-match  "^([ab](?i)[cd]|[ef])"
::~["ac" "aC" "bD" "elephant" "Europe " "frog" "France"]
::~["Africa     "]
::::
:::^  %has-match  "^(ab|a(?i)[b-c](?m-i)d|x(?i)y|z)"
::~["ab" "aBd" "xy" "xY" "zebra" "Zambesi"]
::~["aCD  " "XY  "]
::::
:::^  %has-match  "(?<=foo\\n)^bar/"
::~["foo\0abar"]
::~["bar" "baz\0abar   "]
::::
:::^  %has-match  "(?<=(?<!foo)bar)baz"
::~["barbaz" "barbarbaz " "koobarbaz "]
::~["baz" "foobarbaz "]
::::
::::
::::
:::^  %has-match  "recursive references in Perl, as far as 5.11.3 - see some stuff in test #2."
::~
::~
::::
:::^  %has-match  "^(a\\01?)\{4}$"
::~["a" "aa" "aaa" "aaaaa" "aaaaaaa" "aaaaaaaa" "aaaaaaaaa" "aaaaaaaaaa" "aaaaaaaaaaa" "aaaaaaaaaaaa" "aaaaaaaaaaaaa" "aaaaaaaaaaaaaa" "aaaaaaaaaaaaaaa" "aaaaaaaaaaaaaaaa               "]
::~
::::
:::^  %has-match  "^(a\\01?)(a\\01?)(a\\02?)(a\\03?)$"
::~["a" "aa" "aaa" "aaaa" "aaaaa" "aaaaaa" "aaaaaaa" "aaaaaaaa" "aaaaaaaaa" "aaaaaaaaaa" "aaaaaaaaaaa" "aaaaaaaaaaaa" "aaaaaaaaaaaaa" "aaaaaaaaaaaaaa" "aaaaaaaaaaaaaaa" "aaaaaaaaaaaaaaaa               "]
::~
::::
::::
:::^  %has-match  "are compatible with 5.004, but I'd rather not have to sort them out."
::~
::~
::::
:::^  %has-match  "abc"
::~["abc" "xabcy" "ababc"]
::~["xbc" "axc" "abx"]
::::
:::^  %has-match  "ab*c"
::~["abc"]
::~
::::
:::^  %has-match  "ab*bc"
::~["abc" "abbc" "abbbbc"]
::~
::::
:::^  %has-match  ".\{1}"
::~["abbbbc"]
::~
::::
:::^  %has-match  ".\{3,4}"
::~["abbbbc"]
::~
::::
:::^  %has-match  "ab\{0,}bc"
::~["abbbbc"]
::~
::::
:::^  %has-match  "ab+bc"
::~["abbc"]
::~["abc" "abq"]
::::
:::^  %has-match  "ab\{1,}bc"
::~
::~
::::
:::^  %has-match  "ab+bc"
::~["abbbbc"]
::~
::::
:::^  %has-match  "ab\{1,}bc"
::~["abbbbc"]
::~
::::
:::^  %has-match  "ab\{1,3}bc"
::~["abbbbc"]
::~
::::
:::^  %has-match  "ab\{3,4}bc"
::~["abbbbc"]
::~
::::
:::^  %has-match  "ab\{4,5}bc"
::~
::~["abq" "abbbbc"]
::::
:::^  %has-match  "ab?bc"
::~["abbc" "abc"]
::~
::::
:::^  %has-match  "ab\{0,1}bc"
::~["abc"]
::~
::::
:::^  %has-match  "ab?bc"
::~
::~
::::
:::^  %has-match  "ab?c"
::~["abc"]
::~
::::
:::^  %has-match  "ab\{0,1}c"
::~["abc"]
::~
::::
:::^  %has-match  "^abc$"
::~["abc"]
::~["abbbbc" "abcc"]
::::
:::^  %has-match  "^abc"
::~["abcc"]
::~
::::
:::^  %has-match  "^abc$"
::~
::~
::::
:::^  %has-match  "abc$"
::~["aabc"]
::~["aabc" "aabcd"]
::::
:::^  %has-match  "^"
::~["abc"]
::~
::::
:::^  %has-match  "$"
::~["abc"]
::~
::::
:::^  %has-match  "a.c"
::~["abc" "axc"]
::~
::::
:::^  %has-match  "a.*c"
::~["axyzc"]
::~
::::
:::^  %has-match  "a[bc]d"
::~["abd"]
::~["axyzd" "abc"]
::::
:::^  %has-match  "a[b-d]e"
::~["ace"]
::~
::::
:::^  %has-match  "a[b-d]"
::~["aac"]
::~
::::
:::^  %has-match  "a[-b]"
::~["a-"]
::~
::::
:::^  %has-match  "a[b-]"
::~["a-"]
::~
::::
:::^  %has-match  "a]"
::~["a]"]
::~
::::
:::^  %has-match  "a[]]b"
::~["a]b"]
::~
::::
:::^  %has-match  "a[^bc]d"
::~["aed"]
::~["abd" "abd"]
::::
:::^  %has-match  "a[^-b]c"
::~["adc"]
::~
::::
:::^  %has-match  "a[^]b]c"
::~["adc"]
::~["a-c" "a]c"]
::::
:::^  %has-match  "\\ba\\b"
::~["a-" "-a" "-a-"]
::~
::::
:::^  %has-match  "\\by\\b"
::~
::~["xy" "yz" "xyz"]
::::
:::^  %has-match  "\\ba\\B"
::~
::~["a-" "-a" "-a-"]
::::
:::^  %has-match  "\\By\\b"
::~["xy"]
::~
::::
:::^  %has-match  "\\by\\B"
::~["yz"]
::~
::::
:::^  %has-match  "\\By\\B"
::~["xyz"]
::~
::::
:::^  %has-match  "\\w"
::~["a"]
::~
::::
:::^  %has-match  "\\W"
::~["-"]
::~["-" "a"]
::::
:::^  %has-match  "a\\sb"
::~["a b"]
::~
::::
:::^  %has-match  "a\\Sb"
::~["a-b"]
::~["a-b" "a b"]
::::
:::^  %has-match  "\\d"
::~["1"]
::~
::::
:::^  %has-match  "\\D"
::~["-"]
::~["-" "1"]
::::
:::^  %has-match  "[\\w]"
::~["a"]
::~
::::
:::^  %has-match  "[\\W]"
::~["-"]
::~["-" "a"]
::::
:::^  %has-match  "a[\\s]b"
::~["a b"]
::~
::::
:::^  %has-match  "a[\\S]b"
::~["a-b"]
::~["a-b" "a b"]
::::
:::^  %has-match  "[\\d]"
::~["1"]
::~
::::
:::^  %has-match  "[\\D]"
::~["-"]
::~["-" "1"]
::::
:::^  %has-match  "ab|cd"
::~["abc" "abcd"]
::~
::::
:::^  %has-match  "()ef"
::~["def"]
::~
::::
:::^  %has-match  "$b"
::~
::~
::::
:::^  %has-match  "a\\(b"
::~["a(b"]
::~
::::
:::^  %has-match  "a\\(*b"
::~["ab" "a((b"]
::~
::::
:::^  %has-match  "a\\\\b"
::~["a\\b"]
::~
::::
:::^  %has-match  "((a))"
::~["abc"]
::~
::::
:::^  %has-match  "(a)b(c)"
::~["abc"]
::~
::::
:::^  %has-match  "a+b+c"
::~["aabbabc"]
::~
::::
:::^  %has-match  "a\{1,}b\{1,}c"
::~["aabbabc"]
::~
::::
:::^  %has-match  "a.+?c"
::~["abcabc"]
::~
::::
:::^  %has-match  "(a+|b)*"
::~["ab"]
::~
::::
:::^  %has-match  "(a+|b)\{0,}"
::~["ab"]
::~
::::
:::^  %has-match  "(a+|b)+"
::~["ab"]
::~
::::
:::^  %has-match  "(a+|b)\{1,}"
::~["ab"]
::~
::::
:::^  %has-match  "(a+|b)?"
::~["ab"]
::~
::::
:::^  %has-match  "(a+|b)\{0,1}"
::~["ab"]
::~
::::
:::^  %has-match  "[^ab]*"
::~["cde"]
::~
::::
:::^  %has-match  "abc"
::~
::~["b" ""]
::::
:::^  %has-match  "a*"
::~[""]
::~
::::
:::^  %has-match  "([abc])*d"
::~["abbbcd"]
::~
::::
:::^  %has-match  "([abc])*bcd"
::~["abcd"]
::~
::::
:::^  %has-match  "a|b|c|d|e"
::~["e"]
::~
::::
:::^  %has-match  "(a|b|c|d|e)f"
::~["ef"]
::~
::::
:::^  %has-match  "abcd*efg"
::~["abcdefg"]
::~
::::
:::^  %has-match  "ab*"
::~["xabyabbbz" "xayabbbz"]
::~
::::
:::^  %has-match  "(ab|cd)e"
::~["abcde"]
::~
::::
:::^  %has-match  "[abhgefdc]ij"
::~["hij"]
::~
::::
:::^  %has-match  "^(ab|cd)e"
::~
::~
::::
:::^  %has-match  "(abc|)ef"
::~["abcdef"]
::~
::::
:::^  %has-match  "(a|b)c*d"
::~["abcd"]
::~
::::
:::^  %has-match  "(ab|ab*)bc"
::~["abc"]
::~
::::
:::^  %has-match  "a([bc]*)c*"
::~["abc"]
::~
::::
:::^  %has-match  "a([bc]*)(c*d)"
::~["abcd"]
::~
::::
:::^  %has-match  "a([bc]+)(c*d)"
::~["abcd"]
::~
::::
:::^  %has-match  "a([bc]*)(c+d)"
::~["abcd"]
::~
::::
:::^  %has-match  "a[bcd]*dcdcde"
::~["adcdcde"]
::~
::::
:::^  %has-match  "a[bcd]+dcdcde"
::~
::~["abcde" "adcdcde"]
::::
:::^  %has-match  "(ab|a)b*c"
::~["abc"]
::~
::::
:::^  %has-match  "((a)(b)c)(d)"
::~["abcd"]
::~
::::
:::^  %has-match  "[a-zA-Z_][a-zA-Z0-9_]*"
::~["alpha"]
::~
::::
:::^  %has-match  "^a(bc+|b[eh])g|.h$"
::~["abh"]
::~
::::
:::^  %has-match  "(bc+d$|ef*g.|h?i(j|k))"
::~["effgz" "ij" "reffgz"]
::~["effg" "bcdd"]
::::
:::^  %has-match  "((((((((((a))))))))))"
::~["a"]
::~
::::
:::^  %has-match  "((((((((((a))))))))))\\08"
::~["aa"]
::~
::::
:::^  %has-match  "(((((((((a)))))))))"
::~["a"]
::~
::::
:::^  %has-match  "multiple words of text"
::~
::~["aa" "uh-uh"]
::::
:::^  %has-match  "multiple words"
::~["multiple words, yeah"]
::~
::::
:::^  %has-match  "(.*)c(.*)"
::~["abcde"]
::~
::::
:::^  %has-match  "\\((.*), (.*)\\)"
::~["(a, b)"]
::~
::::
:::^  %has-match  "[k]"
::~
::~
::::
:::^  %has-match  "abcd"
::~["abcd"]
::~
::::
:::^  %has-match  "a(bc)d"
::~["abcd"]
::~
::::
:::^  %has-match  "a[-]?c"
::~["ac"]
::~
::::
:::^  %has-match  "(abc)\\01"
::~["abcabc"]
::~
::::
:::^  %has-match  "([a-c]*)\\01"
::~["abcabc"]
::~
::::
:::^  %has-match  "(a)|\\01"
::~["a"]
::~["ab" "x"]
::::
:::^  %has-match  "(([a-c])b*?\\02)*"
::~["ababbbcbc"]
::~
::::
:::^  %has-match  "(([a-c])b*?\\02)\{3}"
::~["ababbbcbc"]
::~
::::
:::^  %has-match  "((\\03|b)\\02(a)x)+"
::~["aaaxabaxbaaxbbax"]
::~
::::
:::^  %has-match  "((\\03|b)\\02(a))\{2,}"
::~["bbaababbabaaaaabbaaaabba"]
::~
::::
:::^  %has-match  "abc/"
::~["ABC" "XABCY" "ABABC"]
::~["aaxabxbaxbbx" "XBC" "AXC" "ABX"]
::::
:::^  %has-match  "ab*c/"
::~["ABC"]
::~
::::
:::^  %has-match  "ab*bc/"
::~["ABC" "ABBC"]
::~
::::
:::^  %has-match  "ab*?bc/"
::~["ABBBBC"]
::~
::::
:::^  %has-match  "ab\{0,}?bc/"
::~["ABBBBC"]
::~
::::
:::^  %has-match  "ab+?bc/"
::~["ABBC"]
::~
::::
:::^  %has-match  "ab+bc/"
::~
::~["ABC" "ABQ"]
::::
:::^  %has-match  "ab\{1,}bc/"
::~
::~
::::
:::^  %has-match  "ab+bc/"
::~["ABBBBC"]
::~
::::
:::^  %has-match  "ab\{1,}?bc/"
::~["ABBBBC"]
::~
::::
:::^  %has-match  "ab\{1,3}?bc/"
::~["ABBBBC"]
::~
::::
:::^  %has-match  "ab\{3,4}?bc/"
::~["ABBBBC"]
::~
::::
:::^  %has-match  "ab\{4,5}?bc/"
::~
::~["ABQ" "ABBBBC"]
::::
:::^  %has-match  "ab??bc/"
::~["ABBC" "ABC"]
::~
::::
:::^  %has-match  "ab\{0,1}?bc/"
::~["ABC"]
::~
::::
:::^  %has-match  "ab??bc/"
::~
::~
::::
:::^  %has-match  "ab??c/"
::~["ABC"]
::~
::::
:::^  %has-match  "ab\{0,1}?c/"
::~["ABC"]
::~
::::
:::^  %has-match  "^abc$/"
::~["ABC"]
::~["ABBBBC" "ABCC"]
::::
:::^  %has-match  "^abc/"
::~["ABCC"]
::~
::::
:::^  %has-match  "^abc$/"
::~
::~
::::
:::^  %has-match  "abc$/"
::~["AABC"]
::~
::::
:::^  %has-match  "^/"
::~["ABC"]
::~
::::
:::^  %has-match  "$/"
::~["ABC"]
::~
::::
:::^  %has-match  "a.c/"
::~["ABC" "AXC"]
::~
::::
:::^  %has-match  "a.*?c/"
::~["AXYZC"]
::~
::::
:::^  %has-match  "a.*c/"
::~
::~["AABC" "AXYZD"]
::::
:::^  %has-match  "a[bc]d/"
::~["ABD"]
::~
::::
:::^  %has-match  "a[b-d]e/"
::~["ACE"]
::~["ABC" "ABD"]
::::
:::^  %has-match  "a[b-d]/"
::~["AAC"]
::~
::::
:::^  %has-match  "a[-b]/"
::~["A-"]
::~
::::
:::^  %has-match  "a[b-]/"
::~["A-"]
::~
::::
:::^  %has-match  "a]/"
::~["A]"]
::~
::::
:::^  %has-match  "a[]]b/"
::~["A]B"]
::~
::::
:::^  %has-match  "a[^bc]d/"
::~["AED"]
::~
::::
:::^  %has-match  "a[^-b]c/"
::~["ADC"]
::~["ABD" "A-C"]
::::
:::^  %has-match  "a[^]b]c/"
::~["ADC"]
::~
::::
:::^  %has-match  "ab|cd/"
::~["ABC" "ABCD"]
::~
::::
:::^  %has-match  "()ef/"
::~["DEF"]
::~
::::
:::^  %has-match  "$b/"
::~
::~["A]C" "B"]
::::
:::^  %has-match  "a\\(b/"
::~["A(B"]
::~
::::
:::^  %has-match  "a\\(*b/"
::~["AB" "A((B"]
::~
::::
:::^  %has-match  "a\\\\b/"
::~["A\\B"]
::~
::::
:::^  %has-match  "((a))/"
::~["ABC"]
::~
::::
:::^  %has-match  "(a)b(c)/"
::~["ABC"]
::~
::::
:::^  %has-match  "a+b+c/"
::~["AABBABC"]
::~
::::
:::^  %has-match  "a\{1,}b\{1,}c/"
::~["AABBABC"]
::~
::::
:::^  %has-match  "a.+?c/"
::~["ABCABC"]
::~
::::
:::^  %has-match  "a.*?c/"
::~["ABCABC"]
::~
::::
:::^  %has-match  "a.\{0,5}?c/"
::~["ABCABC"]
::~
::::
:::^  %has-match  "(a+|b)*/"
::~["AB"]
::~
::::
:::^  %has-match  "(a+|b)\{0,}/"
::~["AB"]
::~
::::
:::^  %has-match  "(a+|b)+/"
::~["AB"]
::~
::::
:::^  %has-match  "(a+|b)\{1,}/"
::~["AB"]
::~
::::
:::^  %has-match  "(a+|b)?/"
::~["AB"]
::~
::::
:::^  %has-match  "(a+|b)\{0,1}/"
::~["AB"]
::~
::::
:::^  %has-match  "(a+|b)\{0,1}?/"
::~["AB"]
::~
::::
:::^  %has-match  "[^ab]*/"
::~["CDE"]
::~
::::
:::^  %has-match  "abc/"
::~
::~
::::
:::^  %has-match  "a*/"
::~[""]
::~
::::
:::^  %has-match  "([abc])*d/"
::~["ABBBCD"]
::~
::::
:::^  %has-match  "([abc])*bcd/"
::~["ABCD"]
::~
::::
:::^  %has-match  "a|b|c|d|e/"
::~["E"]
::~
::::
:::^  %has-match  "(a|b|c|d|e)f/"
::~["EF"]
::~
::::
:::^  %has-match  "abcd*efg/"
::~["ABCDEFG"]
::~
::::
:::^  %has-match  "ab*/"
::~["XABYABBBZ" "XAYABBBZ"]
::~
::::
:::^  %has-match  "(ab|cd)e/"
::~["ABCDE"]
::~
::::
:::^  %has-match  "[abhgefdc]ij/"
::~["HIJ"]
::~
::::
:::^  %has-match  "^(ab|cd)e/"
::~["ABCDE"]
::~
::::
:::^  %has-match  "(abc|)ef/"
::~["ABCDEF"]
::~
::::
:::^  %has-match  "(a|b)c*d/"
::~["ABCD"]
::~
::::
:::^  %has-match  "(ab|ab*)bc/"
::~["ABC"]
::~
::::
:::^  %has-match  "a([bc]*)c*/"
::~["ABC"]
::~
::::
:::^  %has-match  "a([bc]*)(c*d)/"
::~["ABCD"]
::~
::::
:::^  %has-match  "a([bc]+)(c*d)/"
::~["ABCD"]
::~
::::
:::^  %has-match  "a([bc]*)(c+d)/"
::~["ABCD"]
::~
::::
:::^  %has-match  "a[bcd]*dcdcde/"
::~["ADCDCDE"]
::~
::::
:::^  %has-match  "a[bcd]+dcdcde/"
::~
::~
::::
:::^  %has-match  "(ab|a)b*c/"
::~["ABC"]
::~
::::
:::^  %has-match  "((a)(b)c)(d)/"
::~["ABCD"]
::~
::::
:::^  %has-match  "[a-zA-Z_][a-zA-Z0-9_]*/"
::~["ALPHA"]
::~
::::
:::^  %has-match  "^a(bc+|b[eh])g|.h$/"
::~["ABH"]
::~
::::
:::^  %has-match  "(bc+d$|ef*g.|h?i(j|k))/"
::~["EFFGZ" "IJ" "REFFGZ"]
::~["ADCDCDE" "EFFG" "BCDD"]
::::
:::^  %has-match  "((((((((((a))))))))))/"
::~["A"]
::~
::::
:::^  %has-match  "((((((((((a))))))))))\\08/"
::~["AA"]
::~
::::
:::^  %has-match  "(((((((((a)))))))))/"
::~["A"]
::~
::::
:::^  %has-match  "(?:(?:(?:(?:(?:(?:(?:(?:(?:(a))))))))))/"
::~["A"]
::~
::::
:::^  %has-match  "(?:(?:(?:(?:(?:(?:(?:(?:(?:(a|b|c))))))))))/"
::~["C"]
::~
::::
:::^  %has-match  "multiple words of text/"
::~
::~["AA" "UH-UH"]
::::
:::^  %has-match  "multiple words/"
::~["MULTIPLE WORDS, YEAH"]
::~
::::
:::^  %has-match  "(.*)c(.*)/"
::~["ABCDE"]
::~
::::
:::^  %has-match  "\\((.*), (.*)\\)/"
::~["(A, B)"]
::~
::::
:::^  %has-match  "[k]/"
::~
::~
::::
:::^  %has-match  "abcd/"
::~["ABCD"]
::~
::::
:::^  %has-match  "a(bc)d/"
::~["ABCD"]
::~
::::
:::^  %has-match  "a[-]?c/"
::~["AC"]
::~
::::
:::^  %has-match  "(abc)\\01/"
::~["ABCABC"]
::~
::::
:::^  %has-match  "([a-c]*)\\01/"
::~["ABCABC"]
::~
::::
:::^  %has-match  "a(?!b)."
::~["abad"]
::~
::::
:::^  %has-match  "a(?=d)."
::~["abad"]
::~
::::
:::^  %has-match  "a(?=c|d)."
::~["abad"]
::~
::::
:::^  %has-match  "a(?:b|c|d)(.)"
::~["ace"]
::~
::::
:::^  %has-match  "a(?:b|c|d)*(.)"
::~["ace"]
::~
::::
:::^  %has-match  "a(?:b|c|d)+?(.)"
::~["ace" "acdbcdbe"]
::~
::::
:::^  %has-match  "a(?:b|c|d)+(.)"
::~["acdbcdbe"]
::~
::::
:::^  %has-match  "a(?:b|c|d)\{2}(.)"
::~["acdbcdbe"]
::~
::::
:::^  %has-match  "a(?:b|c|d)\{4,5}(.)"
::~["acdbcdbe"]
::~
::::
:::^  %has-match  "a(?:b|c|d)\{4,5}?(.)"
::~["acdbcdbe"]
::~
::::
:::^  %has-match  "((foo)|(bar))*"
::~["foobar"]
::~
::::
:::^  %has-match  "a(?:b|c|d)\{6,7}(.)"
::~["acdbcdbe"]
::~
::::
:::^  %has-match  "a(?:b|c|d)\{6,7}?(.)"
::~["acdbcdbe"]
::~
::::
:::^  %has-match  "a(?:b|c|d)\{5,6}(.)"
::~["acdbcdbe"]
::~
::::
:::^  %has-match  "a(?:b|c|d)\{5,6}?(.)"
::~["acdbcdbe"]
::~
::::
:::^  %has-match  "a(?:b|c|d)\{5,7}(.)"
::~["acdbcdbe"]
::~
::::
:::^  %has-match  "a(?:b|c|d)\{5,7}?(.)"
::~["acdbcdbe"]
::~
::::
:::^  %has-match  "a(?:b|(c|e)\{1,2}?|d)+?(.)"
::~["ace"]
::~
::::
:::^  %has-match  "^(.+)?B"
::~["AB"]
::~
::::
:::^  %has-match  "^([^a-z])|(\\^)$"
::~["."]
::~
::::
:::^  %has-match  "^[<>]&"
::~["<&OUT"]
::~
::::
:::^  %has-match  "^(a\\01?)\{4}$"
::~["aaaaaaaaaa"]
::~["AB" "aaaaaaaaa" "aaaaaaaaaaa"]
::::
:::^  %has-match  "^(a(?(1)\\01))\{4}$"
::~["aaaaaaaaaa"]
::~["aaaaaaaaa" "aaaaaaaaaaa"]
::::
:::^  %has-match  "(?:(f)(o)(o)|(b)(a)(r))*"
::~["foobar"]
::~
::::
:::^  %has-match  "(?<=a)b"
::~["ab"]
::~["cb" "b"]
::::
:::^  %has-match  "(?<!c)b"
::~["ab" "b" "b"]
::~
::::
:::^  %has-match  "(?:..)*a"
::~["aba"]
::~
::::
:::^  %has-match  "(?:..)*?a"
::~["aba"]
::~
::::
:::^  %has-match  "^(?:b|a(?=(.)))*\\01"
::~["abc"]
::~
::::
:::^  %has-match  "^()\{3,5}"
::~["abc"]
::~
::::
:::^  %has-match  "^(a+)*ax"
::~["aax"]
::~
::::
:::^  %has-match  "^((a|b)+)*ax"
::~["aax"]
::~
::::
:::^  %has-match  "^((a|bc)+)*ax"
::~["aax"]
::~
::::
:::^  %has-match  "(a|x)*ab"
::~["cab"]
::~
::::
:::^  %has-match  "(a)*ab"
::~["cab"]
::~
::::
:::^  %has-match  "(?:(?i)a)b"
::~["ab"]
::~
::::
:::^  %has-match  "((?i)a)b"
::~["ab"]
::~
::::
:::^  %has-match  "(?:(?i)a)b"
::~["Ab"]
::~
::::
:::^  %has-match  "((?i)a)b"
::~["Ab"]
::~
::::
:::^  %has-match  "(?:(?i)a)b"
::~
::~["cb" "aB"]
::::
:::^  %has-match  "((?i)a)b"
::~
::~
::::
:::^  %has-match  "(?i:a)b"
::~["ab"]
::~
::::
:::^  %has-match  "((?i:a))b"
::~["ab"]
::~
::::
:::^  %has-match  "(?i:a)b"
::~["Ab"]
::~
::::
:::^  %has-match  "((?i:a))b"
::~["Ab"]
::~
::::
:::^  %has-match  "(?i:a)b"
::~
::~["aB" "aB"]
::::
:::^  %has-match  "((?i:a))b"
::~
::~
::::
:::^  %has-match  "(?:(?-i)a)b/"
::~["ab"]
::~
::::
:::^  %has-match  "((?-i)a)b/"
::~["ab"]
::~
::::
:::^  %has-match  "(?:(?-i)a)b/"
::~["aB"]
::~
::::
:::^  %has-match  "((?-i)a)b/"
::~["aB"]
::~
::::
:::^  %has-match  "(?:(?-i)a)b/"
::~
::~["aB" "Ab"]
::::
:::^  %has-match  "((?-i)a)b/"
::~
::~
::::
:::^  %has-match  "(?:(?-i)a)b/"
::~["aB"]
::~
::::
:::^  %has-match  "((?-i)a)b/"
::~["aB"]
::~
::::
:::^  %has-match  "(?:(?-i)a)b/"
::~
::~["Ab" "AB"]
::::
:::^  %has-match  "((?-i)a)b/"
::~
::~
::::
:::^  %has-match  "(?-i:a)b/"
::~["ab"]
::~
::::
:::^  %has-match  "((?-i:a))b/"
::~["ab"]
::~
::::
:::^  %has-match  "(?-i:a)b/"
::~["aB"]
::~
::::
:::^  %has-match  "((?-i:a))b/"
::~["aB"]
::~
::::
:::^  %has-match  "(?-i:a)b/"
::~
::~["AB" "Ab"]
::::
:::^  %has-match  "((?-i:a))b/"
::~
::~
::::
:::^  %has-match  "(?-i:a)b/"
::~["aB"]
::~
::::
:::^  %has-match  "((?-i:a))b/"
::~["aB"]
::~
::::
:::^  %has-match  "(?-i:a)b/"
::~
::~["Ab" "AB"]
::::
:::^  %has-match  "((?-i:a))b/"
::~
::~
::::
:::^  %has-match  "((?-i:a.))b/"
::~
::~["AB" "a\0aB"]
::::
:::^  %has-match  "((?s-i:a.))b/"
::~["a\0aB"]
::~
::::
:::^  %has-match  "(?:c|d)(?:)(?:a(?:)(?:b)(?:b(?:))(?:b(?:)(?:b)))"
::~["cabbbb"]
::~
::::
:::^  %has-match  "(?:c|d)(?:)(?:aaaaaaaa(?:)(?:bbbbbbbb)(?:bbbbbbbb(?:))(?:bbbbbbbb(?:)(?:bbbbbbbb)))"
::~["caaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"]
::~
::::
:::^  %has-match  "(ab)\\d\\01/"
::~["Ab4ab" "ab4Ab"]
::~
::::
:::^  %has-match  "foo\\w*\\d\{4}baz"
::~["foobar1234baz"]
::~
::::
:::^  %has-match  "x(~~)*(?:(?:F)?)?"
::~["x~~"]
::~
::::
:::^  %has-match  "^a(?#xxx)\{3}c"
::~["aaac"]
::~
::::
:::^  %has-match  "^a (?#xxx) (?#yyy) \{3}c/"
::~["aaac"]
::~
::::
:::^  %has-match  "(?<![cd])b"
::~
::~["B\0aB" "dbcb"]
::::
:::^  %has-match  "(?<![cd])[ab]"
::~["dbaacb"]
::~
::::
:::^  %has-match  "(?<!(c|d))b"
::~
::~
::::
:::^  %has-match  "(?<!(c|d))[ab]"
::~["dbaacb"]
::~
::::
:::^  %has-match  "(?<!cd)[ab]"
::~["cdaccb"]
::~
::::
:::^  %has-match  "^(?:a?b?)*$"
::~["\\" "a" "ab" "aaa   "]
::~["dbcb" "a--" "aa-- "]
::::
:::^  %has-match  "((?s)^a(.))((?m)^b$)"
::~["a\0ab\0ac\0a"]
::~
::::
:::^  %has-match  "((?m)^b$)"
::~["a\0ab\0ac\0a"]
::~
::::
:::^  %has-match  "(?m)^b"
::~["a\0ab\0a"]
::~
::::
:::^  %has-match  "(?m)^(b)"
::~["a\0ab\0a"]
::~
::::
:::^  %has-match  "((?m)^b)"
::~["a\0ab\0a"]
::~
::::
:::^  %has-match  "\\n((?m)^b)"
::~["a\0ab\0a"]
::~
::::
:::^  %has-match  "((?s).)c(?!.)"
::~["a\0ab\0ac\0a" "a\0ab\0ac\0a"]
::~
::::
:::^  %has-match  "((?s)b.)c(?!.)"
::~["a\0ab\0ac\0a" "a\0ab\0ac\0a"]
::~
::::
:::^  %has-match  "^b"
::~
::~
::::
:::^  %has-match  "()^b"
::~
::~["a\0ab\0ac\0a" "a\0ab\0ac\0a"]
::::
:::^  %has-match  "((?m)^b)"
::~["a\0ab\0ac\0a"]
::~
::::
:::^  %has-match  "(x)?(?(1)a|b)"
::~
::~["a" "a"]
::::
:::^  %has-match  "(x)?(?(1)b|a)"
::~["a"]
::~
::::
:::^  %has-match  "()?(?(1)b|a)"
::~["a"]
::~
::::
:::^  %has-match  "()(?(1)b|a)"
::~
::~
::::
:::^  %has-match  "()?(?(1)a|b)"
::~["a"]
::~
::::
:::^  %has-match  "^(\\()?blah(?(1)(\\)))$"
::~["(blah)" "blah"]
::~["a" "blah)" "(blah"]
::::
:::^  %has-match  "^(\\(+)?blah(?(1)(\\)))$"
::~["(blah)" "blah"]
::~["blah)" "(blah"]
::::
:::^  %has-match  "(?(?!a)a|b)"
::~
::~
::::
:::^  %has-match  "(?(?!a)b|a)"
::~["a"]
::~
::::
:::^  %has-match  "(?(?=a)b|a)"
::~
::~["a" "a"]
::::
:::^  %has-match  "(?(?=a)a|b)"
::~["a"]
::~
::::
:::^  %has-match  "(?=(a+?))(\\01ab)"
::~["aaab"]
::~
::::
:::^  %has-match  "^(?=(a+?))\\01ab"
::~
::~
::::
:::^  %has-match  "(\\w+:)+"
::~["one:"]
::~
::::
:::^  %has-match  "$(?<=^(a))"
::~["a"]
::~
::::
:::^  %has-match  "(?=(a+?))(\\01ab)"
::~["aaab"]
::~
::::
:::^  %has-match  "^(?=(a+?))\\01ab"
::~
::~["aaab" "aaab"]
::::
:::^  %has-match  "([\\w:]+::)?(\\w+)$"
::~["abcd" "xy:z:::abcd"]
::~
::::
:::^  %has-match  "^[^bcd]*(c+)"
::~["aexycd"]
::~
::::
:::^  %has-match  "(a*)b+"
::~["caab"]
::~
::::
:::^  %has-match  "([\\w:]+::)?(\\w+)$"
::~["abcd" "xy:z:::abcd"]
::~["abcd:" "abcd:"]
::::
:::^  %has-match  "^[^bcd]*(c+)"
::~["aexycd"]
::~
::::
:::^  %has-match  "(>a+)ab"
::~
::~
::::
:::^  %has-match  "(?>a+)b"
::~["aaab"]
::~
::::
:::^  %has-match  "([[:]+)"
::~["a:[b]:"]
::~
::::
:::^  %has-match  "([[=]+)"
::~["a=[b]="]
::~
::::
:::^  %has-match  "([[.]+)"
::~["a.[b]."]
::~
::::
:::^  %has-match  "((?>a+)b)"
::~["aaab"]
::~
::::
:::^  %has-match  "(?>(a+))b"
::~["aaab"]
::~
::::
:::^  %has-match  "((?>[^()]+)|\\([^()]*\\))+"
::~["((abc(ade)ufh()()x"]
::~
::::
:::^  %has-match  "a\\Z"
::~
::~["aaab" "a\0ab\0a"]
::::
:::^  %has-match  "b\\Z"
::~["a\0ab\0a"]
::~
::::
:::^  %has-match  "b\\z"
::~
::~
::::
:::^  %has-match  "b\\Z"
::~["a\0ab"]
::~
::::
::::
:::^  %has-match  "^(?>(?(1)\\.|())[^\\W_](?>[a-z0-9-]*[^\\W_])?)+$"
::~["a" "abc" "a-b" "0-9 " "a.b" "5.6.7  " "the.quick.brown.fox" "a100.b200.300c  " "12-ab.1245 "]
::~["\\" ".a" "-a" "a-" "a.  " "a_b " "a.-" "a..  " "ab..bc " "the.quick.brown.fox-" "the.quick.brown.fox." "the.quick.brown.fox_" "the.quick.brown.fox+       "]
::::
:::^  %has-match  "(?>.*)(?<=(abcd|wxyz))"
::~["alphabetabcd" "endingwxyz"]
::~["a rather long string that doesn't end with one of them"]
::::
::::
:::^  %has-match  "word (?>[a-zA-Z0-9]+ )\{0,30}otherword"
::~["word cat dog elephant mussel cow horse canary baboon snake shark the quick brown fox and the lazy dog and several other words getting close to thirty by now I hope"]
::~
::::
::::
:::^  %has-match  "(?<=(?!...999)\\d\{3})foo"
::~["999foo" "123999foo "]
::~["123abcfoo"]
::::
::::
:::^  %has-match  "(?<=\\d\{3}...)(?<!999)foo"
::~["123abcfoo   " "123456foo "]
::~["123999foo  "]
::::
:::^  %has-match  "((Z)+|A)*"
::~["ZABCDEFG"]
::~
::::
:::^  %has-match  "(Z()|A)*"
::~["ZABCDEFG"]
::~
::::
:::^  %has-match  "(Z(())|A)*"
::~["ZABCDEFG"]
::~
::::
:::^  %has-match  "((?>Z)+|A)*"
::~["ZABCDEFG"]
::~
::::
:::^  %has-match  "((?>)+|A)*"
::~["ZABCDEFG"]
::~
::::
:::^  %has-match  "a*/"
::~["abbab"]
::~
::::
::::
::::
::::
::::
:::^  %has-match  "\\s+"
::~["> \009\00a\00c\00d\00b<" ""]
::~
::::
:::^  %has-match  "abc./"
::~["abc1abc2xyzabc3 "]
::~
::::
:::^  %has-match  "(?i)AB(?-i)C"
::~["XabCY"]
::~["XabcY  "]
::::
:::^  %has-match  "((?i)AB(?-i)C|D)E"
::~["abCE" "DE"]
::~["abcE" "abCe  " "dE" "De    "]
::::
:::^  %has-match  "(.*)\\d+\\01"
::~["abc123abc" "abc123bc "]
::~
::::
::::
:::^  %has-match  "((.*))\\d+\\01"
::~["abc123abc" "abc123bc  "]
::~
:::^  %has-match  "((.*))\\d+\\01"
::~["abc123abc" "abc123bc  "]
::~
::::
:::^  %has-match  "^(?!:)                       # colon disallowed at start"
::~
::~["1:2:3:4:5:6:7:8" "a123:bce:ddde:9999:b342::324e:dcba:abcd" "a123::9999:b342::324e:dcba:abcd" "abcde:2:3:4:5:6:7:8" "::1" "abcd:fee0:123::   " ":1" "1:  "]
::::
:::^  %has-match  "[z\\Qa-d]\\E]"
::~["z" "a" "-" "d" "] "]
::~["b     "]
::::
::::
::::
::::
:::^  %has-match  "(?i)reg(?:ul(?:[aä]|ae)r|ex)"
::~["REGular" "regulaer" "Regex  " "regulär "]
::~
::::
:::^  %has-match  "Åæåä[à-ÿÀ-ß]+"
::~["Åæåäà" "Åæåäÿ" "ÅæåäÀ" "Åæåäß"]
::~
::::
:::^  %has-match  "ab cd (?x) de fg"
::~["ab cd defg"]
::~
::::
:::^  %has-match  "ab cd(?x) de fg"
::~["ab cddefg" "** Failers " "abcddefg"]
::~
::::
:::^  %has-match  "(?<![^f]oo)(bar)"
::~["foobarX " "** Failers " "boobarX"]
::~
::::
:::^  %has-match  "(?<![^f])X"
::~["offX" "** Failers" "onyX  "]
::~
::::
:::^  %has-match  "(?<=[^f])X"
::~["onyX" "** Failers" "offX "]
::~
::::
::::
:::^  %has-match  "(?<=C\\n)^/m"
::~["A\0aC\0aC\0a "]
::~
::::
:::^  %has-match  "(?:(?(1)a|b)(X))+"
::~["bXaX"]
::~
::::
:::^  %has-match  "(?:(?(1)\\01a|b)(X|Y))+"
::~["bXXaYYaY" "bXYaXXaX  "]
::~
::::
:::^  %has-match  "()()()()()()()()()(?:(?(10)\\08a|b)(X|Y))+"
::~["bXXaYYaY"]
::~
::::
:::^  %has-match  "[[,abc,]+]"
::~["abc]" "a,b]" "[a,b,c]  "]
::~
::::
:::^  %has-match  "(?-x: )/"
::~["A\10B" "" "A # B" "** Failers" "#  "]
::~
:::^  %has-match  "(?-x: )/"
::~["A\10B" "" "A # B" "** Failers" "#  " "A #include" "** Failers" "A#include  " "A #Include"]
::~
::::
:::^  %has-match  "a*b*\\w"
::~["aaabbbb" "aaaa" "a"]
::~
::::
:::^  %has-match  "a*b?\\w"
::~["aaabbbb" "aaaa" "a"]
::~
::::
:::^  %has-match  "a*b\{0,4}\\w"
::~["aaabbbb" "aaaa" "a"]
::~
::::
::::
::::
:::^  %has-match  "a*b *\\w/"
::~["a "]
::~
::::
:::^  %has-match  "a*b#comment"
::~
::~
::::
:::^  %has-match  "a* b *\\w/"
::~["a "]
::~
::::
:::^  %has-match  "^\\w+=.*(\\\\\\n.*)*"
::~["abc=xyz\\\0apqr"]
::~
::::
:::^  %has-match  "(?=(\\w+))\\01:"
::~["abcd:"]
::~
::::
:::^  %has-match  "^(?=(\\w+))\\01:"
::~["abcd:"]
::~
::::
::::
::::
:::^  %has-match  "^[a-\\ec]"
::~["b" "** Failers" "-" "E    "]
::~
::::
:::^  %has-match  "^[a\\E\\E-\\ec]"
::~["b" "** Failers" "-" "E    "]
::~
::::::
::::::
::::::
:::::^  %has-match  "^[a-\\Q\\E]"
::::~["a" "-     "]
::::~
::::::
:::::^  %has-match  "^(a()*)*"
::::~["aaaa"]
::::~
::::::
:::::^  %has-match  "^(?:a(?:(?:))*)*"
::::~["aaaa"]
::::~
::::::
:::::^  %has-match  "^(a()+)+"
::::~["aaaa"]
::::~
::::::
:::::^  %has-match  "^(?:a(?:(?:))+)+"
::::~["aaaa"]
::::~
::::::
:::::^  %has-match  "(a)\{0,3}(?(1)b|(c|))*D"
::::~["abbD" "ccccD" "D  "]
::::~
::::::
:::::^  %has-match  "(a|)*\\d"
::::~["aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4"]
::::~
::::::
:::::^  %has-match  "(?>a|)*\\d"
::::~["aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4"]
::::~
::::::
:::::^  %has-match  "(?:a|)*\\d"
::::~["aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4"]
::::~
::::::
::::::
:::::^  %has-match  "^(?s)(?>.*)(?<!\\n)"
::::~["abc" "abc\0a  "]
::::~
::::::
::::::
:::::^  %has-match  "\\z(?<!\\n)"
::::~["abc" "abc\0a  "]
::::~
::::
:::^  %has-match  "(.*(.)?)*"
::~["abcd"]
::~
::::
:::^  %has-match  "( (A | (?(1)0|) )*   )/"
::~["abcd"]
::~
::::
:::^  %has-match  "( ( (?(1)0|) )*   )/"
::~["abcd"]
::~
::::
:::^  %has-match  "(  (?(1)0|)*   )/"
::~["abcd"]
::~
::::
::::
:::^  %has-match  "[abc[:x\\]pqr]"
::~["a" "[" ":" "]" "p    "]
::~
::::
:::^  %has-match  ".*[op][xyz]"
::~["fooabcfoo"]
::~
::::
:::^  %has-match  "(?(?=.*b)b|^)"
::~["adc" "abc "]
::~
::::
:::^  %has-match  "(?(?=^.*b)b|^)"
::~["adc" "abc "]
::~
::::
:::^  %has-match  "(?(?=.*b)b|^)*"
::~["adc" "abc "]
::~
::::
:::^  %has-match  "(?(?=.*b)b|^)+"
::~["adc" "abc "]
::~
::::
:::^  %has-match  "(?(?=b).*b|^d)"
::~["abc"]
::~
::::
:::^  %has-match  "(?(?=.*b).*b|^d)"
::~["abc"]
::~
::::
:::^  %has-match  "^%((?(?=[a])[^%])|b)*%$"
::~["%ab%"]
::~
::::
:::^  %has-match  "(?i)a(?-i)b|c"
::~["XabX" "XAbX" "CcC " "** Failers" "XABX   "]
::~
::::
:::^  %has-match  "[\\00-\\ff\\s]+"
::~["\00a\00b\00c\00d"]
::~
::::
:::^  %has-match  "(abc)\\01/"
::~["abc"]
::~
::::
:::^  %has-match  "(abc)\\01"
::~["abc"]
::~
::::
:::^  %has-match  "[^a]*/"
::~["12abc" "12ABC"]
::~
::::
:::^  %has-match  "[^a]*+/"
::~["12abc" "12ABC"]
::~
::::
::::
:::^  %has-match  "[^a]+?X/i   "
::~
::~
::::
:::^  %has-match  "[^a]?X/"
::~["12aXbcX" "12AXBCX" "BCX "]
::~
::::
::::
:::^  %has-match  "[^a]?+X/"
::~["12aXbcX" "12AXBCX" "BCX "]
::~
::::
:::^  %has-match  "[^a]\{2,3}/"
::~["abcdef" "ABCDEF  "]
::~
::::
:::^  %has-match  "[^a]\{2,3}?/"
::~["abcdef" "ABCDEF  "]
::~
::::
:::^  %has-match  "[^a]\{2,3}+/"
::~["abcdef" "ABCDEF  "]
::~
::::
:::^  %has-match  "((a|)+)+Z"
::~["Z"]
::~
::::
:::^  %has-match  "(a)b|(a)c"
::~["ac"]
::~
::::
:::^  %has-match  "(?>(a))b|(a)c"
::~["ac"]
::~
::::
:::^  %has-match  "(?=(a))ab|(a)c"
::~["ac"]
::~
::::
:::^  %has-match  "((?>(a))b|(a)c)"
::~["ac"]
::~
::::
:::^  %has-match  "((?>(a))b|(a)c)++"
::~["ac"]
::~
::::
:::^  %has-match  "(?:(?>(a))b|(a)c)++"
::~["ac"]
::~
::::
:::^  %has-match  "(?=(?>(a))b|(a)c)(..)"
::~["ac"]
::~
::::
:::^  %has-match  "(?>(?>(a))b|(a)c)"
::~["ac"]
::~
::::
:::^  %has-match  "(?:(?>([ab])))+a=/+"
::~
::~
::::
:::^  %has-match  "(?>([ab]))+a=/+"
::~
::~
::::
:::^  %has-match  "((?>(a+)b)+(aabab))"
::~["aaaabaaabaabab"]
::~
::::
:::^  %has-match  "(?>a+|ab)+?c"
::~["aabc"]
::~
::::
:::^  %has-match  "(?>a+|ab)+c"
::~["aabc"]
::~
::::
:::^  %has-match  "(?:a+|ab)+c"
::~["aabc"]
::~
::::
:::^  %has-match  "(?(?=(a))a)"
::~["a"]
::~
::::
:::^  %has-match  "(?(?=(a))a)(b)"
::~["ab"]
::~
::::
:::^  %has-match  "^(?:a|ab)++c"
::~["aaaabc"]
::~
::::
:::^  %has-match  "^(?>a|ab)++c"
::~["aaaabc"]
::~
::::
:::^  %has-match  "^(?:a|ab)+c"
::~["aaaabc"]
::~
::::
::::
::::
::::
:::^  %has-match  "(?=abc)\{0}xyz"
::~["xyz "]
::~
::::
::::
::::
:::^  %has-match  "(?=(a))??."
::~["ab" "bc"]
::~
::::
:::^  %has-match  "^(?=(?1))?[az]([abc])d"
::~["abd " "zcdxx "]
::~
::::
:::^  %has-match  "^(?!a)\{0}\\w+"
::~["aaaaa"]
::~
::::
:::^  %has-match  "(?<=(abc))?xyz"
::~["abcxyz" "pqrxyz "]
::~
::::
::::
::::
:::^  %has-match  "^[:a[:digit:]]+"
::~["aaaa444:::Z "]
::~
::::
:::^  %has-match  "^[:a[:digit:]:b]+"
::~["aaaa444:::bbbZ "]
::~
::::
::::
:::^  %has-match  "(?<=a\{2})b/"
::~["xaabc" "** Failers" "xabc  "]
::~
::::
:::^  %has-match  "(?<!a\{2})b/"
::~["xabc" "** Failers" "xaabc  "]
::~
::::
::::
:::^  %has-match  "(?<=[^a]\{2})b"
::~["axxbc" "aAAbc " "** Failers" "xaabc    "]
::~
::::
:::^  %has-match  "(?<=[^a]\{2})b/"
::~["axxbc  " "** Failers" "aAAbc " "xaabc    "]
::~
::::
:::^  %has-match  "(?<=a\\H)c"
::~["abc"]
::~
::::
::::
:::^  %has-match  "(?<=a\\v)c"
::~["a\0ac"]
::~
::::
:::^  %has-match  "(?(?=c)c|d)++Y"
::~["XcccddYX"]
::~
::::
:::^  %has-match  "(?(?=c)c|d)*+Y"
::~["XcccddYX"]
::~
::::
:::^  %has-match  "^(a\{2,3})\{2,}+a"
::~["aaaaaaa" "** Failers" "aaaaaa" "aaaaaaaaa "]
::~
::::
:::^  %has-match  "^(a\{2,3})++a"
::~["** Failers" "aaaaaa"]
::~
::::
:::^  %has-match  "^(a\{2,3})*+a"
::~["** Failers" "aaaaaa"]
::~
::::
::::
:::^  %has-match  "(?<=ab\\cde)X"
::~["abZdeX"]
::~
::::
:::^  %has-match  "a[\\cd]b"
::~["aCb" "aDb "]
::~
::::
:::^  %has-match  "a[\\C-X]b"
::~["aJb"]
::~
::::
::::
::::
::::
:::^  %has-match  ".\\h\{3,4}."
::~["XY  AB    PQRS"]
::~
::::
:::^  %has-match  "\\h*X\\h?\\H+Y\\H?Z"
::~[">XNNNYZ" ">  X NYQZ" "** Failers" ">XYZ   " ">  X NY Z"]
::~
::::
:::^  %has-match  "\\v*X\\v?Y\\v+Z\\V*\\00a\\V+\\00b\\V\{2,3}\\00c"
::~[">XY\00aZ\00aA\00bNN\00c" ">\00a\00dX\00aY\00a\00bZZZ\00aAAA\00bNNN\00c"]
::~
::::
::::
:::^  %has-match  "(foo)(\\Kbar|baz)"
::~["foobar" "foobaz "]
::~
::::
:::^  %has-match  "(foo\\Kbar)baz"
::~["foobarbaz"]
::~
::::
:::^  %has-match  "abc\\K|def\\K/g+"
::~
::~
::::
::::
::::
:::^  %has-match  "^abc\\K/+"
::~
::~
::::
:::^  %has-match  "^(a(b))\\01\\g1\\g\{1}\\g-1\\g\{-1}\\g\{-02}Z"
::~["ababababbbabZXXXX"]
::~
::::
::::
:::^  %has-match  "(^(a|b\\g\{-1}))"
::~["bacxxx"]
::~
::::
::::
::::
:::^  %has-match  "^X(?5)(a)(?|(b)|(q))(c)(d)(Y)"
::~["XYabcdY"]
::~
::::
:::^  %has-match  "^X(?7)(a)(?|(b|(r)(s))|(q))(c)(d)(Y)"
::~["XYabcdY"]
::~
::::
:::^  %has-match  "^X(?7)(a)(?|(b|(?|(r)|(t))(s))|(q))(c)(d)(Y)"
::~["XYabcdY"]
::~
::::
:::^  %has-match  "(?'abc'\\w+):\\k<abc>\{2}"
::~["a:aaxyz" "ab:ababxyz" "** Failers" "a:axyz" "ab:abxyz"]
::~
::::
:::^  %has-match  "(?'abc'\\w+):\\g\{abc}\{2}"
::~["a:aaxyz" "ab:ababxyz" "** Failers" "a:axyz" "ab:abxyz"]
::~
::::
:::^  %has-match  "^(?<ab>a)? (?(<ab>)b|c) (?('ab')d|e)/"
::~["abd" "ce"]
::~
::::
:::^  %has-match  "^(a.)\\g-1Z"
::~["aXaXZ"]
::~
::::
:::^  %has-match  "^(a.)\\g\{-1}Z"
::~["aXaXZ"]
::~
::::
:::^  %has-match  "^(?(DEFINE) (?<A> a) (?<B> b) )  (?&A) (?&B) /"
::~["abcd"]
::~
::::
:::^  %has-match  "(?<NAME>(?&NAME_PAT))\\s+(?<ADDR>(?&ADDRESS_PAT))"
::~
::~
::::
:::^  %has-match  "(?(DEFINE)(?<byte>2[0-4]\\d|25[0-5]|1\\d\\d|[1-9]?\\d))\\b(?&byte)(\\.(?&byte))\{3}"
::~["1.2.3.4" "131.111.10.206" "10.0.0.0" "** Failers" "10.6" "455.3.4.5"]
::~
::::
:::^  %has-match  "\\b(?&byte)(\\.(?&byte))\{3}(?(DEFINE)(?<byte>2[0-4]\\d|25[0-5]|1\\d\\d|[1-9]?\\d))"
::~["1.2.3.4" "131.111.10.206" "10.0.0.0" "** Failers" "10.6" "455.3.4.5"]
::~
::::
:::^  %has-match  "^(\\w++|\\s++)*$"
::~["now is the time for all good men to come to the aid of the party"]
::~["this is not a line with only words and spaces!"]
::::
:::^  %has-match  "(\\d++)(\\w)"
::~["12345a"]
::~["12345+"]
::::
:::^  %has-match  "a++b"
::~["aaab"]
::~
::::
:::^  %has-match  "(a++b)"
::~["aaab"]
::~
::::
:::^  %has-match  "(a++)b"
::~["aaab"]
::~
::::
:::^  %has-match  "([^()]++|\\([^()]*\\))+"
::~["((abc(ade)ufh()()x"]
::~
::::
:::^  %has-match  "\\(([^()]++|\\([^()]+\\))+\\)"
::~["(abc)" "(abc(def)xyz)"]
::~["((()aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"]
::::
:::^  %has-match  "^([^()]|\\((?1)*\\))*$"
::~["abc" "a(b)c" "a(b(c))d"]
::~["a(b(c)d"]
::::
:::^  %has-match  "^>abc>([^()]|\\((?1)*\\))*<xyz<$"
::~[">abc>123<xyz<" ">abc>1(2)3<xyz<" ">abc>(1(2)3)<xyz<"]
::~
::::
:::^  %has-match  "^(?:((.)(?1)\\02|)|((.)(?3)\\04|.))$/"
::~["1221" "Satanoscillatemymetallicsonatas" "AmanaplanacanalPanama" "AblewasIereIsawElba"]
::~["Thequickbrownfox"]
::::
:::^  %has-match  "^(\\d+|\\((?1)([+*-])(?1)\\)|-(?1))$"
::~["12" "(((2+2)*-3)-7)" "-12"]
::~["((2+2)*-3)-7)"]
::::
:::^  %has-match  "^(x(y|(?1)\{2})z)"
::~["xyz" "xxyzxyzz"]
::~["xxyzz" "xxyzxyzxyzz"]
::::
:::^  %has-match  "((< (?: (?(R) \\d++  | [^<>]*+) | (?2)) * >))/"
::~["<>" "<abcd>" "<abc <123> hij>" "<abc <def> hij>" "<abc<>def>" "<abc<>"]
::~["<abc"]
::::
::::
:::^  %has-match  "a+b?c+(*FAIL)"
::~["aaabccc"]
::~
::::
:::^  %has-match  "a+b?(*PRUNE)c+(*FAIL)"
::~["aaabccc"]
::~
::::
::::
:::^  %has-match  "a+b?(*SKIP)c+(*FAIL)"
::~["aaabcccaaabccc"]
::~
::::
:::^  %has-match  "^(?:aaa(*THEN)\\w\{6}|bbb(*THEN)\\w\{5}|ccc(*THEN)\\w\{4}|\\w\{3})"
::~["aaaxxxxxx" "aaa++++++ " "bbbxxxxx" "bbb+++++ " "cccxxxx" "ccc++++ " "dddddddd   "]
::~
::::
:::^  %has-match  "^(aaa(*THEN)\\w\{6}|bbb(*THEN)\\w\{5}|ccc(*THEN)\\w\{4}|\\w\{3})"
::~["aaaxxxxxx" "aaa++++++ " "bbbxxxxx" "bbb+++++ " "cccxxxx" "ccc++++ " "dddddddd   "]
::~
::::
:::^  %has-match  "a+b?(*THEN)c+(*FAIL)"
::~["aaabccc"]
::~
::::
::::
:::^  %has-match  "^\\W*+(?:((.)\\W*+(?1)\\W*+\\02|)|((.)\\W*+(?3)\\W*+\\04|\\W*+.\\W*+))\\W*+$/"
::~["1221" "Satan, oscillate my metallic sonatas!" "A man, a plan, a canal: Panama!" "Able was I ere I saw Elba."]
::~["The quick brown fox"]
::::
:::^  %has-match  "^((.)(?1)\\02|.)$"
::~["a" "aba" "aabaa  " "abcdcba " "pqaabaaqp  " "ablewasiereisawelba" "rhubarb" "the quick brown fox  "]
::~
::::
::::
::::
:::^  %has-match  "(?<X>a)(?<=b(?&X))"
::~["baz"]
::~
::::
::::
:::^  %has-match  "^(?|(abc)|(def))(?1)"
::~["abcabc" "defabc" "** Failers" "defdef" "abcdef    "]
::~
::::
:::^  %has-match  "(?:a(?<quote> (?<apostrophe>')|(?<realquote>\")) |b(?<quote> (?<apostrophe>')|(?<realquote>\")) ) (?('quote')[a-z]+|[0-9]+)/x"
::~["a\"aaaaa" "b\"aaaaa " "** Failers " "b\"11111"]
::~
::::
:::^  %has-match  "(?:(?1)|B)(A(*F)|C)"
::~["ABCD" "CCD" "** Failers" "CAD   "]
::~
::::
:::^  %has-match  "^(?:(?1)|B)(A(*F)|C)"
::~["CCD" "BCD " "** Failers" "ABCD" "CAD" "BAD    "]
::~
::::
:::^  %has-match  "(?:(?1)|B)(A(*ACCEPT)XX|C)D"
::~["AAD" "ACD" "BAD" "BCD" "BAX  " "** Failers" "ACX" "ABC   "]
::~
::::
:::^  %has-match  "(?(DEFINE)(A))B(?1)C"
::~["BAC"]
::~
::::
:::^  %has-match  "(?(DEFINE)((A)\\02))B(?1)C"
::~["BAAC"]
::~
::::
:::^  %has-match  "(?<pn> \\( ( [^()]++ | (?&pn) )* \\) )/"
::~["(ab(cd)ef)"]
::~
::::
::::
:::^  %has-match  "^(?=a(*PRUNE)b)"
::~["ab  " "** Failers " "ac"]
::~
::::
:::^  %has-match  "^(?=a(*ACCEPT)b)"
::~["ac"]
::~
::::
:::^  %has-match  "(?>a\\Kb)"
::~["ab"]
::~
::::
:::^  %has-match  "((?>a\\Kb))"
::~["ab"]
::~
::::
::::
::::
:::^  %has-match  "(?>a\\Kbz|ab)"
::~["ab "]
::~
::::
:::^  %has-match  "^(?&t)(?(DEFINE)(?<t>a\\Kb))$"
::~["ab"]
::~
::::
:::^  %has-match  "^([^()]|\\((?1)*\\))*$"
::~["a(b)c" "a(b(c)d)e "]
::~
::::
:::^  %has-match  "(?P<L1>(?P<L2>0)(?P>L1)|(?P>L2))"
::~["0" "00" "0000  "]
::~
::::
:::^  %has-match  "(?P<L1>(?P<L2>0)|(?P>L2)(?P>L1))"
::~["0" "00" "0000  "]
::~
:::^  %has-match  "(?P<L1>(?P<L2>0)|(?P>L2)(?P>L1))"
::~["0" "00" "0000  "]
::~
::::
:::^  %has-match  "^(A(*PRUNE:A)B|C(*PRUNE:B)D)/"
::~["** Failers" "AC" "CB    " ""]
::~
::::
::::
:::^  %has-match  "^(A(*THEN:A)B|C(*THEN:B)D)/"
::~["** Failers" "CB    "]
::~
::::
::::
:::^  %has-match  "^(?>A(*THEN:A)B|C(*THEN:B)D)/"
::~["CB    " ""]
::~
::::
:::^  %has-match  "A(*MARK:A)A+(*SKIP:A)(B|Z) | AC/x"
::~["AAAC" ""]
::~
::::
:::^  %has-match  "A(*:A)A+(*SKIP:A)(B|Z) | AC/x"
::~["AAAC"]
::~
:::^  %has-match  "A(*:A)A+(*SKIP:A)(B|Z) | AC/x"
::~["AAAC"]
::~
::::
:::^  %has-match  "A(*MARK:A)A+(*SKIP:B)(B|Z) | AC/x"
::~["AAAC"]
::~
::::
:::^  %has-match  "A(*MARK:A)A+(*SKIP:B)(B|Z) | AC(*:B)/x"
::~["AAAC"]
::~
:::^  %has-match  "A(*MARK:A)A+(*SKIP:B)(B|Z) | AC(*:B)/x"
::~["AAAC"]
::~
::::
:::^  %has-match  "(*COMMIT)(A|P)(B|P)(C|P)"
::~["ABCDEFG" "** Failers" "DEFGABC  "]
::~
:::^  %has-match  "(*COMMIT)(A|P)(B|P)(C|P)"
::~["ABCDEFG" "** Failers" "DEFGABC  "]
::~
::::
:::^  %has-match  "(?&t)(?#()(?(DEFINE)(?<t>a))"
::~["bac"]
::~
:::^  %has-match  "(?&t)(?#()(?(DEFINE)(?<t>a))"
::~["bac"]
::~
:::^  %has-match  "(?&t)(?#()(?(DEFINE)(?<t>a))"
::~["bac"]
::~
::::
:::^  %has-match  "^.*? (?:a(*THEN)b) c/"
::~["aabc"]
::~
::::
:::^  %has-match  "^.*? (?:a(*THEN)b|(*F)) c/"
::~["aabc"]
::~
::::
:::^  %has-match  "^.*? (?: (?:a(*THEN)b) | (*F) ) c/"
::~["aabc"]
::~
::::
:::^  %has-match  "^.*? (?: (?:a(*THEN)b) ) c/"
::~["aabc"]
::~
:::^  %has-match  "^.*? (?: (?:a(*THEN)b) ) c/"
::~["aabc"]
::~
::::
:::^  %has-match  "^.*? (a(*THEN)b)++ c/"
::~["aabc"]
::~
::::
:::^  %has-match  "^.*? (a(*THEN)b|(*F))++ c/"
::~["aabc"]
::~
::::
:::^  %has-match  "^.*? ( (a(*THEN)b)++ | (*F) )++ c/"
::~["aabc"]
::~
::::
:::^  %has-match  "^.*? ( (a(*THEN)b)++ )++ c/"
::~["aabc"]
::~
:::^  %has-match  "^.*? ( (a(*THEN)b)++ )++ c/"
::~["aabc"]
::~
::::
:::^  %has-match  "^(?(?=a(*THEN)b)ab|ac)"
::~["ac" ""]
::~
::::
:::^  %has-match  "^.*(?=a(*THEN)b)/ "
::~
::~
:::^  %has-match  "^.*(?=a(*THEN)b)/ "
::~
::~
::::
:::^  %has-match  "A(*MARK:A)A+(*SKIP)(B|Z) | AC/x"
::~["AAAC"]
::~
:::^  %has-match  "A(*MARK:A)A+(*SKIP)(B|Z) | AC/x"
::~["AAAC"]
::~
::::
:::^  %has-match  "A(*MARK:A)A+(*SKIP:)(B|Z) | AC/x"
::~["AAAC"]
::~
:::^  %has-match  "A(*MARK:A)A+(*SKIP:)(B|Z) | AC/x"
::~["AAAC"]
::~
::::
::::
::::
:::^  %has-match  "^(A(*PRUNE:A)B|C(*PRUNE:B)D)/"
::~["AB" "CD" "** Failers" "AC" "CB    " ""]
::~
::::
:::^  %has-match  "^(A(*PRUNE:)B|C(*PRUNE:B)D)/"
::~["AB" "CD "]
::~
:::^  %has-match  "^(A(*PRUNE:)B|C(*PRUNE:B)D)/"
::~["AB" "CD "]
::~
::::
::::
:::^  %has-match  "b(*:m)f|a(*:n)w/"
::~["aw " "** Failers " "abc"]
::~
::::
:::^  %has-match  "b(*:m)f|aw/"
::~["abaw" "** Failers " "abc" "abax "]
::~
::::
:::^  %has-match  "A(*MARK:A)A+(*SKIP:B)(B|Z) | AAC/x"
::~["AAAC"]
::~
::::
:::^  %has-match  "a(*PRUNE:X)bc|qq/K"
::~["** Failers" "axy"]
::~
::::
:::^  %has-match  "a(*THEN:X)bc|qq/K"
::~["** Failers" "axy"]
::~
::::
:::^  %has-match  "(?=a(*MARK:A)b)..x/"
::~["abxy" "** Failers" "abpq  "]
::~
::::
:::^  %has-match  "(?=a(*MARK:A)b)..(*:Y)x/"
::~["abxy" "** Failers" "abpq  "]
::~
::::
:::^  %has-match  "(?=a(*PRUNE:A)b)..x/"
::~["abxy" "** Failers" "abpq  "]
::~
::::
:::^  %has-match  "(?=a(*PRUNE:A)b)..(*:Y)x/"
::~["abxy" "** Failers" "abpq  "]
::~
::::
:::^  %has-match  "(?=a(*THEN:A)b)..x/"
::~["abxy" "** Failers" "abpq  "]
::~
::::
:::^  %has-match  "(?=a(*THEN:A)b)..(*:Y)x/"
::~["abxy" "** Failers" "abpq  "]
::~
::::
:::^  %has-match  "(another)?(\\01?)test"
::~["hello world test"]
::~
::::
:::^  %has-match  "(another)?(\\01+)test"
::~["hello world test"]
::~
::::
:::^  %has-match  "(a(*COMMIT)b)\{0}a(?1)|aac"
::~["aac"]
::~
::::
:::^  %has-match  "((?:a?)*)*c"
::~["aac   "]
::~
::::
:::^  %has-match  "((?>a?)*)*c"
::~["aac   "]
::~
::::
:::^  %has-match  "(?>.*?a)(?<=ba)"
::~["aba"]
::~
::::
:::^  %has-match  "(?:.*?a)(?<=ba)"
::~["aba"]
::~
::::
:::^  %has-match  ".*?a(*PRUNE)b"
::~["aab"]
::~
::::
:::^  %has-match  ".*?a(*PRUNE)b/"
::~["aab"]
::~
::::
:::^  %has-match  "^a(*PRUNE)b/"
::~["aab"]
::~
::::
:::^  %has-match  ".*?a(*SKIP)b"
::~["aab"]
::~
::::
:::^  %has-match  "(?>.*?a)b/"
::~["aab"]
::~
::::
:::^  %has-match  "(?>.*?a)b"
::~["aab"]
::~
::::
:::^  %has-match  "(?>^a)b/"
::~["aab"]
::~
::::
:::^  %has-match  "(?>.*?)(?<=(abcd)|(wxyz))"
::~["alphabetabcd" "endingwxyz "]
::~
::::
:::^  %has-match  "(?>.*)(?<=(abcd)|(wxyz))"
::~["alphabetabcd" "endingwxyz "]
::~
:::^  %has-match  "(?>.*)(?<=(abcd)|(wxyz))"
::~["alphabetabcd" "endingwxyz " "abcdfooxyz" "" "abcdfooxyz"]
::~
::::
::::
:::^  %has-match  "(?:(a(*SKIP)b))\{0}(?:(?1)|ac)"
::~["ac "]
::~
::::
:::^  %has-match  "(?<=(*SKIP)ac)a"
::~["aa"]
::~
::::
:::^  %has-match  "A(*MARK:A)A+(*SKIP:B)(B|Z) | AC/x"
::~["AAAC"]
::~
::::
:::^  %has-match  "a(*SKIP:m)x|ac(*:n)(*SKIP:n)d|ac/"
::~["acacd"]
::~
::::
:::^  %has-match  "A(*SKIP:m)x|A(*SKIP:n)x|AB/"
::~["AB"]
::~
::::
:::^  %has-match  "((*SKIP:r)d)\{0}a(*SKIP:m)x|ac(*:n)|ac/"
::~["acacd"]
::~
:::^  %has-match  "((*SKIP:r)d)\{0}a(*SKIP:m)x|ac(*:n)|ac/"
::~["acacd"]
::~
:::^  %has-match  "((*SKIP:r)d)\{0}a(*SKIP:m)x|ac(*:n)|ac/"
::~["acacd"]
::~
::::
:::^  %has-match  "aaaaa(*PRUNE)b|a+c"
::~["aaaaaac"]
::~
:::^  %has-match  "aaaaa(*PRUNE)b|a+c"
::~["aaaaaac"]
::~
::::
:::^  %has-match  "aaaaa(*SKIP)(*PRUNE)b|a+c"
::~["aaaaaac"]
::~
::::
:::^  %has-match  "aaaaa(*SKIP:N)(*PRUNE)b|a+c"
::~["aaaaaac"]
::~
::::
:::^  %has-match  "aaaa(*:N)a(*SKIP:N)(*PRUNE)b|a+c"
::~["aaaaaac"]
::~
:::^  %has-match  "aaaa(*:N)a(*SKIP:N)(*PRUNE)b|a+c"
::~["aaaaaac"]
::~
::::
:::^  %has-match  "aaaaa(*COMMIT)(*PRUNE)b|a+c"
::~[""]
::~
:::^  %has-match  "aaaaa(*COMMIT)(*PRUNE)b|a+c"
::~[""]
::~
::::
:::^  %has-match  "aaaaa(*SKIP)b|a+c"
::~["aaaaaac" ""]
::~
::::
:::^  %has-match  "aaaaa(*THEN)(*SKIP)b|a+c"
::~["aaaaaac"]
::~
:::^  %has-match  "aaaaa(*THEN)(*SKIP)b|a+c"
::~["aaaaaac"]
::~
::::
:::^  %has-match  "aaaaa(*COMMIT)b|a+c"
::~["aaaaaac" ""]
::~
:::^  %has-match  "aaaaa(*COMMIT)b|a+c"
::~["aaaaaac" ""]
::~
::::
:::^  %has-match  "aaaaa(*THEN)b|a+c"
::~["aaaaaac"]
::~
:::^  %has-match  "aaaaa(*THEN)b|a+c"
::~["aaaaaac"]
::~
::::
:::^  %has-match  "aaaaa(*PRUNE)(*THEN)b|a+c"
::~["aaaaaac" ""]
::~
::::
:::^  %has-match  "aaaaa(*:m)(*PRUNE:m)(*SKIP:m)m|a+"
::~["aaaaaa"]
::~
::::
:::^  %has-match  "aaaaa(*:m)(*MARK:m)(*PRUNE)(*SKIP:m)m|a+"
::~["aaaaaa"]
::~
::::
:::^  %has-match  "aaaaa(*:n)(*PRUNE:m)(*SKIP:m)m|a+"
::~["aaaaaa"]
::~
::::
:::^  %has-match  "aaaaa(*:n)(*MARK:m)(*PRUNE)(*SKIP:m)m|a+"
::~["aaaaaa"]
::~
::::
:::^  %has-match  "a(*MARK:A)aa(*PRUNE:A)a(*SKIP:A)b|a+c"
::~["aaaac"]
::~
::::
:::^  %has-match  "a(*MARK:A)aa(*MARK:A)a(*SKIP:A)b|a+c"
::~["aaaac"]
::~
::::
:::^  %has-match  "aaa(*PRUNE:A)a(*SKIP:A)b|a+c"
::~["aaaac"]
::~
::::
:::^  %has-match  "aaa(*MARK:A)a(*SKIP:A)b|a+c"
::~["aaaac"]
::~
::::
:::^  %has-match  "a(*:m)a(*COMMIT)(*SKIP:m)b|a+c/"
::~["aaaaaac"]
::~
::::
:::^  %has-match  ".?(a|b(*THEN)c)"
::~["ba"]
::~
::::
:::^  %has-match  "(a(*COMMIT)b)c|abd"
::~["abc" "abd"]
::~
::::
:::^  %has-match  "(?=a(*COMMIT)b)abc|abd"
::~["abc" "abd"]
::~
::::
:::^  %has-match  "(?>a(*COMMIT)b)c|abd"
::~["abc" "abd"]
::~
::::
:::^  %has-match  "a(?=b(*COMMIT)c)[^d]|abd"
::~["abd" "abc "]
::~
::::
::::
:::^  %has-match  "a(?>b(*COMMIT)c)d|abd"
::~["abceabd "]
::~
::::
:::^  %has-match  "a(?>bc)d|abd"
::~["abceabd "]
::~
::::
:::^  %has-match  "(?>a(*COMMIT)b)c|abd"
::~["abd"]
::~
::::
:::^  %has-match  "(?>a(*COMMIT)c)d|abd"
::~["abd"]
::~
::::
::::
:::^  %has-match  "^(a)?(?(1)a|b)+$"
::~
::~["a"]
::::
:::^  %has-match  "(?=a\\Kb)ab"
::~["ab "]
::~
::::
::::
:::^  %has-match  "^abc(?<=b\\Kc)d"
::~["abcd"]
::~
::::
:::^  %has-match  "^abc(?<!b\\Kq)d"
::~["abcd"]
::~
:::^  %has-match  "^abc(?<!b\\Kq)d"
::~["abcd"]
::~
::::
:::^  %has-match  "A(*PRUNE:A)A+(*SKIP:A)(B|Z) | AC/x"
::~["AAAC"]
::~
::::
::::
:::^  %has-match  "^((yes|no)(*THEN)(*F))?"
::~["yes"]
::~
::::
:::^  %has-match  "(A (.*)   C? (*THEN)  | A D) (*FAIL)/"
::~
::~
::::
:::^  %has-match  "(A (.*)   C? (*THEN)  | A D) z/"
::~
::~
::::
:::^  %has-match  "(A (.*)   C? (*THEN)  | A D) \\s* (*FAIL)/"
::~
::~
::::
:::^  %has-match  "(A (.*)   C? (*THEN)  | A D) \\s* z/"
::~
::~
::::
:::^  %has-match  "(A (.*)   (?:C|) (*THEN)  | A D) (*FAIL)/"
::~
::~
::::
:::^  %has-match  "(A (.*)   (?:C|) (*THEN)  | A D) z/"
::~
::~
::::
:::^  %has-match  "(A (.*)   C\{0,6} (*THEN)  | A D) (*FAIL)/"
::~
::~
::::
:::^  %has-match  "(A (.*)   C\{0,6} (*THEN)  | A D) z/"
::~
::~
::::
:::^  %has-match  "(A (.*)   (CE)\{0,6} (*THEN)  | A D) (*FAIL)/"
::~
::~
::::
:::^  %has-match  "(A (.*)   (CE)\{0,6} (*THEN)  | A D) z/"
::~
::~
::::
:::^  %has-match  "(A (.*)   (CE*)\{0,6} (*THEN)  | A D) (*FAIL)/"
::~
::~
::::
:::^  %has-match  "(A (.*)   (CE*)\{0,6} (*THEN)  | A D) z/"
::~
::~
::::
:::^  %has-match  "(?=a(*COMMIT)b|ac)ac|ac"
::~["ac"]
::~
::::
:::^  %has-match  "(?=a(*COMMIT)b|(ac)) ac | (a)c/"
::~["ac"]
::~
==
