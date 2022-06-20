### Tapes versus cords

I'm not sure whether the library should take a tape or a cord.  Here are
my tentative thoughts on this:

In the future, the jet is the main thing developers will interface with,
and the Hoon implementation is just there by necessity; therefore, the
Hoon library should have whatever interface is best for the jet.  If a
cord is simpler for a VM to represent than a tape[^1], then the Hoon
library should have a cord interface.  If in Hoon I happen to want to
convert the cord to a tape for convenience, and use a naive backtracking
algorithm, that's fine *iff* there will be a jet, since the actual role
of the Hoon code will be to serve as a model for the jet.

[^1]: I'm not sure this is true of all potential VMs, or even Vere.

It would be possible to have the library use `(list @)` on the inside,
and offer a special case that takes a cord and converts it to a tape; it
is the special case that would be jetted rather than the general.  I
think this would be more versatile, working on paths (for example) to
potentially simplify switching and routing tasks.


### Hoon interface

The grant mentions "single matching and multiple matching".  I could
take that to mean an all-at-once interface:

  ```
  getOneMatch   :: Cord {-pattern-} -> Cord {-subject-} -> Maybe Cord
  getAllMatches :: Cord {-pattern-} -> Cord {-subject-} -> [Cord]
  ```

Or I could take it to mean stateful iteration:

  ```
  initialState  :: Cord {-pattern-} -> Cord {-subject-} -> MatchState
  nextMatch     :: MatchState -> Maybe (Cord, MatchState)
  ```

I'm partial to the second form, since it allows more sophisticated logic
on when to stop matching---this will be especially important for public
facing services that would like to avoid DoS'ing themselves.  But that
brings me to my next question...


### Vere interface

The producer interface, `initialState` with `nextMatch`, would cross the
jet boundary for every invocation of `nextMatch`.  Theoretically, that
should mean the jet has to parse the regular expression anew for every
subsequent match, right?

  ```
          nextMatch   nextMatch   nextMatch   nextMatch
    Nock  ... o--> - - -->o--> - - -->o--> - - -->o ...
               \         / \         / \         /
  ~~~~~~~~~~~~~~\~~~~~~~/~~~\~~~~~~~o~~~\~~~~~~~/~~~~~~~~
                 \     /     \     /     \     /
    Vere          o-->o       o-->o       o-->o
                parse emit  parse emit  parse emit
  ```

Some time ago I read something about "cold", "warm", and "hot" jet
state...  well, I didn't really understand it, but I figured that
whatever those are, they wouldn't make sense unless some sort of state
could be retained between jet invocations.  This is what I'm imagining:

  ```
          nextMatch                nextMatch      nextMatch
    Nock      o---> - - - - - - - - -->o---> - - - -->o ...
               \                      / \            /
  ~~~~~~~~~~~~~~\~~~~~~~~~~~~~~~~~~~~/~~~\~~~~~~~~~~/~~~~~~~~
                 \           match  /     \ match  /
    Vere          o---> - - -->o-->o       o----->o
                   \          /   emit     |     emit
  ~~~~~~~~~~~~~~~~~~\~~~~~~~~/~~~~~~~~~~~~~|~~~~~~~~~~~~~~~~~
                     \  X   /              |
    Cached state      o--->o--> - - - - -->o
                   parse  emit            emit
  ```

Granted, I do not actually know how jets work.

Maybe it's not the worst thing in the world anyway to reparse a regular
expression with every subsequent match.  But I would like to see a path
to eliminate redundant computations.  And I think this does impact the
design of the library's interface.

If those diagrams don't make sense, then what about an interface that
has two separate jets for compiling and executing regular expressions?

  ```
           initialState  nextMatch  nextMatch  nextMatch
    Nock        ... o--> - -->o--> - -->o--> - -->o ...
                     \       / \       / \       /
  ~~~~~~~~~~~~~~~~~~~~\~~~~~/~~~\~~~~~/~~~\~~~~~/~~~~~~~~~
                       \   /     \   /     \   /
    Vere                \ /       \ /       \ /
                         o         o         o
                      compile    match     match
                       jet 1     jet 2     jet 2
  ```

This actually seems like the best way since it's so unmagical.  The
compiler makes something friendly to the matcher jet, the matcher jet
doesn't need any extra logic to get to work, and there's only one Vere
crossing with each call to `nextMatch`.  **However**, in order for the
compiler jet to be valid, the Hoon implemetation has to have an opinion
about what's convenient for the jet, and that seems perverted to me. So
I'm really not sure.


### Unicode

Obviously Unicode does not belong in the regular expressions library
itself; there should be another layer that handles normalization and
localization.  But, it is good to check that the regex cord interface
can properly match UTF strings this way before deciding that it has to
fit in that pigeonhole.  Can you recommend any particular resources on
this topic, especially pattern matching in normalized UTF?  Otherwise I
am off to Google.


### Other features I'm thinking of implementing

`\A` and `\Z` (match the very beginning/end of the subject, as
distinguished from `^` and `$` which also match before or any newline)
were useful when I used to write perl.

`\<` and `\>` (beginning- and end-of-word boundary) seem worthwhile;
I've never used them personally but they seem more legible than `\b`,
and they are also semantically distinct.

What about non-greedy repetition operators like `a*?`?  The grant
doesn't mention them but some people may find them useful.

Lua has a feature where an instance of `()` in a pattern captures the
index in the subject where `()` was matched.  I always found that very
convenient.

Capture groups are cool, but it'd be even cooler to have some kind of
inline destructuring.  Imagine if instead of manually assigning faces
to capture groups after the matter, you could just write a regex like:

  ```
  ...

  ++  phone-number-regex
    %-  crip  %+  weld
    "(\(({area}\d{3})\)|({area}\d{3}))[-. ]"
    "({digits}\d{3}[-. ]\d{4}))"

  ...

    (first:re phone-number-regex subject)
  ```

producing `[0 14 '(123) 456-7890' area='123' suffix='456-7890']`.
