/+  re
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
++  run
  |=  [lis=(list test-case)]
  ?~  lis  ~
  =+  ~|  "regex was:  /{reg.i.lis}/"
      ?~  (purse:re reg.i.lis)
        ~&  "failed to parse regex:  /{reg.i.lis}/"
        ~
      ?-  -.i.lis
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
