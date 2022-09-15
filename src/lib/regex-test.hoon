/+  regex
|%
+$  has-match-case
  $:  pattern=tape
      pass=(list tape)
      fail=(list tape)
  ==
+$  capture-groups-case
  $:  pattern=tape
      subject=tape
      captures=(list [p=@ud q=tape])
  ==
+$  parse-failure-case
  pattern=tape
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
    ~&  =+  total=(scow %ud (add passes failures))
        %+  weld  "Finished tests. "
        %+  weld  "Failed {(scow %ud failures)}/{total} "
        "(passed {(scow %ud passes)})"
    ~
  ::~&  [%run -.i.lis +<.i.lis]
  ?-  -.i.lis
      %has-match
    ~|  "regex was:  /{pattern.i.lis}/"
    ?~  (valid:regex pattern.i.lis "")
      ~&  "failed to parse regex:  /{pattern.i.lis}/"
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
      ?~  (run:regex pattern.i.lis i.fail.i.lis)
        $(fail.i.lis t.fail.i.lis, passes +(passes))
      ~&  "failed:  /{pattern.i.lis}/ !~ {~(rt at (crip i.fail.i.lis))}"
      $(fail.i.lis t.fail.i.lis, failures +(failures))
    ?~  (run:regex pattern.i.lis i.pass.i.lis)
      ~&  "failed:  /{pattern.i.lis}/ ~~ {~(rt at (crip i.pass.i.lis))}"
      $(pass.i.lis t.pass.i.lis, failures +(failures))
    $(pass.i.lis t.pass.i.lis, passes +(passes))
  ::
      %capture-groups
    ~|  "regex was:  /{pattern.i.lis}/"
    ?~  (valid:regex pattern.i.lis "")
      ~&  "failed to parse regex:  /{pattern.i.lis}/"
      $(lis t.lis, failures +(failures))
    =+  mat=(run:regex pattern.i.lis subject.i.lis)
    ?~  mat
      ~&  "failed:  /{pattern.i.lis}/ ~~ {~(rt at (crip subject.i.lis))}"
      $(lis t.lis, failures +(failures))
    =/  gur=(list (pair @u tape))
      %+  sort
        (turn ~(tap by q.u.mat) |=([p=@ q=range:regex] [p q.q]))
      |=  [a=(pair @u tape) b=(pair @u tape)]
      (lth p.a p.b)
    ?.  =(gur captures.i.lis)
      ~&  "wrong grouping:  /{pattern.i.lis}/ ~~ {~(rt at (crip subject.i.lis))}"
      ~&  [%need captures.i.lis]
      ~&  [%have gur]
      $(lis t.lis, failures +(failures))
    $(lis t.lis)
  ::
      %parse-failure
    ?~  (valid:regex pattern.i.lis "")
      $(lis t.lis, passes +(passes))
    ~&  "failed:  /{pattern.i.lis}/ parsed but it shouldn't have"
    $(lis t.lis, failures +(failures))
  ==
--
