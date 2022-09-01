:: Todo:
:: - User interface with convenience functions
:: - Unicode (integrate with `calf` type)
:: - Anchors
:: - Greedy, non-greedy and possessive repetition
:: - Escape codes
:: - Leftmost-longest matching
:: - Case-insensitive matching
:: - Character classes
:: - Lookaround
:: - Capture only the first instance of a repeated capture group
:: - Start match after a certain point
:: - Test suite

!:  !?  140

=|  tex=tape
|%
+$  mast  (map @ud [p=pint q=tape])
+$  edgt  [p=mast q=nail]
+$  mist  (list edgt)
+$  rult  _^|(|:($:edgt $:mist))
+$  fret  [p=[p=@ud q=(unit @ud)] q=(unit ?(%'?' %'+'))]
++  cont
  :: Concatenate two regular expressions
  |=  [a=rult b=rult]  ^-  rult
  |=  [vex=edgt]  ^-  mist
  =+  mix=(a vex)
  |-  ^-  mist
  ?~  mix  mix
  (weld (b i.mix) $(mix t.mix))
++  salt
  :: Alternate two regular expressions
  |=  [a=rult b=rult]  ^-  rult
  |=  [vex=edgt]  ^-  mist
  (weld (a vex) (b vex))
++  capt
  :: Capture matched text
  |=  [n=@ud a=rult]  ^-  rult
  |=  [vex=edgt]  ^-  mist
  %+  turn  (a vex)
  |=  [yit=edgt]  ^-  edgt
  =+  lit=`pint`[p.q.vex p.q.yit]
  [(~(put by p.yit) n lit (lint lit tex)) q.yit]
++  gist
  :: `jest` but for tapes
  |=  [tap=tape]  ^-  rult
  |=  [vex=edgt]  ^-  mist
  ?~  tap  ~[vex]
  ?~  q.q.vex  ~
  ?:  !=(i.tap i.q.q.vex)  ~
  $(tap t.tap, q.vex [(lust i.q.q.vex p.q.vex) t.q.q.vex])
++  loot
  :: Turn a regex into a lookaround expression
  :: - positive, ahead:  (loot %.y %.y a)
  :: - positive, behind: (loot %.y %.n a)
  :: - negative, ahead:  (loot %.n %.y a)
  :: - negative, behind: (loot %.n %.n a)
  |=  [pos=? for=? a=rult]
  |=  [vex=edgt]  ^-  mist
  ?:  for
    =+  yit=(a vex)
    ?~  yit
      ?:(pos yit ~[vex])
    ?:(pos ~[vex] yit)
  ~&  "Lookbehind! tex={tex}"
  ~  :: todo: lookbehind
  :: strategy: run `a` on `tex` and see if any masts end on `p.q.vex`
++  stut
  :: Ranged repetition (see +$fret)
  :: todo: make sure each repetition matches at least one char, to prevent infinite loops
  |=  [a=rult fet=fret]  ^-  rult
  a
::  =+  n=`@ud`0
::  ?~  q.fet  :: greedy repetition
::    |=  [vex=edgt]  ^-  mist
::    ?:  (lth n p.p.fet)
::      (roll weld (turn (a vex) .(n +(n)))
::    ?~  q.p.fet
::      [vex (roll weld (turn (a vex) .))]
::    ?:  =(n u.q.p.fet)  ~[vex]
::    [vex (roll weld (turn (a vex) .(n +(n))))]
::  ?-  u.q.fet
::      %'?'
::    a  :: todo: non-greedy repetition
::      %'+'
::    a  :: todo: possessive repetitition
::  ==
++  bart
  :: Backreference
  |=  [n=@ud]  ^-  rult
  ~&  [%bart n]
  |=  [vex=edgt]  ^-  mist
  =+  mat=(~(get by p.vex) n)
  ~&  [%bart n mat]
  ?~  mat  ~
  ((gist q.u.mat) vex)
++  past
  :: Compare two hairs (p < q)
  |=  [p=hair q=hair]
  |((lth p.p p.q) &(=(p.p p.q) (lth q.p q.q)))
++  lint
  ::  Cut a tape from hair to hair
  |=  [har=pint wat=tape]  ::^-  tape
  ~&  [%lint har=har wat=wat]
  =+  wer=`hair`[1 1]
  =+  mid=`tape`wat
  |-
  ?~  mid  ~
  ?:  (past wer p.har)
    $(wer (lust i.mid wer), mid t.mid)
  (lant q.har wer mid)
++  lant
  ::  Cut a nail after a certain hair
  |=  [til=hair tub=nail]
  =+  beh=`tape`~
  |-
  ?:  (past p.tub til)
    ?~  q.tub  ~
    $(tub [(lust i.q.tub p.tub) t.q.tub], beh [i.q.tub beh])
  (flop beh)
::
++  purse  |=([reg=tape] `(unit rult)`(rust reg top))
++  parse  |=([reg=tape] `rult`(scan reg top))
++  run
  |=  [reg=tape tix=tape]
  =+  per=(parse reg)
  =.  tex  tix
  ((parse reg) [~ [1 1] tix])
::
++  top
  %+  knee  *rult
  |.  ~+
  ;~  simu  next
    %+  cook
      |=  [a=rult b=(unit rult)]
      ?~(b a (salt a u.b))
    ;~(plug mid (punt ;~(pfix bar top)))
  ==
++  mid
  %+  knee  *rult
  |.  ~+
  ;~  pose
    (cook cont ;~(plug bot mid))
    nil
  ==
++  bot
  %+  knee  *rult
  |.  ~+
  %+  cook
    |=  [a=rult b=(unit fret)]
    ?~  b  a
    (stut a u.b)
  ;~(plug elm (punt rep))
++  elm
  ;~(pose lit any bak cap)
++  cap
  %+  knee  *rult
  |.  ~+
  (cook (cury capt 1) (ifix [pal par] top))
  :: todo: correct capture numbering
++  rep
  ;~  plug
    ;~  pose
      (cold [0 `1] wut)
      (cold [0 ~] tar)
      (cold [1 ~] tar)
    ::
      ;~  plug
        %+  ifix  [kel ker]
        ;~  pose
          ;~(plug dem (easy ~) ;~(pfix com dem))
          (cook |=([n=@ud] [n `n]) dem)
          (cook |=([n=@ud] [0 `n]) ;~(pfix com dem))
          ::   todo: is /a{,}/ a legitimate regular expression?
        ==
      ==
    ==
  ::
    (punt (perk ~[%'?' %'+']))
  ==
++  met  (mask "().[\{*?+|\\")
++  asc  ;~(plug ;~(less met (shim 1 127)) (easy ~))
++  utf  ;~(plug (shim 192 255) (star (shim 128 255)))
  :: note: this accepts malformed utf8
++  oor  ;~(plug (shim 128 191) (easy ~))
++  cha  ;~(pose asc utf oor)
++  nil  (cold |=([vex=edgt] ~[vex]) (easy ~))
++  lit  (cook gist cha)
::  todo: make lit less slow by absorbing all non-repeated chars into one tape
++  any
  %-  cold
  :_  dot
  |=  [vex=edgt]  ^-  mist
  ?~  q.q.vex  ~
  =+  yit=(cha q.vex)
  ?~  q.yit  ~
  ?:  =('\0a' i.q.q.vex)  ~
  [p.vex q.u.q.yit]~
++  bak
  (cook bart ;~(pfix bas ;~(less (jest '0') dit)))
--
