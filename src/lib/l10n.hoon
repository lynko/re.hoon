  :: l10n.hoon
:::: Localization support for Urbit apps.
::
::  Localization is important for apps to render front-end details correctly
::  for all users.  For instance, knowing the locale allows the app to
::  adaptively display strings in the appropriate language and script and to
::  render date and time strings as preferred.
::
::  A locale consists of a language code, a script code, and a region code.
::
::  Languages are indicated by two-letter ISO 639-1 codes or three-letter
::  ISO 639-2 codes only if an appropriate two-letter code is not defined.
::
::  Writing systems are indicated using an optional four-letter ISO 15924
::  script code.  Of course all strings are represented using UTF-8, but a few
::  languages may be written using multiple scripts (including English:  Latin,
::  Shavian, Deseret; and Mongolian:  Hudum Mongol bichig, Cyrillic, ’Phags-pa). 
::
::  Regions are indicated with two-letter ISO 3166 codes.
::
::  Additional support features included with this localization library include
::  the associated Unicode character range for each alphabet, case pairs, and
::  writing direction.  These are available in parallel cores TODO.
::
::  Having combined all of these, we arrive at locale codes such as:
::
::  - `en_US` or `[%en %$ %us]` for American English written in the default
::    script.
::  - `en_Dsrt_US` or `[%en %dsrt %us]` for American English written in the
::    Deseret alphabet.
::  - `zh_Hant_HK` or `[%zh %hant %hk]` for Mandarin Chinese written in
::    traditional Han symbols.
::
::  The `%$` alphabet used in the absence of any other information is presumed
::  to be the 26-letter Latin ASCII alphabet.
::
::  (Many combinations are invalid or absurd.  We do not lint for these.)
::
::  %l10n-store represents these as three-element tuples of type unions.
::
::  ```hoon
::  +$  language  ?(iso-639-1-leys iso-639-2-keys)
::  +$  script    ?(iso-15924-keys)
::  +$  region    ?(iso-3166-keys)
::  +$  locale  [language script region]
::  ```
::
::  The tricky part is that locales should “nest” inside of each other, rather
::  like auras.  Thus if we cannot locate `'en_Latn_GB'`, we should check first
::  for `'en_GB'` then `'en'`.  This means we actually search components:  we
::  look for language, then script, then region, and fall back on our best prior
::  match if we can't find a perfect match.
::
::  We have a custom search core for handling this behavior.
::
::    (~(get le app) locale string-label)
::    (~(gets le app) 'en-US' string-label)
::    (~(put le app) locale string-label string)
::    (~(puts le app) 'en-US' string-label string)
::
::  Each client app will create its own instance:
::
::    /+  *l10n
::    /*  words  %hoon  /app/my-app/string-table/hoon
::    (~(get le words) [%en %$ %$] %autonym)
::    (~(getd le words) %autonym)
::    (~(gets le words) 'en-Dsrt-US' %autonym)
::
::  We recommend putting your app's string table at /lib/app-name/strings/hoon.
::  It is up to the app to change the default locale if the strings source
::  should be overridden.
::
::  Two-letter and three-letter codes are NOT unified.  Pick a lane!
::
!:
|%
+$  language  ?(iso-639-1-keys iso-639-2-keys)
+$  script    ?(iso-15924-keys)
+$  region    ?(iso-3166-keys)
+$  locale    $:(language script region)
::
+$  label     @tas
+$  griffe    (map label @t)
::
++  le
  |_  [default-locale=locale mots=(map locale griffe)]
  ::  Parse locale string into locale tuple.
  ::
  ++  parse-locale
    |=  str=@t
    ^-  locale
    =/  str  (trip str)
    =/  n  (lent str)
    =/  str  (cass str)
    ?:  |(=(n 2) =(n 3))
      :: language only
      =/  lang
          ~|  'Failed to parse language from locale string.'
        p.u.+.q:((cook |=(a=tape =/(a (crip a) ?>(?=(language a) a))) (star (shim 'a' 'z'))) [[1 1] str])
      `locale`[`language`lang `script`%$ `region`%$]
    ?:  |(=(n 5) =(n 6))
      :: language and region
      =/  lang
          ~|  'Failed to parse language from locale string.'
        p.u.+.q:((cook |=(a=tape =/(a (crip a) ?>(?=(language a) a))) (star (shim 'a' 'z'))) [[1 1] str])
      =/  regn
          ~|  'Failed to parse region from locale string.'
        p.u.+.q:((cook |=(a=tape =/(a (crip (flop a)) ?>(?=(region a) a))) (star (shim 'a' 'z'))) [[1 1] (flop str)])
      `locale`[`language`lang `script`%$ `region`regn]
    ?:  |(=(n 7) =(n 8))
      :: language and script (uncommon)
      =/  lang-hold
          ~|  'Failed to parse language from locale string.'
        ((cook |=(a=tape =/(a (crip a) ?>(?=(language a) a))) (star (shim 'a' 'z'))) [[1 1] str])
      =/  lang  p.u.+.q:lang-hold
      =/  writ-str
          ~|  'Failed to parse script from locale string.'
        q.q.u.+.q:lang-hold
      =/  writ
          ~|  'Failed to parse script from locale string.'
        p.+<.q:((cook |=(a=tape =/(a (crip a) ?>(?=(script a) a))) (star (shim 'a' 'z'))) [[1 1] +.writ-str])
      `locale`[`language`lang `script`writ `region`%$]
    ?:  |(=(n 10) =(n 11))
      :: language, script, and region (uncommon)
      =/  lang-hold
          ~|  'Failed to parse language from locale string.'
        ((cook |=(a=tape =/(a (crip a) ?>(?=(language a) a))) (star (shim 'a' 'z'))) [[1 1] str])
      =/  lang  p.u.+.q:lang-hold
      =/  writ-str
          ~|  'Failed to parse script from locale string.'
        q.q.u.+.q:lang-hold
      =/  writ
          ~|  'Failed to parse script from locale string.'
        p.+<.q:((cook |=(a=tape =/(a (crip a) ?>(?=(script a) a))) (star (shim 'a' 'z'))) [[1 1] +.writ-str])
      =/  regn
          ~|  'Failed to parse region from locale string.'
        p.u.+.q:((cook |=(a=tape =/(a (crip (flop a)) ?>(?=(region a) a))) (star (shim 'a' 'z'))) [[1 1] (flop str)])
      `locale`[`language`lang `script`writ `region`regn]
    ~|  'Failed to parse locale string.  Length not as expected (include `-` or `_` separators).'
    !!
  ::  Put by string (e.g. 'en_GB').
  ::
  ++  puts
    |=  [lieu=@t =label =@t]
    ^-  [locale (map locale griffe)]
    =/  locale  `locale`(parse-locale lieu)
    (put locale label t)
  ::  Put by locale (e.g. [%en %$ %gb]).
  ::
  ++  put
    |=  [=locale =label =@t]
    ^-  [^locale (map ^locale griffe)]
    =/  source  ^-  griffe
        ?:  (~(has by mots) locale)
        (~(got by mots) locale)
      *griffe
    :-  default-locale
        (~(put by mots) locale `griffe`(~(put by source) label t))
  ::  Put by default locale.
  ::
  ++  putd
    |=  [=label =@t]
    ^-  [locale (map locale griffe)]
    (put default-locale label t)
  ::  Get by string (e.g. 'en_GB').  Fallback handled in ++get.
  ::
  ++  gets
    |=  [=@t =label]
    ^-  (unit @t)
    ::  Retrieve locale from string.
    =/  locale  `locale`(parse-locale t)
    (get locale label)
  ::  Get by locale (e.g. [%en %$ %gb]).  Fall back by removing script, then
  ::  region.
  ::
  ++  get
    |=  [=locale =label]
    ^-  (unit @t)
    =/  language   -.locale
    =/  script    +<.locale
    =/  region    +>.locale
    =/  source  ^-  griffe
            ?:  (~(has by mots) [language script region])
              (~(got by mots) [language script region])
          ?:  (~(has by mots) [language %$ region])
            (~(got by mots) [language %$ region])
        ?:  (~(has by mots) [language %$ %$])
          (~(got by mots) [language %$ %$])
      ?:  (~(has by mots) default-locale)
        (~(got by mots) default-locale)
    *griffe
    ?:  (~(has by source) label)
      (~(get by source) label)
    `(unit @t)`~
  ::  Get by default locale.
  ::
  ++  getd
    |=  [=label]
    ^-  (unit @t)
    (get default-locale label)
  ::  Get by tree (e.g. [%en %$ %gb]).  Fall back by removing script, then
  ::  region.
  ::
  ++  gett
    |=  [=locale =label]
    ^-  (unit @t)
    =/  language   -.locale
    =/  script    +<.locale
    =/  region    +>.locale
    ?:  (has [language script region] label)
      (get [language script region] label)
    ?:  (has [language %$ region] label)
      (get [language %$ region] label)
    ?:  (has [language %$ %$] label)
      (get [language %$ region] label)
    ~
  ::  Has by string (e.g. 'en_GB').  Fallback handled in ++has.
  ::
  ++  hass
    |=  [=@t =label]
    ^-  ?(%.y %.n)
    (has (parse-locale t) label)
  ::  Has by locale (e.g. [%en %$ %gb]).  No fallback.
  ::
  ++  has
    |=  [=locale =label]
    ^-  ?(%.y %.n)
    =/  language   -.locale
    =/  script    +<.locale
    =/  region    +>.locale
    (~(has by mots) [language script region])
  ::  Has by default locale.
  ::
  ++  hasd
    |=  [=label]
    ^-  ?(%.y %.n)
    (has default-locale label)
  ::  Has by tree (e.g. [%en %$ %gb]).  Fall back by removing script, then
  ::  region.
  ::
  ++  hast
    |=  [=locale =label]
    ^-  (unit ^locale)
    =/  language   -.locale
    =/  script    +<.locale
    =/  region    +>.locale
    ?:  (has [language script region] label)
      `[language script region]
    ?:  (has [language %$ region] label)
      `[language %$ region]
    ?:  (has [language %$ %$] label)
      `[language %$ %$]
    ~
  ::  Delete by string
  ++  dels
    |=  [=@t =label]
    ^-  [locale (map locale griffe)]
    ::  Retrieve locale from string.
    (del (parse-locale t) label)
  ::  Delete by locale
  ++  del
    |=  [=locale =label]
    ^-  [^locale (map ^locale griffe)]
    ~|  'Failed to locate key for deletion.'
    ?.  (~(has by mots) locale)  !!
    =/  source  (~(got by mots) locale)
    =/  result  (~(del by source) label)
    ?:  =(result *griffe)
      [default-locale (~(del by mots) locale)]
    [default-locale (~(put by mots) locale result)]
  --
::  LANGUAGE CODES :: ISO-639
::
::  ISO 639-1 Two-Letter Codes
+$  iso-639-1-keys  $?  %ab  %aa  %af  %ak  %sq  %am  %ar  %an  %hy  %as  %av
                        %ae  %ay  %az  %bm  %ba  %eu  %be  %bn  %bi  %bs  %br
                        %bg  %my  %ca  %ch  %ce  %ny  %zh  %cu  %cv  %kw  %co
                        %cr  %hr  %cs  %da  %dv  %nl  %dz  %en  %eo  %et  %ee
                        %fo  %fj  %fi  %fr  %fy  %ff  %gd  %gl  %lg  %ka  %de
                        %el  %kl  %gn  %gu  %ht  %ha  %he  %hz  %hi  %ho  %hu
                        %is  %io  %ig  %id  %ia  %ie  %iu  %ik  %ga  %it  %ja
                        %jv  %kn  %kr  %ks  %kk  %km  %ki  %rw  %ky  %kv  %kg
                        %ko  %kj  %ku  %lo  %la  %lv  %li  %ln  %lt  %lu  %lb
                        %mk  %mg  %ms  %ml  %mt  %gv  %mi  %mr  %mh  %mn  %na
                        %nv  %nd  %nr  %ng  %ne  %no  %nb  %nn  %ii  %oc  %oj
                        %or  %om  %os  %pi  %ps  %fa  %pl  %pt  %pa  %qu  %ro
                        %rm  %rn  %ru  %se  %sm  %sg  %sa  %sc  %sr  %sn  %sd
                        %si  %sk  %sl  %so  %st  %es  %su  %sw  %ss  %sv  %tl
                        %ty  %tg  %ta  %tt  %te  %th  %bo  %ti  %to  %ts  %tn
                        %tr  %tk  %tw  %ug  %uk  %ur  %uz  %ve  %vi  %vo  %wa
                        %cy  %wo  %xh  %yi  %yo  %za  %zu
                        %$   ==
++  iso-639-1
  ^-  (map iso-639-1-keys @t)
  %-  malt
  ^-  (list (pair iso-639-1-keys @t))
  :~  :-  %ab  'Abkhazian'
      :-  %aa  'Afar'
      :-  %af  'Afrikaans'
      :-  %ak  'Akan'
      :-  %sq  'Albanian'
      :-  %am  'Amharic'
      :-  %ar  'Arabic'
      :-  %an  'Aragonese'
      :-  %hy  'Armenian'
      :-  %as  'Assamese'
      :-  %av  'Avaric'
      :-  %ae  'Avestan'
      :-  %ay  'Aymara'
      :-  %az  'Azerbaijani'
      :-  %bm  'Bambara'
      :-  %ba  'Bashkir'
      :-  %eu  'Basque'
      :-  %be  'Belarusian'
      :-  %bn  'Bengali'
      :-  %bi  'Bislama'
      :-  %bs  'Bosnian'
      :-  %br  'Breton'
      :-  %bg  'Bulgarian'
      :-  %my  'Burmese'
      :-  %ca  'Catalan, Valencian'
      :-  %ch  'Chamorro'
      :-  %ce  'Chechen'
      :-  %ny  'Chichewa, Chewa, Nyanja'
      :-  %zh  'Chinese'
      :-  %cu  'Church Slavic, Old Slavonic, Church Slavonic, Old Bulgarian, Old Church Slavonic'
      :-  %cv  'Chuvash'
      :-  %kw  'Cornish'
      :-  %co  'Corsican'
      :-  %cr  'Cree'
      :-  %hr  'Croatian'
      :-  %cs  'Czech'
      :-  %da  'Danish'
      :-  %dv  'Divehi, Dhivehi, Maldivian'
      :-  %nl  'Dutch, Flemish'
      :-  %dz  'Dzongkha'
      :-  %en  'English'
      :-  %eo  'Esperanto'
      :-  %et  'Estonian'
      :-  %ee  'Ewe'
      :-  %fo  'Faroese'
      :-  %fj  'Fijian'
      :-  %fi  'Finnish'
      :-  %fr  'French'
      :-  %fy  'Western Frisian'
      :-  %ff  'Fulah'
      :-  %gd  'Gaelic, Scottish Gaelic'
      :-  %gl  'Galician'
      :-  %lg  'Ganda'
      :-  %ka  'Georgian'
      :-  %de  'German'
      :-  %el  'Greek, Modern (1453–)'
      :-  %kl  'Kalaallisut, Greenlandic'
      :-  %gn  'Guarani'
      :-  %gu  'Gujarati'
      :-  %ht  'Haitian, Haitian Creole'
      :-  %ha  'Hausa'
      :-  %he  'Hebrew'
      :-  %hz  'Herero'
      :-  %hi  'Hindi'
      :-  %ho  'Hiri Motu'
      :-  %hu  'Hungarian'
      :-  %is  'Icelandic'
      :-  %io  'Ido'
      :-  %ig  'Igbo'
      :-  %id  'Indonesian'
      :-  %ia  'Interlingua (International Auxiliary Language Association)'
      :-  %ie  'Interlingue, Occidental'
      :-  %iu  'Inuktitut'
      :-  %ik  'Inupiaq'
      :-  %ga  'Irish'
      :-  %it  'Italian'
      :-  %ja  'Japanese'
      :-  %jv  'Javanese'
      :-  %kn  'Kannada'
      :-  %kr  'Kanuri'
      :-  %ks  'Kashmiri'
      :-  %kk  'Kazakh'
      :-  %km  'Central Khmer'
      :-  %ki  'Kikuyu, Gikuyu'
      :-  %rw  'Kinyarwanda'
      :-  %ky  'Kirghiz, Kyrgyz'
      :-  %kv  'Komi'
      :-  %kg  'Kongo'
      :-  %ko  'Korean'
      :-  %kj  'Kuanyama, Kwanyama'
      :-  %ku  'Kurdish'
      :-  %lo  'Lao'
      :-  %la  'Latin'
      :-  %lv  'Latvian'
      :-  %li  'Limburgan, Limburger, Limburgish'
      :-  %ln  'Lingala'
      :-  %lt  'Lithuanian'
      :-  %lu  'Luba-Katanga'
      :-  %lb  'Luxembourgish, Letzeburgesch'
      :-  %mk  'Macedonian'
      :-  %mg  'Malagasy'
      :-  %ms  'Malay'
      :-  %ml  'Malayalam'
      :-  %mt  'Maltese'
      :-  %gv  'Manx'
      :-  %mi  'Maori'
      :-  %mr  'Marathi'
      :-  %mh  'Marshallese'
      :-  %mn  'Mongolian'
      :-  %na  'Nauru'
      :-  %nv  'Navajo, Navaho'
      :-  %nd  'North Ndebele'
      :-  %nr  'South Ndebele'
      :-  %ng  'Ndonga'
      :-  %ne  'Nepali'
      :-  %no  'Norwegian'
      :-  %nb  'Norwegian Bokmål'
      :-  %nn  'Norwegian Nynorsk'
      :-  %ii  'Sichuan Yi, Nuosu'
      :-  %oc  'Occitan'
      :-  %oj  'Ojibwa'
      :-  %or  'Oriya'
      :-  %om  'Oromo'
      :-  %os  'Ossetian, Ossetic'
      :-  %pi  'Pali'
      :-  %ps  'Pashto, Pushto'
      :-  %fa  'Persian'
      :-  %pl  'Polish'
      :-  %pt  'Portuguese'
      :-  %pa  'Punjabi, Panjabi'
      :-  %qu  'Quechua'
      :-  %ro  'Romanian, Moldavian, Moldovan'
      :-  %rm  'Romansh'
      :-  %rn  'Rundi'
      :-  %ru  'Russian'
      :-  %se  'Northern Sami'
      :-  %sm  'Samoan'
      :-  %sg  'Sango'
      :-  %sa  'Sanskrit'
      :-  %sc  'Sardinian'
      :-  %sr  'Serbian'
      :-  %sn  'Shona'
      :-  %sd  'Sindhi'
      :-  %si  'Sinhala, Sinhalese'
      :-  %sk  'Slovak'
      :-  %sl  'Slovenian'
      :-  %so  'Somali'
      :-  %st  'Southern Sotho'
      :-  %es  'Spanish, Castilian'
      :-  %su  'Sundanese'
      :-  %sw  'Swahili'
      :-  %ss  'Swati'
      :-  %sv  'Swedish'
      :-  %tl  'Tagalog'
      :-  %ty  'Tahitian'
      :-  %tg  'Tajik'
      :-  %ta  'Tamil'
      :-  %tt  'Tatar'
      :-  %te  'Telugu'
      :-  %th  'Thai'
      :-  %bo  'Tibetan'
      :-  %ti  'Tigrinya'
      :-  %to  'Tonga (Tonga Islands)'
      :-  %ts  'Tsonga'
      :-  %tn  'Tswana'
      :-  %tr  'Turkish'
      :-  %tk  'Turkmen'
      :-  %tw  'Twi'
      :-  %ug  'Uighur, Uyghur'
      :-  %uk  'Ukrainian'
      :-  %ur  'Urdu'
      :-  %uz  'Uzbek'
      :-  %ve  'Venda'
      :-  %vi  'Vietnamese'
      :-  %vo  'Volapük'
      :-  %wa  'Walloon'
      :-  %cy  'Welsh'
      :-  %wo  'Wolof'
      :-  %xh  'Xhosa'
      :-  %yi  'Yiddish'
      :-  %yo  'Yoruba'
      :-  %za  'Zhuang, Chuang'
      :-  %zu  'Zulu'
  ==
::
::  ISO 639-2 Three-Letter Codes
+$  iso-639-2-keys  $?  %aar  %abk  %ace  %ach  %ada  %ady  %afa  %afh  %afr
                        %ain  %aka  %akk  %ale  %alg  %alt  %amh  %ang  %anp
                        %apa  %ara  %arc  %arg  %arn  %arp  %art  %arw  %asm
                        %ast  %ath  %aus  %ava  %ave  %awa  %aym  %aze  %bad
                        %bai  %bak  %bal  %bam  %ban  %bas  %bat  %bej  %bel
                        %bem  %ben  %ber  %bho  %bih  %bik  %bin  %bis  %bla
                        %bnt  %bod  %bos  %bra  %bre  %btk  %bua  %bug  %bul  
                        %byn  %cad  %cai  %car  %cat  %cau  %ceb  %cel  %ces  
                        %cha  %chb  %che  %chg  %chk  %chm  %chn  %cho  %chp  
                        %chr  %chu  %chv  %chy  %cmc  %cnr  %cop  %cor  %cos  
                        %cpe  %cpf  %cpp  %cre  %crh  %crp  %csb  %cus  %cym  
                        %dak  %dan  %dar  %day  %del  %den  %deu  %dgr  %din  
                        %div  %doi  %dra  %dsb  %dua  %dum  %dyu  %dzo  %efi  
                        %egy  %eka  %ell  %elx  %eng  %enm  %epo  %est  %eus  
                        %ewe  %ewo  %fan  %fao  %fas  %fat  %fij  %fil  %fin  
                        %fiu  %fon  %fra  %frm  %fro  %frr  %frs  %fry  %ful  
                        %fur  %gaa  %gay  %gba  %gem  %gez  %gil  %gla  %gle  
                        %glg  %glv  %gmh  %goh  %gon  %gor  %got  %grb  %grc  
                        %grn  %gsw  %guj  %gwi  %hai  %hat  %hau  %haw  %heb  
                        %her  %hil  %him  %hin  %hit  %hmn  %hmo  %hrv  %hsb  
                        %hun  %hup  %hye  %iba  %ibo  %ido  %iii  %ijo  %iku  
                        %ile  %ilo  %ina  %inc  %ind  %ine  %inh  %ipk  %ira  
                        %iro  %isl  %ita  %jav  %jbo  %jpn  %jpr  %jrb  %kaa  
                        %kab  %kac  %kal  %kam  %kan  %kar  %kas  %kat  %kau  
                        %kaw  %kaz  %kbd  %kha  %khi  %khm  %kho  %kik  %kin  
                        %kir  %kmb  %kok  %kom  %kon  %kor  %kos  %kpe  %krc  
                        %krl  %kro  %kru  %kua  %kum  %kur  %kut  %lad  %lah  
                        %lam  %lao  %lat  %lav  %lez  %lim  %lin  %lit  %lol  
                        %loz  %ltz  %lua  %lub  %lug  %lui  %lun  %luo  %lus  
                        %mad  %mag  %mah  %mai  %mak  %mal  %man  %map  %mar  
                        %mas  %mdf  %mdr  %men  %mga  %mic  %min  %mis  %mkd  
                        %mkh  %mlg  %mlt  %mnc  %mni  %mno  %moh  %mon  %mos  
                        %mri  %msa  %mul  %mun  %mus  %mwl  %mwr  %mya  %myn  
                        %myv  %nah  %nai  %nap  %nau  %nav  %nbl  %nde  %ndo  
                        %nds  %nep  %new  %nia  %nic  %niu  %nld  %nno  %nob  
                        %nog  %non  %nor  %nqo  %nso  %nub  %nwc  %nya  %nym  
                        %nyn  %nyo  %nzi  %oci  %oji  %ori  %orm  %osa  %oss  
                        %ota  %oto  %paa  %pag  %pal  %pam  %pan  %pap  %pau  
                        %peo  %phi  %phn  %pli  %pol  %pon  %por  %pra  %pro  
                        %pus  %qaa  %qab  %qac  %qad  %qae  %qaf  %qag  %qah  
                        %qai  %qaj  %qak  %qal  %qam  %qan  %qao  %qap  %qaq  
                        %qar  %qas  %qat  %qau  %qav  %qaw  %qax  %qay  %qaz  
                        %qba  %qbb  %qbc  %qbd  %qbe  %qbf  %qbg  %qbh  %qbi  
                        %qbj  %qbk  %qbl  %qbm  %qbn  %qbo  %qbp  %qbq  %qbr  
                        %qbs  %qbt  %qbu  %qbv  %qbw  %qbx  %qby  %qbz  %qca  
                        %qcb  %qcc  %qcd  %qce  %qcf  %qcg  %qch  %qci  %qcj  
                        %qck  %qcl  %qcm  %qcn  %qco  %qcp  %qcq  %qcr  %qcs  
                        %qct  %qcu  %qcv  %qcw  %qcx  %qcy  %qcz  %qda  %qdb  
                        %qdc  %qdd  %qde  %qdf  %qdg  %qdh  %qdi  %qdj  %qdk  
                        %qdl  %qdm  %qdn  %qdo  %qdp  %qdq  %qdr  %qds  %qdt  
                        %qdu  %qdv  %qdw  %qdx  %qdy  %qdz  %qea  %qeb  %qec  
                        %qed  %qee  %qef  %qeg  %qeh  %qei  %qej  %qek  %qel  
                        %qem  %qen  %qeo  %qep  %qeq  %qer  %qes  %qet  %qeu  
                        %qev  %qew  %qex  %qey  %qez  %qfa  %qfb  %qfc  %qfd  
                        %qfe  %qff  %qfg  %qfh  %qfi  %qfj  %qfk  %qfl  %qfm  
                        %qfn  %qfo  %qfp  %qfq  %qfr  %qfs  %qft  %qfu  %qfv  
                        %qfw  %qfx  %qfy  %qfz  %qga  %qgb  %qgc  %qgd  %qge  
                        %qgf  %qgg  %qgh  %qgi  %qgj  %qgk  %qgl  %qgm  %qgn  
                        %qgo  %qgp  %qgq  %qgr  %qgs  %qgt  %qgu  %qgv  %qgw  
                        %qgx  %qgy  %qgz  %qha  %qhb  %qhc  %qhd  %qhe  %qhf  
                        %qhg  %qhh  %qhi  %qhj  %qhk  %qhl  %qhm  %qhn  %qho  
                        %qhp  %qhq  %qhr  %qhs  %qht  %qhu  %qhv  %qhw  %qhx  
                        %qhy  %qhz  %qia  %qib  %qic  %qid  %qie  %qif  %qig  
                        %qih  %qii  %qij  %qik  %qil  %qim  %qin  %qio  %qip  
                        %qiq  %qir  %qis  %qit  %qiu  %qiv  %qiw  %qix  %qiy  
                        %qiz  %qja  %qjb  %qjc  %qjd  %qje  %qjf  %qjg  %qjh  
                        %qji  %qjj  %qjk  %qjl  %qjm  %qjn  %qjo  %qjp  %qjq  
                        %qjr  %qjs  %qjt  %qju  %qjv  %qjw  %qjx  %qjy  %qjz  
                        %qka  %qkb  %qkc  %qkd  %qke  %qkf  %qkg  %qkh  %qki  
                        %qkj  %qkk  %qkl  %qkm  %qkn  %qko  %qkp  %qkq  %qkr  
                        %qks  %qkt  %qku  %qkv  %qkw  %qkx  %qky  %qkz  %qla  
                        %qlb  %qlc  %qld  %qle  %qlf  %qlg  %qlh  %qli  %qlj  
                        %qlk  %qll  %qlm  %qln  %qlo  %qlp  %qlq  %qlr  %qls  
                        %qlt  %qlu  %qlv  %qlw  %qlx  %qly  %qlz  %qma  %qmb  
                        %qmc  %qmd  %qme  %qmf  %qmg  %qmh  %qmi  %qmj  %qmk  
                        %qml  %qmm  %qmn  %qmo  %qmp  %qmq  %qmr  %qms  %qmt  
                        %qmu  %qmv  %qmw  %qmx  %qmy  %qmz  %qna  %qnb  %qnc  
                        %qnd  %qne  %qnf  %qng  %qnh  %qni  %qnj  %qnk  %qnl  
                        %qnm  %qnn  %qno  %qnp  %qnq  %qnr  %qns  %qnt  %qnu  
                        %qnv  %qnw  %qnx  %qny  %qnz  %qoa  %qob  %qoc  %qod  
                        %qoe  %qof  %qog  %qoh  %qoi  %qoj  %qok  %qol  %qom  
                        %qon  %qoo  %qop  %qoq  %qor  %qos  %qot  %qou  %qov 
                        %qow  %qox  %qoy  %qoz  %qpa  %qpb  %qpc  %qpd  %qpe  
                        %qpf  %qpg  %qph  %qpi  %qpj  %qpk  %qpl  %qpm  %qpn  
                        %qpo  %qpp  %qpq  %qpr  %qps  %qpt  %qpu  %qpv  %qpw  
                        %qpx  %qpy  %qpz  %qqa  %qqb  %qqc  %qqd  %qqe  %qqf  
                        %qqg  %qqh  %qqi  %qqj  %qqk  %qql  %qqm  %qqn  %qqo  
                        %qqp  %qqq  %qqr  %qqs  %qqt  %qqu  %qqv  %qqw  %qqx  
                        %qqy  %qqz  %qra  %qrb  %qrc  %qrd  %qre  %qrf  %qrg  
                        %qrh  %qri  %qrj  %qrk  %qrl  %qrm  %qrn  %qro  %qrp  
                        %qrq  %qrr  %qrs  %qrt  %qru  %qrv  %qrw  %qrx  %qry  
                        %qrz  %qsa  %qsb  %qsc  %qsd  %qse  %qsf  %qsg  %qsh  
                        %qsi  %qsj  %qsk  %qsl  %qsm  %qsn  %qso  %qsp  %qsq  
                        %qsr  %qss  %qst  %qsu  %qsv  %qsw  %qsx  %qsy  %qsz  
                        %qta  %qtb  %qtc  %qtd  %qte  %qtf  %qtg  %qth  %qti  
                        %qtj  %qtk  %qtl  %qtm  %qtn  %qto  %qtp  %qtq  %qtr  
                        %qts  %qtt  %qtu  %qtv  %qtw  %qtx  %qty  %qtz  %que  
                        %raj  %rap  %rar  %roa  %roh  %rom  %ron  %run  %rup  
                        %rus  %sad  %sag  %sah  %sai  %sal  %sam  %san  %sas  
                        %sat  %scn  %sco  %sel  %sem  %sga  %sgn  %shn  %sid  
                        %sin  %sio  %sit  %sla  %slk  %slv  %sma  %sme  %smi  
                        %smj  %smn  %smo  %sms  %sna  %snd  %snk  %sog  %som  
                        %son  %sot  %spa  %sqi  %srd  %srn  %srp  %srr  %ssa  
                        %ssw  %suk  %sun  %sus  %sux  %swa  %swe  %syc  %syr  
                        %tah  %tai  %tam  %tat  %tel  %tem  %ter  %tet  %tgk  
                        %tgl  %tha  %tig  %tir  %tiv  %tkl  %tlh  %tli  %tmh  
                        %tog  %ton  %tpi  %tsi  %tsn  %tso  %tuk  %tum  %tup  
                        %tur  %tut  %tvl  %twi  %tyv  %udm  %uga  %uig  %ukr  
                        %umb  %und  %urd  %uzb  %vai  %ven  %vie  %vol  %vot  
                        %wak  %wal  %war  %was  %wen  %wln  %wol  %xal  %xho  
                        %yao  %yap  %yid  %yor  %ypk  %zap  %zbl  %zen  %zgh  
                        %zha  %zho  %znd  %zul  %zun  %zxx  %zza   %pie  %hop
                        %$    ==
++  iso-639-2
  ^-  (map @tas @t)
  %-  malt
  ^-  (list (pair @tas @t))
  ;:  weld
  ^-  (list (pair @tas @t))
  :~  :-  %aar  'Afar'
      :-  %abk  'Abkhazian'
      :-  %ace  'Achinese'
      :-  %ach  'Acoli'
      :-  %ada  'Adangme'
      :-  %ady  'Adyghe; Adygei'
      :-  %afa  'Afro-Asiatic languages'
      :-  %afh  'Afrihili'
      :-  %afr  'Afrikaans'
      :-  %ain  'Ainu'
      :-  %aka  'Akan'
      :-  %akk  'Akkadian'
      :-  %ale  'Aleut'
      :-  %alg  'Algonquian languages'
      :-  %alt  'Southern Altai'
      :-  %amh  'Amharic'
      :-  %ang  'English, Old (ca.450–1100)'
      :-  %anp  'Angika'
      :-  %apa  'Apache languages'
      :-  %ara  'Arabic'
      :-  %arc  'Official Aramaic (700–300 BCE); Imperial Aramaic (700–300 BCE)'
      :-  %arg  'Aragonese'
      :-  %arn  'Mapudungun; Mapuche'
      :-  %arp  'Arapaho'
      :-  %art  'Artificial languages'
      :-  %arw  'Arawak'
      :-  %asm  'Assamese'
      :-  %ast  'Asturian; Bable; Leonese; Asturleonese'
      :-  %ath  'Athapascan languages'
      :-  %aus  'Australian languages'
      :-  %ava  'Avaric'
      :-  %ave  'Avestan'
      :-  %awa  'Awadhi'
      :-  %aym  'Aymara'
      :-  %aze  'Azerbaijani'
      :-  %bad  'Banda languages'
      :-  %bai  'Bamileke languages'
      :-  %bak  'Bashkir'
      :-  %bal  'Baluchi'
      :-  %bam  'Bambara'
      :-  %ban  'Balinese'
      :-  %bas  'Basa'
      :-  %bat  'Baltic languages'
      :-  %bej  'Beja; Bedawiyet'
      :-  %bel  'Belarusian'
      :-  %bem  'Bemba'
      :-  %ben  'Bengali'
      :-  %ber  'Berber languages'
      :-  %bho  'Bhojpuri'
      :-  %bih  'Bihari languages'
      :-  %bik  'Bikol'
      :-  %bin  'Bini; Edo'
      :-  %bis  'Bislama'
      :-  %bla  'Siksika'
      :-  %bnt  'Bantu languages'
      :-  %bod  'Tibetan'
      :-  %bos  'Bosnian'
      :-  %bra  'Braj'
      :-  %bre  'Breton'
      :-  %btk  'Batak languages'
      :-  %bua  'Buriat'
      :-  %bug  'Buginese'
      :-  %bul  'Bulgarian'
      :-  %byn  'Blin; Bilin'
      :-  %cad  'Caddo'
      :-  %cai  'Central American Indian languages'
      :-  %car  'Galibi Carib'
      :-  %cat  'Catalan; Valencian'
      :-  %cau  'Caucasian languages'
      :-  %ceb  'Cebuano'
      :-  %cel  'Celtic languages'
      :-  %ces  'Czech'
      :-  %cha  'Chamorro'
      :-  %chb  'Chibcha'
      :-  %che  'Chechen'
      :-  %chg  'Chagatai'
      :-  %chk  'Chuukese'
      :-  %chm  'Mari'
      :-  %chn  'Chinook jargon'
      :-  %cho  'Choctaw'
      :-  %chp  'Chipewyan; Dene Suline'
      :-  %chr  'Cherokee'
      :-  %chu  'Church Slavic; Old Slavonic; Church Slavonic; Old Bulgarian; Old Church Slavonic'
      :-  %chv  'Chuvash'
      :-  %chy  'Cheyenne'
      :-  %cmc  'Chamic languages'
      :-  %cnr  'Montenegrin'
      :-  %cop  'Coptic'
      :-  %cor  'Cornish'
      :-  %cos  'Corsican'
      :-  %cpe  'Creoles and pidgins, English based'
      :-  %cpf  'Creoles and pidgins, French-based'
      :-  %cpp  'Creoles and pidgins, Portuguese-based'
      :-  %cre  'Cree'
      :-  %crh  'Crimean Tatar; Crimean Turkish'
      :-  %crp  'Creoles and pidgins'
      :-  %csb  'Kashubian'
      :-  %cus  'Cushitic languages'
      :-  %cym  'Welsh'
      :-  %dak  'Dakota'
      :-  %dan  'Danish'
      :-  %dar  'Dargwa'
      :-  %day  'Land Dayak languages'
      :-  %del  'Delaware'
      :-  %den  'Slave (Athapascan)'
      :-  %deu  'German'
      :-  %dgr  'Dogrib'
      :-  %din  'Dinka'
      :-  %div  'Divehi; Dhivehi; Maldivian'
      :-  %doi  'Dogri'
      :-  %dra  'Dravidian languages'
      :-  %dsb  'Lower Sorbian'
      :-  %dua  'Duala'
      :-  %dum  'Dutch, Middle (ca. 1050–1350)'
      :-  %dyu  'Dyula'
      :-  %dzo  'Dzongkha'
      :-  %efi  'Efik'
      :-  %egy  'Egyptian (Ancient)'
      :-  %eka  'Ekajuk'
      :-  %ell  'Greek, Modern (1453–)'
      :-  %elx  'Elamite'
      :-  %eng  'English'
      :-  %enm  'English, Middle (1100–1500)'
      :-  %epo  'Esperanto'
      :-  %est  'Estonian'
      :-  %eus  'Basque'
      :-  %ewe  'Ewe'
      :-  %ewo  'Ewondo'
      :-  %fan  'Fang'
      :-  %fao  'Faroese'
      :-  %fas  'Persian'
      :-  %fat  'Fanti'
      :-  %fij  'Fijian'
      :-  %fil  'Filipino; Pilipino'
      :-  %fin  'Finnish'
      :-  %fiu  'Finno-Ugrian languages'
      :-  %fon  'Fon'
      :-  %fra  'French'
      :-  %frm  'French, Middle (ca. 1400–1600)'
      :-  %fro  'French, Old (842–ca. 1400)'
      :-  %frr  'Northern Frisian'
      :-  %frs  'East Frisian Low Saxon'
      :-  %fry  'Western Frisian'
      :-  %ful  'Fulah'
      :-  %fur  'Friulian'
      :-  %gaa  'Ga'
      :-  %gay  'Gayo'
      :-  %gba  'Gbaya'
      :-  %gem  'Germanic languages'
      :-  %gez  'Geez'
      :-  %gil  'Gilbertese'
      :-  %gla  'Gaelic; Scottish Gaelic'
      :-  %gle  'Irish'
      :-  %glg  'Galician'
      :-  %glv  'Manx'
      :-  %gmh  'German, Middle High (ca. 1050–1500)'
      :-  %goh  'German, Old High (ca. 750–1050)'
      :-  %gon  'Gondi'
      :-  %gor  'Gorontalo'
      :-  %got  'Gothic'
      :-  %grb  'Grebo'
      :-  %grc  'Greek, Ancient (to 1453)'
      :-  %grn  'Guarani'
      :-  %gsw  'Swiss German; Alemannic; Alsatian'
      :-  %guj  'Gujarati'
      :-  %gwi  'Gwich\'in'
      :-  %hai  'Haida'
      :-  %hat  'Haitian; Haitian Creole'
      :-  %hau  'Hausa'
      :-  %haw  'Hawaiian'
      :-  %heb  'Hebrew'
      :-  %her  'Herero'
      :-  %hil  'Hiligaynon'
      :-  %him  'Himachali languages; Pahari languages'
      :-  %hin  'Hindi'
      :-  %hit  'Hittite'
      :-  %hmn  'Hmong; Mong'
      :-  %hmo  'Hiri Motu'
      :-  %hop  'Hopi'  :: ISO-639-3
      :-  %hrv  'Croatian'
      :-  %hsb  'Upper Sorbian'
      :-  %hun  'Hungarian'
      :-  %hup  'Hupa'
      :-  %hye  'Armenian'
      :-  %iba  'Iban'
      :-  %ibo  'Igbo'
      :-  %ido  'Ido'
      :-  %iii  'Sichuan Yi; Nuosu'
      :-  %ijo  'Ijo languages'
      :-  %iku  'Inuktitut'
      :-  %ile  'Interlingue; Occidental'
      :-  %ilo  'Iloko'
      :-  %ina  'Interlingua (International Auxiliary Language Association)'
      :-  %inc  'Indo-Aryan languages'
      :-  %ind  'Indonesian'
      :-  %ine  'Indo-European languages'
      :-  %inh  'Ingush'
      :-  %ipk  'Inupiaq'
      :-  %ira  'Iranian languages'
      :-  %iro  'Iroquoian languages'
      :-  %isl  'Icelandic'
      :-  %ita  'Italian'
      :-  %jav  'Javanese'
      :-  %jbo  'Lojban'
      :-  %jpn  'Japanese'
      :-  %jpr  'Judeo-Persian'
      :-  %jrb  'Judeo-Arabic'
      :-  %kaa  'Kara-Kalpak'
      :-  %kab  'Kabyle'
      :-  %kac  'Kachin; Jingpho'
      :-  %kal  'Kalaallisut; Greenlandic'
      :-  %kam  'Kamba'
      :-  %kan  'Kannada'
      :-  %kar  'Karen languages'
      :-  %kas  'Kashmiri'
      :-  %kat  'Georgian'
      :-  %kau  'Kanuri'
      :-  %kaw  'Kawi'
      :-  %kaz  'Kazakh'
      :-  %kbd  'Kabardian'
      :-  %kha  'Khasi'
      :-  %khi  'Khoisan languages'
      :-  %khm  'Central Khmer'
      :-  %kho  'Khotanese; Sakan'
      :-  %kik  'Kikuyu; Gikuyu'
      :-  %kin  'Kinyarwanda'
      :-  %kir  'Kirghiz; Kyrgyz'
      :-  %kmb  'Kimbundu'
      :-  %kok  'Konkani'
      :-  %kom  'Komi'
      :-  %kon  'Kongo'
      :-  %kor  'Korean'
      :-  %kos  'Kosraean'
      :-  %kpe  'Kpelle'
      :-  %krc  'Karachay-Balkar'
      :-  %krl  'Karelian'
      :-  %kro  'Kru languages'
      :-  %kru  'Kurukh'
      :-  %kua  'Kuanyama; Kwanyama'
      :-  %kum  'Kumyk'
      :-  %kur  'Kurdish'
      :-  %kut  'Kutenai'
      :-  %lad  'Ladino'
      :-  %lah  'Lahnda'
      :-  %lam  'Lamba'
      :-  %lao  'Lao'
      :-  %lat  'Latin'
      :-  %lav  'Latvian'
      :-  %lez  'Lezghian'
      :-  %lim  'Limburgan; Limburger; Limburgish'
      :-  %lin  'Lingala'
      :-  %lit  'Lithuanian'
      :-  %lol  'Mongo'
      :-  %loz  'Lozi'
      :-  %ltz  'Luxembourgish; Letzeburgesch'
      :-  %lua  'Luba-Lulua'
      :-  %lub  'Luba-Katanga'
      :-  %lug  'Ganda'
      :-  %lui  'Luiseno'
      :-  %lun  'Lunda'
      :-  %luo  'Luo (Kenya and Tanzania)'
      :-  %lus  'Lushai'
      :-  %mad  'Madurese'
      :-  %mag  'Magahi'
      :-  %mah  'Marshallese'
      :-  %mai  'Maithili'
      :-  %mak  'Makasar'
      :-  %mal  'Malayalam'
      :-  %man  'Mandingo'
      :-  %map  'Austronesian languages'
      :-  %mar  'Marathi'
      :-  %mas  'Masai'
      :-  %mdf  'Moksha'
      :-  %mdr  'Mandar'
      :-  %men  'Mende'
      :-  %mga  'Irish, Middle (900–1200)'
      :-  %mic  'Mi\'kmaq; Micmac'
      :-  %min  'Minangkabau'
      :-  %mis  'Uncoded languages'
      :-  %mkd  'Macedonian'
      :-  %mkh  'Mon-Khmer languages'
      :-  %mlg  'Malagasy'
      :-  %mlt  'Maltese'
      :-  %mnc  'Manchu'
      :-  %mni  'Manipuri'
      :-  %mno  'Manobo languages'
      :-  %moh  'Mohawk'
      :-  %mon  'Mongolian'
      :-  %mos  'Mossi'
      :-  %mri  'Māori'
      :-  %msa  'Malay'
      :-  %mul  'Multiple languages'
      :-  %mun  'Munda languages'
      :-  %mus  'Creek'
      :-  %mwl  'Mirandese'
      :-  %mwr  'Marwari'
      :-  %mya  'Burmese'
      :-  %myn  'Mayan languages'
      :-  %myv  'Erzya'
      :-  %nah  'Nahuatl languages'
      :-  %nai  'North American Indian languages'
      :-  %nap  'Neapolitan'
      :-  %nau  'Nauru'
      :-  %nav  'Navajo; Navaho'
      :-  %nbl  'Ndebele, South; South Ndebele'
      :-  %nde  'Ndebele, North; North Ndebele'
      :-  %ndo  'Ndonga'
      :-  %nds  'Low German; Low Saxon; German, Low; Saxon, Low'
      :-  %nep  'Nepali'
      :-  %new  'Nepal Bhasa; Newari'
      :-  %nia  'Nias'
      :-  %nic  'Niger-Kordofanian languages'
      :-  %niu  'Niuean'
      :-  %nld  'Dutch; Flemish'
      :-  %nno  'Norwegian Nynorsk; Nynorsk, Norwegian'
      :-  %nob  'Bokmål, Norwegian; Norwegian Bokmål'
      :-  %nog  'Nogai'
      :-  %non  'Norse, Old'
      :-  %nor  'Norwegian'
      :-  %nqo  'N\'Ko'
      :-  %nso  'Pedi; Sepedi; Northern Sotho'
      :-  %nub  'Nubian languages'
      :-  %nwc  'Classical Newari; Old Newari; Classical Nepal Bhasa'
      :-  %nya  'Chichewa; Chewa; Nyanja'
      :-  %nym  'Nyamwezi'
      :-  %nyn  'Nyankole'
      :-  %nyo  'Nyoro'
      :-  %nzi  'Nzima'
      :-  %oci  'Occitan (post 1500)'
      :-  %oji  'Ojibwa'
      :-  %ori  'Oriya'
      :-  %orm  'Oromo'
      :-  %osa  'Osage'
      :-  %oss  'Ossetian; Ossetic'
      :-  %ota  'Turkish, Ottoman (1500–1928)'
      :-  %oto  'Otomian languages'
      :-  %paa  'Papuan languages'
      :-  %pag  'Pangasinan'
      :-  %pal  'Pahlavi'
      :-  %pam  'Pampanga; Kapampangan'
      :-  %pan  'Panjabi; Punjabi'
      :-  %pap  'Papiamento'
      :-  %pau  'Palauan'
      :-  %peo  'Persian, Old (ca. 600–400 B.C.)'
      :-  %phi  'Philippine languages'
      :-  %phn  'Phoenician'
      :-  %pie  'Proto-Indo-European'  :: irregular
      :-  %pli  'Pali'
      :-  %pol  'Polish'
      :-  %pon  'Pohnpeian'
      :-  %por  'Portuguese'
      :-  %pra  'Prakrit languages'
      :-  %pro  'Provençal, Old (to 1500); Old Occitan (to 1500)'
      :-  %pus  'Pushto; Pashto'
      ::  %qaa-qtz  'Reserved for local use' (deal with below)
      :-  %que  'Quechua'
      :-  %raj  'Rajasthani'
      :-  %rap  'Rapanui'
      :-  %rar  'Rarotongan; Cook Islands Māori'
      :-  %roa  'Romance languages'
      :-  %roh  'Romansh'
      :-  %rom  'Romany'
      :-  %ron  'Romanian; Moldavian; Moldovan'
      :-  %run  'Rundi'
      :-  %rup  'Aromanian; Arumanian; Macedo-Romanian[b]'
      :-  %rus  'Russian'
      :-  %sad  'Sandawe'
      :-  %sag  'Sango'
      :-  %sah  'Yakut'
      :-  %sai  'South American Indian languages'
      :-  %sal  'Salishan languages'
      :-  %sam  'Samaritan Aramaic'
      :-  %san  'Sanskrit'
      :-  %sas  'Sasak'
      :-  %sat  'Santali'
      :-  %scn  'Sicilian'
      :-  %sco  'Scots'
      :-  %sel  'Selkup'
      :-  %sem  'Semitic languages'
      :-  %sga  'Irish, Old (to 900)'
      :-  %sgn  'Sign Languages'
      :-  %shn  'Shan'
      :-  %sid  'Sidamo'
      :-  %sin  'Sinhala; Sinhalese'
      :-  %sio  'Siouan languages'
      :-  %sit  'Sino-Tibetan languages'
      :-  %sla  'Slavic languages'
      :-  %slk  'Slovak'
      :-  %slv  'Slovenian'
      :-  %sma  'Southern Sami'
      :-  %sme  'Northern Sami'
      :-  %smi  'Sami languages'
      :-  %smj  'Lule Sami'
      :-  %smn  'Inari Sami'
      :-  %smo  'Samoan'
      :-  %sms  'Skolt Sami'
      :-  %sna  'Shona'
      :-  %snd  'Sindhi'
      :-  %snk  'Soninke'
      :-  %sog  'Sogdian'
      :-  %som  'Somali'
      :-  %son  'Songhai languages'
      :-  %sot  'Sotho, Southern'
      :-  %spa  'Spanish; Castilian'
      :-  %sqi  'Albanian'
      :-  %srd  'Sardinian'
      :-  %srn  'Sranan Tongo'
      :-  %srp  'Serbian'
      :-  %srr  'Serer'
      :-  %ssa  'Nilo-Saharan languages'
      :-  %ssw  'Swati'
      :-  %suk  'Sukuma'
      :-  %sun  'Sundanese'
      :-  %sus  'Susu'
      :-  %sux  'Sumerian'
      :-  %swa  'Swahili'
      :-  %swe  'Swedish'
      :-  %syc  'Classical Syriac'
      :-  %syr  'Syriac'
      :-  %tah  'Tahitian'
      :-  %tai  'Tai languages'
      :-  %tam  'Tamil'
      :-  %tat  'Tatar'
      :-  %tel  'Telugu'
      :-  %tem  'Timne'
      :-  %ter  'Tereno'
      :-  %tet  'Tetum'
      :-  %tgk  'Tajik'
      :-  %tgl  'Tagalog'
      :-  %tha  'Thai'
      :-  %tig  'Tigre'
      :-  %tir  'Tigrinya'
      :-  %tiv  'Tiv'
      :-  %tkl  'Tokelau'
      :-  %tlh  'Klingon; tlhIngan-Hol'
      :-  %tli  'Tlingit'
      :-  %tmh  'Tamashek'
      :-  %tog  'Tonga (Nyasa)'
      :-  %ton  'Tonga (Tonga Islands)'
      :-  %tpi  'Tok Pisin'
      :-  %tsi  'Tsimshian'
      :-  %tsn  'Tswana'
      :-  %tso  'Tsonga'
      :-  %tuk  'Turkmen'
      :-  %tum  'Tumbuka'
      :-  %tup  'Tupi languages'
      :-  %tur  'Turkish'
      :-  %tut  'Altaic languages'
      :-  %tvl  'Tuvalu'
      :-  %twi  'Twi'
      :-  %tyv  'Tuvinian'
      :-  %udm  'Udmurt'
      :-  %uga  'Ugaritic'
      :-  %uig  'Uighur; Uyghur'
      :-  %ukr  'Ukrainian'
      :-  %umb  'Umbundu'
      :-  %und  'Undetermined'
      :-  %urd  'Urdu'
      :-  %uzb  'Uzbek'
      :-  %vai  'Vai'
      :-  %ven  'Venda'
      :-  %vie  'Vietnamese'
      :-  %vol  'Volapük'
      :-  %vot  'Votic'
      :-  %wak  'Wakashan languages'
      :-  %wal  'Wolaitta; Wolaytta'
      :-  %war  'Waray'
      :-  %was  'Washo'
      :-  %wen  'Sorbian languages'
      :-  %wln  'Walloon'
      :-  %wol  'Wolof'
      :-  %xal  'Kalmyk; Oirat'
      :-  %xho  'Xhosa'
      :-  %yao  'Yao'
      :-  %yap  'Yapese'
      :-  %yid  'Yiddish'
      :-  %yor  'Yoruba'
      :-  %ypk  'Yupik languages'
      :-  %zap  'Zapotec'
      :-  %zbl  'Blissymbols; Blissymbolics; Bliss'
      :-  %zen  'Zenaga'
      :-  %zgh  'Standard Moroccan Tamazight'
      :-  %zha  'Zhuang; Chuang'
      :-  %zho  'Chinese'
      :-  %znd  'Zande languages'
      :-  %zul  'Zulu'
      :-  %zun  'Zuni'
      :-  %zxx  'No linguistic content; Not applicable'
      :-  %zza  'Zaza; Dimili; Dimli; Kirdki; Kirmanjki; Zazaki'  
  ==
  ::  %qaa-qtz  'Reserved for local use'
  %+  turn
  %+  turn  (gulf 0 519)
  |=(a=@ ^-(@tas (add 0x60.6071 (add (mul +((mod a 26)) 0x1.0000) (mul +((div a 26)) 0x100)))))
  |=(a=@tas [a 'Reserved for local use'])
  ==
::
::  ISO 639-3 Three-Letter Codes are, alas, currently unsupported.
::++  iso-639-3
::
::  SCRIPT CODES :: ISO 15924
::
+$  iso-15924-keys  $?  %adlm  %afak  %aghb  %ahom  %arab  %aran  %armi  %armn  
                        %avst  %bali  %bamu  %bass  %batk  %beng  %bhks  %blis  
                        %bopo  %brah  %brai  %bugi  %buhd  %cakm  %cans  %cari  
                        %cham  %cher  %chrs  %cirt  %copt  %cpmn  %cprt  %cyrl  
                        %cyrs  %deva  %diak  %dogr  %dsrt  %dupl  %egyd  %egyh  
                        %egyp  %elba  %elym  %ethi  %geok  %geor  %glag  %gong  
                        %gonm  %goth  %gran  %grek  %gujr  %guru  %hanb  %hang  
                        %hani  %hano  %hans  %hant  %hatr  %hebr  %hira  %hluw  
                        %hmng  %hmnp  %hrkt  %hung  %inds  %ital  %jamo  %java  
                        %jpan  %jurc  %kali  %kana  %kawi  %khar  %khmr  %khoj  
                        %kitl  %kits  %knda  %kore  %kpel  %kthi  %lana  %laoo  
                        %latf  %latg  %latn  %leke  %lepc  %limb  %lina  %linb  
                        %lisu  %loma  %lyci  %lydi  %mahj  %maka  %mand  %mani  
                        %marc  %maya  %medf  %mend  %merc  %mero  %mlym  %modi  
                        %mong  %moon  %mroo  %mtei  %mult  %mymr  %nagm  %nand  
                        %narb  %nbat  %newa  %nkdb  %nkgb  %nkoo  %nshu  %ogam  
                        %olck  %orkh  %orya  %osge  %osma  %ougr  %palm  %pauc  
                        %pcun  %pelm  %perm  %phag  %phli  %phlp  %phlv  %phnx  
                        %piqd  %plrd  %prti  %psin  %qaaa  %qaab  %qaac  %qaad  
                        %qaae  %qaaf  %qaag  %qaah  %qaai  %qaaj  %qaak  %qaal  
                        %qaam  %qaan  %qaao  %qaap  %qaaq  %qaar  %qaas  %qaat  
                        %qaau  %qaav  %qaaw  %qaax  %qaay  %qaaz  %qaba  %qabb  
                        %qabc  %qabd  %qabe  %qabf  %qabg  %qabh  %qabi  %qabj  
                        %qabk  %qabl  %qabm  %qabn  %qabo  %qabp  %qabq  %qabr  
                        %qabs  %qabt  %qabu  %qabv  %qabw  %qabx  %ranj  %rjng  
                        %rohg  %roro  %runr  %samr  %sara  %sarb  %saur  %sgnw  
                        %shaw  %shrd  %shui  %sidd  %sind  %sinh  %sogd  %sogo  
                        %sora  %soyo  %sund  %sunu  %sylo  %syrc  %syre  %syrj  
                        %syrn  %tagb  %takr  %tale  %talu  %taml  %tang  %tavt  
                        %telu  %teng  %tfng  %tglg  %thaa  %thai  %tibt  %tirh  
                        %tnsa  %toto  %ugar  %vaii  %visp  %vith  %wara  %wcho  
                        %wole  %xpeo  %xsux  %yezi  %yiii  %zanb  %zinh  %zmth  
                        %zsym  %zsye  %zxxx  %zyyy  %zzzz  
                        %$     ==
++  iso-15924
  ^-  (map @tas @t)
  %-  malt
  ^-  (list (pair @tas @t))
  ;:  weld
  ^-  (list (pair @tas @t))
  :~  :-  %adlm  'Adlam'
      :-  %afak  'Afaka'
      :-  %aghb  'Caucasian Albanian'
      :-  %ahom  'Ahom, Tai Ahom'
      :-  %arab  'Arabic'
      :-  %aran  'Arabic (Nastaliq variant)'
      :-  %armi  'Imperial Aramaic'
      :-  %armn  'Armenian'
      :-  %avst  'Avestan'
      :-  %bali  'Balinese'
      :-  %bamu  'Bamum'
      :-  %bass  'Bassa Vah'
      :-  %batk  'Batak'
      :-  %beng  'Bengali (Bangla)'
      :-  %bhks  'Bhaiksuki'
      :-  %blis  'Blissymbols'
      :-  %bopo  'Bopomofo'
      :-  %brah  'Brahmi'
      :-  %brai  'Braille'
      :-  %bugi  'Buginese'
      :-  %buhd  'Buhid'
      :-  %cakm  'Chakma'
      :-  %cans  'Unified Canadian Aboriginal Syllabics'
      :-  %cari  'Carian'
      :-  %cham  'Cham'
      :-  %cher  'Cherokee'
      :-  %chrs  'Chorasmian'
      :-  %cirt  'Cirth'
      :-  %copt  'Coptic'
      :-  %cpmn  'Cypro-Minoan'
      :-  %cprt  'Cypriot syllabary'
      :-  %cyrl  'Cyrillic'
      :-  %cyrs  'Cyrillic (Old Church Slavonic variant)'
      :-  %deva  'Devanagari (Nagari)'
      :-  %diak  'Dives Akuru'
      :-  %dogr  'Dogra'
      :-  %dsrt  'Deseret (Mormon)'
      :-  %dupl  'Duployan shorthand, Duployan stenography'
      :-  %egyd  'Egyptian demotic'
      :-  %egyh  'Egyptian hieratic'
      :-  %egyp  'Egyptian hieroglyphs'
      :-  %elba  'Elbasan'
      :-  %elym  'Elymaic'
      :-  %ethi  'Ethiopic (Geʻez)'
      :-  %geok  'Khutsuri (Asomtavruli and Nuskhuri)'
      :-  %geor  'Georgian (Mkhedruli and Mtavruli)'
      :-  %glag  'Glagolitic'
      :-  %gong  'Gunjala Gondi'
      :-  %gonm  'Masaram Gondi'
      :-  %goth  'Gothic'
      :-  %gran  'Grantha'
      :-  %grek  'Greek'
      :-  %gujr  'Gujarati'
      :-  %guru  'Gurmukhi'
      :-  %hanb  'Han with Bopomofo (alias for Han + Bopomofo)'
      :-  %hang  'Hangul (Hangŭl, Hangeul)'
      :-  %hani  'Han (Hanzi, Kanji, Hanja)'
      :-  %hano  'Hanunoo (Hanunóo)'
      :-  %hans  'Han (Simplified variant)'
      :-  %hant  'Han (Traditional variant)'
      :-  %hatr  'Hatran'
      :-  %hebr  'Hebrew'
      :-  %hira  'Hiragana'
      :-  %hluw  'Anatolian Hieroglyphs (Luwian Hieroglyphs, Hittite Hieroglyphs)'
      :-  %hmng  'Pahawh Hmong'
      :-  %hmnp  'Nyiakeng Puachue Hmong'
      :-  %hrkt  'Japanese syllabaries (alias for Hiragana + Katakana)'
      :-  %hung  'Old Hungarian (Hungarian Runic)'
      :-  %inds  'Indus (Harappan)'
      :-  %ital  'Old Italic (Etruscan, Oscan, etc.)'
      :-  %jamo  'Jamo (alias for Jamo subset of Hangul)'
      :-  %java  'Javanese'
      :-  %jpan  'Japanese (alias for Han + Hiragana + Katakana)'
      :-  %jurc  'Jurchen'
      :-  %kali  'Kayah Li'
      :-  %kana  'Katakana'
      :-  %kawi  'Kawi'
      :-  %khar  'Kharoshthi'
      :-  %khmr  'Khmer'
      :-  %khoj  'Khojki'
      :-  %kitl  'Khitan large script'
      :-  %kits  'Khitan small script'
      :-  %knda  'Kannada'
      :-  %kore  'Korean (alias for Hangul + Han)'
      :-  %kpel  'Kpelle'
      :-  %kthi  'Kaithi'
      :-  %lana  'Tai Tham (Lanna)'
      :-  %laoo  'Lao'
      :-  %latf  'Latin (Fraktur variant)'
      :-  %latg  'Latin (Gaelic variant)'
      :-  %latn  'Latin'
      :-  %leke  'Leke'
      :-  %lepc  'Lepcha (Róng)'
      :-  %limb  'Limbu'
      :-  %lina  'Linear A'
      :-  %linb  'Linear B'
      :-  %lisu  'Lisu (Fraser)'
      :-  %loma  'Loma'
      :-  %lyci  'Lycian'
      :-  %lydi  'Lydian'
      :-  %mahj  'Mahajani'
      :-  %maka  'Makasar'
      :-  %mand  'Mandaic, Mandaean'
      :-  %mani  'Manichaean'
      :-  %marc  'Marchen'
      :-  %maya  'Mayan hieroglyphs'
      :-  %medf  'Medefaidrin (Oberi Okaime, Oberi Ɔkaimɛ)'
      :-  %mend  'Mende Kikakui'
      :-  %merc  'Meroitic Cursive'
      :-  %mero  'Meroitic Hieroglyphs'
      :-  %mlym  'Malayalam'
      :-  %modi  'Modi, Moḍī'
      :-  %mong  'Mongolian'
      :-  %moon  'Moon (Moon code, Moon script, Moon type)'
      :-  %mroo  'Mro, Mru'
      :-  %mtei  'Meitei Mayek (Meithei, Meetei)'
      :-  %mult  'Multani'
      :-  %mymr  'Myanmar (Burmese)'
      :-  %nagm  'Nag Mundari'
      :-  %nand  'Nandinagari'
      :-  %narb  'Old North Arabian (Ancient North Arabian)'
      :-  %nbat  'Nabataean'
      :-  %newa  'Newa, Newar, Newari, Nepāla lipi'
      :-  %nkdb  'Naxi Dongba (na²¹ɕi³³ to³³ba²¹, Nakhi Tomba)'
      :-  %nkgb  'Nakhi Geba (na²¹ɕi³³ gʌ²¹ba²¹, \'Na-\'Khi ²Ggŏ-¹baw, Nakhi Geba)'
      :-  %nkoo  'N’Ko'
      :-  %nshu  'Nüshu'
      :-  %ogam  'Ogham'
      :-  %olck  'Ol Chiki (Ol Cemet’, Ol, Santali)'
      :-  %orkh  'Old Turkic, Orkhon Runic'
      :-  %orya  'Oriya (Odia)'
      :-  %osge  'Osage'
      :-  %osma  'Osmanya'
      :-  %ougr  'Old Uyghur'
      :-  %palm  'Palmyrene'
      :-  %pauc  'Pau Cin Hau'
      :-  %pcun  'Proto-Cuneiform'
      :-  %pelm  'Proto-Elamite'
      :-  %perm  'Old Permic'
      :-  %phag  'Phags-pa'
      :-  %phli  'Inscriptional Pahlavi'
      :-  %phlp  'Psalter Pahlavi'
      :-  %phlv  'Book Pahlavi'
      :-  %phnx  'Phoenician'
      :-  %piqd  'Klingon (KLI pIqaD)'
      :-  %plrd  'Miao (Pollard)'
      :-  %prti  'Inscriptional Parthian'
      :-  %psin  'Proto-Sinaitic'
      ::  %qaaa  'Reserved for private use (range)' (dealt with below)
      :-  %ranj  'Ranjana'
      :-  %rjng  'Rejang (Redjang, Kaganga)'
      :-  %rohg  'Hanifi Rohingya'
      :-  %roro  'Rongorongo'
      :-  %runr  'Runic'
      :-  %samr  'Samaritan'
      :-  %sara  'Sarati'
      :-  %sarb  'Old South Arabian'
      :-  %saur  'Saurashtra'
      :-  %sgnw  'SignWriting'
      :-  %shaw  'Shavian (Shaw)'
      :-  %shrd  'Sharada, Śāradā'
      :-  %shui  'Shuishu'
      :-  %sidd  'Siddham, Siddhaṃ, Siddhamātṛkā'
      :-  %sind  'Khudawadi, Sindhi'
      :-  %sinh  'Sinhala'
      :-  %sogd  'Sogdian'
      :-  %sogo  'Old Sogdian'
      :-  %sora  'Sora Sompeng'
      :-  %soyo  'Soyombo'
      :-  %sund  'Sundanese'
      :-  %sunu  'Sunuwar'
      :-  %sylo  'Syloti Nagri'
      :-  %syrc  'Syriac'
      :-  %syre  'Syriac (Estrangelo variant)'
      :-  %syrj  'Syriac (Western variant)'
      :-  %syrn  'Syriac (Eastern variant)'
      :-  %tagb  'Tagbanwa'
      :-  %takr  'Takri, Ṭākrī, Ṭāṅkrī'
      :-  %tale  'Tai Le'
      :-  %talu  'New Tai Lue'
      :-  %taml  'Tamil'
      :-  %tang  'Tangut'
      :-  %tavt  'Tai Viet'
      :-  %telu  'Telugu'
      :-  %teng  'Tengwar'
      :-  %tfng  'Tifinagh (Berber)'
      :-  %tglg  'Tagalog (Baybayin, Alibata)'
      :-  %thaa  'Thaana'
      :-  %thai  'Thai'
      :-  %tibt  'Tibetan'
      :-  %tirh  'Tirhuta'
      :-  %tnsa  'Tangsa'
      :-  %toto  'Toto'
      :-  %ugar  'Ugaritic'
      :-  %vaii  'Vai'
      :-  %visp  'Visible Speech'
      :-  %vith  'Vithkuqi'
      :-  %wara  'Warang Citi (Varang Kshiti)'
      :-  %wcho  'Wancho'
      :-  %wole  'Woleai'
      :-  %xpeo  'Old Persian'
      :-  %xsux  'Cuneiform, Sumero-Akkadian'
      :-  %yezi  'Yezidi'
      :-  %yiii  'Yi'
      :-  %zanb  'Zanabazar Square (Zanabazarin Dörböljin Useg, Xewtee Dörböljin Bicig, Horizontal Square Script)'
      :-  %zinh  'Code for inherited script'
      :-  %zmth  'Mathematical notation'
      :-  %zsym  'Symbols'
      :-  %zsye  'Symbols (emoji variant)'
      :-  %zxxx  'Code for unwritten documents'
      :-  %zyyy  'Code for undetermined script'
      :-  %zzzz  'Code for uncoded script'
  ==
  ::  'qaaa-qabx'  'Reserved for private use (range)'
  %+  turn
  %+  turn
  %+  turn  (gulf 1 26)
  (cury mul 0x100.0000)
  (cury add 0x6061.6171)
  |=(a=@t [a 'Reserved for private use'])
  %+  turn
  %+  turn
  %+  turn  (gulf 1 24)
  (cury mul 0x100.0000)
  (cury add 0x6062.6171)
  |=(a=@t [a 'Reserved for private use'])
  ==
::
::  REGION CODES :: ISO 3166
::
+$  iso-3166-keys  $?  %af  %ad  %ae  %ag  %ai  %al  %am  %ao  %aq  %ar  %as  
                       %at  %au  %aw  %ax  %az  %ba  %bb  %bd  %be  %bf  %bg  
                       %bh  %bi  %bj  %bl  %bm  %bn  %bo  %bq  %br  %bs  %bt  
                       %bv  %bw  %by  %bz  %ca  %cc  %cd  %cf  %cg  %ch  %ci  
                       %ck  %cl  %cm  %cn  %co  %cr  %cu  %cv  %cw  %cx  %cy  
                       %cz  %de  %dj  %dk  %dm  %do  %dz  %ec  %ee  %eg  %eh  
                       %er  %es  %et  %fi  %fj  %fk  %fm  %fo  %fr  %ga  %gb  
                       %gd  %ge  %gf  %gg  %gh  %gi  %gl  %gm  %gn  %gp  %gq  
                       %gr  %gs  %gt  %gu  %gw  %gy  %hk  %hm  %hn  %hr  %ht  
                       %hu  %id  %ie  %il  %im  %in  %io  %iq  %ir  %is  %it  
                       %je  %jm  %jo  %jp  %ke  %kg  %kh  %ki  %km  %kn  %kp  
                       %kr  %kw  %ky  %kz  %la  %lb  %lc  %li  %lk  %lr  %ls  
                       %lt  %lu  %lv  %ly  %ma  %mc  %md  %me  %mf  %mg  %mh  
                       %mk  %ml  %mm  %mn  %mo  %mp  %mq  %mr  %ms  %mt  %mu  
                       %mv  %mw  %mx  %my  %mz  %na  %nc  %ne  %nf  %ng  %ni  
                       %nl  %no  %np  %nr  %nu  %nz  %om  %pa  %pe  %pf  %pg  
                       %ph  %pk  %pl  %pm  %pn  %pr  %ps  %pt  %pw  %py  %qa  
                       %re  %ro  %rs  %ru  %rw  %sa  %sb  %sc  %sd  %se  %sg  
                       %sh  %si  %sj  %sk  %sl  %sm  %sn  %so  %sr  %ss  %st  
                       %sv  %sx  %sy  %sz  %tc  %td  %tf  %tg  %th  %tj  %tk  
                       %tl  %tm  %tn  %to  %tr  %tt  %tv  %tw  %tz  %ua  %ug  
                       %um  %us  %uy  %uz  %va  %vc  %ve  %vg  %vi  %vn  %vu  
                       %wf  %ws  %ye  %yt  %za  %zm  %zw  
                       %$   ==
++  iso-3166
  ^-  (map iso-3166-keys @t)
  %-  malt
  ^-  (list (pair iso-3166-keys @t))
  :~  :-  %af  'Afghanistan'
      :-  %ax  'Åland Islands'
      :-  %al  'Albania'
      :-  %dz  'Algeria'
      :-  %as  'American Samoa'
      :-  %ad  'Andorra'
      :-  %ao  'Angola'
      :-  %ai  'Anguilla'
      :-  %aq  'Antarctica'
      :-  %ag  'Antigua and Barbuda'
      :-  %ar  'Argentina'
      :-  %am  'Armenia'
      :-  %aw  'Aruba'
      :-  %au  'Australia'
      :-  %at  'Austria'
      :-  %az  'Azerbaijan'
      :-  %bs  'Bahamas (the)'
      :-  %bh  'Bahrain'
      :-  %bd  'Bangladesh'
      :-  %bb  'Barbados'
      :-  %by  'Belarus'
      :-  %be  'Belgium'
      :-  %bz  'Belize'
      :-  %bj  'Benin'
      :-  %bm  'Bermuda'
      :-  %bt  'Bhutan'
      :-  %bo  'Bolivia (Plurinational State of)'
      :-  %bq  'Bonaire, Sint Eustatius, Saba'
      :-  %ba  'Bosnia and Herzegovina'
      :-  %bw  'Botswana'
      :-  %bv  'Bouvet Island'
      :-  %br  'Brazil'
      :-  %io  'British Indian Ocean Territory (the)'
      :-  %bn  'Brunei Darussalam'
      :-  %bg  'Bulgaria'
      :-  %bf  'Burkina Faso'
      :-  %bi  'Burundi'
      :-  %cv  'Cabo Verde'
      :-  %kh  'Cambodia'
      :-  %cm  'Cameroon'
      :-  %ca  'Canada'
      :-  %ky  'Cayman Islands (the)'
      :-  %cf  'Central African Republic (the)'
      :-  %td  'Chad'
      :-  %cl  'Chile'
      :-  %cn  'China'
      :-  %cx  'Christmas Island'
      :-  %cc  'Cocos (Keeling) Islands (the)'
      :-  %co  'Colombia'
      :-  %km  'Comoros (the)'
      :-  %cd  'Congo (the Democratic Republic of the)'
      :-  %cg  'Congo (the)'
      :-  %ck  'Cook Islands (the)'
      :-  %cr  'Costa Rica'
      :-  %ci  'Côte d\'Ivoire'
      :-  %hr  'Croatia'
      :-  %cu  'Cuba'
      :-  %cw  'Curaçao'
      :-  %cy  'Cyprus'
      :-  %cz  'Czechia'
      :-  %dk  'Denmark'
      :-  %dj  'Djibouti'
      :-  %dm  'Dominica'
      :-  %do  'Dominican Republic (the)'
      :-  %ec  'Ecuador'
      :-  %eg  'Egypt'
      :-  %sv  'El Salvador'
      :-  %gq  'Equatorial Guinea'
      :-  %er  'Eritrea'
      :-  %ee  'Estonia'
      :-  %sz  'Eswatini'
      :-  %et  'Ethiopia'
      :-  %fk  'Falkland Islands (the) [Malvinas]'
      :-  %fo  'Faroe Islands (the)'
      :-  %fj  'Fiji'
      :-  %fi  'Finland'
      :-  %fr  'France'
      :-  %gf  'French Guiana'
      :-  %pf  'French Polynesia'
      :-  %tf  'French Southern Territories (the)'
      :-  %ga  'Gabon'
      :-  %gm  'Gambia (the)'
      :-  %ge  'Georgia'
      :-  %de  'Germany'
      :-  %gh  'Ghana'
      :-  %gi  'Gibraltar'
      :-  %gr  'Greece'
      :-  %gl  'Greenland'
      :-  %gd  'Grenada'
      :-  %gp  'Guadeloupe'
      :-  %gu  'Guam'
      :-  %gt  'Guatemala'
      :-  %gg  'Guernsey'
      :-  %gn  'Guinea'
      :-  %gw  'Guinea-Bissau'
      :-  %gy  'Guyana'
      :-  %ht  'Haiti'
      :-  %hm  'Heard Island and McDonald Islands'
      :-  %va  'Holy See (the)'
      :-  %hn  'Honduras'
      :-  %hk  'Hong Kong'
      :-  %hu  'Hungary'
      :-  %is  'Iceland'
      :-  %in  'India'
      :-  %id  'Indonesia'
      :-  %ir  'Iran (Islamic Republic of)'
      :-  %iq  'Iraq'
      :-  %ie  'Ireland'
      :-  %im  'Isle of Man'
      :-  %il  'Israel'
      :-  %it  'Italy'
      :-  %jm  'Jamaica'
      :-  %jp  'Japan'
      :-  %je  'Jersey'
      :-  %jo  'Jordan'
      :-  %kz  'Kazakhstan'
      :-  %ke  'Kenya'
      :-  %ki  'Kiribati'
      :-  %kp  'Korea (the Democratic People\'s Republic of)'
      :-  %kr  'Korea (the Republic of)'
      :-  %kw  'Kuwait'
      :-  %kg  'Kyrgyzstan'
      :-  %la  'Lao People\'s Democratic Republic (the)'
      :-  %lv  'Latvia'
      :-  %lb  'Lebanon'
      :-  %ls  'Lesotho'
      :-  %lr  'Liberia'
      :-  %ly  'Libya'
      :-  %li  'Liechtenstein'
      :-  %lt  'Lithuania'
      :-  %lu  'Luxembourg'
      :-  %mo  'Macao'
      :-  %mk  'North Macedonia'
      :-  %mg  'Madagascar'
      :-  %mw  'Malawi'
      :-  %my  'Malaysia'
      :-  %mv  'Maldives'
      :-  %ml  'Mali'
      :-  %mt  'Malta'
      :-  %mh  'Marshall Islands (the)'
      :-  %mq  'Martinique'
      :-  %mr  'Mauritania'
      :-  %mu  'Mauritius'
      :-  %yt  'Mayotte'
      :-  %mx  'Mexico'
      :-  %fm  'Micronesia (Federated States of)'
      :-  %md  'Moldova (the Republic of)'
      :-  %mc  'Monaco'
      :-  %mn  'Mongolia'
      :-  %me  'Montenegro'
      :-  %ms  'Montserrat'
      :-  %ma  'Morocco'
      :-  %mz  'Mozambique'
      :-  %mm  'Myanmar'
      :-  %na  'Namibia'
      :-  %nr  'Nauru'
      :-  %np  'Nepal'
      :-  %nl  'Netherlands (the)'
      :-  %nc  'New Caledonia'
      :-  %nz  'New Zealand'
      :-  %ni  'Nicaragua'
      :-  %ne  'Niger (the)'
      :-  %ng  'Nigeria'
      :-  %nu  'Niue'
      :-  %nf  'Norfolk Island'
      :-  %mp  'Northern Mariana Islands (the)'
      :-  %no  'Norway'
      :-  %om  'Oman'
      :-  %pk  'Pakistan'
      :-  %pw  'Palau'
      :-  %ps  'Palestine, State of'
      :-  %pa  'Panama'
      :-  %pg  'Papua New Guinea'
      :-  %py  'Paraguay'
      :-  %pe  'Peru'
      :-  %ph  'Philippines (the)'
      :-  %pn  'Pitcairn'
      :-  %pl  'Poland'
      :-  %pt  'Portugal'
      :-  %pr  'Puerto Rico'
      :-  %qa  'Qatar'
      :-  %re  'Réunion'
      :-  %ro  'Romania'
      :-  %ru  'Russian Federation (the)'
      :-  %rw  'Rwanda'
      :-  %bl  'Saint Barthélemy'
      :-  %sh  'Saint Helena, Ascension Island, Tristan da Cunha'
      :-  %kn  'Saint Kitts and Nevis'
      :-  %lc  'Saint Lucia'
      :-  %mf  'Saint Martin (French part)'
      :-  %pm  'Saint Pierre and Miquelon'
      :-  %vc  'Saint Vincent and the Grenadines'
      :-  %ws  'Samoa'
      :-  %sm  'San Marino'
      :-  %st  'Sao Tome and Principe'
      :-  %sa  'Saudi Arabia'
      :-  %sn  'Senegal'
      :-  %rs  'Serbia'
      :-  %sc  'Seychelles'
      :-  %sl  'Sierra Leone'
      :-  %sg  'Singapore'
      :-  %sx  'Sint Maarten (Dutch part)'
      :-  %sk  'Slovakia'
      :-  %si  'Slovenia'
      :-  %sb  'Solomon Islands'
      :-  %so  'Somalia'
      :-  %za  'South Africa'
      :-  %gs  'South Georgia and the South Sandwich Islands'
      :-  %ss  'South Sudan'
      :-  %es  'Spain'
      :-  %lk  'Sri Lanka'
      :-  %sd  'Sudan (the)'
      :-  %sr  'Suriname'
      :-  %sj  'Svalbard, Jan Mayen'
      :-  %se  'Sweden'
      :-  %ch  'Switzerland'
      :-  %sy  'Syrian Arab Republic (the)'
      :-  %tw  'Taiwan (Province of China)'
      :-  %tj  'Tajikistan'
      :-  %tz  'Tanzania, the United Republic of'
      :-  %th  'Thailand'
      :-  %tl  'Timor-Leste'
      :-  %tg  'Togo'
      :-  %tk  'Tokelau'
      :-  %to  'Tonga'
      :-  %tt  'Trinidad and Tobago'
      :-  %tn  'Tunisia'
      :-  %tr  'Turkey'
      :-  %tm  'Turkmenistan'
      :-  %tc  'Turks and Caicos Islands (the)'
      :-  %tv  'Tuvalu'
      :-  %ug  'Uganda'
      :-  %ua  'Ukraine'
      :-  %ae  'United Arab Emirates (the)'
      :-  %gb  'United Kingdom of Great Britain and Northern Ireland (the)'
      :-  %um  'United States Minor Outlying Islands (the)'
      :-  %us  'United States of America (the)'
      :-  %uy  'Uruguay'
      :-  %uz  'Uzbekistan'
      :-  %vu  'Vanuatu'
      :-  %ve  'Venezuela (Bolivarian Republic of)'
      :-  %vn  'Viet Nam'
      :-  %vg  'Virgin Islands (British'
      :-  %vi  'Virgin Islands (U.S.)'
      :-  %wf  'Wallis and Futuna'
      :-  %eh  'Western Sahara'
      :-  %ye  'Yemen'
      :-  %zm  'Zambia'
      :-  %zw  'Zimbabwe'
  ==
++  ul
  |%
  ::  list of UTF-8 multibyte characters (not a tape, which is `(list @tD)`)
  ::  since bitwidth letters aren't coercive now, this is decorative
  +$  calf  (list ?(@tD @tE @tF @tG))
  ::  unify UTF-8 multi-byte characters into a single @t throughout a tape
  ++  lasso
    |=  dogy=tape
    ^-  calf
    =/  index  0
    =|  stok=calf
    %-  flop
    |-  ^-  calf
    ?:  =(index (lent dogy))  stok
    ::  1-byte ASCII?
    ~|  'Error processing sequence of bytes into UTF-8 multi-byte character.'
    =/  first  `@ux``@`(snag index dogy)
    ?:  (lth first 0x7f)
      =/  first   `@t`first
      $(index +(index), stok (weld ~[first] stok))
    ::  2-byte?
    ?:  &((lte 0xc0 first) (gte 0xdf first))
      =/  first   `@t`first
      =/  second  `@t`(snag +(index) dogy)
      =/  char    `@t`(rep 3 ~[first second])
      $(index +(+(index)), stok (weld ~[char] stok))
    ::  3-byte?
    ?:  &((lte 0xe0 first) (gte 0xef first))
      =/  first   `@t`first
      =/  second  `@t`(snag +(index) dogy)
      =/  third   `@t`(snag +(+(index)) dogy)
      =/  char    `@t`(rep 3 ~[first second third])
      $(index +(+(+(index))), stok (weld ~[char] stok))
    ::  4-byte?
    ?:  &((lte 0xf0 first) (gte 0xf7 first))
      =/  first   `@t`first
      =/  second  `@t`(snag +(index) dogy)
      =/  third   `@t`(snag +(+(index)) dogy)
      =/  fourth  `@t`(snag +(+(+(index))) dogy)
      =/  char    `@t`(rep 3 ~[first second third fourth])
      $(index +(+(+(+(index)))), stok (weld ~[char] stok))
    !!
  ::  split UTF-8 multi-byte characters back into bytes in a tape
  ++  brand
    |=  beef=calf
    ^-  tape
    =|  ster=tape
    %-  flop
    |-  ^-  tape
    ?~  beef  ster
    =/  char  `@ux``@`(snag 0 `calf`beef)
    =/  chars  `(list @t)`(rip [3 1] char)
    %=  $
      beef   `calf`(tail `calf`beef)
      ster   (weld (flop chars) ster)
    ==
  ++  cass
    |=  vib=tape
    ^-  tape
    (brand (turn (lasso vib) |=(c=@t ?:((~(has by cass-map) c) (~(got by cass-map) c) c))))
  ++  cass-map
    ^-  (map @t @t)
    %-  malt
    ^-  (list (pair @t @t))
    :~  :-  'A'  'a'        :: 0x41 Latin Capital Letter A
        :-  'B'  'b'        :: 0x42 Latin Capital Letter B
        :-  'C'  'c'        :: 0x43 Latin Capital Letter C
        :-  'D'  'd'        :: 0x44 Latin Capital Letter D
        :-  'E'  'e'        :: 0x45 Latin Capital Letter E
        :-  'F'  'f'        :: 0x46 Latin Capital Letter F
        :-  'G'  'g'        :: 0x47 Latin Capital Letter G
        :-  'H'  'h'        :: 0x48 Latin Capital Letter H
        :-  'I'  'i'        :: 0x49 Latin Capital Letter I
        :-  'J'  'j'        :: 0x4a Latin Capital Letter J
        :-  'K'  'k'        :: 0x4b Latin Capital Letter K
        :-  'L'  'l'        :: 0x4c Latin Capital Letter L
        :-  'M'  'm'        :: 0x4d Latin Capital Letter M
        :-  'N'  'n'        :: 0x4e Latin Capital Letter N
        :-  'O'  'o'        :: 0x4f Latin Capital Letter O
        :-  'P'  'p'        :: 0x50 Latin Capital Letter P
        :-  'Q'  'q'        :: 0x51 Latin Capital Letter Q
        :-  'R'  'r'        :: 0x52 Latin Capital Letter R
        :-  'S'  's'        :: 0x53 Latin Capital Letter S
        :-  'T'  't'        :: 0x54 Latin Capital Letter T
        :-  'U'  'u'        :: 0x55 Latin Capital Letter U
        :-  'V'  'v'        :: 0x56 Latin Capital Letter V
        :-  'W'  'w'        :: 0x57 Latin Capital Letter W
        :-  'X'  'x'        :: 0x58 Latin Capital Letter X
        :-  'Y'  'y'        :: 0x59 Latin Capital Letter Y
        :-  'Z'  'z'        :: 0x5a Latin Capital Letter Z
        :-  'À'  'à'        :: 0xc0 Latin Capital Letter A With Grave
        :-  'Á'  'á'        :: 0xc1 Latin Capital Letter A With Acute
        :-  'Â'  'â'        :: 0xc2 Latin Capital Letter A With Circumflex
        :-  'Ã'  'ã'        :: 0xc3 Latin Capital Letter A With Tilde
        :-  'Ä'  'ä'        :: 0xc4 Latin Capital Letter A With Diaeresis
        :-  'Å'  'å'        :: 0xc5 Latin Capital Letter A With Ring Above
        :-  'Æ'  'æ'        :: 0xc6 Latin Capital Letter Ae
        :-  'Ç'  'ç'        :: 0xc7 Latin Capital Letter C With Cedilla
        :-  'È'  'è'        :: 0xc8 Latin Capital Letter E With Grave
        :-  'É'  'é'        :: 0xc9 Latin Capital Letter E With Acute
        :-  'Ê'  'ê'        :: 0xca Latin Capital Letter E With Circumflex
        :-  'Ë'  'ë'        :: 0xcb Latin Capital Letter E With Diaeresis
        :-  'Ì'  'ì'        :: 0xcc Latin Capital Letter I With Grave
        :-  'Í'  'í'        :: 0xcd Latin Capital Letter I With Acute
        :-  'Î'  'î'        :: 0xce Latin Capital Letter I With Circumflex
        :-  'Ï'  'ï'        :: 0xcf Latin Capital Letter I With Diaeresis
        :-  'Ð'  'ð'        :: 0xd0 Latin Capital Letter Eth
        :-  'Ñ'  'ñ'        :: 0xd1 Latin Capital Letter N With Tilde
        :-  'Ò'  'ò'        :: 0xd2 Latin Capital Letter O With Grave
        :-  'Ó'  'ó'        :: 0xd3 Latin Capital Letter O With Acute
        :-  'Ô'  'ô'        :: 0xd4 Latin Capital Letter O With Circumflex
        :-  'Õ'  'õ'        :: 0xd5 Latin Capital Letter O With Tilde
        :-  'Ö'  'ö'        :: 0xd6 Latin Capital Letter O With Diaeresis
        :-  'Ø'  'ø'        :: 0xd8 Latin Capital Letter O With Stroke
        :-  'Ù'  'ù'        :: 0xd9 Latin Capital Letter U With Grave
        :-  'Ú'  'ú'        :: 0xda Latin Capital Letter U With Acute
        :-  'Û'  'û'        :: 0xdb Latin Capital Letter U With Circumflex
        :-  'Ü'  'ü'        :: 0xdc Latin Capital Letter U With Diaeresis
        :-  'Ý'  'ý'        :: 0xdd Latin Capital Letter Y With Acute
        :-  'Þ'  'þ'        :: 0xde Latin Capital Letter Thorn
        :-  'Ā'  'ā'        :: 0x100 Latin Capital Letter A With Macron
        :-  'Ă'  'ă'        :: 0x102 Latin Capital Letter A With Breve
        :-  'Ą'  'ą'        :: 0x104 Latin Capital Letter A With Ogonek
        :-  'Ć'  'ć'        :: 0x106 Latin Capital Letter C With Acute
        :-  'Ĉ'  'ĉ'        :: 0x108 Latin Capital Letter C With Circumflex
        :-  'Ċ'  'ċ'        :: 0x10a Latin Capital Letter C With Dot Above
        :-  'Č'  'č'        :: 0x10c Latin Capital Letter C With Caron
        :-  'Ď'  'ď'        :: 0x10e Latin Capital Letter D With Caron
        :-  'Đ'  'đ'        :: 0x110 Latin Capital Letter D With Stroke
        :-  'Ē'  'ē'        :: 0x112 Latin Capital Letter E With Macron
        :-  'Ĕ'  'ĕ'        :: 0x114 Latin Capital Letter E With Breve
        :-  'Ė'  'ė'        :: 0x116 Latin Capital Letter E With Dot Above
        :-  'Ę'  'ę'        :: 0x118 Latin Capital Letter E With Ogonek
        :-  'Ě'  'ě'        :: 0x11a Latin Capital Letter E With Caron
        :-  'Ĝ'  'ĝ'        :: 0x11c Latin Capital Letter G With Circumflex
        :-  'Ğ'  'ğ'        :: 0x11e Latin Capital Letter G With Breve
        :-  'Ġ'  'ġ'        :: 0x120 Latin Capital Letter G With Dot Above
        :-  'Ģ'  'ģ'        :: 0x122 Latin Capital Letter G With Cedilla
        :-  'Ĥ'  'ĥ'        :: 0x124 Latin Capital Letter H With Circumflex
        :-  'Ħ'  'ħ'        :: 0x126 Latin Capital Letter H With Stroke
        :-  'Ĩ'  'ĩ'        :: 0x128 Latin Capital Letter I With Tilde
        :-  'Ī'  'ī'        :: 0x12a Latin Capital Letter I With Macron
        :-  'Ĭ'  'ĭ'        :: 0x12c Latin Capital Letter I With Breve
        :-  'Į'  'į'        :: 0x12e Latin Capital Letter I With Ogonek
        :-  'İ'  'i'        :: 0x130 Latin Capital Letter I With Dot Above
        :-  'Ĳ'  'ĳ'        :: 0x132 Latin Capital Ligature Ij
        :-  'Ĵ'  'ĵ'        :: 0x134 Latin Capital Letter J With Circumflex
        :-  'Ķ'  'ķ'        :: 0x136 Latin Capital Letter K With Cedilla
        :-  'Ĺ'  'ĺ'        :: 0x139 Latin Capital Letter L With Acute
        :-  'Ļ'  'ļ'        :: 0x13b Latin Capital Letter L With Cedilla
        :-  'Ľ'  'ľ'        :: 0x13d Latin Capital Letter L With Caron
        :-  'Ŀ'  'ŀ'        :: 0x13f Latin Capital Letter L With Middle Dot
        :-  'Ł'  'ł'        :: 0x141 Latin Capital Letter L With Stroke
        :-  'Ń'  'ń'        :: 0x143 Latin Capital Letter N With Acute
        :-  'Ņ'  'ņ'        :: 0x145 Latin Capital Letter N With Cedilla
        :-  'Ň'  'ň'        :: 0x147 Latin Capital Letter N With Caron
        :-  'Ŋ'  'ŋ'        :: 0x14a Latin Capital Letter Eng
        :-  'Ō'  'ō'        :: 0x14c Latin Capital Letter O With Macron
        :-  'Ŏ'  'ŏ'        :: 0x14e Latin Capital Letter O With Breve
        :-  'Ő'  'ő'        :: 0x150 Latin Capital Letter O With Double Acute
        :-  'Œ'  'œ'        :: 0x152 Latin Capital Ligature Oe
        :-  'Ŕ'  'ŕ'        :: 0x154 Latin Capital Letter R With Acute
        :-  'Ŗ'  'ŗ'        :: 0x156 Latin Capital Letter R With Cedilla
        :-  'Ř'  'ř'        :: 0x158 Latin Capital Letter R With Caron
        :-  'Ś'  'ś'        :: 0x15a Latin Capital Letter S With Acute
        :-  'Ŝ'  'ŝ'        :: 0x15c Latin Capital Letter S With Circumflex
        :-  'Ş'  'ş'        :: 0x15e Latin Capital Letter S With Cedilla
        :-  'Š'  'š'        :: 0x160 Latin Capital Letter S With Caron
        :-  'Ţ'  'ţ'        :: 0x162 Latin Capital Letter T With Cedilla
        :-  'Ť'  'ť'        :: 0x164 Latin Capital Letter T With Caron
        :-  'Ŧ'  'ŧ'        :: 0x166 Latin Capital Letter T With Stroke
        :-  'Ũ'  'ũ'        :: 0x168 Latin Capital Letter U With Tilde
        :-  'Ū'  'ū'        :: 0x16a Latin Capital Letter U With Macron
        :-  'Ŭ'  'ŭ'        :: 0x16c Latin Capital Letter U With Breve
        :-  'Ů'  'ů'        :: 0x16e Latin Capital Letter U With Ring Above
        :-  'Ű'  'ű'        :: 0x170 Latin Capital Letter U With Double Acute
        :-  'Ų'  'ų'        :: 0x172 Latin Capital Letter U With Ogonek
        :-  'Ŵ'  'ŵ'        :: 0x174 Latin Capital Letter W With Circumflex
        :-  'Ŷ'  'ŷ'        :: 0x176 Latin Capital Letter Y With Circumflex
        :-  'Ÿ'  'ÿ'        :: 0x178 Latin Capital Letter Y With Diaeresis
        :-  'Ź'  'ź'        :: 0x179 Latin Capital Letter Z With Acute
        :-  'Ż'  'ż'        :: 0x17b Latin Capital Letter Z With Dot Above
        :-  'Ž'  'ž'        :: 0x17d Latin Capital Letter Z With Caron
        :-  'Ɓ'  'ɓ'        :: 0x181 Latin Capital Letter B With Hook
        :-  'Ƃ'  'ƃ'        :: 0x182 Latin Capital Letter B With Topbar
        :-  'Ƅ'  'ƅ'        :: 0x184 Latin Capital Letter Tone Six
        :-  'Ɔ'  'ɔ'        :: 0x186 Latin Capital Letter Open O
        :-  'Ƈ'  'ƈ'        :: 0x187 Latin Capital Letter C With Hook
        :-  'Ɗ'  'ɗ'        :: 0x18a Latin Capital Letter D With Hook
        :-  'Ƌ'  'ƌ'        :: 0x18b Latin Capital Letter D With Topbar
        :-  'Ǝ'  'ɘ'        :: 0x18e Latin Capital Letter Reversed E
        :-  'Ə'  'ə'        :: 0x18f Latin Capital Letter Schwa
        :-  'Ɛ'  'ɛ'        :: 0x190 Latin Capital Letter Open E
        :-  'Ƒ'  'ƒ'        :: 0x191 Latin Capital Letter F With Hook
        :-  'Ɠ'  'ɠ'        :: 0x193 Latin Capital Letter G With Hook
        :-  'Ɣ'  'ɣ'        :: 0x194 Latin Capital Letter Gamma
        :-  'Ɩ'  'ɩ'        :: 0x196 Latin Capital Letter Iota
        :-  'Ɨ'  'ɨ'        :: 0x197 Latin Capital Letter I With Stroke
        :-  'Ƙ'  'ƙ'        :: 0x198 Latin Capital Letter K With Hook
        :-  'Ɯ'  'ɯ'        :: 0x19c Latin Capital Letter Turned M
        :-  'Ɲ'  'ɲ'        :: 0x19d Latin Capital Letter N With Left Hook
        :-  'Ɵ'  'ɵ'        :: 0x19f Latin Capital Letter O With Middle Tilde
        :-  'Ơ'  'ơ'        :: 0x1a0 Latin Capital Letter O With Horn
        :-  'Ƣ'  'ƣ'        :: 0x1a2 Latin Capital Letter Oi
        :-  'Ƥ'  'ƥ'        :: 0x1a4 Latin Capital Letter P With Hook
        :-  'Ƨ'  'ƨ'        :: 0x1a7 Latin Capital Letter Tone Two
        :-  'Ʃ'  'ʃ'        :: 0x1a9 Latin Capital Letter Esh
        :-  'Ƭ'  'ƭ'        :: 0x1ac Latin Capital Letter T With Hook
        :-  'Ʈ'  'ʈ'        :: 0x1ae Latin Capital Letter T With Retroflex Hook
        :-  'Ư'  'ư'        :: 0x1af Latin Capital Letter U With Horn
        :-  'Ʊ'  'ʊ'        :: 0x1b1 Latin Capital Letter Upsilon
        :-  'Ʋ'  'ʋ'        :: 0x1b2 Latin Capital Letter V With Hook
        :-  'Ƴ'  'ƴ'        :: 0x1b3 Latin Capital Letter Y With Hook
        :-  'Ƶ'  'ƶ'        :: 0x1b5 Latin Capital Letter Z With Stroke
        :-  'Ʒ'  'ʒ'        :: 0x1b7 Latin Capital Letter Ezh
        :-  'Ƹ'  'ƹ'        :: 0x1b8 Latin Capital Letter Ezh Reversed
        :-  'Ƽ'  'ƽ'        :: 0x1bc Latin Capital Letter Tone Five
        :-  'Ǆ'  'ǆ'        :: 0x1c4 Latin Capital Letter Dz With Caron
        :-  'Ǉ'  'ǉ'        :: 0x1c7 Latin Capital Letter Lj
        :-  'Ǌ'  'ǌ'        :: 0x1ca Latin Capital Letter Nj
        :-  'Ǎ'  'ǎ'        :: 0x1cd Latin Capital Letter A With Caron
        :-  'Ǐ'  'ǐ'        :: 0x1cf Latin Capital Letter I With Caron
        :-  'Ǒ'  'ǒ'        :: 0x1d1 Latin Capital Letter O With Caron
        :-  'Ǔ'  'ǔ'        :: 0x1d3 Latin Capital Letter U With Caron
        :-  'Ǖ'  'ǖ'        :: 0x1d5 Latin Capital Letter U With Diaeresis And Macron
        :-  'Ǘ'  'ǘ'        :: 0x1d7 Latin Capital Letter U With Diaeresis And Acute
        :-  'Ǚ'  'ǚ'        :: 0x1d9 Latin Capital Letter U With Diaeresis And Caron
        :-  'Ǜ'  'ǜ'        :: 0x1db Latin Capital Letter U With Diaeresis And Grave
        :-  'Ǟ'  'ǟ'        :: 0x1de Latin Capital Letter A With Diaeresis And Macron
        :-  'Ǡ'  'ǡ'        :: 0x1e0 Latin Capital Letter A With Dot Above And Macron
        :-  'Ǣ'  'ǣ'        :: 0x1e2 Latin Capital Letter Ae With Macron
        :-  'Ǥ'  'ǥ'        :: 0x1e4 Latin Capital Letter G With Stroke
        :-  'Ǧ'  'ǧ'        :: 0x1e6 Latin Capital Letter G With Caron
        :-  'Ǩ'  'ǩ'        :: 0x1e8 Latin Capital Letter K With Caron
        :-  'Ǫ'  'ǫ'        :: 0x1ea Latin Capital Letter O With Ogonek
        :-  'Ǭ'  'ǭ'        :: 0x1ec Latin Capital Letter O With Ogonek And Macron
        :-  'Ǯ'  'ǯ'        :: 0x1ee Latin Capital Letter Ezh With Caron
        :-  'Ǳ'  'ǳ'        :: 0x1f1 Latin Capital Letter Dz
        :-  'Ǵ'  'ǵ'        :: 0x1f4 Latin Capital Letter G With Acute
        :-  'Ǻ'  'ǻ'        :: 0x1fa Latin Capital Letter A With Ring Above And Acute
        :-  'Ǽ'  'ǽ'        :: 0x1fc Latin Capital Letter Ae With Acute
        :-  'Ǿ'  'ǿ'        :: 0x1fe Latin Capital Letter O With Stroke And Acute
        :-  'Ȁ'  'ȁ'        :: 0x200 Latin Capital Letter A With Double Grave
        :-  'Ȃ'  'ȃ'        :: 0x202 Latin Capital Letter A With Inverted Breve
        :-  'Ȅ'  'ȅ'        :: 0x204 Latin Capital Letter E With Double Grave
        :-  'Ȇ'  'ȇ'        :: 0x206 Latin Capital Letter E With Inverted Breve
        :-  'Ȉ'  'ȉ'        :: 0x208 Latin Capital Letter I With Double Grave
        :-  'Ȋ'  'ȋ'        :: 0x20a Latin Capital Letter I With Inverted Breve
        :-  'Ȍ'  'ȍ'        :: 0x20c Latin Capital Letter O With Double Grave
        :-  'Ȏ'  'ȏ'        :: 0x20e Latin Capital Letter O With Inverted Breve
        :-  'Ȑ'  'ȑ'        :: 0x210 Latin Capital Letter R With Double Grave
        :-  'Ȓ'  'ȓ'        :: 0x212 Latin Capital Letter R With Inverted Breve
        :-  'Ȕ'  'ȕ'        :: 0x214 Latin Capital Letter U With Double Grave
        :-  'Ȗ'  'ȗ'        :: 0x216 Latin Capital Letter U With Inverted Breve
        :-  'Ά'  'ά'        :: 0x386 Greek Capital Letter Alpha With Tonos
        :-  'Έ'  'έ'        :: 0x388 Greek Capital Letter Epsilon With Tonos
        :-  'Ή'  'ή'        :: 0x389 Greek Capital Letter Eta With Tonos
        :-  'Ί'  'ί'        :: 0x38a Greek Capital Letter Iota With Tonos
        :-  'Ό'  'ό'        :: 0x38c Greek Capital Letter Omicron With Tonos
        :-  'Ύ'  'ύ'        :: 0x38e Greek Capital Letter Upsilon With Tonos
        :-  'Ώ'  'ώ'        :: 0x38f Greek Capital Letter Omega With Tonos
        :-  'Α'  'α'        :: 0x391 Greek Capital Letter Alpha
        :-  'Β'  'β'        :: 0x392 Greek Capital Letter Beta
        :-  'Γ'  'γ'        :: 0x393 Greek Capital Letter Gamma
        :-  'Δ'  'δ'        :: 0x394 Greek Capital Letter Delta
        :-  'Ε'  'ε'        :: 0x395 Greek Capital Letter Epsilon
        :-  'Ζ'  'ζ'        :: 0x396 Greek Capital Letter Zeta
        :-  'Η'  'η'        :: 0x397 Greek Capital Letter Eta
        :-  'Θ'  'θ'        :: 0x398 Greek Capital Letter Theta
        :-  'Ι'  'ι'        :: 0x399 Greek Capital Letter Iota
        :-  'Κ'  'κ'        :: 0x39a Greek Capital Letter Kappa
        :-  'Λ'  'λ'        :: 0x39b Greek Capital Letter Lamda
        :-  'Μ'  'μ'        :: 0x39c Greek Capital Letter Mu
        :-  'Ν'  'ν'        :: 0x39d Greek Capital Letter Nu
        :-  'Ξ'  'ξ'        :: 0x39e Greek Capital Letter Xi
        :-  'Ο'  'ο'        :: 0x39f Greek Capital Letter Omicron
        :-  'Π'  'π'        :: 0x3a0 Greek Capital Letter Pi
        :-  'Ρ'  'ρ'        :: 0x3a1 Greek Capital Letter Rho
        :-  'Σ'  'σ'        :: 0x3a3 Greek Capital Letter Sigma
        :-  'Τ'  'τ'        :: 0x3a4 Greek Capital Letter Tau
        :-  'Υ'  'υ'        :: 0x3a5 Greek Capital Letter Upsilon
        :-  'Φ'  'φ'        :: 0x3a6 Greek Capital Letter Phi
        :-  'Χ'  'χ'        :: 0x3a7 Greek Capital Letter Chi
        :-  'Ψ'  'ψ'        :: 0x3a8 Greek Capital Letter Psi
        :-  'Ω'  'ω'        :: 0x3a9 Greek Capital Letter Omega
        :-  'Ϊ'  'ϊ'        :: 0x3aa Greek Capital Letter Iota With Dialytika
        :-  'Ϋ'  'ϋ'        :: 0x3ab Greek Capital Letter Upsilon With Dialytika
        :-  'Ά'  'ά'        :: 0x3ac Greek Capital Letter Alpha With Tonos
        :-  'Έ'  'έ'        :: 0x3ad Greek Capital Letter Epsilon With Tonos
        :-  'Ή'  'ή'        :: 0x3ae Greek Capital Letter Eta With Tonos
        :-  'Ί'  'ί'        :: 0x3af Greek Capital Letter Iota With Tonos
        :-  'Ϋ́'  'ΰ'        :: 0x3b0 Greek Capital Letter Upsilon With Dialytika And Tonos
        :-  'Α'  'α'        :: 0x3b1 Greek Capital Letter Alpha
        :-  'Β'  'β'        :: 0x3b2 Greek Capital Letter Beta
        :-  'Γ'  'γ'        :: 0x3b3 Greek Capital Letter Gamma
        :-  'Δ'  'δ'        :: 0x3b4 Greek Capital Letter Delta
        :-  'Ε'  'ε'        :: 0x3b5 Greek Capital Letter Epsilon
        :-  'Ζ'  'ζ'        :: 0x3b6 Greek Capital Letter Zeta
        :-  'Η'  'η'        :: 0x3b7 Greek Capital Letter Eta
        :-  'Θ'  'θ'        :: 0x3b8 Greek Capital Letter Theta
        :-  'Ι'  'ι'        :: 0x3b9 Greek Capital Letter Iota
        :-  'Κ'  'κ'        :: 0x3ba Greek Capital Letter Kappa
        :-  'Λ'  'λ'        :: 0x3bb Greek Capital Letter Lamda
        :-  'Μ'  'μ'        :: 0x3bc Greek Capital Letter Mu
        :-  'Ν'  'ν'        :: 0x3bd Greek Capital Letter Nu
        :-  'Ξ'  'ξ'        :: 0x3be Greek Capital Letter Xi
        :-  'Ο'  'ο'        :: 0x3bf Greek Capital Letter Omicron
        :-  'Π'  'π'        :: 0x3c0 Greek Capital Letter Pi
        :-  'Ρ'  'ρ'        :: 0x3c1 Greek Capital Letter Rho
        :-  'Σ'  'σ'        :: 0x3c3 Greek Capital Letter Sigma
        :-  'Τ'  'τ'        :: 0x3c4 Greek Capital Letter Tau
        :-  'Υ'  'υ'        :: 0x3c5 Greek Capital Letter Upsilon
        :-  'Φ'  'φ'        :: 0x3c6 Greek Capital Letter Phi
        :-  'Χ'  'χ'        :: 0x3c7 Greek Capital Letter Chi
        :-  'Ψ'  'ψ'        :: 0x3c8 Greek Capital Letter Psi
        :-  'Ω'  'ω'        :: 0x3c9 Greek Capital Letter Omega
        :-  'Ϊ'  'ϊ'        :: 0x3ca Greek Capital Letter Iota With Dialytika
        :-  'Ϋ'  'ϋ'        :: 0x3cb Greek Capital Letter Upsilon With Dialytika
        :-  'Ό'  'ό'        :: 0x3cc Greek Capital Letter Omicron With Tonos
        :-  'Ύ'  'ύ'        :: 0x3cd Greek Capital Letter Upsilon With Tonos
        :-  'Ώ'  'ώ'        :: 0x3ce Greek Capital Letter Omega With Tonos
        :-  'Ϗ'  'ϗ'        :: 0x3cf Capital Kai Symbol
        :-  'ϒ'  'ϒ'        :: 0x3d2 Upsilon With Hook Symbol
        :-  'ϓ'  'ϓ'        :: 0x3d3 Upsilon With Acute And Hook Symbol
        :-  'ϔ'  'ϔ'        :: 0x3d4 Upsilon With Diaeresis And Hook Symbol
        :-  'Ϗ'  'ϗ'        :: 0x3d7 Kai Symbol
        :-  'Ϙ'  'ϙ'        :: 0x3d8 Letter Archaic Koppa
        :-  'Ϛ'  'ϛ'        :: 0x3da Letter Stigma
        :-  'Ϝ'  'ϝ'        :: 0x3dc Letter Digamma
        :-  'Ϟ'  'ϟ'        :: 0x3de Letter Koppa
        :-  'Ϡ'  'ϡ'        :: 0x3e0 Letter Sampi
        :-  'Ϣ'  'ϣ'        :: 0x3e2 Coptic Capital Letter Shei
        :-  'Ϥ'  'ϥ'        :: 0x3e4 Coptic Capital Letter Fei
        :-  'Ϧ'  'ϧ'        :: 0x3e6 Coptic Capital Letter Khei
        :-  'Ϩ'  'ϩ'        :: 0x3e8 Coptic Capital Letter Hori
        :-  'Ϫ'  'ϫ'        :: 0x3ea Coptic Capital Letter Gangia
        :-  'Ϭ'  'ϭ'        :: 0x3ec Coptic Capital Letter Shima
        :-  'Ϯ'  'ϯ'        :: 0x3ee Coptic Capital Letter Dei
        :-  'Ё'  'ё'        :: 0x401 Cyrillic Capital Letter Io
        :-  'Ђ'  'ђ'        :: 0x402 Cyrillic Capital Letter Dje
        :-  'Ѓ'  'ѓ'        :: 0x403 Cyrillic Capital Letter Gje
        :-  'Є'  'є'        :: 0x404 Cyrillic Capital Letter Ukrainian Ie
        :-  'Ѕ'  'ѕ'        :: 0x405 Cyrillic Capital Letter Dze
        :-  'І'  'і'        :: 0x406 Cyrillic Capital Letter Byelorussian-Ukrainian I
        :-  'Ї'  'ї'        :: 0x407 Cyrillic Capital Letter Yi
        :-  'Ј'  'ј'        :: 0x408 Cyrillic Capital Letter Je
        :-  'Љ'  'љ'        :: 0x409 Cyrillic Capital Letter Lje
        :-  'Њ'  'њ'        :: 0x40a Cyrillic Capital Letter Nje
        :-  'Ћ'  'ћ'        :: 0x40b Cyrillic Capital Letter Tshe
        :-  'Ќ'  'ќ'        :: 0x40c Cyrillic Capital Letter Kje
        :-  'Ў'  'ў'        :: 0x40e Cyrillic Capital Letter Short U
        :-  'Џ'  'џ'        :: 0x40f Cyrillic Capital Letter Dzhe
        :-  'А'  'а'        :: 0x410 Cyrillic Capital Letter A
        :-  'Б'  'б'        :: 0x411 Cyrillic Capital Letter Be
        :-  'В'  'в'        :: 0x412 Cyrillic Capital Letter Ve
        :-  'Г'  'г'        :: 0x413 Cyrillic Capital Letter Ghe
        :-  'Д'  'д'        :: 0x414 Cyrillic Capital Letter De
        :-  'Е'  'е'        :: 0x415 Cyrillic Capital Letter Ie
        :-  'Ж'  'ж'        :: 0x416 Cyrillic Capital Letter Zhe
        :-  'З'  'з'        :: 0x417 Cyrillic Capital Letter Ze
        :-  'И'  'и'        :: 0x418 Cyrillic Capital Letter I
        :-  'Й'  'й'        :: 0x419 Cyrillic Capital Letter Short I
        :-  'К'  'к'        :: 0x41a Cyrillic Capital Letter Ka
        :-  'Л'  'л'        :: 0x41b Cyrillic Capital Letter El
        :-  'М'  'м'        :: 0x41c Cyrillic Capital Letter Em
        :-  'Н'  'н'        :: 0x41d Cyrillic Capital Letter En
        :-  'О'  'о'        :: 0x41e Cyrillic Capital Letter O
        :-  'П'  'п'        :: 0x41f Cyrillic Capital Letter Pe
        :-  'Р'  'р'        :: 0x420 Cyrillic Capital Letter Er
        :-  'С'  'с'        :: 0x421 Cyrillic Capital Letter Es
        :-  'Т'  'т'        :: 0x422 Cyrillic Capital Letter Te
        :-  'У'  'у'        :: 0x423 Cyrillic Capital Letter U
        :-  'Ф'  'ф'        :: 0x424 Cyrillic Capital Letter Ef
        :-  'Х'  'х'        :: 0x425 Cyrillic Capital Letter Ha
        :-  'Ц'  'ц'        :: 0x426 Cyrillic Capital Letter Tse
        :-  'Ч'  'ч'        :: 0x427 Cyrillic Capital Letter Che
        :-  'Ш'  'ш'        :: 0x428 Cyrillic Capital Letter Sha
        :-  'Щ'  'щ'        :: 0x429 Cyrillic Capital Letter Shcha
        :-  'Ъ'  'ъ'        :: 0x42a Cyrillic Capital Letter Hard Sign
        :-  'Ы'  'ы'        :: 0x42b Cyrillic Capital Letter Yeru
        :-  'Ь'  'ь'        :: 0x42c Cyrillic Capital Letter Soft Sign
        :-  'Э'  'э'        :: 0x42d Cyrillic Capital Letter E
        :-  'Ю'  'ю'        :: 0x42e Cyrillic Capital Letter Yu
        :-  'Я'  'я'        :: 0x42f Cyrillic Capital Letter Ya
        :-  'Ѡ'  'ѡ'        :: 0x460 Cyrillic Capital Letter Omega
        :-  'Ѣ'  'ѣ'        :: 0x462 Cyrillic Capital Letter Yat
        :-  'Ѥ'  'ѥ'        :: 0x464 Cyrillic Capital Letter Iotified E
        :-  'Ѧ'  'ѧ'        :: 0x466 Cyrillic Capital Letter Little Yus
        :-  'Ѩ'  'ѩ'        :: 0x468 Cyrillic Capital Letter Iotified Little Yus
        :-  'Ѫ'  'ѫ'        :: 0x46a Cyrillic Capital Letter Big Yus
        :-  'Ѭ'  'ѭ'        :: 0x46c Cyrillic Capital Letter Iotified Big Yus
        :-  'Ѯ'  'ѯ'        :: 0x46e Cyrillic Capital Letter Ksi
        :-  'Ѱ'  'ѱ'        :: 0x470 Cyrillic Capital Letter Psi
        :-  'Ѳ'  'ѳ'        :: 0x472 Cyrillic Capital Letter Fita
        :-  'Ѵ'  'ѵ'        :: 0x474 Cyrillic Capital Letter Izhitsa
        :-  'Ѷ'  'ѷ'        :: 0x476 Cyrillic Capital Letter Izhitsa With Double Grave Accent
        :-  'Ѹ'  'ѹ'        :: 0x478 Cyrillic Capital Letter Uk
        :-  'Ѻ'  'ѻ'        :: 0x47a Cyrillic Capital Letter Round Omega
        :-  'Ѽ'  'ѽ'        :: 0x47c Cyrillic Capital Letter Omega With Titlo
        :-  'Ѿ'  'ѿ'        :: 0x47e Cyrillic Capital Letter Ot
        :-  'Ҁ'  'ҁ'        :: 0x480 Cyrillic Capital Letter Koppa
        :-  'Ґ'  'ґ'        :: 0x490 Cyrillic Capital Letter Ghe With Upturn
        :-  'Ғ'  'ғ'        :: 0x492 Cyrillic Capital Letter Ghe With Stroke
        :-  'Ҕ'  'ҕ'        :: 0x494 Cyrillic Capital Letter Ghe With Middle Hook
        :-  'Җ'  'җ'        :: 0x496 Cyrillic Capital Letter Zhe With Descender
        :-  'Ҙ'  'ҙ'        :: 0x498 Cyrillic Capital Letter Ze With Descender
        :-  'Қ'  'қ'        :: 0x49a Cyrillic Capital Letter Ka With Descender
        :-  'Ҝ'  'ҝ'        :: 0x49c Cyrillic Capital Letter Ka With Vertical Stroke
        :-  'Ҟ'  'ҟ'        :: 0x49e Cyrillic Capital Letter Ka With Stroke
        :-  'Ҡ'  'ҡ'        :: 0x4a0 Cyrillic Capital Letter Bashkir Ka
        :-  'Ң'  'ң'        :: 0x4a2 Cyrillic Capital Letter En With Descender
        :-  'Ҥ'  'ҥ'        :: 0x4a4 Cyrillic Capital Ligature En Ghe
        :-  'Ҧ'  'ҧ'        :: 0x4a6 Cyrillic Capital Letter Pe With Middle Hook
        :-  'Ҩ'  'ҩ'        :: 0x4a8 Cyrillic Capital Letter Abkhasian Ha
        :-  'Ҫ'  'ҫ'        :: 0x4aa Cyrillic Capital Letter Es With Descender
        :-  'Ҭ'  'ҭ'        :: 0x4ac Cyrillic Capital Letter Te With Descender
        :-  'Ү'  'ү'        :: 0x4ae Cyrillic Capital Letter Straight U
        :-  'Ұ'  'ұ'        :: 0x4b0 Cyrillic Capital Letter Straight U With Stroke
        :-  'Ҳ'  'ҳ'        :: 0x4b2 Cyrillic Capital Letter Ha With Descender
        :-  'Ҵ'  'ҵ'        :: 0x4b4 Cyrillic Capital Ligature Te Tse
        :-  'Ҷ'  'ҷ'        :: 0x4b6 Cyrillic Capital Letter Che With Descender
        :-  'Ҹ'  'ҹ'        :: 0x4b8 Cyrillic Capital Letter Che With Vertical Stroke
        :-  'Һ'  'һ'        :: 0x4ba Cyrillic Capital Letter Shha
        :-  'Ҽ'  'ҽ'        :: 0x4bc Cyrillic Capital Letter Abkhasian Che
        :-  'Ҿ'  'ҿ'        :: 0x4be Cyrillic Capital Letter Abkhasian Che With Descender
        :-  'Ӂ'  'ӂ'        :: 0x4c1 Cyrillic Capital Letter Zhe With Breve
        :-  'Ӄ'  'ӄ'        :: 0x4c3 Cyrillic Capital Letter Ka With Hook
        :-  'Ӈ'  'ӈ'        :: 0x4c7 Cyrillic Capital Letter En With Hook
        :-  'Ӌ'  'ӌ'        :: 0x4cb Cyrillic Capital Letter Khakassian Che
        :-  'Ӑ'  'ӑ'        :: 0x4d0 Cyrillic Capital Letter A With Breve
        :-  'Ӓ'  'ӓ'        :: 0x4d2 Cyrillic Capital Letter A With Diaeresis
        :-  'Ӕ'  'ӕ'        :: 0x4d4 Cyrillic Capital Ligature A Ie
        :-  'Ӗ'  'ӗ'        :: 0x4d6 Cyrillic Capital Letter Ie With Breve
        :-  'Ә'  'ә'        :: 0x4d8 Cyrillic Capital Letter Schwa
        :-  'Ӛ'  'ӛ'        :: 0x4da Cyrillic Capital Letter Schwa With Diaeresis
        :-  'Ӝ'  'ӝ'        :: 0x4dc Cyrillic Capital Letter Zhe With Diaeresis
        :-  'Ӟ'  'ӟ'        :: 0x4de Cyrillic Capital Letter Ze With Diaeresis
        :-  'Ӡ'  'ӡ'        :: 0x4e0 Cyrillic Capital Letter Abkhasian Dze
        :-  'Ӣ'  'ӣ'        :: 0x4e2 Cyrillic Capital Letter I With Macron
        :-  'Ӥ'  'ӥ'        :: 0x4e4 Cyrillic Capital Letter I With Diaeresis
        :-  'Ӧ'  'ӧ'        :: 0x4e6 Cyrillic Capital Letter O With Diaeresis
        :-  'Ө'  'ө'        :: 0x4e8 Cyrillic Capital Letter Barred O
        :-  'Ӫ'  'ӫ'        :: 0x4ea Cyrillic Capital Letter Barred O With Diaeresis
        :-  'Ӯ'  'ӯ'        :: 0x4ee Cyrillic Capital Letter U With Macron
        :-  'Ӱ'  'ӱ'        :: 0x4f0 Cyrillic Capital Letter U With Diaeresis
        :-  'Ӳ'  'ӳ'        :: 0x4f2 Cyrillic Capital Letter U With Double Acute
        :-  'Ӵ'  'ӵ'        :: 0x4f4 Cyrillic Capital Letter Che With Diaeresis
        :-  'Ӹ'  'ӹ'        :: 0x4f8 Cyrillic Capital Letter Yeru With Diaeresis
        :-  'Ա'  'ա'        :: 0x531 Armenian Capital Letter Ayb
        :-  'Բ'  'բ'        :: 0x532 Armenian Capital Letter Ben
        :-  'Գ'  'գ'        :: 0x533 Armenian Capital Letter Gim
        :-  'Դ'  'դ'        :: 0x534 Armenian Capital Letter Da
        :-  'Ե'  'ե'        :: 0x535 Armenian Capital Letter Ech
        :-  'Զ'  'զ'        :: 0x536 Armenian Capital Letter Za
        :-  'Է'  'է'        :: 0x537 Armenian Capital Letter Eh
        :-  'Ը'  'ը'        :: 0x538 Armenian Capital Letter Et
        :-  'Թ'  'թ'        :: 0x539 Armenian Capital Letter To
        :-  'Ժ'  'ժ'        :: 0x53a Armenian Capital Letter Zhe
        :-  'Ի'  'ի'        :: 0x53b Armenian Capital Letter Ini
        :-  'Լ'  'լ'        :: 0x53c Armenian Capital Letter Liwn
        :-  'Խ'  'խ'        :: 0x53d Armenian Capital Letter Xeh
        :-  'Ծ'  'ծ'        :: 0x53e Armenian Capital Letter Ca
        :-  'Կ'  'կ'        :: 0x53f Armenian Capital Letter Ken
        :-  'Հ'  'հ'        :: 0x540 Armenian Capital Letter Ho
        :-  'Ձ'  'ձ'        :: 0x541 Armenian Capital Letter Ja
        :-  'Ղ'  'ղ'        :: 0x542 Armenian Capital Letter Ghad
        :-  'Ճ'  'ճ'        :: 0x543 Armenian Capital Letter Cheh
        :-  'Մ'  'մ'        :: 0x544 Armenian Capital Letter Men
        :-  'Յ'  'յ'        :: 0x545 Armenian Capital Letter Yi
        :-  'Ն'  'ն'        :: 0x546 Armenian Capital Letter Now
        :-  'Շ'  'շ'        :: 0x547 Armenian Capital Letter Sha
        :-  'Ո'  'ո'        :: 0x548 Armenian Capital Letter Vo
        :-  'Չ'  'չ'        :: 0x549 Armenian Capital Letter Cha
        :-  'Պ'  'պ'        :: 0x54a Armenian Capital Letter Peh
        :-  'Ջ'  'ջ'        :: 0x54b Armenian Capital Letter Jheh
        :-  'Ռ'  'ռ'        :: 0x54c Armenian Capital Letter Ra
        :-  'Ս'  'ս'        :: 0x54d Armenian Capital Letter Seh
        :-  'Վ'  'վ'        :: 0x54e Armenian Capital Letter Vew
        :-  'Տ'  'տ'        :: 0x54f Armenian Capital Letter Tiwn
        :-  'Ր'  'ր'        :: 0x550 Armenian Capital Letter Reh
        :-  'Ց'  'ց'        :: 0x551 Armenian Capital Letter Co
        :-  'Ւ'  'ւ'        :: 0x552 Armenian Capital Letter Yiwn
        :-  'Փ'  'փ'        :: 0x553 Armenian Capital Letter Piwr
        :-  'Ք'  'ք'        :: 0x554 Armenian Capital Letter Keh
        :-  'Օ'  'օ'        :: 0x555 Armenian Capital Letter Oh
        :-  'Ֆ'  'ֆ'        :: 0x556 Armenian Capital Letter Feh
        :-  'Ⴀ'  'ა'        :: 0x10a0 Georgian Capital Letter An
        :-  'Ⴁ'  'ბ'        :: 0x10a1 Georgian Capital Letter Ban
        :-  'Ⴂ'  'გ'        :: 0x10a2 Georgian Capital Letter Gan
        :-  'Ⴃ'  'დ'        :: 0x10a3 Georgian Capital Letter Don
        :-  'Ⴄ'  'ე'        :: 0x10a4 Georgian Capital Letter En
        :-  'Ⴅ'  'ვ'        :: 0x10a5 Georgian Capital Letter Vin
        :-  'Ⴆ'  'ზ'        :: 0x10a6 Georgian Capital Letter Zen
        :-  'Ⴇ'  'თ'        :: 0x10a7 Georgian Capital Letter Tan
        :-  'Ⴈ'  'ი'        :: 0x10a8 Georgian Capital Letter In
        :-  'Ⴉ'  'კ'        :: 0x10a9 Georgian Capital Letter Kan
        :-  'Ⴊ'  'ლ'        :: 0x10aa Georgian Capital Letter Las
        :-  'Ⴋ'  'მ'        :: 0x10ab Georgian Capital Letter Man
        :-  'Ⴌ'  'ნ'        :: 0x10ac Georgian Capital Letter Nar
        :-  'Ⴍ'  'ო'        :: 0x10ad Georgian Capital Letter On
        :-  'Ⴎ'  'პ'        :: 0x10ae Georgian Capital Letter Par
        :-  'Ⴏ'  'ჟ'        :: 0x10af Georgian Capital Letter Zhar
        :-  'Ⴐ'  'რ'        :: 0x10b0 Georgian Capital Letter Rae
        :-  'Ⴑ'  'ს'        :: 0x10b1 Georgian Capital Letter San
        :-  'Ⴒ'  'ტ'        :: 0x10b2 Georgian Capital Letter Tar
        :-  'Ⴓ'  'უ'        :: 0x10b3 Georgian Capital Letter Un
        :-  'Ⴔ'  'ფ'        :: 0x10b4 Georgian Capital Letter Phar
        :-  'Ⴕ'  'ქ'        :: 0x10b5 Georgian Capital Letter Khar
        :-  'Ⴖ'  'ღ'        :: 0x10b6 Georgian Capital Letter Ghan
        :-  'Ⴗ'  'ყ'        :: 0x10b7 Georgian Capital Letter Qar
        :-  'Ⴘ'  'შ'        :: 0x10b8 Georgian Capital Letter Shin
        :-  'Ⴙ'  'ჩ'        :: 0x10b9 Georgian Capital Letter Chin
        :-  'Ⴚ'  'ც'        :: 0x10ba Georgian Capital Letter Can
        :-  'Ⴛ'  'ძ'        :: 0x10bb Georgian Capital Letter Jil
        :-  'Ⴜ'  'წ'        :: 0x10bc Georgian Capital Letter Cil
        :-  'Ⴝ'  'ჭ'        :: 0x10bd Georgian Capital Letter Char
        :-  'Ⴞ'  'ხ'        :: 0x10be Georgian Capital Letter Xan
        :-  'Ⴟ'  'ჯ'        :: 0x10bf Georgian Capital Letter Jhan
        :-  'Ⴠ'  'ჰ'        :: 0x10c0 Georgian Capital Letter Hae
        :-  'Ⴡ'  'ჱ'        :: 0x10c1 Georgian Capital Letter He
        :-  'Ⴢ'  'ჲ'        :: 0x10c2 Georgian Capital Letter Hie
        :-  'Ⴣ'  'ჳ'        :: 0x10c3 Georgian Capital Letter We
        :-  'Ⴤ'  'ჴ'        :: 0x10c4 Georgian Capital Letter Har
        :-  'Ⴥ'  'ჵ'        :: 0x10c5 Georgian Capital Letter Hoe
        :-  'Ꭰ'  'ꭰ'        :: 0x13a0 Cherokee Capital Letter 
        :-  'Ꭱ'  'ꭱ'        :: 0x13a1 Cherokee Capital Letter 
        :-  'Ꭲ'  'ꭲ'        :: 0x13a2 Cherokee Capital Letter 
        :-  'Ꭳ'  'ꭳ'        :: 0x13a3 Cherokee Capital Letter 
        :-  'Ꭴ'  'ꭴ'        :: 0x13a4 Cherokee Capital Letter 
        :-  'Ꭵ'  'ꭵ'        :: 0x13a5 Cherokee Capital Letter 
        :-  'Ꭶ'  'ꭶ'        :: 0x13a6 Cherokee Capital Letter 
        :-  'Ꭷ'  'ꭷ'        :: 0x13a7 Cherokee Capital Letter 
        :-  'Ꭸ'  'ꭸ'        :: 0x13a8 Cherokee Capital Letter 
        :-  'Ꭹ'  'ꭹ'        :: 0x13a9 Cherokee Capital Letter 
        :-  'Ꭺ'  'ꭺ'        :: 0x13aa Cherokee Capital Letter 
        :-  'Ꭻ'  'ꭻ'        :: 0x13ab Cherokee Capital Letter 
        :-  'Ꭼ'  'ꭼ'        :: 0x13ac Cherokee Capital Letter 
        :-  'Ꭽ'  'ꭽ'        :: 0x13ad Cherokee Capital Letter 
        :-  'Ꭾ'  'ꭾ'        :: 0x13ae Cherokee Capital Letter 
        :-  'Ꭿ'  'ꭿ'        :: 0x13af Cherokee Capital Letter 
        :-  'Ꮀ'  'ꮀ'        :: 0x13b0 Cherokee Capital Letter 
        :-  'Ꮁ'  'ꮁ'        :: 0x13b1 Cherokee Capital Letter 
        :-  'Ꮂ'  'ꮂ'        :: 0x13b2 Cherokee Capital Letter 
        :-  'Ꮃ'  'ꮃ'        :: 0x13b3 Cherokee Capital Letter 
        :-  'Ꮄ'  'ꮄ'        :: 0x13b4 Cherokee Capital Letter 
        :-  'Ꮅ'  'ꮅ'        :: 0x13b5 Cherokee Capital Letter 
        :-  'Ꮆ'  'ꮆ'        :: 0x13b6 Cherokee Capital Letter 
        :-  'Ꮇ'  'ꮇ'        :: 0x13b7 Cherokee Capital Letter 
        :-  'Ꮈ'  'ꮈ'        :: 0x13b8 Cherokee Capital Letter 
        :-  'Ꮉ'  'ꮉ'        :: 0x13b9 Cherokee Capital Letter 
        :-  'Ꮊ'  'ꮊ'        :: 0x13ba Cherokee Capital Letter 
        :-  'Ꮋ'  'ꮋ'        :: 0x13bb Cherokee Capital Letter 
        :-  'Ꮌ'  'ꮌ'        :: 0x13bc Cherokee Capital Letter 
        :-  'Ꮍ'  'ꮍ'        :: 0x13bd Cherokee Capital Letter 
        :-  'Ꮎ'  'ꮎ'        :: 0x13be Cherokee Capital Letter 
        :-  'Ꮏ'  'ꮏ'        :: 0x13bf Cherokee Capital Letter 
        :-  'Ꮐ'  'ꮐ'        :: 0x13c0 Cherokee Capital Letter 
        :-  'Ꮑ'  'ꮑ'        :: 0x13c1 Cherokee Capital Letter 
        :-  'Ꮒ'  'ꮒ'        :: 0x13c2 Cherokee Capital Letter 
        :-  'Ꮓ'  'ꮓ'        :: 0x13c3 Cherokee Capital Letter 
        :-  'Ꮔ'  'ꮔ'        :: 0x13c4 Cherokee Capital Letter 
        :-  'Ꮕ'  'ꮕ'        :: 0x13c5 Cherokee Capital Letter 
        :-  'Ꮖ'  'ꮖ'        :: 0x13c6 Cherokee Capital Letter 
        :-  'Ꮗ'  'ꮗ'        :: 0x13c7 Cherokee Capital Letter 
        :-  'Ꮘ'  'ꮘ'        :: 0x13c8 Cherokee Capital Letter 
        :-  'Ꮙ'  'ꮙ'        :: 0x13c9 Cherokee Capital Letter 
        :-  'Ꮚ'  'ꮚ'        :: 0x13ca Cherokee Capital Letter 
        :-  'Ꮛ'  'ꮛ'        :: 0x13cb Cherokee Capital Letter 
        :-  'Ꮜ'  'ꮜ'        :: 0x13cc Cherokee Capital Letter 
        :-  'Ꮝ'  'ꮝ'        :: 0x13cd Cherokee Capital Letter 
        :-  'Ꮞ'  'ꮞ'        :: 0x13ce Cherokee Capital Letter 
        :-  'Ꮟ'  'ꮟ'        :: 0x13cf Cherokee Capital Letter 
        :-  'Ꮠ'  'ꮠ'        :: 0x13d0 Cherokee Capital Letter 
        :-  'Ꮡ'  'ꮡ'        :: 0x13d1 Cherokee Capital Letter 
        :-  'Ꮢ'  'ꮢ'        :: 0x13d2 Cherokee Capital Letter 
        :-  'Ꮣ'  'ꮣ'        :: 0x13d3 Cherokee Capital Letter 
        :-  'Ꮤ'  'ꮤ'        :: 0x13d4 Cherokee Capital Letter 
        :-  'Ꮥ'  'ꮥ'        :: 0x13d5 Cherokee Capital Letter 
        :-  'Ꮦ'  'ꮦ'        :: 0x13d6 Cherokee Capital Letter 
        :-  'Ꮧ'  'ꮧ'        :: 0x13d7 Cherokee Capital Letter 
        :-  'Ꮨ'  'ꮨ'        :: 0x13d8 Cherokee Capital Letter 
        :-  'Ꮩ'  'ꮩ'        :: 0x13d9 Cherokee Capital Letter 
        :-  'Ꮪ'  'ꮪ'        :: 0x13da Cherokee Capital Letter 
        :-  'Ꮫ'  'ꮫ'        :: 0x13db Cherokee Capital Letter 
        :-  'Ꮬ'  'ꮬ'        :: 0x13dc Cherokee Capital Letter 
        :-  'Ꮭ'  'ꮭ'        :: 0x13dd Cherokee Capital Letter 
        :-  'Ꮮ'  'ꮮ'        :: 0x13de Cherokee Capital Letter 
        :-  'Ꮯ'  'ꮯ'        :: 0x13df Cherokee Capital Letter 
        :-  'Ꮰ'  'ꮰ'        :: 0x13e0 Cherokee Capital Letter 
        :-  'Ꮱ'  'ꮱ'        :: 0x13e1 Cherokee Capital Letter 
        :-  'Ꮲ'  'ꮲ'        :: 0x13e2 Cherokee Capital Letter 
        :-  'Ꮳ'  'ꮳ'        :: 0x13e3 Cherokee Capital Letter 
        :-  'Ꮴ'  'ꮴ'        :: 0x13e4 Cherokee Capital Letter 
        :-  'Ꮵ'  'ꮵ'        :: 0x13e5 Cherokee Capital Letter 
        :-  'Ꮶ'  'ꮶ'        :: 0x13e6 Cherokee Capital Letter 
        :-  'Ꮷ'  'ꮷ'        :: 0x13e7 Cherokee Capital Letter 
        :-  'Ꮸ'  'ꮸ'        :: 0x13e8 Cherokee Capital Letter 
        :-  'Ꮹ'  'ꮹ'        :: 0x13e9 Cherokee Capital Letter 
        :-  'Ꮺ'  'ꮺ'        :: 0x13ea Cherokee Capital Letter 
        :-  'Ꮻ'  'ꮻ'        :: 0x13eb Cherokee Capital Letter 
        :-  'Ꮼ'  'ꮼ'        :: 0x13ec Cherokee Capital Letter 
        :-  'Ꮽ'  'ꮽ'        :: 0x13ed Cherokee Capital Letter 
        :-  'Ꮾ'  'ꮾ'        :: 0x13ee Cherokee Capital Letter 
        :-  'Ꮿ'  'ꮿ'        :: 0x13ef Cherokee Capital Letter 
        :-  'Ᏸ'  'ᏸ'        :: 0x13f0 Cherokee Capital Letter 
        :-  'Ᏹ'  'ᏹ'        :: 0x13f1 Cherokee Capital Letter 
        :-  'Ᏺ'  'ᏺ'        :: 0x13f2 Cherokee Capital Letter 
        :-  'Ᏻ'  'ᏻ'        :: 0x13f3 Cherokee Capital Letter 
        :-  'Ᏼ'  'ᏼ'        :: 0x13f4 Cherokee Capital Letter 
        :-  'Ᏽ'  'ᏽ'        :: 0x13f5 Cherokee Capital Letter 
        :-  'Ḁ'  'ḁ'        :: 0x1e00 Latin Capital Letter A With Ring Below
        :-  'Ḃ'  'ḃ'        :: 0x1e02 Latin Capital Letter B With Dot Above
        :-  'Ḅ'  'ḅ'        :: 0x1e04 Latin Capital Letter B With Dot Below
        :-  'Ḇ'  'ḇ'        :: 0x1e06 Latin Capital Letter B With Line Below
        :-  'Ḉ'  'ḉ'        :: 0x1e08 Latin Capital Letter C With Cedilla And Acute
        :-  'Ḋ'  'ḋ'        :: 0x1e0a Latin Capital Letter D With Dot Above
        :-  'Ḍ'  'ḍ'        :: 0x1e0c Latin Capital Letter D With Dot Below
        :-  'Ḏ'  'ḏ'        :: 0x1e0e Latin Capital Letter D With Line Below
        :-  'Ḑ'  'ḑ'        :: 0x1e10 Latin Capital Letter D With Cedilla
        :-  'Ḓ'  'ḓ'        :: 0x1e12 Latin Capital Letter D With Circumflex Below
        :-  'Ḕ'  'ḕ'        :: 0x1e14 Latin Capital Letter E With Macron And Grave
        :-  'Ḗ'  'ḗ'        :: 0x1e16 Latin Capital Letter E With Macron And Acute
        :-  'Ḙ'  'ḙ'        :: 0x1e18 Latin Capital Letter E With Circumflex Below
        :-  'Ḛ'  'ḛ'        :: 0x1e1a Latin Capital Letter E With Tilde Below
        :-  'Ḝ'  'ḝ'        :: 0x1e1c Latin Capital Letter E With Cedilla And Breve
        :-  'Ḟ'  'ḟ'        :: 0x1e1e Latin Capital Letter F With Dot Above
        :-  'Ḡ'  'ḡ'        :: 0x1e20 Latin Capital Letter G With Macron
        :-  'Ḣ'  'ḣ'        :: 0x1e22 Latin Capital Letter H With Dot Above
        :-  'Ḥ'  'ḥ'        :: 0x1e24 Latin Capital Letter H With Dot Below
        :-  'Ḧ'  'ḧ'        :: 0x1e26 Latin Capital Letter H With Diaeresis
        :-  'Ḩ'  'ḩ'        :: 0x1e28 Latin Capital Letter H With Cedilla
        :-  'Ḫ'  'ḫ'        :: 0x1e2a Latin Capital Letter H With Breve Below
        :-  'Ḭ'  'ḭ'        :: 0x1e2c Latin Capital Letter I With Tilde Below
        :-  'Ḯ'  'ḯ'        :: 0x1e2e Latin Capital Letter I With Diaeresis And Acute
        :-  'Ḱ'  'ḱ'        :: 0x1e30 Latin Capital Letter K With Acute
        :-  'Ḳ'  'ḳ'        :: 0x1e32 Latin Capital Letter K With Dot Below
        :-  'Ḵ'  'ḵ'        :: 0x1e34 Latin Capital Letter K With Line Below
        :-  'Ḷ'  'ḷ'        :: 0x1e36 Latin Capital Letter L With Dot Below
        :-  'Ḹ'  'ḹ'        :: 0x1e38 Latin Capital Letter L With Dot Below And Macron
        :-  'Ḻ'  'ḻ'        :: 0x1e3a Latin Capital Letter L With Line Below
        :-  'Ḽ'  'ḽ'        :: 0x1e3c Latin Capital Letter L With Circumflex Below
        :-  'Ḿ'  'ḿ'        :: 0x1e3e Latin Capital Letter M With Acute
        :-  'Ṁ'  'ṁ'        :: 0x1e40 Latin Capital Letter M With Dot Above
        :-  'Ṃ'  'ṃ'        :: 0x1e42 Latin Capital Letter M With Dot Below
        :-  'Ṅ'  'ṅ'        :: 0x1e44 Latin Capital Letter N With Dot Above
        :-  'Ṇ'  'ṇ'        :: 0x1e46 Latin Capital Letter N With Dot Below
        :-  'Ṉ'  'ṉ'        :: 0x1e48 Latin Capital Letter N With Line Below
        :-  'Ṋ'  'ṋ'        :: 0x1e4a Latin Capital Letter N With Circumflex Below
        :-  'Ṍ'  'ṍ'        :: 0x1e4c Latin Capital Letter O With Tilde And Acute
        :-  'Ṏ'  'ṏ'        :: 0x1e4e Latin Capital Letter O With Tilde And Diaeresis
        :-  'Ṑ'  'ṑ'        :: 0x1e50 Latin Capital Letter O With Macron And Grave
        :-  'Ṓ'  'ṓ'        :: 0x1e52 Latin Capital Letter O With Macron And Acute
        :-  'Ṕ'  'ṕ'        :: 0x1e54 Latin Capital Letter P With Acute
        :-  'Ṗ'  'ṗ'        :: 0x1e56 Latin Capital Letter P With Dot Above
        :-  'Ṙ'  'ṙ'        :: 0x1e58 Latin Capital Letter R With Dot Above
        :-  'Ṛ'  'ṛ'        :: 0x1e5a Latin Capital Letter R With Dot Below
        :-  'Ṝ'  'ṝ'        :: 0x1e5c Latin Capital Letter R With Dot Below And Macron
        :-  'Ṟ'  'ṟ'        :: 0x1e5e Latin Capital Letter R With Line Below
        :-  'Ṡ'  'ṡ'        :: 0x1e60 Latin Capital Letter S With Dot Above
        :-  'Ṣ'  'ṣ'        :: 0x1e62 Latin Capital Letter S With Dot Below
        :-  'Ṥ'  'ṥ'        :: 0x1e64 Latin Capital Letter S With Acute And Dot Above
        :-  'Ṧ'  'ṧ'        :: 0x1e66 Latin Capital Letter S With Caron And Dot Above
        :-  'Ṩ'  'ṩ'        :: 0x1e68 Latin Capital Letter S With Dot Below And Dot Above
        :-  'Ṫ'  'ṫ'        :: 0x1e6a Latin Capital Letter T With Dot Above
        :-  'Ṭ'  'ṭ'        :: 0x1e6c Latin Capital Letter T With Dot Below
        :-  'Ṯ'  'ṯ'        :: 0x1e6e Latin Capital Letter T With Line Below
        :-  'Ṱ'  'ṱ'        :: 0x1e70 Latin Capital Letter T With Circumflex Below
        :-  'Ṳ'  'ṳ'        :: 0x1e72 Latin Capital Letter U With Diaeresis Below
        :-  'Ṵ'  'ṵ'        :: 0x1e74 Latin Capital Letter U With Tilde Below
        :-  'Ṷ'  'ṷ'        :: 0x1e76 Latin Capital Letter U With Circumflex Below
        :-  'Ṹ'  'ṹ'        :: 0x1e78 Latin Capital Letter U With Tilde And Acute
        :-  'Ṻ'  'ṻ'        :: 0x1e7a Latin Capital Letter U With Macron And Diaeresis
        :-  'Ṽ'  'ṽ'        :: 0x1e7c Latin Capital Letter V With Tilde
        :-  'Ṿ'  'ṿ'        :: 0x1e7e Latin Capital Letter V With Dot Below
        :-  'Ẁ'  'ẁ'        :: 0x1e80 Latin Capital Letter W With Grave
        :-  'Ẃ'  'ẃ'        :: 0x1e82 Latin Capital Letter W With Acute
        :-  'Ẅ'  'ẅ'        :: 0x1e84 Latin Capital Letter W With Diaeresis
        :-  'Ẇ'  'ẇ'        :: 0x1e86 Latin Capital Letter W With Dot Above
        :-  'Ẉ'  'ẉ'        :: 0x1e88 Latin Capital Letter W With Dot Below
        :-  'Ẋ'  'ẋ'        :: 0x1e8a Latin Capital Letter X With Dot Above
        :-  'Ẍ'  'ẍ'        :: 0x1e8c Latin Capital Letter X With Diaeresis
        :-  'Ẏ'  'ẏ'        :: 0x1e8e Latin Capital Letter Y With Dot Above
        :-  'Ẑ'  'ẑ'        :: 0x1e90 Latin Capital Letter Z With Circumflex
        :-  'Ẓ'  'ẓ'        :: 0x1e92 Latin Capital Letter Z With Dot Below
        :-  'Ẕ'  'ẕ'        :: 0x1e94 Latin Capital Letter Z With Line Below
        :-  'Ạ'  'ạ'        :: 0x1ea0 Latin Capital Letter A With Dot Below
        :-  'Ả'  'ả'        :: 0x1ea2 Latin Capital Letter A With Hook Above
        :-  'Ấ'  'ấ'        :: 0x1ea4 Latin Capital Letter A With Circumflex And Acute
        :-  'Ầ'  'ầ'        :: 0x1ea6 Latin Capital Letter A With Circumflex And Grave
        :-  'Ẩ'  'ẩ'        :: 0x1ea8 Latin Capital Letter A With Circumflex And Hook Above
        :-  'Ẫ'  'ẫ'        :: 0x1eaa Latin Capital Letter A With Circumflex And Tilde
        :-  'Ậ'  'ậ'        :: 0x1eac Latin Capital Letter A With Circumflex And Dot Below
        :-  'Ắ'  'ắ'        :: 0x1eae Latin Capital Letter A With Breve And Acute
        :-  'Ằ'  'ằ'        :: 0x1eb0 Latin Capital Letter A With Breve And Grave
        :-  'Ẳ'  'ẳ'        :: 0x1eb2 Latin Capital Letter A With Breve And Hook Above
        :-  'Ẵ'  'ẵ'        :: 0x1eb4 Latin Capital Letter A With Breve And Tilde
        :-  'Ặ'  'ặ'        :: 0x1eb6 Latin Capital Letter A With Breve And Dot Below
        :-  'Ẹ'  'ẹ'        :: 0x1eb8 Latin Capital Letter E With Dot Below
        :-  'Ẻ'  'ẻ'        :: 0x1eba Latin Capital Letter E With Hook Above
        :-  'Ẽ'  'ẽ'        :: 0x1ebc Latin Capital Letter E With Tilde
        :-  'Ế'  'ế'        :: 0x1ebe Latin Capital Letter E With Circumflex And Acute
        :-  'Ề'  'ề'        :: 0x1ec0 Latin Capital Letter E With Circumflex And Grave
        :-  'Ể'  'ể'        :: 0x1ec2 Latin Capital Letter E With Circumflex And Hook Above
        :-  'Ễ'  'ễ'        :: 0x1ec4 Latin Capital Letter E With Circumflex And Tilde
        :-  'Ệ'  'ệ'        :: 0x1ec6 Latin Capital Letter E With Circumflex And Dot Below
        :-  'Ỉ'  'ỉ'        :: 0x1ec8 Latin Capital Letter I With Hook Above
        :-  'Ị'  'ị'        :: 0x1eca Latin Capital Letter I With Dot Below
        :-  'Ọ'  'ọ'        :: 0x1ecc Latin Capital Letter O With Dot Below
        :-  'Ỏ'  'ỏ'        :: 0x1ece Latin Capital Letter O With Hook Above
        :-  'Ố'  'ố'        :: 0x1ed0 Latin Capital Letter O With Circumflex And Acute
        :-  'Ồ'  'ồ'        :: 0x1ed2 Latin Capital Letter O With Circumflex And Grave
        :-  'Ổ'  'ổ'        :: 0x1ed4 Latin Capital Letter O With Circumflex And Hook Above
        :-  'Ỗ'  'ỗ'        :: 0x1ed6 Latin Capital Letter O With Circumflex And Tilde
        :-  'Ộ'  'ộ'        :: 0x1ed8 Latin Capital Letter O With Circumflex And Dot Below
        :-  'Ớ'  'ớ'        :: 0x1eda Latin Capital Letter O With Horn And Acute
        :-  'Ờ'  'ờ'        :: 0x1edc Latin Capital Letter O With Horn And Grave
        :-  'Ở'  'ở'        :: 0x1ede Latin Capital Letter O With Horn And Hook Above
        :-  'Ỡ'  'ỡ'        :: 0x1ee0 Latin Capital Letter O With Horn And Tilde
        :-  'Ợ'  'ợ'        :: 0x1ee2 Latin Capital Letter O With Horn And Dot Below
        :-  'Ụ'  'ụ'        :: 0x1ee4 Latin Capital Letter U With Dot Below
        :-  'Ủ'  'ủ'        :: 0x1ee6 Latin Capital Letter U With Hook Above
        :-  'Ứ'  'ứ'        :: 0x1ee8 Latin Capital Letter U With Horn And Acute
        :-  'Ừ'  'ừ'        :: 0x1eea Latin Capital Letter U With Horn And Grave
        :-  'Ử'  'ử'        :: 0x1eec Latin Capital Letter U With Horn And Hook Above
        :-  'Ữ'  'ữ'        :: 0x1eee Latin Capital Letter U With Horn And Tilde
        :-  'Ự'  'ự'        :: 0x1ef0 Latin Capital Letter U With Horn And Dot Below
        :-  'Ỳ'  'ỳ'        :: 0x1ef2 Latin Capital Letter Y With Grave
        :-  'Ỵ'  'ỵ'        :: 0x1ef4 Latin Capital Letter Y With Dot Below
        :-  'Ỷ'  'ỷ'        :: 0x1ef6 Latin Capital Letter Y With Hook Above
        :-  'Ỹ'  'ỹ'        :: 0x1ef8 Latin Capital Letter Y With Tilde
        :-  'Ἀ'  'ἀ'        :: 0x1f08 Greek Capital Letter Alpha With Psili
        :-  'Ἁ'  'ἁ'        :: 0x1f09 Greek Capital Letter Alpha With Dasia
        :-  'Ἂ'  'ἂ'        :: 0x1f0a Greek Capital Letter Alpha With Psili And Varia
        :-  'Ἃ'  'ἃ'        :: 0x1f0b Greek Capital Letter Alpha With Dasia And Varia
        :-  'Ἄ'  'ἄ'        :: 0x1f0c Greek Capital Letter Alpha With Psili And Oxia
        :-  'Ἅ'  'ἅ'        :: 0x1f0d Greek Capital Letter Alpha With Dasia And Oxia
        :-  'Ἆ'  'ἆ'        :: 0x1f0e Greek Capital Letter Alpha With Psili And Perispomeni
        :-  'Ἇ'  'ἇ'        :: 0x1f0f Greek Capital Letter Alpha With Dasia And Perispomeni
        :-  'Ἐ'  'ἐ'        :: 0x1f18 Greek Capital Letter Epsilon With Psili
        :-  'Ἑ'  'ἑ'        :: 0x1f19 Greek Capital Letter Epsilon With Dasia
        :-  'Ἒ'  'ἒ'        :: 0x1f1a Greek Capital Letter Epsilon With Psili And Varia
        :-  'Ἓ'  'ἓ'        :: 0x1f1b Greek Capital Letter Epsilon With Dasia And Varia
        :-  'Ἔ'  'ἔ'        :: 0x1f1c Greek Capital Letter Epsilon With Psili And Oxia
        :-  'Ἕ'  'ἕ'        :: 0x1f1d Greek Capital Letter Epsilon With Dasia And Oxia
        :-  'Ἠ'  'ἠ'        :: 0x1f28 Greek Capital Letter Eta With Psili
        :-  'Ἡ'  'ἡ'        :: 0x1f29 Greek Capital Letter Eta With Dasia
        :-  'Ἢ'  'ἢ'        :: 0x1f2a Greek Capital Letter Eta With Psili And Varia
        :-  'Ἣ'  'ἣ'        :: 0x1f2b Greek Capital Letter Eta With Dasia And Varia
        :-  'Ἤ'  'ἤ'        :: 0x1f2c Greek Capital Letter Eta With Psili And Oxia
        :-  'Ἥ'  'ἥ'        :: 0x1f2d Greek Capital Letter Eta With Dasia And Oxia
        :-  'Ἦ'  'ἦ'        :: 0x1f2e Greek Capital Letter Eta With Psili And Perispomeni
        :-  'Ἧ'  'ἧ'        :: 0x1f2f Greek Capital Letter Eta With Dasia And Perispomeni
        :-  'Ἰ'  'ἰ'        :: 0x1f38 Greek Capital Letter Iota With Psili
        :-  'Ἱ'  'ἱ'        :: 0x1f39 Greek Capital Letter Iota With Dasia
        :-  'Ἲ'  'ἲ'        :: 0x1f3a Greek Capital Letter Iota With Psili And Varia
        :-  'Ἳ'  'ἳ'        :: 0x1f3b Greek Capital Letter Iota With Dasia And Varia
        :-  'Ἴ'  'ἴ'        :: 0x1f3c Greek Capital Letter Iota With Psili And Oxia
        :-  'Ἵ'  'ἵ'        :: 0x1f3d Greek Capital Letter Iota With Dasia And Oxia
        :-  'Ἶ'  'ἶ'        :: 0x1f3e Greek Capital Letter Iota With Psili And Perispomeni
        :-  'Ἷ'  'ἷ'        :: 0x1f3f Greek Capital Letter Iota With Dasia And Perispomeni
        :-  'Ὀ'  'ὀ'        :: 0x1f48 Greek Capital Letter Omicron With Psili
        :-  'Ὁ'  'ὁ'        :: 0x1f49 Greek Capital Letter Omicron With Dasia
        :-  'Ὂ'  'ὂ'        :: 0x1f4a Greek Capital Letter Omicron With Psili And Varia
        :-  'Ὃ'  'ὃ'        :: 0x1f4b Greek Capital Letter Omicron With Dasia And Varia
        :-  'Ὄ'  'ὄ'        :: 0x1f4c Greek Capital Letter Omicron With Psili And Oxia
        :-  'Ὅ'  'ὅ'        :: 0x1f4d Greek Capital Letter Omicron With Dasia And Oxia
        :-  'Ὑ'  'ὑ'        :: 0x1f59 Greek Capital Letter Upsilon With Dasia
        :-  'Ὓ'  'ὓ'        :: 0x1f5b Greek Capital Letter Upsilon With Dasia And Varia
        :-  'Ὕ'  'ὕ'        :: 0x1f5d Greek Capital Letter Upsilon With Dasia And Oxia
        :-  'Ὗ'  'ὗ'        :: 0x1f5f Greek Capital Letter Upsilon With Dasia And Perispomeni
        :-  'Ὠ'  'ὠ'        :: 0x1f68 Greek Capital Letter Omega With Psili
        :-  'Ὡ'  'ὡ'        :: 0x1f69 Greek Capital Letter Omega With Dasia
        :-  'Ὢ'  'ὢ'        :: 0x1f6a Greek Capital Letter Omega With Psili And Varia
        :-  'Ὣ'  'ὣ'        :: 0x1f6b Greek Capital Letter Omega With Dasia And Varia
        :-  'Ὤ'  'ὤ'        :: 0x1f6c Greek Capital Letter Omega With Psili And Oxia
        :-  'Ὥ'  'ὥ'        :: 0x1f6d Greek Capital Letter Omega With Dasia And Oxia
        :-  'Ὦ'  'ὦ'        :: 0x1f6e Greek Capital Letter Omega With Psili And Perispomeni
        :-  'Ὧ'  'ὧ'        :: 0x1f6f Greek Capital Letter Omega With Dasia And Perispomeni
        :-  'Ᾰ'  'ᾰ'        :: 0x1fb8 Greek Capital Letter Alpha With Vrachy
        :-  'Ᾱ'  'ᾱ'        :: 0x1fb9 Greek Capital Letter Alpha With Macron
        :-  'Ὰ'  'ὰ'        :: 0x1fba Greek Capital Letter Alpha With Varia
        :-  'Ῐ'  'ῐ'        :: 0x1fd8 Greek Capital Letter Iota With Vrachy
        :-  'Ῑ'  'ῑ'        :: 0x1fd9 Greek Capital Letter Iota With Macron
        :-  'Ῠ'  'ῠ'        :: 0x1fe8 Greek Capital Letter Upsilon With Vrachy
        :-  'Ῡ'  'ῡ'        :: 0x1fe9 Greek Capital Letter Upsilon With Macron
        :-  'Ａ'  'ａ'        :: 0xff21 Fullwidth Latin Capital Letter A
        :-  'Ｂ'  'ｂ'        :: 0xff22 Fullwidth Latin Capital Letter B
        :-  'Ｃ'  'ｃ'        :: 0xff23 Fullwidth Latin Capital Letter C
        :-  'Ｄ'  'ｄ'        :: 0xff24 Fullwidth Latin Capital Letter D
        :-  'Ｅ'  'ｅ'        :: 0xff25 Fullwidth Latin Capital Letter E
        :-  'Ｆ'  'ｆ'        :: 0xff26 Fullwidth Latin Capital Letter F
        :-  'Ｇ'  'ｇ'        :: 0xff27 Fullwidth Latin Capital Letter G
        :-  'Ｈ'  'ｈ'        :: 0xff28 Fullwidth Latin Capital Letter H
        :-  'Ｉ'  'ｉ'        :: 0xff29 Fullwidth Latin Capital Letter I
        :-  'Ｊ'  'ｊ'        :: 0xff2a Fullwidth Latin Capital Letter J
        :-  'Ｋ'  'ｋ'        :: 0xff2b Fullwidth Latin Capital Letter K
        :-  'Ｌ'  'ｌ'        :: 0xff2c Fullwidth Latin Capital Letter L
        :-  'Ｍ'  'ｍ'        :: 0xff2d Fullwidth Latin Capital Letter M
        :-  'Ｎ'  'ｎ'        :: 0xff2e Fullwidth Latin Capital Letter N
        :-  'Ｏ'  'ｏ'        :: 0xff2f Fullwidth Latin Capital Letter O
        :-  'Ｐ'  'ｐ'        :: 0xff30 Fullwidth Latin Capital Letter P
        :-  'Ｑ'  'ｑ'        :: 0xff31 Fullwidth Latin Capital Letter Q
        :-  'Ｒ'  'ｒ'        :: 0xff32 Fullwidth Latin Capital Letter R
        :-  'Ｓ'  'ｓ'        :: 0xff33 Fullwidth Latin Capital Letter S
        :-  'Ｔ'  'ｔ'        :: 0xff34 Fullwidth Latin Capital Letter T
        :-  'Ｕ'  'ｕ'        :: 0xff35 Fullwidth Latin Capital Letter U
        :-  'Ｖ'  'ｖ'        :: 0xff36 Fullwidth Latin Capital Letter V
        :-  'Ｗ'  'ｗ'        :: 0xff37 Fullwidth Latin Capital Letter W
        :-  'Ｘ'  'ｘ'        :: 0xff38 Fullwidth Latin Capital Letter X
        :-  'Ｙ'  'ｙ'        :: 0xff39 Fullwidth Latin Capital Letter Y
        :-  'Ｚ'  'ｚ'        :: 0xff3a Fullwidth Latin Capital Letter Z
        :-  '𐐀'  '𐐨'        :: 0x10400 Deseret Capital Letter Long I
        :-  '𐐁'  '𐐩'        :: 0x10401 Deseret Capital Letter Long E
        :-  '𐐂'  '𐐪'        :: 0x10402 Deseret Capital Letter Long A
        :-  '𐐃'  '𐐫'        :: 0x10403 Deseret Capital Letter Long Ah
        :-  '𐐄'  '𐐬'        :: 0x10404 Deseret Capital Letter Long O
        :-  '𐐅'  '𐐭'        :: 0x10405 Deseret Capital Letter Long Oo
        :-  '𐐆'  '𐐮'        :: 0x10406 Deseret Capital Letter Short I
        :-  '𐐇'  '𐐯'        :: 0x10407 Deseret Capital Letter Short E
        :-  '𐐈'  '𐐰'        :: 0x10408 Deseret Capital Letter Short A
        :-  '𐐉'  '𐐱'        :: 0x10409 Deseret Capital Letter Short Ah
        :-  '𐐊'  '𐐲'        :: 0x1040a Deseret Capital Letter Short O
        :-  '𐐋'  '𐐳'        :: 0x1040b Deseret Capital Letter Short Oo
        :-  '𐐌'  '𐐴'        :: 0x1040c Deseret Capital Letter Ay
        :-  '𐐍'  '𐐵'        :: 0x1040d Deseret Capital Letter Ow
        :-  '𐐎'  '𐐶'        :: 0x1040e Deseret Capital Letter Wu
        :-  '𐐏'  '𐐷'        :: 0x1040f Deseret Capital Letter Yee
        :-  '𐐐'  '𐐸'        :: 0x10410 Deseret Capital Letter H
        :-  '𐐑'  '𐐹'        :: 0x10411 Deseret Capital Letter Pee
        :-  '𐐒'  '𐐺'        :: 0x10412 Deseret Capital Letter Bee
        :-  '𐐓'  '𐐻'        :: 0x10413 Deseret Capital Letter Tee
        :-  '𐐔'  '𐐼'        :: 0x10414 Deseret Capital Letter Dee
        :-  '𐐕'  '𐐽'        :: 0x10415 Deseret Capital Letter Chee
        :-  '𐐖'  '𐐾'        :: 0x10416 Deseret Capital Letter Jee
        :-  '𐐗'  '𐐿'        :: 0x10417 Deseret Capital Letter Kay
        :-  '𐐘'  '𐑀'        :: 0x10418 Deseret Capital Letter Gay
        :-  '𐐙'  '𐑁'        :: 0x10419 Deseret Capital Letter Ef
        :-  '𐐚'  '𐑂'        :: 0x1041a Deseret Capital Letter Vee
        :-  '𐐛'  '𐑃'        :: 0x1041b Deseret Capital Letter Eth
        :-  '𐐜'  '𐑄'        :: 0x1041c Deseret Capital Letter Thee
        :-  '𐐝'  '𐑅'        :: 0x1041d Deseret Capital Letter Es
        :-  '𐐞'  '𐑆'        :: 0x1041e Deseret Capital Letter Zee
        :-  '𐐟'  '𐑇'        :: 0x1041f Deseret Capital Letter Esh
        :-  '𐐠'  '𐑈'        :: 0x10420 Deseret Capital Letter Zhee
        :-  '𐐡'  '𐑉'        :: 0x10421 Deseret Capital Letter Er
        :-  '𐐢'  '𐑊'        :: 0x10422 Deseret Capital Letter El
        :-  '𐐣'  '𐑋'        :: 0x10423 Deseret Capital Letter Em
        :-  '𐐤'  '𐑌'        :: 0x10424 Deseret Capital Letter En
        :-  '𐐥'  '𐑍'        :: 0x10425 Deseret Capital Letter Eng
        :-  '𐐦'  '𐑎'        :: 0x10426 Deseret Capital Letter Oi
        :-  '𐐧'  '𐑏'        :: 0x10427 Deseret Capital Letter Ew
  ==
  ++  cuss
    |=  vib=tape
    ^-  tape
    (brand (turn (lasso vib) |=(c=@t ?:((~(has by cuss-map) c) (~(got by cuss-map) c) c))))
  ++  cuss-map
    ^-  (map @t @t)
    %-  malt
    ^-  (list (pair @t @t))
    :~  :-  'a'  'A'        :: 0x41 Latin Capital Letter A
        :-  'b'  'B'        :: 0x42 Latin Capital Letter B
        :-  'c'  'C'        :: 0x43 Latin Capital Letter C
        :-  'd'  'D'        :: 0x44 Latin Capital Letter D
        :-  'e'  'E'        :: 0x45 Latin Capital Letter E
        :-  'f'  'F'        :: 0x46 Latin Capital Letter F
        :-  'g'  'G'        :: 0x47 Latin Capital Letter G
        :-  'h'  'H'        :: 0x48 Latin Capital Letter H
        :-  'i'  'I'        :: 0x49 Latin Capital Letter I
        :-  'j'  'J'        :: 0x4a Latin Capital Letter J
        :-  'k'  'K'        :: 0x4b Latin Capital Letter K
        :-  'l'  'L'        :: 0x4c Latin Capital Letter L
        :-  'm'  'M'        :: 0x4d Latin Capital Letter M
        :-  'n'  'N'        :: 0x4e Latin Capital Letter N
        :-  'o'  'O'        :: 0x4f Latin Capital Letter O
        :-  'p'  'P'        :: 0x50 Latin Capital Letter P
        :-  'q'  'Q'        :: 0x51 Latin Capital Letter Q
        :-  'r'  'R'        :: 0x52 Latin Capital Letter R
        :-  's'  'S'        :: 0x53 Latin Capital Letter S
        :-  't'  'T'        :: 0x54 Latin Capital Letter T
        :-  'u'  'U'        :: 0x55 Latin Capital Letter U
        :-  'v'  'V'        :: 0x56 Latin Capital Letter V
        :-  'w'  'W'        :: 0x57 Latin Capital Letter W
        :-  'x'  'X'        :: 0x58 Latin Capital Letter X
        :-  'y'  'Y'        :: 0x59 Latin Capital Letter Y
        :-  'z'  'Z'        :: 0x5a Latin Capital Letter Z
        :-  'à'  'À'        :: 0xc0 Latin Capital Letter A With Grave
        :-  'á'  'Á'        :: 0xc1 Latin Capital Letter A With Acute
        :-  'â'  'Â'        :: 0xc2 Latin Capital Letter A With Circumflex
        :-  'ã'  'Ã'        :: 0xc3 Latin Capital Letter A With Tilde
        :-  'ä'  'Ä'        :: 0xc4 Latin Capital Letter A With Diaeresis
        :-  'å'  'Å'        :: 0xc5 Latin Capital Letter A With Ring Above
        :-  'æ'  'Æ'        :: 0xc6 Latin Capital Letter Ae
        :-  'ç'  'Ç'        :: 0xc7 Latin Capital Letter C With Cedilla
        :-  'è'  'È'        :: 0xc8 Latin Capital Letter E With Grave
        :-  'é'  'É'        :: 0xc9 Latin Capital Letter E With Acute
        :-  'ê'  'Ê'        :: 0xca Latin Capital Letter E With Circumflex
        :-  'ë'  'Ë'        :: 0xcb Latin Capital Letter E With Diaeresis
        :-  'ì'  'Ì'        :: 0xcc Latin Capital Letter I With Grave
        :-  'í'  'Í'        :: 0xcd Latin Capital Letter I With Acute
        :-  'î'  'Î'        :: 0xce Latin Capital Letter I With Circumflex
        :-  'ï'  'Ï'        :: 0xcf Latin Capital Letter I With Diaeresis
        :-  'ð'  'Ð'        :: 0xd0 Latin Capital Letter Eth
        :-  'ñ'  'Ñ'        :: 0xd1 Latin Capital Letter N With Tilde
        :-  'ò'  'Ò'        :: 0xd2 Latin Capital Letter O With Grave
        :-  'ó'  'Ó'        :: 0xd3 Latin Capital Letter O With Acute
        :-  'ô'  'Ô'        :: 0xd4 Latin Capital Letter O With Circumflex
        :-  'õ'  'Õ'        :: 0xd5 Latin Capital Letter O With Tilde
        :-  'ö'  'Ö'        :: 0xd6 Latin Capital Letter O With Diaeresis
        :-  'ø'  'Ø'        :: 0xd8 Latin Capital Letter O With Stroke
        :-  'ù'  'Ù'        :: 0xd9 Latin Capital Letter U With Grave
        :-  'ú'  'Ú'        :: 0xda Latin Capital Letter U With Acute
        :-  'û'  'Û'        :: 0xdb Latin Capital Letter U With Circumflex
        :-  'ü'  'Ü'        :: 0xdc Latin Capital Letter U With Diaeresis
        :-  'ý'  'Ý'        :: 0xdd Latin Capital Letter Y With Acute
        :-  'þ'  'Þ'        :: 0xde Latin Capital Letter Thorn
        :-  'ā'  'Ā'        :: 0x100 Latin Capital Letter A With Macron
        :-  'ă'  'Ă'        :: 0x102 Latin Capital Letter A With Breve
        :-  'ą'  'Ą'        :: 0x104 Latin Capital Letter A With Ogonek
        :-  'ć'  'Ć'        :: 0x106 Latin Capital Letter C With Acute
        :-  'ĉ'  'Ĉ'        :: 0x108 Latin Capital Letter C With Circumflex
        :-  'ċ'  'Ċ'        :: 0x10a Latin Capital Letter C With Dot Above
        :-  'č'  'Č'        :: 0x10c Latin Capital Letter C With Caron
        :-  'ď'  'Ď'        :: 0x10e Latin Capital Letter D With Caron
        :-  'đ'  'Đ'        :: 0x110 Latin Capital Letter D With Stroke
        :-  'ē'  'Ē'        :: 0x112 Latin Capital Letter E With Macron
        :-  'ĕ'  'Ĕ'        :: 0x114 Latin Capital Letter E With Breve
        :-  'ė'  'Ė'        :: 0x116 Latin Capital Letter E With Dot Above
        :-  'ę'  'Ę'        :: 0x118 Latin Capital Letter E With Ogonek
        :-  'ě'  'Ě'        :: 0x11a Latin Capital Letter E With Caron
        :-  'ĝ'  'Ĝ'        :: 0x11c Latin Capital Letter G With Circumflex
        :-  'ğ'  'Ğ'        :: 0x11e Latin Capital Letter G With Breve
        :-  'ġ'  'Ġ'        :: 0x120 Latin Capital Letter G With Dot Above
        :-  'ģ'  'Ģ'        :: 0x122 Latin Capital Letter G With Cedilla
        :-  'ĥ'  'Ĥ'        :: 0x124 Latin Capital Letter H With Circumflex
        :-  'ħ'  'Ħ'        :: 0x126 Latin Capital Letter H With Stroke
        :-  'ĩ'  'Ĩ'        :: 0x128 Latin Capital Letter I With Tilde
        :-  'ī'  'Ī'        :: 0x12a Latin Capital Letter I With Macron
        :-  'ĭ'  'Ĭ'        :: 0x12c Latin Capital Letter I With Breve
        :-  'į'  'Į'        :: 0x12e Latin Capital Letter I With Ogonek
        :-  'i'  'İ'        :: 0x130 Latin Capital Letter I With Dot Above
        :-  'ĳ'  'Ĳ'        :: 0x132 Latin Capital Ligature Ij
        :-  'ĵ'  'Ĵ'        :: 0x134 Latin Capital Letter J With Circumflex
        :-  'ķ'  'Ķ'        :: 0x136 Latin Capital Letter K With Cedilla
        :-  'ĺ'  'Ĺ'        :: 0x139 Latin Capital Letter L With Acute
        :-  'ļ'  'Ļ'        :: 0x13b Latin Capital Letter L With Cedilla
        :-  'ľ'  'Ľ'        :: 0x13d Latin Capital Letter L With Caron
        :-  'ŀ'  'Ŀ'        :: 0x13f Latin Capital Letter L With Middle Dot
        :-  'ł'  'Ł'        :: 0x141 Latin Capital Letter L With Stroke
        :-  'ń'  'Ń'        :: 0x143 Latin Capital Letter N With Acute
        :-  'ņ'  'Ņ'        :: 0x145 Latin Capital Letter N With Cedilla
        :-  'ň'  'Ň'        :: 0x147 Latin Capital Letter N With Caron
        :-  'ŋ'  'Ŋ'        :: 0x14a Latin Capital Letter Eng
        :-  'ō'  'Ō'        :: 0x14c Latin Capital Letter O With Macron
        :-  'ŏ'  'Ŏ'        :: 0x14e Latin Capital Letter O With Breve
        :-  'ő'  'Ő'        :: 0x150 Latin Capital Letter O With Double Acute
        :-  'œ'  'Œ'        :: 0x152 Latin Capital Ligature Oe
        :-  'ŕ'  'Ŕ'        :: 0x154 Latin Capital Letter R With Acute
        :-  'ŗ'  'Ŗ'        :: 0x156 Latin Capital Letter R With Cedilla
        :-  'ř'  'Ř'        :: 0x158 Latin Capital Letter R With Caron
        :-  'ś'  'Ś'        :: 0x15a Latin Capital Letter S With Acute
        :-  'ŝ'  'Ŝ'        :: 0x15c Latin Capital Letter S With Circumflex
        :-  'ş'  'Ş'        :: 0x15e Latin Capital Letter S With Cedilla
        :-  'š'  'Š'        :: 0x160 Latin Capital Letter S With Caron
        :-  'ţ'  'Ţ'        :: 0x162 Latin Capital Letter T With Cedilla
        :-  'ť'  'Ť'        :: 0x164 Latin Capital Letter T With Caron
        :-  'ŧ'  'Ŧ'        :: 0x166 Latin Capital Letter T With Stroke
        :-  'ũ'  'Ũ'        :: 0x168 Latin Capital Letter U With Tilde
        :-  'ū'  'Ū'        :: 0x16a Latin Capital Letter U With Macron
        :-  'ŭ'  'Ŭ'        :: 0x16c Latin Capital Letter U With Breve
        :-  'ů'  'Ů'        :: 0x16e Latin Capital Letter U With Ring Above
        :-  'ű'  'Ű'        :: 0x170 Latin Capital Letter U With Double Acute
        :-  'ų'  'Ų'        :: 0x172 Latin Capital Letter U With Ogonek
        :-  'ŵ'  'Ŵ'        :: 0x174 Latin Capital Letter W With Circumflex
        :-  'ŷ'  'Ŷ'        :: 0x176 Latin Capital Letter Y With Circumflex
        :-  'ÿ'  'Ÿ'        :: 0x178 Latin Capital Letter Y With Diaeresis
        :-  'ź'  'Ź'        :: 0x179 Latin Capital Letter Z With Acute
        :-  'ż'  'Ż'        :: 0x17b Latin Capital Letter Z With Dot Above
        :-  'ž'  'Ž'        :: 0x17d Latin Capital Letter Z With Caron
        :-  'ɓ'  'Ɓ'        :: 0x181 Latin Capital Letter B With Hook
        :-  'ƃ'  'Ƃ'        :: 0x182 Latin Capital Letter B With Topbar
        :-  'ƅ'  'Ƅ'        :: 0x184 Latin Capital Letter Tone Six
        :-  'ɔ'  'Ɔ'        :: 0x186 Latin Capital Letter Open O
        :-  'ƈ'  'Ƈ'        :: 0x187 Latin Capital Letter C With Hook
        :-  'ɗ'  'Ɗ'        :: 0x18a Latin Capital Letter D With Hook
        :-  'ƌ'  'Ƌ'        :: 0x18b Latin Capital Letter D With Topbar
        :-  'ɘ'  'Ǝ'        :: 0x18e Latin Capital Letter Reversed E
        :-  'ə'  'Ə'        :: 0x18f Latin Capital Letter Schwa
        :-  'ɛ'  'Ɛ'        :: 0x190 Latin Capital Letter Open E
        :-  'ƒ'  'Ƒ'        :: 0x191 Latin Capital Letter F With Hook
        :-  'ɠ'  'Ɠ'        :: 0x193 Latin Capital Letter G With Hook
        :-  'ɣ'  'Ɣ'        :: 0x194 Latin Capital Letter Gamma
        :-  'ɩ'  'Ɩ'        :: 0x196 Latin Capital Letter Iota
        :-  'ɨ'  'Ɨ'        :: 0x197 Latin Capital Letter I With Stroke
        :-  'ƙ'  'Ƙ'        :: 0x198 Latin Capital Letter K With Hook
        :-  'ɯ'  'Ɯ'        :: 0x19c Latin Capital Letter Turned M
        :-  'ɲ'  'Ɲ'        :: 0x19d Latin Capital Letter N With Left Hook
        :-  'ɵ'  'Ɵ'        :: 0x19f Latin Capital Letter O With Middle Tilde
        :-  'ơ'  'Ơ'        :: 0x1a0 Latin Capital Letter O With Horn
        :-  'ƣ'  'Ƣ'        :: 0x1a2 Latin Capital Letter Oi
        :-  'ƥ'  'Ƥ'        :: 0x1a4 Latin Capital Letter P With Hook
        :-  'ƨ'  'Ƨ'        :: 0x1a7 Latin Capital Letter Tone Two
        :-  'ʃ'  'Ʃ'        :: 0x1a9 Latin Capital Letter Esh
        :-  'ƭ'  'Ƭ'        :: 0x1ac Latin Capital Letter T With Hook
        :-  'ʈ'  'Ʈ'        :: 0x1ae Latin Capital Letter T With Retroflex Hook
        :-  'ư'  'Ư'        :: 0x1af Latin Capital Letter U With Horn
        :-  'ʊ'  'Ʊ'        :: 0x1b1 Latin Capital Letter Upsilon
        :-  'ʋ'  'Ʋ'        :: 0x1b2 Latin Capital Letter V With Hook
        :-  'ƴ'  'Ƴ'        :: 0x1b3 Latin Capital Letter Y With Hook
        :-  'ƶ'  'Ƶ'        :: 0x1b5 Latin Capital Letter Z With Stroke
        :-  'ʒ'  'Ʒ'        :: 0x1b7 Latin Capital Letter Ezh
        :-  'ƹ'  'Ƹ'        :: 0x1b8 Latin Capital Letter Ezh Reversed
        :-  'ƽ'  'Ƽ'        :: 0x1bc Latin Capital Letter Tone Five
        :-  'ǆ'  'Ǆ'        :: 0x1c4 Latin Capital Letter Dz With Caron
        :-  'ǉ'  'Ǉ'        :: 0x1c7 Latin Capital Letter Lj
        :-  'ǌ'  'Ǌ'        :: 0x1ca Latin Capital Letter Nj
        :-  'ǎ'  'Ǎ'        :: 0x1cd Latin Capital Letter A With Caron
        :-  'ǐ'  'Ǐ'        :: 0x1cf Latin Capital Letter I With Caron
        :-  'ǒ'  'Ǒ'        :: 0x1d1 Latin Capital Letter O With Caron
        :-  'ǔ'  'Ǔ'        :: 0x1d3 Latin Capital Letter U With Caron
        :-  'ǖ'  'Ǖ'        :: 0x1d5 Latin Capital Letter U With Diaeresis And Macron
        :-  'ǘ'  'Ǘ'        :: 0x1d7 Latin Capital Letter U With Diaeresis And Acute
        :-  'ǚ'  'Ǚ'        :: 0x1d9 Latin Capital Letter U With Diaeresis And Caron
        :-  'ǜ'  'Ǜ'        :: 0x1db Latin Capital Letter U With Diaeresis And Grave
        :-  'ǟ'  'Ǟ'        :: 0x1de Latin Capital Letter A With Diaeresis And Macron
        :-  'ǡ'  'Ǡ'        :: 0x1e0 Latin Capital Letter A With Dot Above And Macron
        :-  'ǣ'  'Ǣ'        :: 0x1e2 Latin Capital Letter Ae With Macron
        :-  'ǥ'  'Ǥ'        :: 0x1e4 Latin Capital Letter G With Stroke
        :-  'ǧ'  'Ǧ'        :: 0x1e6 Latin Capital Letter G With Caron
        :-  'ǩ'  'Ǩ'        :: 0x1e8 Latin Capital Letter K With Caron
        :-  'ǫ'  'Ǫ'        :: 0x1ea Latin Capital Letter O With Ogonek
        :-  'ǭ'  'Ǭ'        :: 0x1ec Latin Capital Letter O With Ogonek And Macron
        :-  'ǯ'  'Ǯ'        :: 0x1ee Latin Capital Letter Ezh With Caron
        :-  'ǳ'  'Ǳ'        :: 0x1f1 Latin Capital Letter Dz
        :-  'ǵ'  'Ǵ'        :: 0x1f4 Latin Capital Letter G With Acute
        :-  'ǻ'  'Ǻ'        :: 0x1fa Latin Capital Letter A With Ring Above And Acute
        :-  'ǽ'  'Ǽ'        :: 0x1fc Latin Capital Letter Ae With Acute
        :-  'ǿ'  'Ǿ'        :: 0x1fe Latin Capital Letter O With Stroke And Acute
        :-  'ȁ'  'Ȁ'        :: 0x200 Latin Capital Letter A With Double Grave
        :-  'ȃ'  'Ȃ'        :: 0x202 Latin Capital Letter A With Inverted Breve
        :-  'ȅ'  'Ȅ'        :: 0x204 Latin Capital Letter E With Double Grave
        :-  'ȇ'  'Ȇ'        :: 0x206 Latin Capital Letter E With Inverted Breve
        :-  'ȉ'  'Ȉ'        :: 0x208 Latin Capital Letter I With Double Grave
        :-  'ȋ'  'Ȋ'        :: 0x20a Latin Capital Letter I With Inverted Breve
        :-  'ȍ'  'Ȍ'        :: 0x20c Latin Capital Letter O With Double Grave
        :-  'ȏ'  'Ȏ'        :: 0x20e Latin Capital Letter O With Inverted Breve
        :-  'ȑ'  'Ȑ'        :: 0x210 Latin Capital Letter R With Double Grave
        :-  'ȓ'  'Ȓ'        :: 0x212 Latin Capital Letter R With Inverted Breve
        :-  'ȕ'  'Ȕ'        :: 0x214 Latin Capital Letter U With Double Grave
        :-  'ȗ'  'Ȗ'        :: 0x216 Latin Capital Letter U With Inverted Breve
        :-  'ά'  'Ά'        :: 0x386 Greek Capital Letter Alpha With Tonos
        :-  'έ'  'Έ'        :: 0x388 Greek Capital Letter Epsilon With Tonos
        :-  'ή'  'Ή'        :: 0x389 Greek Capital Letter Eta With Tonos
        :-  'ί'  'Ί'        :: 0x38a Greek Capital Letter Iota With Tonos
        :-  'ό'  'Ό'        :: 0x38c Greek Capital Letter Omicron With Tonos
        :-  'ύ'  'Ύ'        :: 0x38e Greek Capital Letter Upsilon With Tonos
        :-  'ώ'  'Ώ'        :: 0x38f Greek Capital Letter Omega With Tonos
        :-  'α'  'Α'        :: 0x391 Greek Capital Letter Alpha
        :-  'β'  'Β'        :: 0x392 Greek Capital Letter Beta
        :-  'γ'  'Γ'        :: 0x393 Greek Capital Letter Gamma
        :-  'δ'  'Δ'        :: 0x394 Greek Capital Letter Delta
        :-  'ε'  'Ε'        :: 0x395 Greek Capital Letter Epsilon
        :-  'ζ'  'Ζ'        :: 0x396 Greek Capital Letter Zeta
        :-  'η'  'Η'        :: 0x397 Greek Capital Letter Eta
        :-  'θ'  'Θ'        :: 0x398 Greek Capital Letter Theta
        :-  'ι'  'Ι'        :: 0x399 Greek Capital Letter Iota
        :-  'κ'  'Κ'        :: 0x39a Greek Capital Letter Kappa
        :-  'λ'  'Λ'        :: 0x39b Greek Capital Letter Lamda
        :-  'μ'  'Μ'        :: 0x39c Greek Capital Letter Mu
        :-  'ν'  'Ν'        :: 0x39d Greek Capital Letter Nu
        :-  'ξ'  'Ξ'        :: 0x39e Greek Capital Letter Xi
        :-  'ο'  'Ο'        :: 0x39f Greek Capital Letter Omicron
        :-  'π'  'Π'        :: 0x3a0 Greek Capital Letter Pi
        :-  'ρ'  'Ρ'        :: 0x3a1 Greek Capital Letter Rho
        :-  'σ'  'Σ'        :: 0x3a3 Greek Capital Letter Sigma
        :-  'τ'  'Τ'        :: 0x3a4 Greek Capital Letter Tau
        :-  'υ'  'Υ'        :: 0x3a5 Greek Capital Letter Upsilon
        :-  'φ'  'Φ'        :: 0x3a6 Greek Capital Letter Phi
        :-  'χ'  'Χ'        :: 0x3a7 Greek Capital Letter Chi
        :-  'ψ'  'Ψ'        :: 0x3a8 Greek Capital Letter Psi
        :-  'ω'  'Ω'        :: 0x3a9 Greek Capital Letter Omega
        :-  'ϊ'  'Ϊ'        :: 0x3aa Greek Capital Letter Iota With Dialytika
        :-  'ϋ'  'Ϋ'        :: 0x3ab Greek Capital Letter Upsilon With Dialytika
        :-  'ά'  'Ά'        :: 0x3ac Greek Capital Letter Alpha With Tonos
        :-  'έ'  'Έ'        :: 0x3ad Greek Capital Letter Epsilon With Tonos
        :-  'ή'  'Ή'        :: 0x3ae Greek Capital Letter Eta With Tonos
        :-  'ί'  'Ί'        :: 0x3af Greek Capital Letter Iota With Tonos
        :-  'ΰ'  'Ϋ́'        :: 0x3b0 Greek Capital Letter Upsilon With Dialytika And Tonos
        :-  'α'  'Α'        :: 0x3b1 Greek Capital Letter Alpha
        :-  'β'  'Β'        :: 0x3b2 Greek Capital Letter Beta
        :-  'γ'  'Γ'        :: 0x3b3 Greek Capital Letter Gamma
        :-  'δ'  'Δ'        :: 0x3b4 Greek Capital Letter Delta
        :-  'ε'  'Ε'        :: 0x3b5 Greek Capital Letter Epsilon
        :-  'ζ'  'Ζ'        :: 0x3b6 Greek Capital Letter Zeta
        :-  'η'  'Η'        :: 0x3b7 Greek Capital Letter Eta
        :-  'θ'  'Θ'        :: 0x3b8 Greek Capital Letter Theta
        :-  'ι'  'Ι'        :: 0x3b9 Greek Capital Letter Iota
        :-  'κ'  'Κ'        :: 0x3ba Greek Capital Letter Kappa
        :-  'λ'  'Λ'        :: 0x3bb Greek Capital Letter Lamda
        :-  'μ'  'Μ'        :: 0x3bc Greek Capital Letter Mu
        :-  'ν'  'Ν'        :: 0x3bd Greek Capital Letter Nu
        :-  'ξ'  'Ξ'        :: 0x3be Greek Capital Letter Xi
        :-  'ο'  'Ο'        :: 0x3bf Greek Capital Letter Omicron
        :-  'π'  'Π'        :: 0x3c0 Greek Capital Letter Pi
        :-  'ρ'  'Ρ'        :: 0x3c1 Greek Capital Letter Rho
        :-  'ς'  'Σ'        :: 0x3c2 Greek Capital Letter Final Sigma
        :-  'σ'  'Σ'        :: 0x3c3 Greek Capital Letter Sigma
        :-  'τ'  'Τ'        :: 0x3c4 Greek Capital Letter Tau
        :-  'υ'  'Υ'        :: 0x3c5 Greek Capital Letter Upsilon
        :-  'φ'  'Φ'        :: 0x3c6 Greek Capital Letter Phi
        :-  'χ'  'Χ'        :: 0x3c7 Greek Capital Letter Chi
        :-  'ψ'  'Ψ'        :: 0x3c8 Greek Capital Letter Psi
        :-  'ω'  'Ω'        :: 0x3c9 Greek Capital Letter Omega
        :-  'ϊ'  'Ϊ'        :: 0x3ca Greek Capital Letter Iota With Dialytika
        :-  'ϋ'  'Ϋ'        :: 0x3cb Greek Capital Letter Upsilon With Dialytika
        :-  'ό'  'Ό'        :: 0x3cc Greek Capital Letter Omicron With Tonos
        :-  'ύ'  'Ύ'        :: 0x3cd Greek Capital Letter Upsilon With Tonos
        :-  'ώ'  'Ώ'        :: 0x3ce Greek Capital Letter Omega With Tonos
        :-  'ϗ'  'Ϗ'        :: 0x3cf Capital Kai Symbol
        :-  'ϐ'  'Β'        :: 0x3d0 Beta Symbol
        :-  'ϑ'  'Θ'        :: 0x3d1 Theta Symbol
        :-  'ϒ'  'ϒ'        :: 0x3d2 Upsilon With Hook Symbol
        :-  'ϓ'  'ϓ'        :: 0x3d3 Upsilon With Acute And Hook Symbol
        :-  'ϔ'  'ϔ'        :: 0x3d4 Upsilon With Diaeresis And Hook Symbol
        :-  'ϕ'  'Φ'        :: 0x3d5 Phi Symbol
        :-  'ϖ'  'Π'        :: 0x3d6 Pi Symbol
        :-  'ϗ'  'Ϗ'        :: 0x3d7 Kai Symbol
        :-  'ϙ'  'Ϙ'        :: 0x3d9 Greek Capital Letter Archaic Koppa
        :-  'ϛ'  'Ϛ'        :: 0x3db Greek Capital Letter Stigma
        :-  'ϝ'  'Ϝ'        :: 0x3dd Greek Capital Letter Digamma
        :-  'ϟ'  'Ϟ'        :: 0x3df Greek Capital Letter Koppa
        :-  'ϡ'  'Ϡ'        :: 0x3e1 Greek Capital Letter Sampi
        :-  'ϣ'  'Ϣ'        :: 0x3e2 Coptic Capital Letter Shei
        :-  'ϥ'  'Ϥ'        :: 0x3e4 Coptic Capital Letter Fei
        :-  'ϧ'  'Ϧ'        :: 0x3e6 Coptic Capital Letter Khei
        :-  'ϩ'  'Ϩ'        :: 0x3e8 Coptic Capital Letter Hori
        :-  'ϫ'  'Ϫ'        :: 0x3ea Coptic Capital Letter Gangia
        :-  'ϭ'  'Ϭ'        :: 0x3ec Coptic Capital Letter Shima
        :-  'ϯ'  'Ϯ'        :: 0x3ee Coptic Capital Letter Dei
        :-  'ё'  'Ё'        :: 0x401 Cyrillic Capital Letter Io
        :-  'ђ'  'Ђ'        :: 0x402 Cyrillic Capital Letter Dje
        :-  'ѓ'  'Ѓ'        :: 0x403 Cyrillic Capital Letter Gje
        :-  'є'  'Є'        :: 0x404 Cyrillic Capital Letter Ukrainian Ie
        :-  'ѕ'  'Ѕ'        :: 0x405 Cyrillic Capital Letter Dze
        :-  'і'  'І'        :: 0x406 Cyrillic Capital Letter Byelorussian-Ukrainian I
        :-  'ї'  'Ї'        :: 0x407 Cyrillic Capital Letter Yi
        :-  'ј'  'Ј'        :: 0x408 Cyrillic Capital Letter Je
        :-  'љ'  'Љ'        :: 0x409 Cyrillic Capital Letter Lje
        :-  'њ'  'Њ'        :: 0x40a Cyrillic Capital Letter Nje
        :-  'ћ'  'Ћ'        :: 0x40b Cyrillic Capital Letter Tshe
        :-  'ќ'  'Ќ'        :: 0x40c Cyrillic Capital Letter Kje
        :-  'ў'  'Ў'        :: 0x40e Cyrillic Capital Letter Short U
        :-  'џ'  'Џ'        :: 0x40f Cyrillic Capital Letter Dzhe
        :-  'а'  'А'        :: 0x410 Cyrillic Capital Letter A
        :-  'б'  'Б'        :: 0x411 Cyrillic Capital Letter Be
        :-  'в'  'В'        :: 0x412 Cyrillic Capital Letter Ve
        :-  'г'  'Г'        :: 0x413 Cyrillic Capital Letter Ghe
        :-  'д'  'Д'        :: 0x414 Cyrillic Capital Letter De
        :-  'е'  'Е'        :: 0x415 Cyrillic Capital Letter Ie
        :-  'ж'  'Ж'        :: 0x416 Cyrillic Capital Letter Zhe
        :-  'з'  'З'        :: 0x417 Cyrillic Capital Letter Ze
        :-  'и'  'И'        :: 0x418 Cyrillic Capital Letter I
        :-  'й'  'Й'        :: 0x419 Cyrillic Capital Letter Short I
        :-  'к'  'К'        :: 0x41a Cyrillic Capital Letter Ka
        :-  'л'  'Л'        :: 0x41b Cyrillic Capital Letter El
        :-  'м'  'М'        :: 0x41c Cyrillic Capital Letter Em
        :-  'н'  'Н'        :: 0x41d Cyrillic Capital Letter En
        :-  'о'  'О'        :: 0x41e Cyrillic Capital Letter O
        :-  'п'  'П'        :: 0x41f Cyrillic Capital Letter Pe
        :-  'р'  'Р'        :: 0x420 Cyrillic Capital Letter Er
        :-  'с'  'С'        :: 0x421 Cyrillic Capital Letter Es
        :-  'т'  'Т'        :: 0x422 Cyrillic Capital Letter Te
        :-  'у'  'У'        :: 0x423 Cyrillic Capital Letter U
        :-  'ф'  'Ф'        :: 0x424 Cyrillic Capital Letter Ef
        :-  'х'  'Х'        :: 0x425 Cyrillic Capital Letter Ha
        :-  'ц'  'Ц'        :: 0x426 Cyrillic Capital Letter Tse
        :-  'ч'  'Ч'        :: 0x427 Cyrillic Capital Letter Che
        :-  'ш'  'Ш'        :: 0x428 Cyrillic Capital Letter Sha
        :-  'щ'  'Щ'        :: 0x429 Cyrillic Capital Letter Shcha
        :-  'ъ'  'Ъ'        :: 0x42a Cyrillic Capital Letter Hard Sign
        :-  'ы'  'Ы'        :: 0x42b Cyrillic Capital Letter Yeru
        :-  'ь'  'Ь'        :: 0x42c Cyrillic Capital Letter Soft Sign
        :-  'э'  'Э'        :: 0x42d Cyrillic Capital Letter E
        :-  'ю'  'Ю'        :: 0x42e Cyrillic Capital Letter Yu
        :-  'я'  'Я'        :: 0x42f Cyrillic Capital Letter Ya
        :-  'ѡ'  'Ѡ'        :: 0x460 Cyrillic Capital Letter Omega
        :-  'ѣ'  'Ѣ'        :: 0x462 Cyrillic Capital Letter Yat
        :-  'ѥ'  'Ѥ'        :: 0x464 Cyrillic Capital Letter Iotified E
        :-  'ѧ'  'Ѧ'        :: 0x466 Cyrillic Capital Letter Little Yus
        :-  'ѩ'  'Ѩ'        :: 0x468 Cyrillic Capital Letter Iotified Little Yus
        :-  'ѫ'  'Ѫ'        :: 0x46a Cyrillic Capital Letter Big Yus
        :-  'ѭ'  'Ѭ'        :: 0x46c Cyrillic Capital Letter Iotified Big Yus
        :-  'ѯ'  'Ѯ'        :: 0x46e Cyrillic Capital Letter Ksi
        :-  'ѱ'  'Ѱ'        :: 0x470 Cyrillic Capital Letter Psi
        :-  'ѳ'  'Ѳ'        :: 0x472 Cyrillic Capital Letter Fita
        :-  'ѵ'  'Ѵ'        :: 0x474 Cyrillic Capital Letter Izhitsa
        :-  'ѷ'  'Ѷ'        :: 0x476 Cyrillic Capital Letter Izhitsa With Double Grave Accent
        :-  'ѹ'  'Ѹ'        :: 0x478 Cyrillic Capital Letter Uk
        :-  'ѻ'  'Ѻ'        :: 0x47a Cyrillic Capital Letter Round Omega
        :-  'ѽ'  'Ѽ'        :: 0x47c Cyrillic Capital Letter Omega With Titlo
        :-  'ѿ'  'Ѿ'        :: 0x47e Cyrillic Capital Letter Ot
        :-  'ҁ'  'Ҁ'        :: 0x480 Cyrillic Capital Letter Koppa
        :-  'ґ'  'Ґ'        :: 0x490 Cyrillic Capital Letter Ghe With Upturn
        :-  'ғ'  'Ғ'        :: 0x492 Cyrillic Capital Letter Ghe With Stroke
        :-  'ҕ'  'Ҕ'        :: 0x494 Cyrillic Capital Letter Ghe With Middle Hook
        :-  'җ'  'Җ'        :: 0x496 Cyrillic Capital Letter Zhe With Descender
        :-  'ҙ'  'Ҙ'        :: 0x498 Cyrillic Capital Letter Ze With Descender
        :-  'қ'  'Қ'        :: 0x49a Cyrillic Capital Letter Ka With Descender
        :-  'ҝ'  'Ҝ'        :: 0x49c Cyrillic Capital Letter Ka With Vertical Stroke
        :-  'ҟ'  'Ҟ'        :: 0x49e Cyrillic Capital Letter Ka With Stroke
        :-  'ҡ'  'Ҡ'        :: 0x4a0 Cyrillic Capital Letter Bashkir Ka
        :-  'ң'  'Ң'        :: 0x4a2 Cyrillic Capital Letter En With Descender
        :-  'ҥ'  'Ҥ'        :: 0x4a4 Cyrillic Capital Ligature En Ghe
        :-  'ҧ'  'Ҧ'        :: 0x4a6 Cyrillic Capital Letter Pe With Middle Hook
        :-  'ҩ'  'Ҩ'        :: 0x4a8 Cyrillic Capital Letter Abkhasian Ha
        :-  'ҫ'  'Ҫ'        :: 0x4aa Cyrillic Capital Letter Es With Descender
        :-  'ҭ'  'Ҭ'        :: 0x4ac Cyrillic Capital Letter Te With Descender
        :-  'ү'  'Ү'        :: 0x4ae Cyrillic Capital Letter Straight U
        :-  'ұ'  'Ұ'        :: 0x4b0 Cyrillic Capital Letter Straight U With Stroke
        :-  'ҳ'  'Ҳ'        :: 0x4b2 Cyrillic Capital Letter Ha With Descender
        :-  'ҵ'  'Ҵ'        :: 0x4b4 Cyrillic Capital Ligature Te Tse
        :-  'ҷ'  'Ҷ'        :: 0x4b6 Cyrillic Capital Letter Che With Descender
        :-  'ҹ'  'Ҹ'        :: 0x4b8 Cyrillic Capital Letter Che With Vertical Stroke
        :-  'һ'  'Һ'        :: 0x4ba Cyrillic Capital Letter Shha
        :-  'ҽ'  'Ҽ'        :: 0x4bc Cyrillic Capital Letter Abkhasian Che
        :-  'ҿ'  'Ҿ'        :: 0x4be Cyrillic Capital Letter Abkhasian Che With Descender
        :-  'ӂ'  'Ӂ'        :: 0x4c1 Cyrillic Capital Letter Zhe With Breve
        :-  'ӄ'  'Ӄ'        :: 0x4c3 Cyrillic Capital Letter Ka With Hook
        :-  'ӈ'  'Ӈ'        :: 0x4c7 Cyrillic Capital Letter En With Hook
        :-  'ӌ'  'Ӌ'        :: 0x4cb Cyrillic Capital Letter Khakassian Che
        :-  'ӑ'  'Ӑ'        :: 0x4d0 Cyrillic Capital Letter A With Breve
        :-  'ӓ'  'Ӓ'        :: 0x4d2 Cyrillic Capital Letter A With Diaeresis
        :-  'ӕ'  'Ӕ'        :: 0x4d4 Cyrillic Capital Ligature A Ie
        :-  'ӗ'  'Ӗ'        :: 0x4d6 Cyrillic Capital Letter Ie With Breve
        :-  'ә'  'Ә'        :: 0x4d8 Cyrillic Capital Letter Schwa
        :-  'ӛ'  'Ӛ'        :: 0x4da Cyrillic Capital Letter Schwa With Diaeresis
        :-  'ӝ'  'Ӝ'        :: 0x4dc Cyrillic Capital Letter Zhe With Diaeresis
        :-  'ӟ'  'Ӟ'        :: 0x4de Cyrillic Capital Letter Ze With Diaeresis
        :-  'ӡ'  'Ӡ'        :: 0x4e0 Cyrillic Capital Letter Abkhasian Dze
        :-  'ӣ'  'Ӣ'        :: 0x4e2 Cyrillic Capital Letter I With Macron
        :-  'ӥ'  'Ӥ'        :: 0x4e4 Cyrillic Capital Letter I With Diaeresis
        :-  'ӧ'  'Ӧ'        :: 0x4e6 Cyrillic Capital Letter O With Diaeresis
        :-  'ө'  'Ө'        :: 0x4e8 Cyrillic Capital Letter Barred O
        :-  'ӫ'  'Ӫ'        :: 0x4ea Cyrillic Capital Letter Barred O With Diaeresis
        :-  'ӯ'  'Ӯ'        :: 0x4ee Cyrillic Capital Letter U With Macron
        :-  'ӱ'  'Ӱ'        :: 0x4f0 Cyrillic Capital Letter U With Diaeresis
        :-  'ӳ'  'Ӳ'        :: 0x4f2 Cyrillic Capital Letter U With Double Acute
        :-  'ӵ'  'Ӵ'        :: 0x4f4 Cyrillic Capital Letter Che With Diaeresis
        :-  'ӹ'  'Ӹ'        :: 0x4f8 Cyrillic Capital Letter Yeru With Diaeresis
        :-  'ա'  'Ա'        :: 0x531 Armenian Capital Letter Ayb
        :-  'բ'  'Բ'        :: 0x532 Armenian Capital Letter Ben
        :-  'գ'  'Գ'        :: 0x533 Armenian Capital Letter Gim
        :-  'դ'  'Դ'        :: 0x534 Armenian Capital Letter Da
        :-  'ե'  'Ե'        :: 0x535 Armenian Capital Letter Ech
        :-  'զ'  'Զ'        :: 0x536 Armenian Capital Letter Za
        :-  'է'  'Է'        :: 0x537 Armenian Capital Letter Eh
        :-  'ը'  'Ը'        :: 0x538 Armenian Capital Letter Et
        :-  'թ'  'Թ'        :: 0x539 Armenian Capital Letter To
        :-  'ժ'  'Ժ'        :: 0x53a Armenian Capital Letter Zhe
        :-  'ի'  'Ի'        :: 0x53b Armenian Capital Letter Ini
        :-  'լ'  'Լ'        :: 0x53c Armenian Capital Letter Liwn
        :-  'խ'  'Խ'        :: 0x53d Armenian Capital Letter Xeh
        :-  'ծ'  'Ծ'        :: 0x53e Armenian Capital Letter Ca
        :-  'կ'  'Կ'        :: 0x53f Armenian Capital Letter Ken
        :-  'հ'  'Հ'        :: 0x540 Armenian Capital Letter Ho
        :-  'ձ'  'Ձ'        :: 0x541 Armenian Capital Letter Ja
        :-  'ղ'  'Ղ'        :: 0x542 Armenian Capital Letter Ghad
        :-  'ճ'  'Ճ'        :: 0x543 Armenian Capital Letter Cheh
        :-  'մ'  'Մ'        :: 0x544 Armenian Capital Letter Men
        :-  'յ'  'Յ'        :: 0x545 Armenian Capital Letter Yi
        :-  'ն'  'Ն'        :: 0x546 Armenian Capital Letter Now
        :-  'շ'  'Շ'        :: 0x547 Armenian Capital Letter Sha
        :-  'ո'  'Ո'        :: 0x548 Armenian Capital Letter Vo
        :-  'չ'  'Չ'        :: 0x549 Armenian Capital Letter Cha
        :-  'պ'  'Պ'        :: 0x54a Armenian Capital Letter Peh
        :-  'ջ'  'Ջ'        :: 0x54b Armenian Capital Letter Jheh
        :-  'ռ'  'Ռ'        :: 0x54c Armenian Capital Letter Ra
        :-  'ս'  'Ս'        :: 0x54d Armenian Capital Letter Seh
        :-  'վ'  'Վ'        :: 0x54e Armenian Capital Letter Vew
        :-  'տ'  'Տ'        :: 0x54f Armenian Capital Letter Tiwn
        :-  'ր'  'Ր'        :: 0x550 Armenian Capital Letter Reh
        :-  'ց'  'Ց'        :: 0x551 Armenian Capital Letter Co
        :-  'ւ'  'Ւ'        :: 0x552 Armenian Capital Letter Yiwn
        :-  'փ'  'Փ'        :: 0x553 Armenian Capital Letter Piwr
        :-  'ք'  'Ք'        :: 0x554 Armenian Capital Letter Keh
        :-  'օ'  'Օ'        :: 0x555 Armenian Capital Letter Oh
        :-  'ֆ'  'Ֆ'        :: 0x556 Armenian Capital Letter Feh
        :-  'ა'  'Ⴀ'        :: 0x10a0 Georgian Capital Letter An
        :-  'ბ'  'Ⴁ'        :: 0x10a1 Georgian Capital Letter Ban
        :-  'გ'  'Ⴂ'        :: 0x10a2 Georgian Capital Letter Gan
        :-  'დ'  'Ⴃ'        :: 0x10a3 Georgian Capital Letter Don
        :-  'ე'  'Ⴄ'        :: 0x10a4 Georgian Capital Letter En
        :-  'ვ'  'Ⴅ'        :: 0x10a5 Georgian Capital Letter Vin
        :-  'ზ'  'Ⴆ'        :: 0x10a6 Georgian Capital Letter Zen
        :-  'თ'  'Ⴇ'        :: 0x10a7 Georgian Capital Letter Tan
        :-  'ი'  'Ⴈ'        :: 0x10a8 Georgian Capital Letter In
        :-  'კ'  'Ⴉ'        :: 0x10a9 Georgian Capital Letter Kan
        :-  'ლ'  'Ⴊ'        :: 0x10aa Georgian Capital Letter Las
        :-  'მ'  'Ⴋ'        :: 0x10ab Georgian Capital Letter Man
        :-  'ნ'  'Ⴌ'        :: 0x10ac Georgian Capital Letter Nar
        :-  'ო'  'Ⴍ'        :: 0x10ad Georgian Capital Letter On
        :-  'პ'  'Ⴎ'        :: 0x10ae Georgian Capital Letter Par
        :-  'ჟ'  'Ⴏ'        :: 0x10af Georgian Capital Letter Zhar
        :-  'რ'  'Ⴐ'        :: 0x10b0 Georgian Capital Letter Rae
        :-  'ს'  'Ⴑ'        :: 0x10b1 Georgian Capital Letter San
        :-  'ტ'  'Ⴒ'        :: 0x10b2 Georgian Capital Letter Tar
        :-  'უ'  'Ⴓ'        :: 0x10b3 Georgian Capital Letter Un
        :-  'ფ'  'Ⴔ'        :: 0x10b4 Georgian Capital Letter Phar
        :-  'ქ'  'Ⴕ'        :: 0x10b5 Georgian Capital Letter Khar
        :-  'ღ'  'Ⴖ'        :: 0x10b6 Georgian Capital Letter Ghan
        :-  'ყ'  'Ⴗ'        :: 0x10b7 Georgian Capital Letter Qar
        :-  'შ'  'Ⴘ'        :: 0x10b8 Georgian Capital Letter Shin
        :-  'ჩ'  'Ⴙ'        :: 0x10b9 Georgian Capital Letter Chin
        :-  'ც'  'Ⴚ'        :: 0x10ba Georgian Capital Letter Can
        :-  'ძ'  'Ⴛ'        :: 0x10bb Georgian Capital Letter Jil
        :-  'წ'  'Ⴜ'        :: 0x10bc Georgian Capital Letter Cil
        :-  'ჭ'  'Ⴝ'        :: 0x10bd Georgian Capital Letter Char
        :-  'ხ'  'Ⴞ'        :: 0x10be Georgian Capital Letter Xan
        :-  'ჯ'  'Ⴟ'        :: 0x10bf Georgian Capital Letter Jhan
        :-  'ჰ'  'Ⴠ'        :: 0x10c0 Georgian Capital Letter Hae
        :-  'ჱ'  'Ⴡ'        :: 0x10c1 Georgian Capital Letter He
        :-  'ჲ'  'Ⴢ'        :: 0x10c2 Georgian Capital Letter Hie
        :-  'ჳ'  'Ⴣ'        :: 0x10c3 Georgian Capital Letter We
        :-  'ჴ'  'Ⴤ'        :: 0x10c4 Georgian Capital Letter Har
        :-  'ჵ'  'Ⴥ'        :: 0x10c5 Georgian Capital Letter Hoe
        :-  'ꭰ'  'Ꭰ'        :: 0x13a0 Cherokee Capital Letter 
        :-  'ꭱ'  'Ꭱ'        :: 0x13a1 Cherokee Capital Letter 
        :-  'ꭲ'  'Ꭲ'        :: 0x13a2 Cherokee Capital Letter 
        :-  'ꭳ'  'Ꭳ'        :: 0x13a3 Cherokee Capital Letter 
        :-  'ꭴ'  'Ꭴ'        :: 0x13a4 Cherokee Capital Letter 
        :-  'ꭵ'  'Ꭵ'        :: 0x13a5 Cherokee Capital Letter 
        :-  'ꭶ'  'Ꭶ'        :: 0x13a6 Cherokee Capital Letter 
        :-  'ꭷ'  'Ꭷ'        :: 0x13a7 Cherokee Capital Letter 
        :-  'ꭸ'  'Ꭸ'        :: 0x13a8 Cherokee Capital Letter 
        :-  'ꭹ'  'Ꭹ'        :: 0x13a9 Cherokee Capital Letter 
        :-  'ꭺ'  'Ꭺ'        :: 0x13aa Cherokee Capital Letter 
        :-  'ꭻ'  'Ꭻ'        :: 0x13ab Cherokee Capital Letter 
        :-  'ꭼ'  'Ꭼ'        :: 0x13ac Cherokee Capital Letter 
        :-  'ꭽ'  'Ꭽ'        :: 0x13ad Cherokee Capital Letter 
        :-  'ꭾ'  'Ꭾ'        :: 0x13ae Cherokee Capital Letter 
        :-  'ꭿ'  'Ꭿ'        :: 0x13af Cherokee Capital Letter 
        :-  'ꮀ'  'Ꮀ'        :: 0x13b0 Cherokee Capital Letter 
        :-  'ꮁ'  'Ꮁ'        :: 0x13b1 Cherokee Capital Letter 
        :-  'ꮂ'  'Ꮂ'        :: 0x13b2 Cherokee Capital Letter 
        :-  'ꮃ'  'Ꮃ'        :: 0x13b3 Cherokee Capital Letter 
        :-  'ꮄ'  'Ꮄ'        :: 0x13b4 Cherokee Capital Letter 
        :-  'ꮅ'  'Ꮅ'        :: 0x13b5 Cherokee Capital Letter 
        :-  'ꮆ'  'Ꮆ'        :: 0x13b6 Cherokee Capital Letter 
        :-  'ꮇ'  'Ꮇ'        :: 0x13b7 Cherokee Capital Letter 
        :-  'ꮈ'  'Ꮈ'        :: 0x13b8 Cherokee Capital Letter 
        :-  'ꮉ'  'Ꮉ'        :: 0x13b9 Cherokee Capital Letter 
        :-  'ꮊ'  'Ꮊ'        :: 0x13ba Cherokee Capital Letter 
        :-  'ꮋ'  'Ꮋ'        :: 0x13bb Cherokee Capital Letter 
        :-  'ꮌ'  'Ꮌ'        :: 0x13bc Cherokee Capital Letter 
        :-  'ꮍ'  'Ꮍ'        :: 0x13bd Cherokee Capital Letter 
        :-  'ꮎ'  'Ꮎ'        :: 0x13be Cherokee Capital Letter 
        :-  'ꮏ'  'Ꮏ'        :: 0x13bf Cherokee Capital Letter 
        :-  'ꮐ'  'Ꮐ'        :: 0x13c0 Cherokee Capital Letter 
        :-  'ꮑ'  'Ꮑ'        :: 0x13c1 Cherokee Capital Letter 
        :-  'ꮒ'  'Ꮒ'        :: 0x13c2 Cherokee Capital Letter 
        :-  'ꮓ'  'Ꮓ'        :: 0x13c3 Cherokee Capital Letter 
        :-  'ꮔ'  'Ꮔ'        :: 0x13c4 Cherokee Capital Letter 
        :-  'ꮕ'  'Ꮕ'        :: 0x13c5 Cherokee Capital Letter 
        :-  'ꮖ'  'Ꮖ'        :: 0x13c6 Cherokee Capital Letter 
        :-  'ꮗ'  'Ꮗ'        :: 0x13c7 Cherokee Capital Letter 
        :-  'ꮘ'  'Ꮘ'        :: 0x13c8 Cherokee Capital Letter 
        :-  'ꮙ'  'Ꮙ'        :: 0x13c9 Cherokee Capital Letter 
        :-  'ꮚ'  'Ꮚ'        :: 0x13ca Cherokee Capital Letter 
        :-  'ꮛ'  'Ꮛ'        :: 0x13cb Cherokee Capital Letter 
        :-  'ꮜ'  'Ꮜ'        :: 0x13cc Cherokee Capital Letter 
        :-  'ꮝ'  'Ꮝ'        :: 0x13cd Cherokee Capital Letter 
        :-  'ꮞ'  'Ꮞ'        :: 0x13ce Cherokee Capital Letter 
        :-  'ꮟ'  'Ꮟ'        :: 0x13cf Cherokee Capital Letter 
        :-  'ꮠ'  'Ꮠ'        :: 0x13d0 Cherokee Capital Letter 
        :-  'ꮡ'  'Ꮡ'        :: 0x13d1 Cherokee Capital Letter 
        :-  'ꮢ'  'Ꮢ'        :: 0x13d2 Cherokee Capital Letter 
        :-  'ꮣ'  'Ꮣ'        :: 0x13d3 Cherokee Capital Letter 
        :-  'ꮤ'  'Ꮤ'        :: 0x13d4 Cherokee Capital Letter 
        :-  'ꮥ'  'Ꮥ'        :: 0x13d5 Cherokee Capital Letter 
        :-  'ꮦ'  'Ꮦ'        :: 0x13d6 Cherokee Capital Letter 
        :-  'ꮧ'  'Ꮧ'        :: 0x13d7 Cherokee Capital Letter 
        :-  'ꮨ'  'Ꮨ'        :: 0x13d8 Cherokee Capital Letter 
        :-  'ꮩ'  'Ꮩ'        :: 0x13d9 Cherokee Capital Letter 
        :-  'ꮪ'  'Ꮪ'        :: 0x13da Cherokee Capital Letter 
        :-  'ꮫ'  'Ꮫ'        :: 0x13db Cherokee Capital Letter 
        :-  'ꮬ'  'Ꮬ'        :: 0x13dc Cherokee Capital Letter 
        :-  'ꮭ'  'Ꮭ'        :: 0x13dd Cherokee Capital Letter 
        :-  'ꮮ'  'Ꮮ'        :: 0x13de Cherokee Capital Letter 
        :-  'ꮯ'  'Ꮯ'        :: 0x13df Cherokee Capital Letter 
        :-  'ꮰ'  'Ꮰ'        :: 0x13e0 Cherokee Capital Letter 
        :-  'ꮱ'  'Ꮱ'        :: 0x13e1 Cherokee Capital Letter 
        :-  'ꮲ'  'Ꮲ'        :: 0x13e2 Cherokee Capital Letter 
        :-  'ꮳ'  'Ꮳ'        :: 0x13e3 Cherokee Capital Letter 
        :-  'ꮴ'  'Ꮴ'        :: 0x13e4 Cherokee Capital Letter 
        :-  'ꮵ'  'Ꮵ'        :: 0x13e5 Cherokee Capital Letter 
        :-  'ꮶ'  'Ꮶ'        :: 0x13e6 Cherokee Capital Letter 
        :-  'ꮷ'  'Ꮷ'        :: 0x13e7 Cherokee Capital Letter 
        :-  'ꮸ'  'Ꮸ'        :: 0x13e8 Cherokee Capital Letter 
        :-  'ꮹ'  'Ꮹ'        :: 0x13e9 Cherokee Capital Letter 
        :-  'ꮺ'  'Ꮺ'        :: 0x13ea Cherokee Capital Letter 
        :-  'ꮻ'  'Ꮻ'        :: 0x13eb Cherokee Capital Letter 
        :-  'ꮼ'  'Ꮼ'        :: 0x13ec Cherokee Capital Letter 
        :-  'ꮽ'  'Ꮽ'        :: 0x13ed Cherokee Capital Letter 
        :-  'ꮾ'  'Ꮾ'        :: 0x13ee Cherokee Capital Letter 
        :-  'ꮿ'  'Ꮿ'        :: 0x13ef Cherokee Capital Letter 
        :-  'ᏸ'  'Ᏸ'        :: 0x13f0 Cherokee Capital Letter 
        :-  'ᏹ'  'Ᏹ'        :: 0x13f1 Cherokee Capital Letter 
        :-  'ᏺ'  'Ᏺ'        :: 0x13f2 Cherokee Capital Letter 
        :-  'ᏻ'  'Ᏻ'        :: 0x13f3 Cherokee Capital Letter 
        :-  'ᏼ'  'Ᏼ'        :: 0x13f4 Cherokee Capital Letter 
        :-  'ᏽ'  'Ᏽ'        :: 0x13f5 Cherokee Capital Letter 
        :-  'ḁ'  'Ḁ'        :: 0x1e00 Latin Capital Letter A With Ring Below
        :-  'ḃ'  'Ḃ'        :: 0x1e02 Latin Capital Letter B With Dot Above
        :-  'ḅ'  'Ḅ'        :: 0x1e04 Latin Capital Letter B With Dot Below
        :-  'ḇ'  'Ḇ'        :: 0x1e06 Latin Capital Letter B With Line Below
        :-  'ḉ'  'Ḉ'        :: 0x1e08 Latin Capital Letter C With Cedilla And Acute
        :-  'ḋ'  'Ḋ'        :: 0x1e0a Latin Capital Letter D With Dot Above
        :-  'ḍ'  'Ḍ'        :: 0x1e0c Latin Capital Letter D With Dot Below
        :-  'ḏ'  'Ḏ'        :: 0x1e0e Latin Capital Letter D With Line Below
        :-  'ḑ'  'Ḑ'        :: 0x1e10 Latin Capital Letter D With Cedilla
        :-  'ḓ'  'Ḓ'        :: 0x1e12 Latin Capital Letter D With Circumflex Below
        :-  'ḕ'  'Ḕ'        :: 0x1e14 Latin Capital Letter E With Macron And Grave
        :-  'ḗ'  'Ḗ'        :: 0x1e16 Latin Capital Letter E With Macron And Acute
        :-  'ḙ'  'Ḙ'        :: 0x1e18 Latin Capital Letter E With Circumflex Below
        :-  'ḛ'  'Ḛ'        :: 0x1e1a Latin Capital Letter E With Tilde Below
        :-  'ḝ'  'Ḝ'        :: 0x1e1c Latin Capital Letter E With Cedilla And Breve
        :-  'ḟ'  'Ḟ'        :: 0x1e1e Latin Capital Letter F With Dot Above
        :-  'ḡ'  'Ḡ'        :: 0x1e20 Latin Capital Letter G With Macron
        :-  'ḣ'  'Ḣ'        :: 0x1e22 Latin Capital Letter H With Dot Above
        :-  'ḥ'  'Ḥ'        :: 0x1e24 Latin Capital Letter H With Dot Below
        :-  'ḧ'  'Ḧ'        :: 0x1e26 Latin Capital Letter H With Diaeresis
        :-  'ḩ'  'Ḩ'        :: 0x1e28 Latin Capital Letter H With Cedilla
        :-  'ḫ'  'Ḫ'        :: 0x1e2a Latin Capital Letter H With Breve Below
        :-  'ḭ'  'Ḭ'        :: 0x1e2c Latin Capital Letter I With Tilde Below
        :-  'ḯ'  'Ḯ'        :: 0x1e2e Latin Capital Letter I With Diaeresis And Acute
        :-  'ḱ'  'Ḱ'        :: 0x1e30 Latin Capital Letter K With Acute
        :-  'ḳ'  'Ḳ'        :: 0x1e32 Latin Capital Letter K With Dot Below
        :-  'ḵ'  'Ḵ'        :: 0x1e34 Latin Capital Letter K With Line Below
        :-  'ḷ'  'Ḷ'        :: 0x1e36 Latin Capital Letter L With Dot Below
        :-  'ḹ'  'Ḹ'        :: 0x1e38 Latin Capital Letter L With Dot Below And Macron
        :-  'ḻ'  'Ḻ'        :: 0x1e3a Latin Capital Letter L With Line Below
        :-  'ḽ'  'Ḽ'        :: 0x1e3c Latin Capital Letter L With Circumflex Below
        :-  'ḿ'  'Ḿ'        :: 0x1e3e Latin Capital Letter M With Acute
        :-  'ṁ'  'Ṁ'        :: 0x1e40 Latin Capital Letter M With Dot Above
        :-  'ṃ'  'Ṃ'        :: 0x1e42 Latin Capital Letter M With Dot Below
        :-  'ṅ'  'Ṅ'        :: 0x1e44 Latin Capital Letter N With Dot Above
        :-  'ṇ'  'Ṇ'        :: 0x1e46 Latin Capital Letter N With Dot Below
        :-  'ṉ'  'Ṉ'        :: 0x1e48 Latin Capital Letter N With Line Below
        :-  'ṋ'  'Ṋ'        :: 0x1e4a Latin Capital Letter N With Circumflex Below
        :-  'ṍ'  'Ṍ'        :: 0x1e4c Latin Capital Letter O With Tilde And Acute
        :-  'ṏ'  'Ṏ'        :: 0x1e4e Latin Capital Letter O With Tilde And Diaeresis
        :-  'ṑ'  'Ṑ'        :: 0x1e50 Latin Capital Letter O With Macron And Grave
        :-  'ṓ'  'Ṓ'        :: 0x1e52 Latin Capital Letter O With Macron And Acute
        :-  'ṕ'  'Ṕ'        :: 0x1e54 Latin Capital Letter P With Acute
        :-  'ṗ'  'Ṗ'        :: 0x1e56 Latin Capital Letter P With Dot Above
        :-  'ṙ'  'Ṙ'        :: 0x1e58 Latin Capital Letter R With Dot Above
        :-  'ṛ'  'Ṛ'        :: 0x1e5a Latin Capital Letter R With Dot Below
        :-  'ṝ'  'Ṝ'        :: 0x1e5c Latin Capital Letter R With Dot Below And Macron
        :-  'ṟ'  'Ṟ'        :: 0x1e5e Latin Capital Letter R With Line Below
        :-  'ṡ'  'Ṡ'        :: 0x1e60 Latin Capital Letter S With Dot Above
        :-  'ṣ'  'Ṣ'        :: 0x1e62 Latin Capital Letter S With Dot Below
        :-  'ṥ'  'Ṥ'        :: 0x1e64 Latin Capital Letter S With Acute And Dot Above
        :-  'ṧ'  'Ṧ'        :: 0x1e66 Latin Capital Letter S With Caron And Dot Above
        :-  'ṩ'  'Ṩ'        :: 0x1e68 Latin Capital Letter S With Dot Below And Dot Above
        :-  'ṫ'  'Ṫ'        :: 0x1e6a Latin Capital Letter T With Dot Above
        :-  'ṭ'  'Ṭ'        :: 0x1e6c Latin Capital Letter T With Dot Below
        :-  'ṯ'  'Ṯ'        :: 0x1e6e Latin Capital Letter T With Line Below
        :-  'ṱ'  'Ṱ'        :: 0x1e70 Latin Capital Letter T With Circumflex Below
        :-  'ṳ'  'Ṳ'        :: 0x1e72 Latin Capital Letter U With Diaeresis Below
        :-  'ṵ'  'Ṵ'        :: 0x1e74 Latin Capital Letter U With Tilde Below
        :-  'ṷ'  'Ṷ'        :: 0x1e76 Latin Capital Letter U With Circumflex Below
        :-  'ṹ'  'Ṹ'        :: 0x1e78 Latin Capital Letter U With Tilde And Acute
        :-  'ṻ'  'Ṻ'        :: 0x1e7a Latin Capital Letter U With Macron And Diaeresis
        :-  'ṽ'  'Ṽ'        :: 0x1e7c Latin Capital Letter V With Tilde
        :-  'ṿ'  'Ṿ'        :: 0x1e7e Latin Capital Letter V With Dot Below
        :-  'ẁ'  'Ẁ'        :: 0x1e80 Latin Capital Letter W With Grave
        :-  'ẃ'  'Ẃ'        :: 0x1e82 Latin Capital Letter W With Acute
        :-  'ẅ'  'Ẅ'        :: 0x1e84 Latin Capital Letter W With Diaeresis
        :-  'ẇ'  'Ẇ'        :: 0x1e86 Latin Capital Letter W With Dot Above
        :-  'ẉ'  'Ẉ'        :: 0x1e88 Latin Capital Letter W With Dot Below
        :-  'ẋ'  'Ẋ'        :: 0x1e8a Latin Capital Letter X With Dot Above
        :-  'ẍ'  'Ẍ'        :: 0x1e8c Latin Capital Letter X With Diaeresis
        :-  'ẏ'  'Ẏ'        :: 0x1e8e Latin Capital Letter Y With Dot Above
        :-  'ẑ'  'Ẑ'        :: 0x1e90 Latin Capital Letter Z With Circumflex
        :-  'ẓ'  'Ẓ'        :: 0x1e92 Latin Capital Letter Z With Dot Below
        :-  'ẕ'  'Ẕ'        :: 0x1e94 Latin Capital Letter Z With Line Below
        :-  'ạ'  'Ạ'        :: 0x1ea0 Latin Capital Letter A With Dot Below
        :-  'ả'  'Ả'        :: 0x1ea2 Latin Capital Letter A With Hook Above
        :-  'ấ'  'Ấ'        :: 0x1ea4 Latin Capital Letter A With Circumflex And Acute
        :-  'ầ'  'Ầ'        :: 0x1ea6 Latin Capital Letter A With Circumflex And Grave
        :-  'ẩ'  'Ẩ'        :: 0x1ea8 Latin Capital Letter A With Circumflex And Hook Above
        :-  'ẫ'  'Ẫ'        :: 0x1eaa Latin Capital Letter A With Circumflex And Tilde
        :-  'ậ'  'Ậ'        :: 0x1eac Latin Capital Letter A With Circumflex And Dot Below
        :-  'ắ'  'Ắ'        :: 0x1eae Latin Capital Letter A With Breve And Acute
        :-  'ằ'  'Ằ'        :: 0x1eb0 Latin Capital Letter A With Breve And Grave
        :-  'ẳ'  'Ẳ'        :: 0x1eb2 Latin Capital Letter A With Breve And Hook Above
        :-  'ẵ'  'Ẵ'        :: 0x1eb4 Latin Capital Letter A With Breve And Tilde
        :-  'ặ'  'Ặ'        :: 0x1eb6 Latin Capital Letter A With Breve And Dot Below
        :-  'ẹ'  'Ẹ'        :: 0x1eb8 Latin Capital Letter E With Dot Below
        :-  'ẻ'  'Ẻ'        :: 0x1eba Latin Capital Letter E With Hook Above
        :-  'ẽ'  'Ẽ'        :: 0x1ebc Latin Capital Letter E With Tilde
        :-  'ế'  'Ế'        :: 0x1ebe Latin Capital Letter E With Circumflex And Acute
        :-  'ề'  'Ề'        :: 0x1ec0 Latin Capital Letter E With Circumflex And Grave
        :-  'ể'  'Ể'        :: 0x1ec2 Latin Capital Letter E With Circumflex And Hook Above
        :-  'ễ'  'Ễ'        :: 0x1ec4 Latin Capital Letter E With Circumflex And Tilde
        :-  'ệ'  'Ệ'        :: 0x1ec6 Latin Capital Letter E With Circumflex And Dot Below
        :-  'ỉ'  'Ỉ'        :: 0x1ec8 Latin Capital Letter I With Hook Above
        :-  'ị'  'Ị'        :: 0x1eca Latin Capital Letter I With Dot Below
        :-  'ọ'  'Ọ'        :: 0x1ecc Latin Capital Letter O With Dot Below
        :-  'ỏ'  'Ỏ'        :: 0x1ece Latin Capital Letter O With Hook Above
        :-  'ố'  'Ố'        :: 0x1ed0 Latin Capital Letter O With Circumflex And Acute
        :-  'ồ'  'Ồ'        :: 0x1ed2 Latin Capital Letter O With Circumflex And Grave
        :-  'ổ'  'Ổ'        :: 0x1ed4 Latin Capital Letter O With Circumflex And Hook Above
        :-  'ỗ'  'Ỗ'        :: 0x1ed6 Latin Capital Letter O With Circumflex And Tilde
        :-  'ộ'  'Ộ'        :: 0x1ed8 Latin Capital Letter O With Circumflex And Dot Below
        :-  'ớ'  'Ớ'        :: 0x1eda Latin Capital Letter O With Horn And Acute
        :-  'ờ'  'Ờ'        :: 0x1edc Latin Capital Letter O With Horn And Grave
        :-  'ở'  'Ở'        :: 0x1ede Latin Capital Letter O With Horn And Hook Above
        :-  'ỡ'  'Ỡ'        :: 0x1ee0 Latin Capital Letter O With Horn And Tilde
        :-  'ợ'  'Ợ'        :: 0x1ee2 Latin Capital Letter O With Horn And Dot Below
        :-  'ụ'  'Ụ'        :: 0x1ee4 Latin Capital Letter U With Dot Below
        :-  'ủ'  'Ủ'        :: 0x1ee6 Latin Capital Letter U With Hook Above
        :-  'ứ'  'Ứ'        :: 0x1ee8 Latin Capital Letter U With Horn And Acute
        :-  'ừ'  'Ừ'        :: 0x1eea Latin Capital Letter U With Horn And Grave
        :-  'ử'  'Ử'        :: 0x1eec Latin Capital Letter U With Horn And Hook Above
        :-  'ữ'  'Ữ'        :: 0x1eee Latin Capital Letter U With Horn And Tilde
        :-  'ự'  'Ự'        :: 0x1ef0 Latin Capital Letter U With Horn And Dot Below
        :-  'ỳ'  'Ỳ'        :: 0x1ef2 Latin Capital Letter Y With Grave
        :-  'ỵ'  'Ỵ'        :: 0x1ef4 Latin Capital Letter Y With Dot Below
        :-  'ỷ'  'Ỷ'        :: 0x1ef6 Latin Capital Letter Y With Hook Above
        :-  'ỹ'  'Ỹ'        :: 0x1ef8 Latin Capital Letter Y With Tilde
        :-  'ἀ'  'Ἀ'        :: 0x1f08 Greek Capital Letter Alpha With Psili
        :-  'ἁ'  'Ἁ'        :: 0x1f09 Greek Capital Letter Alpha With Dasia
        :-  'ἂ'  'Ἂ'        :: 0x1f0a Greek Capital Letter Alpha With Psili And Varia
        :-  'ἃ'  'Ἃ'        :: 0x1f0b Greek Capital Letter Alpha With Dasia And Varia
        :-  'ἄ'  'Ἄ'        :: 0x1f0c Greek Capital Letter Alpha With Psili And Oxia
        :-  'ἅ'  'Ἅ'        :: 0x1f0d Greek Capital Letter Alpha With Dasia And Oxia
        :-  'ἆ'  'Ἆ'        :: 0x1f0e Greek Capital Letter Alpha With Psili And Perispomeni
        :-  'ἇ'  'Ἇ'        :: 0x1f0f Greek Capital Letter Alpha With Dasia And Perispomeni
        :-  'ἐ'  'Ἐ'        :: 0x1f18 Greek Capital Letter Epsilon With Psili
        :-  'ἑ'  'Ἑ'        :: 0x1f19 Greek Capital Letter Epsilon With Dasia
        :-  'ἒ'  'Ἒ'        :: 0x1f1a Greek Capital Letter Epsilon With Psili And Varia
        :-  'ἓ'  'Ἓ'        :: 0x1f1b Greek Capital Letter Epsilon With Dasia And Varia
        :-  'ἔ'  'Ἔ'        :: 0x1f1c Greek Capital Letter Epsilon With Psili And Oxia
        :-  'ἕ'  'Ἕ'        :: 0x1f1d Greek Capital Letter Epsilon With Dasia And Oxia
        :-  'ἠ'  'Ἠ'        :: 0x1f28 Greek Capital Letter Eta With Psili
        :-  'ῆ'  'Ἠ'        :: 0x1f20 Greek Capital Letter Eta with Psili
        :-  'ἡ'  'Ἡ'        :: 0x1f29 Greek Capital Letter Eta With Dasia
        :-  'ἢ'  'Ἢ'        :: 0x1f2a Greek Capital Letter Eta With Psili And Varia
        :-  'ἣ'  'Ἣ'        :: 0x1f2b Greek Capital Letter Eta With Dasia And Varia
        :-  'ἤ'  'Ἤ'        :: 0x1f2c Greek Capital Letter Eta With Psili And Oxia
        :-  'ἥ'  'Ἥ'        :: 0x1f2d Greek Capital Letter Eta With Dasia And Oxia
        :-  'ἦ'  'Ἦ'        :: 0x1f2e Greek Capital Letter Eta With Psili And Perispomeni
        :-  'ἧ'  'Ἧ'        :: 0x1f2f Greek Capital Letter Eta With Dasia And Perispomeni
        :-  'ἰ'  'Ἰ'        :: 0x1f38 Greek Capital Letter Iota With Psili
        :-  'ἱ'  'Ἱ'        :: 0x1f39 Greek Capital Letter Iota With Dasia
        :-  'ἲ'  'Ἲ'        :: 0x1f3a Greek Capital Letter Iota With Psili And Varia
        :-  'ἳ'  'Ἳ'        :: 0x1f3b Greek Capital Letter Iota With Dasia And Varia
        :-  'ἴ'  'Ἴ'        :: 0x1f3c Greek Capital Letter Iota With Psili And Oxia
        :-  'ἵ'  'Ἵ'        :: 0x1f3d Greek Capital Letter Iota With Dasia And Oxia
        :-  'ἶ'  'Ἶ'        :: 0x1f3e Greek Capital Letter Iota With Psili And Perispomeni
        :-  'ἷ'  'Ἷ'        :: 0x1f3f Greek Capital Letter Iota With Dasia And Perispomeni
        :-  'ὀ'  'Ὀ'        :: 0x1f48 Greek Capital Letter Omicron With Psili
        :-  'ὁ'  'Ὁ'        :: 0x1f49 Greek Capital Letter Omicron With Dasia
        :-  'ὂ'  'Ὂ'        :: 0x1f4a Greek Capital Letter Omicron With Psili And Varia
        :-  'ὃ'  'Ὃ'        :: 0x1f4b Greek Capital Letter Omicron With Dasia And Varia
        :-  'ὄ'  'Ὄ'        :: 0x1f4c Greek Capital Letter Omicron With Psili And Oxia
        :-  'ὅ'  'Ὅ'        :: 0x1f4d Greek Capital Letter Omicron With Dasia And Oxia
        :-  'ὑ'  'Ὑ'        :: 0x1f59 Greek Capital Letter Upsilon With Dasia
        :-  'ὓ'  'Ὓ'        :: 0x1f5b Greek Capital Letter Upsilon With Dasia And Varia
        :-  'ὕ'  'Ὕ'        :: 0x1f5d Greek Capital Letter Upsilon With Dasia And Oxia
        :-  'ὗ'  'Ὗ'        :: 0x1f5f Greek Capital Letter Upsilon With Dasia And Perispomeni
        :-  'ὠ'  'Ὠ'        :: 0x1f68 Greek Capital Letter Omega With Psili
        :-  'ὡ'  'Ὡ'        :: 0x1f69 Greek Capital Letter Omega With Dasia
        :-  'ὢ'  'Ὢ'        :: 0x1f6a Greek Capital Letter Omega With Psili And Varia
        :-  'ὣ'  'Ὣ'        :: 0x1f6b Greek Capital Letter Omega With Dasia And Varia
        :-  'ὤ'  'Ὤ'        :: 0x1f6c Greek Capital Letter Omega With Psili And Oxia
        :-  'ὥ'  'Ὥ'        :: 0x1f6d Greek Capital Letter Omega With Dasia And Oxia
        :-  'ὦ'  'Ὦ'        :: 0x1f6e Greek Capital Letter Omega With Psili And Perispomeni
        :-  'ὧ'  'Ὧ'        :: 0x1f6f Greek Capital Letter Omega With Dasia And Perispomeni
        :-  'ᾰ'  'Ᾰ'        :: 0x1fb8 Greek Capital Letter Alpha With Vrachy
        :-  'ᾱ'  'Ᾱ'        :: 0x1fb9 Greek Capital Letter Alpha With Macron
        :-  'ὰ'  'Ὰ'        :: 0x1fba Greek Capital Letter Alpha With Varia
        :-  'ῐ'  'Ῐ'        :: 0x1fd8 Greek Capital Letter Iota With Vrachy
        :-  'ῑ'  'Ῑ'        :: 0x1fd9 Greek Capital Letter Iota With Macron
        :-  'ῠ'  'Ῠ'        :: 0x1fe8 Greek Capital Letter Upsilon With Vrachy
        :-  'ῡ'  'Ῡ'        :: 0x1fe9 Greek Capital Letter Upsilon With Macron
        :-  'ａ'  'Ａ'        :: 0xff21 Fullwidth Latin Capital Letter A
        :-  'ｂ'  'Ｂ'        :: 0xff22 Fullwidth Latin Capital Letter B
        :-  'ｃ'  'Ｃ'        :: 0xff23 Fullwidth Latin Capital Letter C
        :-  'ｄ'  'Ｄ'        :: 0xff24 Fullwidth Latin Capital Letter D
        :-  'ｅ'  'Ｅ'        :: 0xff25 Fullwidth Latin Capital Letter E
        :-  'ｆ'  'Ｆ'        :: 0xff26 Fullwidth Latin Capital Letter F
        :-  'ｇ'  'Ｇ'        :: 0xff27 Fullwidth Latin Capital Letter G
        :-  'ｈ'  'Ｈ'        :: 0xff28 Fullwidth Latin Capital Letter H
        :-  'ｉ'  'Ｉ'        :: 0xff29 Fullwidth Latin Capital Letter I
        :-  'ｊ'  'Ｊ'        :: 0xff2a Fullwidth Latin Capital Letter J
        :-  'ｋ'  'Ｋ'        :: 0xff2b Fullwidth Latin Capital Letter K
        :-  'ｌ'  'Ｌ'        :: 0xff2c Fullwidth Latin Capital Letter L
        :-  'ｍ'  'Ｍ'        :: 0xff2d Fullwidth Latin Capital Letter M
        :-  'ｎ'  'Ｎ'        :: 0xff2e Fullwidth Latin Capital Letter N
        :-  'ｏ'  'Ｏ'        :: 0xff2f Fullwidth Latin Capital Letter O
        :-  'ｐ'  'Ｐ'        :: 0xff30 Fullwidth Latin Capital Letter P
        :-  'ｑ'  'Ｑ'        :: 0xff31 Fullwidth Latin Capital Letter Q
        :-  'ｒ'  'Ｒ'        :: 0xff32 Fullwidth Latin Capital Letter R
        :-  'ｓ'  'Ｓ'        :: 0xff33 Fullwidth Latin Capital Letter S
        :-  'ｔ'  'Ｔ'        :: 0xff34 Fullwidth Latin Capital Letter T
        :-  'ｕ'  'Ｕ'        :: 0xff35 Fullwidth Latin Capital Letter U
        :-  'ｖ'  'Ｖ'        :: 0xff36 Fullwidth Latin Capital Letter V
        :-  'ｗ'  'Ｗ'        :: 0xff37 Fullwidth Latin Capital Letter W
        :-  'ｘ'  'Ｘ'        :: 0xff38 Fullwidth Latin Capital Letter X
        :-  'ｙ'  'Ｙ'        :: 0xff39 Fullwidth Latin Capital Letter Y
        :-  'ｚ'  'Ｚ'        :: 0xff3a Fullwidth Latin Capital Letter Z
        :-  '𐐨'  '𐐀'        :: 0x10400 Deseret Capital Letter Long I
        :-  '𐐩'  '𐐁'        :: 0x10401 Deseret Capital Letter Long E
        :-  '𐐪'  '𐐂'        :: 0x10402 Deseret Capital Letter Long A
        :-  '𐐫'  '𐐃'        :: 0x10403 Deseret Capital Letter Long Ah
        :-  '𐐬'  '𐐄'        :: 0x10404 Deseret Capital Letter Long O
        :-  '𐐭'  '𐐅'        :: 0x10405 Deseret Capital Letter Long Oo
        :-  '𐐮'  '𐐆'        :: 0x10406 Deseret Capital Letter Short I
        :-  '𐐯'  '𐐇'        :: 0x10407 Deseret Capital Letter Short E
        :-  '𐐰'  '𐐈'        :: 0x10408 Deseret Capital Letter Short A
        :-  '𐐱'  '𐐉'        :: 0x10409 Deseret Capital Letter Short Ah
        :-  '𐐲'  '𐐊'        :: 0x1040a Deseret Capital Letter Short O
        :-  '𐐳'  '𐐋'        :: 0x1040b Deseret Capital Letter Short Oo
        :-  '𐐴'  '𐐌'        :: 0x1040c Deseret Capital Letter Ay
        :-  '𐐵'  '𐐍'        :: 0x1040d Deseret Capital Letter Ow
        :-  '𐐶'  '𐐎'        :: 0x1040e Deseret Capital Letter Wu
        :-  '𐐷'  '𐐏'        :: 0x1040f Deseret Capital Letter Yee
        :-  '𐐸'  '𐐐'        :: 0x10410 Deseret Capital Letter H
        :-  '𐐹'  '𐐑'        :: 0x10411 Deseret Capital Letter Pee
        :-  '𐐺'  '𐐒'        :: 0x10412 Deseret Capital Letter Bee
        :-  '𐐻'  '𐐓'        :: 0x10413 Deseret Capital Letter Tee
        :-  '𐐼'  '𐐔'        :: 0x10414 Deseret Capital Letter Dee
        :-  '𐐽'  '𐐕'        :: 0x10415 Deseret Capital Letter Chee
        :-  '𐐾'  '𐐖'        :: 0x10416 Deseret Capital Letter Jee
        :-  '𐐿'  '𐐗'        :: 0x10417 Deseret Capital Letter Kay
        :-  '𐑀'  '𐐘'        :: 0x10418 Deseret Capital Letter Gay
        :-  '𐑁'  '𐐙'        :: 0x10419 Deseret Capital Letter Ef
        :-  '𐑂'  '𐐚'        :: 0x1041a Deseret Capital Letter Vee
        :-  '𐑃'  '𐐛'        :: 0x1041b Deseret Capital Letter Eth
        :-  '𐑄'  '𐐜'        :: 0x1041c Deseret Capital Letter Thee
        :-  '𐑅'  '𐐝'        :: 0x1041d Deseret Capital Letter Es
        :-  '𐑆'  '𐐞'        :: 0x1041e Deseret Capital Letter Zee
        :-  '𐑇'  '𐐟'        :: 0x1041f Deseret Capital Letter Esh
        :-  '𐑈'  '𐐠'        :: 0x10420 Deseret Capital Letter Zhee
        :-  '𐑉'  '𐐡'        :: 0x10421 Deseret Capital Letter Er
        :-  '𐑊'  '𐐢'        :: 0x10422 Deseret Capital Letter El
        :-  '𐑋'  '𐐣'        :: 0x10423 Deseret Capital Letter Em
        :-  '𐑌'  '𐐤'        :: 0x10424 Deseret Capital Letter En
        :-  '𐑍'  '𐐥'        :: 0x10425 Deseret Capital Letter Eng
        :-  '𐑎'  '𐐦'        :: 0x10426 Deseret Capital Letter Oi
        :-  '𐑏'  '𐐧'        :: 0x10427 Deseret Capital Letter Ew
  ==
  --
--
