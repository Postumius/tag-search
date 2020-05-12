#lang racket

(require "tag-compare.rkt" "read-list.rkt")

(define the-list (build-the-list))

(define (all-tags ls)
  ((compose
    (curryr sort (tag-compare string<?))
    set->list
    (curry foldr (λ(ent st)
                   (set-union st (entry-tags ent)))
           (make-immutable-tag-set)))
   ls))

(all-tags the-list)