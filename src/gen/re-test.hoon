/+  re

:-  %say
|=  *
:-  %noun

=>
|%
+$  has-match-case
  $:  reg=tape
      pass=(list tape)
      fail=(list tape)
  ==
+$  capture-groups-case
  $:  reg=tape
      pass=(list [p=tape q=(list [p=@ud q=tape])])
  ==
+$  test-case
  $%  [%has-match has-match-case]
      [%capture-groups capture-groups-case]
  ==
++  run-tests
  |=  [lis=(list test-case)]
  ?~  lis  ~
  =+  ?-  -.i.lis
        %has-match
      |-
      ?~  pass.i.lis
        |-
        ?~  fail.i.lis  ~
        =>  ?~  (run:re reg.i.lis i.fail.i.lis)
              .
            ~&("failed:  /{reg.i.lis}/ !~ {~(rt at (crip i.fail.i.lis))}" .)
        $(fail.i.lis t.fail.i.lis)
      =>  ?~  (run:re reg.i.lis i.pass.i.lis)
            ~&("failed:  /{reg.i.lis}/ ~~ {~(rt at (crip i.pass.i.lis))}" .)
          .
      $(pass.i.lis t.pass.i.lis)
      ::
        %capture-groups
      :: todo
      ~
      ==
  $(lis t.lis)
--

%-  run-tests
:~
  [%has-match "." ~["." "a" "abc" "^" "$" "(" ")"] ~["" "\0a"]]
  [%has-match "^a" ~["a" "\0aa" "bcd\0aa"] ~["" "ba"]]
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
  :-  %has-match  :-  "(foo|ba.)\\1"
  :-  ~["foofoo" "barbar" "bazbaz"]
  ~["foobar" "barbaz"]
::
  :-  %has-match  :-  "^(11+)\\1+$"
  :-  ~["1111" "111111" "11111111" "111111111" "1111111111"]
  ~["1" "11" "111" "11111" "1111111" "11111111111" "1111111111111"]
::
==
