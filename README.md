# tag-search
A search function that filters a tagged list. Boolean logic can be used to combine filters. Still in development

## Usage Examples

```racket
(tag-search the-list "2D") ;Match all entries in the-list with the tag "2D"

(tag-search the-list (AND "2D" "Platformer") ;Match entries that have "2D" and "Platformer"

(tag-search the-list (AND (NOT "Turn-based") (OR "JRPG" "CRPG")) 
;Match entries that don't have "Turn-based", but do have "JRPG", "CRPG", or both

(tag-search the-list (lambda(st) ([set-count st] . <= . 5))) 
;Advanced usage. Match entries with 5 or fewer tags.
```

## Definitions
The function *tag-search* takes this form:
```racket
(tag-search lst Filter)
```
Where *Filter* is either a *tag* or a *set-predicate*. 

A *tag* is a string. This kind of filter matches when an entry's set of tags includes the string.

A *set-predicate* is a Racket function that takes a set and returns truth or falsity. This kind of filter matches when the 
function returns a true value given an entry's set of tags.

The following functions take filters and return set-predicates that can then be passed to *tag-search*. They can be nested to
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
