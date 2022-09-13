!:  !?  140

|%
+$  range  [p=pint q=tape]
+$  match  [num=(map @u range) nom=(map tape range)]
--

|_  [rig=tape tex=tape cas=?]                :: match context
::
:: Types
::
+$  mast  [p=match q=nail r=(unit @t)]       :: match state
+$  mist                                     :: tree of match states
  $@  ~
  $%  [%ng ng=(list mist)] :: matches caused by a nongreedy repetition
      [%br br=(list mist)] :: matches caused by alternation or repetition
      [~ te=mast]          :: matches caused by text or character classes
  ==
+$  rult  _^|(|:($:mast $:mist))             :: analogous to `rule`
+$  rept  (unit ?(%'?' %'+'))                :: repetition mode
+$  fret  [[p=@u q=(unit @u)] r=rept]        :: repetition specifier
+$  flat  ?(@t [p=@t q=@t] [~ r=post])     :: character class element
+$  felt  [neg=? bil=(list flat)]            :: character class
+$  post
  $:  neg=?
    $?  %ascii  %alpha  %alnum  %blank
        %cntrl  %digit  %graph  %lower
        %print  %punct  %space  %upper
        %word   %xdigit
    ==
  ==
::
:: Combinators and rule builders
::
++  part
  :: Apply a rult to every mast in a mist
  |=  [mix=mist rel=rult]  ^-  mist
  %-  root
  ?~  mix  mix
  ?-  -.mix
    %ng  =.  ng.mix
           (skip (turn ng.mix (curr part rel)) |=(a=* =(~ a)))
         ?~  ng.mix  ~
         mix
  ::
    %br  =.  br.mix
           (skip (turn br.mix (curr part rel)) |=(a=* =(~ a)))
         ?~  br.mix  ~
         mix
  ::
    ~    (rel te.mix)
  ==
++  cont
  :: Concatenate two regexes
  |=  [a=rult b=rult]  ^-  rult
  |=  [mas=mast]  ^-  mist
  (part (a mas) b)
++  salt
  :: Alternate two regexes
  |=  [a=rult b=rult]  ^-  rult
  |=  [mas=mast]  ^-  mist
  [%br ~[(a mas) (b mas)]]
++  capt
  :: Capture a regular expression
  |=  [n=@u rel=rult]  ^-  rult
  |=  [mas=mast]  ^-  mist
  ?:  (~(has by num.p.mas) n)
    (rel mas)
  %+  part  (rel mas)
  |=  [mes=mast]  ^-  mist
  :-  ~
  %=  mes
      num.p
    %+  ~(put by num.p.mes)  n
    [[p.q.mas p.q.mes] (lant p.q.mes q.mas)]
  ==
++  gist
  :: `jest` but for tapes
  |=  [tap=tape]  ^-  rult
  ?:  cas
    |=  [mas=mast]  ^-  mist
    ?~  tap  `mas
    ?~  q.q.mas  ~
    ?.  =(i.tap i.q.q.mas)  ~
    $(q.mas (nixt q.mas), r.mas `i.q.q.mas, tap t.tap)
  =.  tap  (cass tap)
  |=  [mas=mast]  ^-  mist
  ?~  tap  `mas
  ?~  q.q.mas  ~
  =+  luc=(cass [i.q.q.mas ~])
  ?~  luc  ~
  ?.  =(i.tap i.luc)  ~
  $(q.mas (nixt q.mas), r.mas `i.q.q.mas, tap t.tap)
++  must
  :: Modify a rult to require at least one character
  |=  [rel=rult]  ^-  rult
  |=  [mas=mast]  ^-  mist
  =+  mix=(rel mas)
  |-
  %-  root
  ?~  mix  ~
  ?-  -.mix
    %ng  =.  ng.mix
           %-  skip  :_  |=(a=mist =(a ~))
           |-
           ?~  ng.mix  ~
           [^$(mix i.ng.mix) $(ng.mix t.ng.mix)]
         ?~  ng.mix  ~
         mix
  ::
    %br  =.  br.mix
           %-  skip  :_  |=(a=mist =(a ~))
           |-
           ?~  br.mix  ~
           [^$(mix i.br.mix) $(br.mix t.br.mix)]
         ?~  br.mix  ~
         mix
  ::
    ~    ?:  =(p.q.mas p.q.te.mix)  ~
         mix
  ==
++  stut
  :: Fixed repetition
  |=  [rel=rult n=@u]  ^-  rult
  |=  [mas=mast]  ^-  mist
  =+  m=0
  =+  mix=`mist``mas
  |-  ^-  mist
  ?:  =(n m)  mix
  $(mix (part mix rel), m +(m))
++  belt
  :: Bounded repetition
  |=  [rel=rult mod=rept n=@u]  ^-  rult
  |=  [mas=mast]  ^-  mist
  =+  m=0
  =+  mix=`mist``mas
  =+  lis=`(list mist)`~[mix]
  |-  ^-  mist
  ?:  =(n m)  (moot lis mod)
  =+  max=(part mix rel)
  ?~  max  (moot lis mod)
  $(mix (part mix (must rel)), lis [max lis], m +(m))
++  pelt
  :: Unbounded repetition
  |=  [rel=rult mod=rept]  ^-  rult
  |=  [mas=mast]  ^-  mist
  =+  mix=`mist``mas
  =+  lis=`(list mist)`~[mix]
  |-  ^-  mist
  =+  max=(part mix rel)
  ?~  max  (moot lis mod)
  $(mix (part mix (must rel)), lis [max lis])
++  cost
  :: Bounded repetition (possessive)
  |=  [rel=rult n=@u]  ^-  rult
  |=  [mas=mast]  ^-  mist
  =+  m=0
  =+  mix=`mist``mas
  |-  ^-  mist
  ?:  =(n m)  mix
  =+  max=(part mix rel)
  ?~  max  mix
  $(mix max, m +(m))
++  most
  :: Unbounded repetition (possessive)
  |=  [rel=rult]  ^-  rult
  |=  [mas=mast]  ^-  mist
  =+  mix=`mist``mas
  |-  ^-  mist
  =+  mox=(part mix rel)
  ?~  mox  mix
  =+  mux=(part mix (must rel))
  ?~  mux  mox
  $(mix mux)
++  blit
  :: Generic repetition interface
  |=  [rel=rult fet=(unit fret)]
  ?~  fet  rel
  %+  cont  (stut rel p.u.fet)
  ?:  =(r.u.fet `%'+')
    ?~  q.u.fet  (most rel)
    (cost rel (sub u.q.u.fet p.u.fet))
  ?~  q.u.fet  (pelt rel r.u.fet)
  (belt rel r.u.fet (sub u.q.u.fet p.u.fet))
++  loot
  :: Turn a regex into a lookaround expression
  |=  [bak=? neg=? rel=rult]
  |=  [mas=mast]  ^-  mist
  ?.  bak
    =+  mix=(rel mas)
    ?~  mix
      ?:(neg `mas mix)
    ?:(neg ~ `mas)
  =+  tub=`nail`[[1 1] tex]
  =+  mos=`mast`[[~ ~] [[1 1] tex] ~]
  |-
  ?~  q.q.mos
    ?:(neg `mas ~)
  ?.  (past p.q.mos p.q.mas)
    ?:(neg `mas ~)
  =+  mix=(rel mos)
  ?~  mix  $(mos [p.mos (nixt q.mos) `i.q.q.mos])
  ?:  neg  ~
  `mas
++  bart
  :: Create a backreference rule
  |=  [n=@u]  ^-  rult
  |=  [mas=mast]  ^-  mist
  =+  mat=(~(get by num.p.mas) n)
  ?~  mat  ~
  ((gist q.u.mat) mas)
++  flit
  :: Create a character class
  |=  [neg=? fal=(list flat)]  ^-  rult
  |=  [mas=mast]  ^-  mist
  ?~  q.q.mas  ~
  =*  mix  `mas(q (nixt q.mas), r `i.q.q.mas)
  |-
  ?~  fal  ?:(neg mix ~)
  ?@  i.fal
    ?:  =(i.fal i.q.q.mas)
      ?:(neg ~ mix)
    $(fal t.fal)
  ?@  +.i.fal
    ?:  (rant i.q.q.mas -.i.fal +.i.fal)
      ?:(neg ~ mix)
    $(fal t.fal)
  ?:  (hast i.q.q.mas +.i.fal)
    ?:(neg ~ mix)
  $(fal t.fal)
++  bont  ^-  rult
  :: Match a word boundary
  |=  [mas=mast]  ^-  mist
  ?~  r.mas  `mas
  ?~  q.q.mas  `mas
  =+  neg=(hast u.r.mas [| %word])
  ?:  (hast i.q.q.mas [neg %word])  `mas
  ~
++  bant  ^-  rult
  :: Match except on word boundaries
  |=  [mas=mast]  ^-  mist
  =+  mos=(bont mas)
  ?~(mos `mas ~)
::
:: Helper functions
::
++  best
  :: Make a tape into a mast
  |=  [tap=tape]  ^-  mast
  [p=[~ ~] q=[[1 1] tap] r=~]
++  nixt
  :: Advance a nail by one character
  |=  [tub=nail]  ^-  nail
  ?~  q.tub  tub
  [(lust i.q.tub p.tub) t.q.tub]
++  past
  :: Determine if a < b (for hair type)
  |=  [a=hair b=hair]  ^-  ?
  ?|  (lth p.a p.b)
      &(=(p.a p.b) (lth q.a q.b))
  ==
++  lant
  :: Get text before a certain hair
  |=  [wer=hair tub=nail]  ^-  tape
  =+  beh=""
  |-
  ?~  q.tub  (flop beh)
  ?.  (past p.tub wer)  (flop beh)
  $(tub (nixt tub), beh [i.q.tub beh])
++  whet
  :: Get text after a certain hair
  |=  [wer=hair tub=nail]  ^-  tape
  ?~  q.tub  q.tub
  ?.  (past p.tub wer)  q.tub
  $(tub (nixt tub))
++  moot
  :: Turn a list of mist into a mist according to repetition mode
  |=  [lis=(list mist) mod=rept]  ^-  mist
  ?:  =(mod `%'?')  [%ng lis]
  [%br lis]
++  left
  :: Choose the leftmost-longest match from a mist
  |=  [mix=mist]  ^-  (unit match)
  %-  |=([m=(unit mast)] ?~(m m `p.u.m))
  |-  ^-  (unit mast)
  ?~  mix  ~
  ?-  -.mix
      ~
    `te.mix
  ::
      %ng
    =+  lis=(flop ng.mix)
    |-  ^-  (unit mast)
    ?~  lis  ~
    =+  mat=^$(mix i.lis)
    ?~  mat  $(lis t.lis)
    mat
  ::
      %br
    ?~  br.mix  ~
    =+  lef=`(unit mast)`$(mix i.br.mix)
    =+  lis=t.br.mix
    |-  ^-  (unit mast)
    ?~  lis  lef
    =+  dis=^$(mix i.lis)
    ?~  dis  $(lis t.lis)
    ?~  lef  $(lef dis, lis t.lis)
    $(lef `(lont u.lef u.dis), lis t.lis)
  ==
++  lont
  :: Choose the leftmost-longest of two masts
  |=  [a=mast b=mast]  ^-  mast
  =/  lot=@u
    .+  %+  max
    (roll ~(tap in ~(key by num.p.a)) max)
    (roll ~(tap in ~(key by num.p.b)) max)
  =|  n=@u
  |-
  ?:  =(n lot)  a
  =+  ub=(~(get by num.p.b) n)
  ?~  ub
    ?:  (~(has by num.p.a) n)  a
    $(n +(n))
  =+  ua=(~(get by num.p.a) n)
  ?~  ua  b
  ?:  (past p.p.u.ub p.p.u.ua)  b
  ?:  (past p.p.u.ua p.p.u.ub)  a
  ?:  (past q.p.u.ua q.p.u.ub)  b
  a
++  what
  :: Determine a group's capture number
  |=  [wer=hair]  ^-  @u
  =|  n=@ud
  =+  tub=`nail`[[1 1] rig]
  |^
    ?.  (past p.tub wer)  n
    ?~  q.tub  n
    =+  vex=(non tub)
    ?~  q.vex
      $(tub (nixt tub), n ?:(=('(' i.q.tub) +(n) n))
    $(tub q.u.q.vex)
  ++  non
    %+  knee  *@
    |.  ~+
    %+  cold  0
    ;~(pose (ifix [(jest '(?') par] nom) cla)
  ++  nom
    %+  knee  *@
    |.  ~+
    %+  cold  0
    ;~  pose
      ;~(plug (ifix [pal par] nom) nom)
      ;~(plug bas next nom)
      ;~(plug ;~(less (mask "\\()[") next) nom)
      ;~(plug cla nom)
      (easy ~)
    ==
  --
++  root
  :: Simplify a mist
  |=  [mix=mist]  ^-  mist
  ?~  mix  mix
  ?-  -.mix
    %ng  =.  ng.mix  (skip (turn ng.mix root) |=(a=mist =(~ a)))
             ?~  ng.mix  ~
             ?~  t.ng.mix  i.ng.mix
             mix
  ::
    %br  =.  br.mix  (skip (turn br.mix root) |=(a=mist =(~ a)))
             ?~  br.mix  ~
             ?~  t.br.mix  i.br.mix
             mix
  ::
    ~    mix
  ==
++  rant
  |=  [n=@ lo=@ hi=@]
  &((gte n lo) (lte n hi))
++  hast
  :: Determine if a character is part of a character class
  |=  [car=@t pos=post]  ^-  ?
  .=  !neg.pos
  ?+  +.pos  |
    %ascii   (rant car 0 127)
    %alnum   ?|  (rant car 'A' 'Z')
                 (rant car 'a' 'z')
                 (rant car '0' '9')
                 =('_' car)
             ==
    %blank   |(=(car ' ') =(car '\09'))
    %cntrl   |((rant car '\00' '\1f') =(car '\ff'))
    %digit   (rant car '0' '9')
    %graph   (rant car '!' '~')
    %lower   (rant car 'a' 'z')
    %print   (rant car ' ' '~')
    %punct   (~(has in (silt "[]!\"#$%&'()*+,./:;<=>?@\\^_`\{|}~-]")) car)
    %space   (~(has in (silt " \09\0a\0b\0c\0d")) car)
    %upper   (rant car 'A' 'Z')
    %word    ?|  (rant car 'A' 'Z')
                 (rant car 'a' 'z')
                 (rant car '0' '9')
                 =('_' car)
             ==
    %xdigit  ?|  (rant car '0' '9')
                 (rant car 'A' 'F')
                 (rant car 'a' 'f')
             ==
  ==
::
:: Parser functions
::
++  top
  %+  knee  *rult
  |.  ~+
  %-  cook
  :_  ;~(plug mid (star ;~(pfix bar top)))
  |=  [rel=rult ris=(list rult)]
  ?~  ris  rel
  %+  salt  rel
  |-  ^-  rult
  ?~  t.ris  i.ris
  (salt i.ris $(ris t.ris))
++  mid
  %+  knee  *rult
  |.  ~+
  ;~  pose
    (cook cont ;~(plug str mid))
    (cook cont ;~(plug bot mid))
    nil
  ==
++  bot  :: Bottom-level element or recursive capture group
  %+  cook  blit
  ;~  plug
    ;~  pose
      lit  any  ::cla
      cap  bak  luk
      kan  ban  pan
      ins
    ==
  ::
    (punt rep)
  ==
++  ins  :: Case-insensitive (?i)
  ;~(pfix (jest '(?i)') top(cas |))
++  kan  :: Anchor ^
  %-  cold  :_  ket
  |=  [mas=mast]  ^-  mist
  ?~  r.mas  `mas
  ?:  =('\0a' u.r.mas)  `mas
  ~
++  ban  :: Anchor $
  %-  cold  :_  buc
  |=  [mas=mast]  ^-  mist
  ?~  q.q.mas  `mas
  ?:  =('\0a' i.q.q.mas)  `mas
  ~
++  pan  :: Perl-style anchor (\A, \Z, \z, \b, \B)
  ;~  pfix  bas
    %-  sear  :_  next
    %~  get  by  ^-  (map @t rult)
    %-  malt  ^-  (list [@t rult])
    :~
      :-  'A'  |=  [mas=mast]  ^-  mist
               ?:(=([1 1] p.q.mas) `mas ~)
    ::
      :-  'Z'  |=  [mas=mast]  ^-  mist
               ?:(=("" q.q.mas) `mas ~)
    ::
      :-  'z'  |=  [mas=mast]  ^-  mist
               ?:(|(=("" q.q.mas) =("\0a" q.q.mas)) `mas ~)
    ::
      :-  'b'  bont
    ::
      :-  'B'  bant
    ==
  ==
++  cap  :: Capture group
  %+  cook
    |=  [wer=hair rel=rult]
    (capt (what wer) rel)
  %+  ifix  [pal par]
  ;~(plug (here |=([a=pint *] p.a) (easy ~)) top)
++  luk  :: Lookaround
  %+  ifix  [pal par]
  %+  cook  loot
  ;~  pfix  wut
    ;~  plug
      (fuss '<' '')
      (fuss '!' '=')
      top
    ==
  ==
++  bak  :: Backreference
  (cook bart ;~(pfix bas dit))
++  str  :: Unquantified literal text
  (cook gist (plus ;~(less ;~(sfix cha rep) cha)))
++  lit  :: Match a specific character
  (cook (cork trip gist) cha)
++  nil  :: Empty regex
  (easy `rult`|=(mas=mast `mist``mas))
++  any  :: Any character but newline
  %-  cold  :_  ;~(pose dot (jest '\\N'))
  |=  [mas=mast]  ^-  mist
  ?~  q.q.mas  ~
  ?:  =('\0a' i.q.q.mas)  ~
  `mas(q (nixt q.mas), r `i.q.q.mas)
::
:: Parser helpers
::
++  met  :: metacharacter
  (mask "^$.|?+*()[]\{}\\")
++  cha
  ;~(pose esc ;~(less met next))
++  rep  :: Repetition quantifier
  %+  sear
    |=  [fet=fret]  ^-  (unit fret)
    ?~  q.fet  `fet
    ?:  (lth u.q.fet p.fet)  ~
    `fet
  ;~  plug
    ;~  pose
      (cold [0 `1] wut)
      (cold [0 ~] tar)
      (cold [1 ~] lus)
    ::
      %+  ifix  [kel ker]
      ;~  pose
        ;~(plug dem ;~(pfix com (punt dem)))
        (cook |=(n=@u [n `n]) dem)
        ;~(plug (easy 0) ;~(plug (cold ~ com) dem))
      ==
    ==
    (punt (perk ~[%'?' %'+']))
  ==
++  esc  :: escape code
  ;~  pfix  bas
    ;~  pose
      met
    ::
      %-  sear  :_  next
      %~  get  by
      %-  malt
      :~  ['a' '\07']
          ['t' '\09']
          ['n' '\0a']
          ['f' '\0b']
          ['v' '\0c']
          ['r' '\0d']
          ['e' '\1b']
      ==
    ::
      ;~  pfix  (jest 'x')
        %+  cook
          |=  [a=@u b=@u]  ^-  @t
          (add (mul 16 a) b)
        ;~(plug hit hit)
      ==
    ::
      ;~  pfix  (jest '0')
        %+  cook
          |=  [a=@u b=@u c=@u]  ^-  @t
          (add (add (mul 64 a) (mul 8 b)) c)
        ;~(plug cit cit cit)
      ==
    ::
      ;~(pfix (jest 'c') (cook |=(c=@t (mod c 32)) next))
    ==
  ==
++  cla  :: character class
  :: todo: apply case-insensivity
  ::|^
    %+  cook  flit
    ;~  pose
      (cook |=(pos=[~ post] [| ~[pos]]) pec)
    ::
      ::(ifix [sel ser] ;~(plug (fuss '^' '') bel (star cel)))
      %+  ifix  [sel ser]
      ;~  plug
        (fuss '^' '')
      ::
        %+  cook  |=([i=flat t=(list flat)] `(list flat)`[i t])
        ;~(plug bel (star cel))
      ==
    ==
  ++  pec
    %-  sear  :_  ;~(pfix bas next)
    %~  get  by  ^-  (map @t [~ post])
    %-  malt  ^-  (list [@t ~ post])
    :~  ['d' `|^%digit]  ['D' `&^%digit]
        ['w' `|^%word]   ['W' `&^%word]
        ['s' `|^%space]  ['S' `&^%space]
        ['u' `|^%upper]  ['U' `&^%upper]
        ['l' `|^%lower]  ['L' `&^%lower]
    ==
  ++  bel
    ;~(pose pec cep ;~(plug ser ;~(pfix hep cil)) ser cel)
  ++  cel
    ;~(pose pec cep ;~(plug cil ;~(pfix hep cil)) cil)
  ++  cil
    ;~(pose cha (cold '\08' (jest '\\b')) ;~(less ser met))
  ++  cep
    %+  ifix  [(jest '[:') (jest ':]')]
    ;~  plug  (easy ~)  (fuss '^' '')
      %-  perk
      :~  %ascii  %alpha  %alnum  %blank
          %cntrl  %digit  %graph  %lower
          %print  %punct  %space  %upper
          %word   %xdigit
      ==
    ==
  ::--
::
:: Interface functions
::
::|%
++  purse  |=(reg=tape (rust reg top))
++  parse  |=(reg=tape (scan reg top))
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
++  all
  :: Get all non-empty, non-overlapping matches
  |=  [reg=tape tix=tape]  ^-  (list match)
  ~&  [%allll reg tix]
  =+  wer=[1 1]
  =+  lis=`(list match)`~
  |-
  =+  res=(ran reg tix wer)
  ~&  [%all res %ran reg tix wer]
  ?~  res  (flop lis)
  $(wer q.p:(~(got by num.u.res) 0), lis [u.res lis])
++  ran
  :: Get the first match after a certain point
  |=  [reg=tape tix=tape wer=hair]  ^-  (unit match)
  =.  tex  tix
  =.  rig  reg
  =/  mas=mast
    =+  pre=(lant wer [1 1] tex)
    [[~ ~] [wer (whet wer [1 1] tex)] ?~(pre ~ `(rear pre))]
  (left ((capt 0 (parse reg)) mas))
--
