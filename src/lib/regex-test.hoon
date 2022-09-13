/+  regex
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
+$  parse-failure-case
  reg=tape
::
+$  generic-test-case
  $%  [%has-match has-match-case]
      [%capture-groups capture-groups-case]
      [%parse-failure parse-failure-case]
  ==
::
++  run
  |=  [lis=(list generic-test-case)]
  =|  [passes=@ud failures=@ud]
  |-
  ?~  lis
    ~&  %+  weld  "Finished tests. "
        ?:  =(0 failures)
          "Passed {(scow %ud passes)}/{(scow %ud passes)}"
        =+  total=(scow %ud (add passes failures))
        %+  weld  "Failed {(scow %ud failures)}/{total} "
        "(passed {(scow %ud passes)})"
    ~
  ::~&  [%run -.i.lis +<.i.lis]
  ?-  -.i.lis
      %has-match
    ~|  "regex was:  /{reg.i.lis}/"
    ?~  (purse:regex reg.i.lis)
      ~&  "failed to parse regex:  /{reg.i.lis}/"
      %=  $
          lis
        t.lis
          failures
        (add (add (lent pass.i.lis) (lent fail.i.lis)) failures)
      ==
    |-
    ?~  pass.i.lis
      |-
      ?~  fail.i.lis  ^^$(lis t.lis)
      ?~  (run:regex reg.i.lis i.fail.i.lis)
        $(fail.i.lis t.fail.i.lis, passes +(passes))
      ~&  "failed:  /{reg.i.lis}/ !~ {~(rt at (crip i.fail.i.lis))}"
      $(fail.i.lis t.fail.i.lis, failures +(failures))
    ?~  (run:regex reg.i.lis i.pass.i.lis)
      ~&  "failed:  /{reg.i.lis}/ ~~ {~(rt at (crip i.pass.i.lis))}"
      $(pass.i.lis t.pass.i.lis, failures +(failures))
    $(pass.i.lis t.pass.i.lis, passes +(passes))
  ::
      %capture-groups
    :: todo
    ~
      %parse-failure
    ?~  (purse:regex reg.i.lis)
      $(lis t.lis, passes +(passes))
    ~&  "failed:  /{reg.i.lis}/ parsed but it shouldn't have"
    $(lis t.lis, failures +(failures))
  ==
--
