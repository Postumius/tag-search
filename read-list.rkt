#lang racket

(provide (struct-out entry) build-the-list)

(define (trim str)
  (first (regexp-match #px"\\S.*\\S|\\S|$" str)))

(struct entry (title tags)
  #:transparent)

(define (build-the-list str)
  [define (clean-split pat str)
    (filter
     (λ(s) (not (equal? "" s)))
     (map trim (regexp-split pat str)))]
  [define split
    (map (curry clean-split #rx"\n+")
         (clean-split #rx"~+" str))]
  (map (match-lambda
         [(cons title tags) (entry title (list->set tags))])
       split))