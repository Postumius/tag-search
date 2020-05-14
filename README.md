# tag-search
A search function that filters a tagged list. Boolean logic can be used to combine filters. Not currently in development,
although Moodie or I might add some functionality or fixes in the future.

## Usage Examples

Launch *tag-search.exe* and enter a *Filter* in the console window. 

```racket
"2D" ;Match all entries with the tag "2D"

(AND "2D" "Platformer") ;Match entries that have "2D" and "Platformer"

(AND (NOT "Turn-based") (OR "JRPG" "CRPG"))
;Match entries that don't have "Turn-based", but do have "JRPG", "CRPG", or both

(lambda(st) ([set-count st] . <= . 5))
;Advanced usage. Match entries with 5 or fewer tags.
```

There's no exception handling, so the window will just crash if there's an error. If you experience frequent crashing 
consider opening tag-search.rkt and running the tag-search function directly (although you'll have to install Racket to do
so).

## Definitions
A *Filter* is either a *tag* or a *set-predicate*. 

A *tag* is a string. This kind of filter matches when an entry's set of tags includes the string.

A *set-predicate* is a Racket function that takes a set and returns truth or falsity. This kind of filter matches when the 
function returns a true value given an entry's set of tags.

The following functions take filters as arguments and return set-predicates that can themselves be used as filters. They can be nested to
an arbitrary depth.

```racket
(AND Filter ...) ;Takes an arbitrary number of Filters and matches if they all match. 
                 ;Always matches if no Filters are given.
                 
(OR Filter ...) ;Takes an arbitrary number of Filters and matches if at least one of them matches.
                ;Never matches if no Filters are given.

(NOT Filter) ; Takes one Filter and matches if and only if that Filter doesn't match.
```

Any Racket procedure that takes a set and returns truth or falsity is a valid filter. See the Racket Guide for defining your
own procedures: https://docs.racket-lang.org/guide/lambda.html
