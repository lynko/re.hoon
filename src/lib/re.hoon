:: Todo:
:: - More convenience functions
:: - Escape codes
:: - Non-greedy ("hesitant") repetition
:: - Leftmost-longest matching
:: - Case-insensitive matching
:: - Character classes
:: - Test suite

:: Store the previous character in +$edgt to simplify ^, \b, etc

/+  l10n
!:  !?  140

::=>
=+  calf=calf:ul:l10n

=<
|%
+$  match  [p=(map @ud [p=pint q=tape]) q=[p=pint q=tape]]
::
++  purse
  |=  [reg=tape]  ^-  (unit rult)
  =.  rig  `tape``(list @)`(lasso:ul:l10n reg)
  (rust rig top)
++  parse
  |=  [reg=tape]  ^-  rult
  =.  rig  `tape``(list @)`(lasso:ul:l10n reg)
  (scan rig top)
::
++  run
  :: Get the first match of a regular expression
  |=  [reg=tape tix=tape]  ^-  (unit match)
  =+  wer=`hair`[1 1]
  =+  tax=tix
  |-
  =+  res=(ran reg tix wer)
  ?~  res
    ?~  tax  ~
    $(wer (lust i.tax wer), tax t.tax)
  res
++  ran
  :: Get the first match after a certain point
  |=  [reg=tape tix=tape wer=hair]  ^-  (unit match)
  =.  tex  `tape``(list @)`(lasso:ul:l10n tix)
  (left ((capt 0 (parse reg)) ~ wer (whet wer tex)))
::++  all
::  :: Get all matches
::  |=  [reg=tape tix=tape]  ^-  (list match)
::  =|  lis=(list match)
::  =+  wer=`hair`[1 1]
::  =.  tix  `tape``(list @)`(lasso:ul:l10n tix)
::  |-
::  =+  res=(ran reg tix wer)
::  ?~  res  (flop lis)
::  $(wer q.p.q.i.res, lis [res lis])
++  left
  :: Choose the leftmost longest match
  |=  [mix=mist]  ^-  (unit match)
  :: todo: actually choose leftmost-longest, not just the first one
  ::mix
  ?~  mix  ~
  `[p.i.mix (~(got by p.i.mix) 0)]
--

::=|  tex=tape  :: the text being searched
::=|  ins=?  :: are we case-insensitive?
=|  [rig=tape tex=tape ins=?]
|%
+$  mast  (map @ud [p=pint q=tape])
+$  edgt  [p=mast q=nail]
+$  mist  (list edgt)
+$  rult  _^|(|:($:edgt $:mist))
+$  fret  [p=[p=@ud q=(unit @ud)] q=(unit ?(%'?' %'+'))]
+$  posix-class
  $?  %ascii
      %lower
      %upper
      %word
  ==
::+$  belt
::  $:  p=(set @t)  :: individual characters
::      q=(list [lo=@t hi=@t])
::      r=(list posix-class)
::  ==
+$  belt  (list ?(@ta [p=@ta q=@ta]))
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
  ?:  (~(has by p.yit) n)  yit
  =+  lit=`pint`[p.q.vex p.q.yit]
  [(~(put by p.yit) n lit (lint lit [1 1] tex)) q.yit]
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
  :: - positive, ahead:  (loot %.n %.n a)
  :: - positive, behind: (loot %.y %.n a)
  :: - negative, ahead:  (loot %.n %.y a)
  :: - negative, behind: (loot %.y %.y a)
  |=  [bak=? neg=? a=rult]
  |=  [vex=edgt]  ^-  mist
  ?.  bak
    =+  yit=(a vex)
    ?~  yit
      ?:(neg ~[vex] yit)
    ?:(neg yit ~[vex])
  =+  tub=`nail`[[1 1] tex]
  |-
  ?~  q.tub
    ?:(neg ~[vex] ~)
  ?.  (past p.tub p.q.vex)
    ?:(neg ~[vex] ~)
  =+  mix=(a [~ tub])
  |-
  ?~  mix  ^$(tub [(lust i.q.tub p.tub) t.q.tub])
  ?:  =(p.q.i.mix p.q.vex)
    ?:(neg ~ ~[vex])
  $(mix t.mix)
  ::~  :: todo: lookbehind
  :: strategy: run `a` on `tex` and see if any masts end on `p.q.vex`
++  cart
  :: Fixed repetition
  |=  [a=rult n=@ud]  ^-  rult
  =|  m=@ud
  |=  [vex=edgt]  ^-  mist
  ?:  =(m n)  ~[vex]
  =+  mix=(a vex)
  |-  ^-  mist
  ?~  mix  mix
  ?:  =(p.q.i.mix p.q.vex)
    $(mix t.mix)
  (weld ^$(vex i.mix, m +(m)) $(mix t.mix))
++  mart
  :: Unbounded repetition
  |=  [a=rult]  ^-  rult
  |=  [vex=edgt]  ^-  mist
  :-  vex
  =+  mix=(a vex)
  |-  ^-  mist
  ?~  mix  mix
  ?:  =(p.q.i.mix p.q.vex)
    $(mix t.mix)
  (weld ^$(vex i.mix) $(mix t.mix))
++  dart
  :: Bounded repetition
  |=  [a=rult n=@ud]  ^-  rult
  =|  m=@ud
  |=  [vex=edgt]  ^-  mist
  ?:  =(m n)  ~[vex]
  :-  vex
  =+  mix=(a vex)
  |-  ^-  mist
  ?~  mix  mix
  ?:  =(p.q.i.mix p.q.vex)
    $(mix t.mix)
  (weld ^$(vex i.mix, m +(m)) $(mix t.mix))
++  welt
  :: Unbounded repetition, possessive
  |=  [a=rult]  ^-  rult
  |=  [vex=edgt]  ^-  mist
  =+  mix=(a vex)
  ?:  |-  ^-  ?
      ?~  mix  %.y
      ?:  =(p.q.i.mix p.q.vex)
        $(mix t.mix)
      %.n
    ~[vex]
  |-  ^-  mist
  ?~  mix  mix
  ?:  =(p.q.i.mix p.q.vex)
    $(mix t.mix)
  (weld ^$(vex i.mix) $(mix t.mix))
++  pelt
  :: Bounded repetition, possessive
  |=  [a=rult n=@ud]  ^-  rult
  =|  m=@ud
  |=  [vex=edgt]  ^-  mist
  ?:  =(m n)  ~[vex]
  =+  mix=(a vex)
  ?~  mix  ~[vex]
  %.  mix
  |=  [mix=mist]  ^-  mist
  ?~  mix  mix
  ?:  =(p.q.i.mix p.q.vex)
    $(mix t.mix)
  (weld ^$(vex i.mix, m +(m)) $(mix t.mix))
++  stut
  :: Ranged repetition (see +$fret)
  :: todo: make sure each repetition matches at least one char, to prevent infinite loops
  |=  [a=rult fet=fret]  ^-  rult
  ?~  q.fet
    :: greedy repetition
    %+  cont  (cart a p.p.fet)
    ?~  q.p.fet
      (mart a)
    (dart a (sub u.q.p.fet p.p.fet))
  ?-  u.q.fet
      %'?'
    a  :: todo: non-greedy repetition
      %'+'
    :: possessive repetition
    %+  cont  (cart a p.p.fet)
    ?~  q.p.fet  (welt a)
    (pelt a (sub u.q.p.fet p.p.fet))
  ==
++  rant
  :: Tell if an atom is in a certain range
  |=  [n=@ a=@ b=@]  ^-  ?
  &((gte n a) (lte n b))
++  flit
  :: Turn a set of characters and ranges into a character class regex
  |=  [neg=? bil=belt]  ^-  rult
  |=  [vex=edgt]  ^-  mist
  ?~  q.q.vex  ~
  =*  yit  ~[vex(p.q (lust i.q.q.vex p.q.vex), q.q t.q.q.vex)]
  |-  ^-  mist
  ?~  bil  ~
  ?@  i.bil
    ?:  !=(=(i.bil i.q.q.vex) neg)  yit
    $(bil t.bil)
  ?:  !=((rant i.q.q.vex i.bil) neg)  yit
  $(bil t.bil)
++  bart
  :: Backreference
  |=  [n=@ud]  ^-  rult
  |=  [vex=edgt]  ^-  mist
  =+  mat=(~(get by p.vex) n)
  ?~  mat  ~
  ((gist q.u.mat) vex)
++  past
  :: Compare two hairs (p < q)
  |=  [p=hair q=hair]
  |((lth p.p p.q) &(=(p.p p.q) (lth q.p q.q)))
++  whet
  ::  Get the tail after a certain hair
  |=  [har=hair wat=tape]  ^-  tape
  =+  wer=`hair`[1 1]
  =+  mid=`tape`wat
  |-
  ?~  mid  ~
  ?.  (past wer har)  mid
  $(wer (lust i.mid wer), mid t.mid)
++  lint
  ::  Cut a nail from hair to hair
  |=  [har=pint wat=nail]  ^-  tape
  ?~  q.wat  q.wat
  ?:  (past p.wat p.har)
    $(wat [(lust i.q.wat p.wat) t.q.wat])
  (lant q.har wat)
++  lant
  ::  Cut a nail after a certain hair
  |=  [til=hair tub=nail]  ^-  tape
  =+  beh=`tape`~
  |-
  ?:  (past p.tub til)
    ?~  q.tub  (flop beh)
    $(tub [(lust i.q.tub p.tub) t.q.tub], beh [i.q.tub beh])
  (flop beh)
::
::  Parser functions
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
  ;~(pose lit any cla kan ban bak cap luk)
++  cap
  %+  knee  *rult
  |.  ~+
  %+  ifix  [pal par]
  %+  cook
    |=  [har=hair rul=rult]  ^-  rult
    =/  n=@ud
      =|  n=@ud
      =+  wer=`hair`[1 1]
      |-
      ?~  rig  n
      ?:  (past har wer)  n
      %=  $
        rig  t.rig
        wer  (lust i.rig wer)
        n    ?:(=('(' i.rig) +(n) n)
      ==
    (capt n rul)
  ;~(plug (here |=([p=pint ~] p.p) (easy ~)) top)
++  rep
  ;~  plug
    ;~  pose
      (cold [0 `1] wut)
      (cold [0 ~] tar)
      (cold [1 ~] lus)
      ;~  plug
        %+  ifix  [kel ker]
        %+  cook
          |=  [p=@ud q=(unit @ud)]
          ?~  q  [p q]
          ?>  (lte p u.q)  [p q]
        ;~  pose
          ;~(plug dem (easy ~) ;~(pfix com dem))
          (cook |=([n=@ud] [n `n]) dem)
          (cook |=([n=@ud] [0 `n]) ;~(pfix com dem))
          ::   todo: is /a{,}/ a legitimate regular expression?
        ==
      ==
    ==
    (punt (perk ~[%'?' %'+']))
  ==
::
:: Miniature parsers
::
++  met  (mask "^$().[\{*?+|\\")
++  nel  (jest '\0a')
++  cha  ;~(less met next)
++  nil  (cold `rult`|=([vex=edgt] ~[vex]) (easy ~))
::
::  Middle-sized parsers
::
++  lit  :: literal character
  %-  cook
  :_  cha
  |=  [c=@t]
  |=  [vex=edgt]  ^-  mist
  ?~  q.q.vex  ~
  ?.  =(c i.q.q.vex)  ~
  ~[vex(q [(lust c p.q.vex) t.q.q.vex])]
::  todo: make lit less slow by absorbing all non-repeated chars into one tape
++  any  :: . (any character except newline)
  %-  cold
  :_  dot
  |=  [vex=edgt]  ^-  mist
  ?~  q.q.vex  ~
  ?:  =('\0a' i.q.q.vex)  ~
  [p.vex [p.p.q.vex +(q.p.q.vex)] t.q.q.vex]~
++  kan  :: ^ anchor
  %-  cold  :_  ket
  |=  [vex=edgt]  ^-  mist
  =+  lan=(flop (lant p.q.vex [1 1] tex))
  ?~  lan  ~[vex]
  ?:  =(i.lan '\0a')  ~[vex]
  ~
++  ban  :: $ anchor
  %-  cold  :_  buc
  |=  [vex=edgt]  ^-  mist
  ?~  q.q.vex  ~[vex]
  ?:  =('\0a' i.q.q.vex)  ~[vex]
  ~
++  cla  :: character class (incomplete)
  %+  ifix  [sel ser]
  %+  cook  flit
  ;~(plug (fuss '^' '') (star cel))
++  cel  :: character class element
  ;~  pose
    ;~(plug cha ;~(pfix hep ;~(less ser cha)))
  ::
    cha
  ::
    ::%+  ifix  [;~(plug sel col) ;~(plug col sel)]
    ::(perk ~[%ascii %lower %upper %word])
  ==
++  bak  :: backreference
  (cook bart ;~(pfix bas ;~(less (jest '0') dit)))
++  chi  :: character, case-insensitive
  %-  cook
  :_  cha
  |=  [c=@t]
  =+  d=(~(get by cass-map:ul:l10n) c)
  =.  c  ?~(d c u.d)
  |=  [vex=edgt]  ^-  mist
  ?~  q.q.vex  ~
  ?.  =(c i.q.q.vex)  ~
  ~[vex(q [(lust c p.q.vex) t.q.q.vex])]
::
++  esc  :: escape code
  ;~  pfix  bas
    ;~  pose
      (cold (gist "\0a") (jest 'n'))
      (cook (cork trip gist) met)
    ==
  ==
::
++  luk  :: lookaround expression
  %+  ifix  [pal par]
  %+  cook  loot
  ;~  pfix  wut
    ;~  plug
      (fuss '<' '')
      (fuss '!' '=')
      top
    ==
  ==
::
--
