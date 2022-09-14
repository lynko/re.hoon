:: Todo:
:: - Error messaging for invalid regexes
:: - Convenience function for string validation
:: - ++set-text to change the subject of a parsed regex

!:  !?  140
::
::
::  Types
::
|%
+$  range  (pair pint tape)                       ::  Matched text
+$  match  (pair range (map @u range))            ::  Complete match
+$  mast   (trel (unit char) nail (map @u range)) ::  Incomplete match
+$  mist                                          ::  Match collection
  $@  ~
  $%  [%ng lis=(list mist)]   ::  Matched by nongreedy repetition
      [%br lis=(list mist)]   ::  Matched by alternation or repetition
      [~ mas=mast]            ::  Matched by text, class, or anchor
  ==
+$  rult   _^|(|:($:mast $:mist))   ::  Match continuation
+$  stat                            ::  Internal state
  $:  tub=nail        ::  Remaining text to match
      las=(unit @t)   ::  Most recently matched character
      cas=?           ::  Case-sensitive mode
      arp=?           ::  Allow right-parenthesis
      pan=nail        ::  Pattern text
      sut=nail        ::  Subject text
      mar=rult        ::  Matcher function
  ==
+$  rept  (unit ?(%'?' %'+'))           ::  Repetition mode
+$  fret  [[p=@u q=(unit @u)] r=rept]   ::  Repetition specifier
+$  flat  ?(@t [p=@t q=@t] [~ r=post])  ::  Character class element
+$  felt  [neg=? bil=(list flat)]       ::  Character class specifier
+$  post              ::  POSIX character class
  $:  neg=?
    $?  %ascii  %alpha  %alnum  %blank
        %cntrl  %digit  %graph  %lower
        %print  %punct  %space  %upper
        %word   %xdigit
    ==
  ==
+$  ment  _^|(|:($:tape $:tape))   ::  Pattern substitution function
--
::
::
::  Main interface
::
|_  [sat=stat]
+*  self  .
::
::
:: These can be called directly, as in `(run:re <pattern> <subject>)`.
::
++  run
  ::  Find the first match of a regex
  |=  [pattern=tape subject=tape]  ^-  (unit match)
  =+  res=~(next self (start pattern subject))
  ?~  res  res
  `p.u.res
++  all
  ::  Find all non-overlapping matches of a regex
  |=  [pattern=tape subject=tape]  ^-  (list match)
  =+  lis=`(list match)`~
  =+  sat=(start pattern subject)
  |-
  =+  res=~(next self sat)
  ?~  res  (flop lis)
  $(lis [p.u.res lis], sat q.u.res)
++  sub
  ::  Replace the first match of a regex
  |=  [pattern=tape subject=tape repl=tape]  ^-  tape
  =+  sat=(start pattern subject)
  =+  res=~(next self sat)
  ?~  res  subject
  ;:  weld
    q:(lant:of p.p.p.p.u.res sut.sat)
  ::
::    ?-  repl
::      tape  repl
::      ment  (repl q.p.u.res)
::    ==
    repl
  ::
    q.tub.q.u.res
  ==
++  gsub
  ::  Replace all instances of a regex
  |=  [pattern=tape subject=tape repl=tape]  ^-  tape
  =+  lis=`(list tape)`~
  =+  sat=(start pattern subject)
  |-  ^-  tape
  =+  res=~(next self sat)
  ?~  res
    =+  tap=q.tub.sat
    |-  ^-  tape
    ?~  lis  tap
    $(tap (weld i.lis tap), lis t.lis)
  %=  $
    lis  :_  lis
         ^-  tape
         %+  weld  q:(lant:of p.p.p.p.u.res tub.sat)
         repl
::         ?-  repl
::           tape  repl
::           ment  (repl q.p.u.res)
::         ==
  ::
    sat  q.u.res
  ==
++  start
  ::  Create a sample for the `next` arm, crashing on an invalid regex
  |=  [pattern=tape subject=tape]  ^-  stat
  =.  sat
    :-  tub=[[1 1] subject]
    :-  las=~
    :-  cas=%.y
    :-  arp=%.y
    :-  pan=[[1 1] pattern]
    :-  sut=[[1 1] subject]
        mar=*rult
  sat(mar (capt:of 0 (scan pattern top:of)))
++  valid
  ::  Unitized `++start`, producing nil on an invalid regex
  |=  [pattern=tape subject=tape]  ^-  (unit stat)
  =.  sat
    :-  tub=[[1 1] subject]
    :-  las=~
    :-  cas=%.y
    :-  arp=%.y
    :-  pan=[[1 1] pattern]
    :-  sut=[[1 1] subject]
        mar=*rult
  =+  rel=(rust pattern top:of)
  ?~  rel  rel
  `sat(mar (capt:of 0 u.rel))
::
::
::  This arm operates on a custom sample.  Use as in:
::
::    =/  sat=stat
::      (start:regex pattern-text subject-text)
::    =/  x=(unit (pair match:regex stat:regex))
::      ~(next re sat)
::    ...
::
++  next
  ::  Produce a tuple of next-match and new-state, or nil if no match
  |-  ^-  (unit (pair match stat))
  =+  mat=(left:of (mar.sat [las.sat tub.sat ~]))
  ?~  mat
    ?~  q.tub.sat  ~
    $(tub.sat (nixt:of tub.sat), las.sat `i.q.tub.sat)
  :+  ~  u.mat
  %=  sat
    tub  (whet:of q.p.p.u.mat tub.sat)
    las  (wast:of q.p.p.u.mat [p.p.p.u.mat q.p.u.mat])
  ==
++  of
::
::
::  Internal operations
::
  |%
  ::
  ::
  ::  Mast and mist operations
  ::
  ++  part
    ::  Apply a rult to every mast in a mist
    |=  [mix=mist rel=rult]  ^-  mist
    %-  root
    ?~  mix  mix
    ?+  -.mix
      =.  lis.mix
        (skip (turn lis.mix (curr part rel)) |=(a=* =(~ a)))
      ?~  lis.mix  ~
      mix
    ::
        ~
      (rel mas.mix)
    ==
  ++  moot
    ::  Turn a list of mist into a mist according to repetition mode
    |=  [lis=(list mist) mod=rept]  ^-  mist
    ?:  =(mod `%'?')  [%ng lis]
    [%br lis]
  ++  root
    ::  Simplify a mist
    |=  [mix=mist]  ^-  mist
    ?~  mix  mix
    ?+  -.mix
        =.  lis.mix  (skip (turn lis.mix root) |=(a=mist =(~ a)))
        ?~  lis.mix  ~
        ?~  t.lis.mix  i.lis.mix
        mix
    ::
        ~
      mix
    ==
  ++  left
    ::  Choose the leftmost-longest match from a mist
    |=  [mix=mist]  ^-  (unit match)
    %-  |=  [mas=(unit mast)]
        ?~  mas  mas
        `[(~(got by r.u.mas) 0) r.u.mas]
    |-  ^-  (unit mast)
    ?~  mix  ~
    ?-  -.mix
        ~
      `mas.mix
    ::
        %ng
      =+  lis=(flop lis.mix)
      |-  ^-  (unit mast)
      ?~  lis  ~
      =+  mat=^$(mix i.lis)
      ?~  mat  $(lis t.lis)
      mat
    ::
        %br
      ?~  lis.mix  ~
      =+  lef=`(unit mast)`$(mix i.lis.mix)
      =+  lis=t.lis.mix
      |-  ^-  (unit mast)
      ?~  lis  lef
      =+  dis=^$(mix i.lis)
      ?~  dis  $(lis t.lis)
      ?~  lef  $(lef dis, lis t.lis)
      $(lef `(lont u.lef u.dis), lis t.lis)
    ==
  ++  lont
    ::  Choose the leftmost-longest of two masts
    |=  [a=mast b=mast]  ^-  mast
    =/  lot=@u
      .+  %+  max
      (roll ~(tap in ~(key by r.a)) max)
      (roll ~(tap in ~(key by r.b)) max)
    =|  n=@u
    |-
    ?:  =(n lot)  a
    =+  ub=(~(get by r.b) n)
    ?~  ub
      ?:  (~(has by r.a) n)  a
      $(n +(n))
    =+  ua=(~(get by r.a) n)
    ?~  ua  b
    ?:  (past p.p.u.ub p.p.u.ua)  b
    ?:  (past p.p.u.ua p.p.u.ub)  a
    ?:  (past q.p.u.ua q.p.u.ub)  b
    a
  ::
  ::
  :: Rule builders
  ::
  ++  cont
    ::  Concatenate two regexes
    |=  [a=rult b=rult]  ^-  rult
    |=  [mas=mast]  ^-  mist
    (part (a mas) b)
  ++  salt
    ::  Alternate two regexes
    |=  [a=rult b=rult]  ^-  rult
    |=  [mas=mast]  ^-  mist
    [%br ~[(a mas) (b mas)]]
  ++  capt
    ::  Capture a regex
    |=  [n=@u rel=rult]  ^-  rult
    |=  [mas=mast]  ^-  mist
    ?:  (~(has by r.mas) n)
      (rel mas)
    %+  part  (rel mas)
    |=  [mes=mast]  ^-  mist
    :-  ~
    %=  mes
        r
      %+  ~(put by r.mes)  n
      [[p.q.mas p.q.mes] q:(lant p.q.mes q.mas)]
    ==
  ++  gist
    ::  `jest` but for tapes
    |=  [tap=tape]  ^-  rult
    ?:  cas.sat
      |=  [mas=mast]  ^-  mist
      ?~  tap  `mas
      ?~  q.q.mas  ~
      ?.  =(i.tap i.q.q.mas)  ~
      $(p.mas `i.q.q.mas, q.mas (nixt q.mas), tap t.tap)
    =.  tap  (cass tap)
    |=  [mas=mast]  ^-  mist
    ?~  tap  `mas
    ?~  q.q.mas  ~
    =+  luc=(cass [i.q.q.mas ~])
    ?~  luc  ~
    ?.  =(i.tap i.luc)  ~
    $(p.mas `i.q.q.mas, q.mas (nixt q.mas), tap t.tap)
  ++  must
    ::  Modify a rult to require at least one character
    |=  [rel=rult]  ^-  rult
    |=  [mas=mast]  ^-  mist
    =+  mix=(rel mas)
    |-
    %-  root
    ?~  mix  ~
    ?+  -.mix
        =.  lis.mix
          %-  skip  :_  |=(a=mist =(a ~))
          |-
          ?~  lis.mix  ~
          [^$(mix i.lis.mix) $(lis.mix t.lis.mix)]
        ?~  lis.mix  ~
        mix
    ::
        ~
      ?:  =(p.q.mas p.q.mas.mix)  ~
      mix
    ==
  ++  stut
    ::  Fixed repetition
    |=  [rel=rult n=@u]  ^-  rult
    |=  [mas=mast]  ^-  mist
    =+  m=0
    =+  mix=`mist``mas
    |-  ^-  mist
    ?:  =(n m)  mix
    $(mix (part mix rel), m +(m))
  ++  belt
    ::  Bounded repetition
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
    ::  Unbounded repetition
    |=  [rel=rult mod=rept]  ^-  rult
    |=  [mas=mast]  ^-  mist
    =+  mix=`mist``mas
    =+  lis=`(list mist)`~[mix]
    |-  ^-  mist
    =+  max=(part mix rel)
    ?~  max  (moot lis mod)
    $(mix (part mix (must rel)), lis [max lis])
  ++  cost
    ::  Bounded repetition (possessive)
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
    ::  Unbounded repetition (possessive)
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
    ::  Generic repetition interface
    |=  [rel=rult fet=(unit fret)]  ^-  rult
    ?~  fet  rel
    %+  cont  (stut rel p.u.fet)
    ?:  =(r.u.fet `%'+')
      ?~  q.u.fet  (most rel)
      (cost rel (^sub u.q.u.fet p.u.fet))
    ?~  q.u.fet  (pelt rel r.u.fet)
    (belt rel r.u.fet (^sub u.q.u.fet p.u.fet))
  ++  loot
    ::  Turn a regex into a lookaround expression
    |=  [bak=? neg=? rel=rult]
    |=  [mas=mast]  ^-  mist
    ?.  bak
      =+  mix=(rel mas)
      ?~  mix
        ?:(neg `mas mix)
      ?:(neg ~ `mas)
    =+  tib=sut.sat
    =+  mos=`mast`[~ tib ~]
    |-
    ?~  q.q.mos
      ?:(neg `mas ~)
    ?.  (past p.q.mos p.q.mas)
      ?:(neg `mas ~)
    =+  mix=(rel mos)
    ?~  mix  $(p.mos `i.q.q.mos, q.mos (nixt q.mos))
    ?:(neg ~ `mas)
  ++  bart
    ::  Create a backreference rule
    |=  [n=@u]  ^-  rult
    |=  [mas=mast]  ^-  mist
    =+  mat=(~(get by r.mas) n)
    ?~  mat  ~
    ((gist q.u.mat) mas)
  ++  flit
    ::  Create a character class
    ::  TODO:  clean this up
    |=  [neg=? fal=(list flat)]  ^-  rult
    |=  [mas=mast]  ^-  mist
    ?~  q.q.mas  ~
    =*  mix  `mas(p `i.q.q.mas, q (nixt q.mas))
    |-
    ?~  fal  ?:(neg mix ~)
    ?@  i.fal
      ?:  ?:  cas.sat
            =(i.fal i.q.q.mas)
          ?:  (rant i.q.q.mas 'A' 'Z')
            ?|  =(i.q.q.mas i.fal)
                =((add i.q.q.mas 32) i.fal)
            ==
          ?:  (rant i.q.q.mas 'a' 'z')
            ?|  =(i.q.q.mas i.fal)
                =((^sub i.q.q.mas 32) i.fal)
            ==
          =(i.fal i.q.q.mas)
        ?:(neg ~ mix)
      $(fal t.fal)
    ?@  +.i.fal
      ?:  ?:  cas.sat
            (rant i.q.q.mas i.fal)
          ?:  (rant i.q.q.mas 'A' 'Z')
            ?|  (rant i.q.q.mas i.fal)
                (rant (add i.q.q.mas 32) i.fal)
            ==
          ?:  (rant i.q.q.mas 'a' 'z')
            ?|  (rant i.q.q.mas i.fal)
                (rant (^sub i.q.q.mas 32) i.fal)
            ==
          (rant i.q.q.mas i.fal)
        ?:(neg ~ mix)
      $(fal t.fal)
    ?:  ?:  cas.sat
          (hast i.q.q.mas +.i.fal)
        ?:  (rant i.q.q.mas 'A' 'Z')
          ?|  (hast i.q.q.mas +.i.fal)
              (hast (add i.q.q.mas 32) +.i.fal)
          ==
        ?:  (rant i.q.q.mas 'a' 'z')
          ?|  (hast i.q.q.mas +.i.fal)
              (hast (^sub i.q.q.mas 32) +.i.fal)
          ==
        (hast i.q.q.mas +.i.fal)
      ?:(neg ~ mix)
    $(fal t.fal)
  ++  bont  ^-  rult
    ::  Match a word boundary
    |=  [mas=mast]  ^-  mist
    ?~  p.mas
      ?~  q.q.mas  ~
      ?:  (hast i.q.q.mas [| %word])  `mas
      ~
    ?~  q.q.mas
      ?:  (hast u.p.mas [| %word])  `mas
      ~
    =+  neg=(hast u.p.mas [| %word])
    ?:  (hast i.q.q.mas [neg %word])  `mas
    ~
  ++  bant  ^-  rult
    ::  Match except on word boundaries
    |=  [mas=mast]  ^-  mist
    =+  mos=(bont mas)
    ?~(mos `mas ~)
  ::
  ::
  ::  Helper functions
  ::
  ++  what
    ::  Determine a group's capture number
    |=  [wer=hair]  ^-  @u
    =|  n=@u
    =+  tub=pan.sat
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
        ;~(plug bas ^next nom)
        ;~(plug ;~(less (mask "\\()[") ^next) nom)
        ;~(plug cla nom)
        (easy ~)
      ==
    --
  ++  rant
    ::  Determine if an atom is in a certain range
    |=  [n=@ lo=@ hi=@]
    &((gte n lo) (lte n hi))
  ++  hast
    ::  Determine if a character is part of a character class
    |=  [car=@t pos=post]  ^-  ?
    .=  !neg.pos
    ?-  +.pos
      %ascii   (rant car 0 127)
      %alnum   ?|  (rant car 'A' 'Z')
                   (rant car 'a' 'z')
                   (rant car '0' '9')
               ==
      %alpha   ?|  (rant car 'A' 'Z')
                   (rant car 'a' 'z')
               ==
      %blank   |(=(car ' ') =(car '\09'))
      %cntrl   |((rant car '\00' '\1f') =(car '\7f'))
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
  ++  nixt
    ::  Advance a nail by one character
    |=  [tub=nail]  ^-  nail
    ?~  q.tub  tub
    [(lust i.q.tub p.tub) t.q.tub]
  ++  past
    ::  Determine whether hair `b` comes after hair `a`
    |=  [a=hair b=hair]  ^-  ?
    ?|  (lth p.a p.b)
        &(=(p.a p.b) (lth q.a q.b))
    ==
  ++  wast
    ::  Get the last character before a certain point
    |=  [har=hair tub=nail]  ^-  (unit @t)
    ?~  q.tub  ~
    ?.  (past p.tub har)  ~
    =+  c=i.q.tub
    %.  tub
    |=  [tub=nail]
    ?.  (past p.tub har)  `c
    ?~  q.tub  `c
    $(c i.q.tub, tub (nixt tub))
  ++  lant
    ::  Get the text of a nail up to a certain hair
    |=  [wer=hair tub=nail]  ^-  nail
    :-  p.tub
    =+  beh=""
    |-
    ?~  q.tub  (flop beh)
    ?.  (past p.tub wer)  (flop beh)
    $(tub (nixt tub), beh [i.q.tub beh])
  ++  whet
    ::  Get the tail of a nail after a certain hair
    |=  [wer=hair tub=nail]  ^-  nail
    ?~  q.tub  tub
    ?.  (past p.tub wer)  tub
    $(tub (nixt tub))
  ::
  ::
  ::  Parser functions
  ::
  ++  top
    ::  Alternated list of regular expressions
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
    ::  Concatenated list of regular expressions
    %+  knee  *rult
    |.  ~+
    ;~  pose
      ::(cook cont ;~(plug str mid))
      (cook cont ;~(plug bot mid))
      nil
    ==
  ++  bot
    ::  Bottom-level element or recursive capture group
    %+  cook  blit
    ;~  plug
      ;~  pose
        cla  bak  luk
        cap  ank  lit
        any  ins  nis
      ==
    ::
      (punt rep)
    ==
  ++  nil
    ::  Empty regex
    (easy `rult`|=(mas=mast `mist``mas))
  ++  str
    ::  Unquantified literal text
    (cook gist (plus ;~(less ;~(sfix cha rep) cha)))
  ++  lit
    ::  Match a specific character
    (cook (cork trip gist) cha)
  ++  any
    ::  Match any character (.)
    %-  cold  :_  dot
    |=  [mas=mast]  ^-  mist
    ?~  q.q.mas  ~
    ?:  =('\00' i.q.q.mas)  ~
    `mas(p `i.q.q.mas, q (nixt q.mas))
  ++  cla
    ::  Character class
    |^
      %+  sear
        |=  [neg=? bil=(list flat)]  ^-  (unit rult)
        =+  lis=bil
        |-  ^-  (unit rult)
        ?~  lis  `(flit neg bil)
        ?@  i.lis  $(lis t.lis)
        ?^  +.i.lis  $(lis t.lis)
        ?:  (lte -.i.lis +.i.lis)  $(lis t.lis)
        ~
      ;~  pose
        (cook |=(pos=[~ post] [| ~[pos]]) pec)
        (ifix [sel ser] ;~(plug (fuss '^' '') bel (star cel)))
      ==
    ++  bel
      ::  Beginning element (may be ])
      ;~(pose ;~(plug ser ;~(pfix hep cil)) ser cel)
    ++  cel
      ::  Class element (may be range or Perl/POSIX class)
      ;~(pose pec cep ;~(plug cil ;~(pfix hep cil)) cil)
    ++  cil
      ::  Individual class element
      ;~(pose sec ;~(less ser cha) ;~(less ser bas met))
    ++  sec
      ::  Escape codes have special meaning here
      ;~(pose (cold '\08' (jest '\\b')) esc)
    ++  pec
      ::  Perl-style class
      %-  sear  :_  ;~(pfix bas ^next)
      %~  get  by  ^-  (map @t [~ post])
      %-  malt  ^-  (list [@t ~ post])
      :~  ['d' `|^%digit]  ['D' `&^%digit]
          ['w' `|^%word]   ['W' `&^%word]
          ['s' `|^%space]  ['S' `&^%space]
          ['u' `|^%upper]  ['U' `&^%upper]
          ['l' `|^%lower]  ['L' `&^%lower]
      ==
    ++  cep
      ::  POSIX-style class
      %+  ifix  [(jest '[:') (jest ':]')]
      ;~  plug  (easy ~)  (fuss '^' '')
        %-  perk
        :~  %ascii  %alpha  %alnum  %blank
            %cntrl  %digit  %graph  %lower
            %print  %punct  %space  %upper
            %word   %xdigit
        ==
      ==
    ::
    ::  TODO:  collation elements etc
    --
  ++  cap
    :: Capture group
    %+  cook
      |=  [wer=hair rel=rult]
      (capt (what wer) rel)
    %+  ifix  [pal par]
    ;~  plug
      (here |=([a=pint *] p.a) (easy ~))
      top(arp.sat |)
    ==
  ++  bak
    ::  Backreference
    (cook bart ;~(pfix bas dit))
  ++  luk
    ::  Lookaround
    %+  ifix  [pal par]
    %+  cook  loot
    ;~  pfix  wut
      ;~  plug
        (fuss '<' '')
        (fuss '!' '=')
        top(arp.sat |)
      ==
    ==
  ++  ank
    ::  Anchor
    ;~  pose
      %-  cold  :_  ket
      |=  [mas=mast]  ^-  mist
      ?~(p.mas `mas ~)
    ::
      %-  cold  :_  buc
      |=  [mas=mast]  ^-  mist
      ?~(q.q.mas `mas ~)
    ::
      (cold bont (jest '\\b'))
    ::
      (cold bant (jest '\\B'))
    ==
  ++  ins
    ::  Case-insensitive (?i)
    ;~(pfix (jest '(?i)') top(cas.sat |))
  ++  nis
    ::  Not case-insensitive (?-i)
    ;~(pfix (jest '(?-i)') top(cas.sat &))
  ::
  ::
  :: Parser helpers
  ::
  ++  met
    ::  Metacharacter
    (mask "^$.|?+*()[]\{}\\")
  ++  cha
    ::  Sequence that matches a specific character
    =;  cha
      ?.  arp.sat  cha
      ;~(pose par cha)
    ;~(pose ker ser esc ;~(less met ^next))
  ++  esc
    ::  Escape code
    ;~  pfix  bas
      ;~  pose
        %-  sear  :_  ^next
        %~  get  by
        %-  malt
        :~  ['a' '\07']
            ['t' '\09']
            ['n' '\0a']
            ['v' '\0b']
            ['f' '\0c']
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
        ;~  pfix  (jest 'c')
          %-  cook  :_  (shim '\00' '\7f')
          |=  [c=@t]
          =.  c  ?:((rant c 'a' 'z') (^sub c 32) c)
          ?:  =(0 (dis c '\40'))
            (add c '\40')
          (^sub c '\40')
        ==
      ::
        ^next
      ==
    ==
  ++  rep
    :: Repetition quantifier
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
          %+  sear
            |=  [a=@u b=(unit @u)]
            ^-  (unit [@u (unit @u)])
            ?~  b  `[a b]
            ?:  (lth u.b a)  ~
            `[a b]
          ;~(plug dem ;~(pfix com (punt dem)))
        ::
          (cook |=(n=@u [n `n]) dem)
        ==
      ==
      (punt (perk ~[%'?' %'+']))
    ==
  --
--
