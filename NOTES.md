### Tapes versus cords

I'm not sure whether the library should take a tape or a cord.
Here are my tentative thoughts on this:

In the future, the jet is the main thing developers will interface with,
and the Hoon implementation is just there by necessity; therefore, the
Hoon library should have whatever interface is best for the jet.  If a
cord is simpler for a VM to represent than a tape[^1], then the Hoon
library should have a cord interface.  If in Hoon I happen to want to
convert the cord to a tape for convenience, that's fine *iff* there will
be a jet, since the actual role of the Hoon code will be to serve as a
model for the jet.

[^1]: I'm not sure this is true of all potential VMs, or even Vere.

It would be possible to make the library use `(list @)` on the inside,
and offer a special case that takes a cord and converts it to tape; it
is the special case that would be jetted rather than the general.  I
think this would be more versatile, potentially simplifing routing
tasks for example.


### Hoon interface

For the sake of getting moving, I'm just using cords for now in the
interface.

The bounty mentions "single matching and multiple matching".  I could
take that to mean an all-at-once interface:

  ```
  getOneMatch   :: Cord {-pattern-} -> Cord {-subject-} -> Maybe Cord
  getAllMatches :: Cord {-pattern-} -> Cord {-subject-} -> [Cord]
  ```

Or I could take it to mean stateful iteration:

  ```
  initialState  :: Cord {-pattern-} -> Cord {-subject-} -> MatchState
  nextMatch     :: MatchState -> Maybe (MatchState, Cord)
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
    Nock      o--> - - -->o--> - - -->o--> - - -->o ...
               \         / \         / \         /
  ~~~~~~~~~~~~~~\~~~~~~~/~~~\~~~~~~~o~~~\~~~~~~~/~~~~~~~~~
                 \     /     \     /     \     /
    Vere          o-->o       o-->o       o-->o
                parse emit  parse emit  parse emit
  ```

Some time ago  I read something about "cold", "warm", and "hot" jet
state...  well, I didn't really understand it, but I figured that
whatever those are, they wouldn't make sense if some sort of state could
be retained between jet invocations.  This is what I'm imagining:

  ```
          nextMatch            nextMatch       nextMatch
    Nock      o---> - - - - - - - - -->o---> - - - -->o ...
               \                      / \            /
  ~~~~~~~~~~~~~~\~~~~~~~~~~~~~~~~~~~~/~~~\~~~~~~~~~~/~~~~~~~~~
                 \           match  /     \ match  /
    Vere          o---> - - -->o-->o       o----->o
                   \          /   emit     |     emit
  ~~~~~~~~~~~~~~~~~~\~~~~~~~~/~~~~~~~~~~~~~|~~~~~~~~~~~~~~~
                     \  X   /              |
    Cached state      o--->o--> - - - - -->o
                   parse  emit            emit
  ```

Granted, I do not actually know how jets work.

Maybe it's not the worst thing in the world anyway to reparse a regular
expression with every subsequent match.  But I would like to see a path
to eliminate redundant computations (labeled `X` in the second diagram).
And I think this does impact the design of the library's interface.

If those diagrams don't make sense, then what about an interface that
has two separate jets for compiling and executing regular expressions?

  ```
          initialState  nextMatch nextMatch
    Nock            o-> - ->o-> - ->o ...
                     \     / \     /
  ~~~~~~~~~~~~~~~~~~~~\~~~/~~~\~~~/~~~~~~~~~~
                       \ /     \ /
    Vere                o       o
                     compile  match

                      jet 1   jet 2
  ```

### Unicode

Obviously Unicode does not belong in the regular expressions library
itself; there should be another layer that handles normalization and
localization.  But, it is good to check that the regex cord interface
can properly match UTF strings this way before deciding that it has to
fit in that pigeonhole.  Can you recommend any particular resources on
this topic, especially pattern matching in normalized UTF?  Otherwise I
am off to Google.
