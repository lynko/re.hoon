::
::  To be an implementation of PCRE; to be jetted later.  See NOTES.md.
::


!:
!?  140


::
::  This part is the developer interface.
::
=<  =>  ::  If I put this in the other core, the compiler hangs.  Why?
    |%
    ::
    ::  Different from below; contains a cord rather than a tape.
    ::
    +$  match   [a=@ z=@ txt=cord cap=(list match)]
    --
|%
    ++  crip-match
      |=  [=^match]
      ^-  ^match
      :-  a.match
      :-  z.match
      :-  (crip `tape`txt.match)
      (turn cap.match crip-match)
      ::=:  txt.match   (crip `tape`txt.match)
      ::    cap.match   (turn cap.match crip-match)
      ::  ==
      ::match
::
::  Create an AST from a cord.
::
++  parse
  |=  [=cord]
  ^-  ast
  (^parse "{(trip cord)}")
::
::  Create an initial match state from an AST.
::
++  start
  |=  [=ast =cord]
  ^-  state
  (^start ast "{(trip cord)}")
::
::  Advance a match state to the next match.
::
++  next
  |=  [=state]
  ^-  (unit [=match =^state])
  %.  (^next state)
  |=  [match=(unit [=^match =^state])]
  ?~  match  ~
  [~ (crip-match match.u.match) state.u.match]
::
::  Get the first match of a pattern.
::
++  first
  |=  [pattern=cord subject=cord]
  ^-  (unit match)
  %+  bind  (next (start (parse pattern) subject))
  |=  [=match *]  match
::
::  Get all matches of a pattern.
::
++  all
  |=  [pattern=cord subject=cord]
  ^-  (list match)
  %.  (start (parse pattern) subject)
  |=  [=state]
  =/  n=(unit [=match =^state])  (next state)
  ?~  n   ~
  [match.u.n $(state state.u.n)]
--


::
::  This part is the types.
::  TODO:  Change all instances of `tape` to `(list @)`.
::
=>  =>  ::  If I put this in the other core, the compiler hangs.  Why?
    |%
    +$  match   [a=@ z=@ txt=(list @) cap=(list match)]
    --
|%
+$  state   [wen=@ fut=tape pas=tape =ast]
::+$  match   [a=@ z=@ txt=(list @) cap=(list match)]
::+$  match   [a=@ z=@ txt=(list @)]
+$  ast
  $:  cap=?                         ::  capture this expression?
      $%  [%text txt=(list @)]      ::  text to be matched exactly
          [%list lis=(list ast)]    ::  sequence of regexes
          [%look sig=? =dir =ast]   ::  lookaround expression
          [%clas =cla]              ::  character class
          [%anch =dir all=?]        ::  anchor ^, $, \A, \Z
          [%more =ran =ast]         ::  counted repetition
          [%opts lis=(list ast)]    ::  alternation
          [%bref wix=@]             ::  backreference
          [%wall den=cla now=cla]   ::  character class boundary
      ==
  ==
+$  dir   ?(%for %bak)              ::  direction for anchor/lookaround
+$  cla   [sig=? wat=(set @)]       ::  character class
+$  ran   [les=?(@) mos=?(@)]       ::  repetition range
--


::
::  This part is the internal logic (mocked for now).
::
|%
::
::  Parse a tape into an AST.
::  Mocked:  produces an AST that matches a bogus path.
::
++  parse
  |=  [=tape]
  ^-  ast
  [& %text /paths/could/go/here]
::
::  Create an initial match state from an AST.
::
++  start
  |=  [=ast =tape]
  ^-  state
  [0 tape ~ ast]
::
::  Advance a match state to the next match.
::  Mocked:  matches '.' instead of the given AST.
::
++  next
  |=  [=state]
  ^-  (unit [=match =^state])
  ?~  fut.state  ~
  =/  n   wen.state
  :-  ~
  :-  [n +(n) ~[i.fut.state] ~]
  :::-  [n +(n) ~[i.fut.state]]
  ^-  ^state
  [+(n) t.fut.state [i.fut.state pas.state] ast.state]
--
