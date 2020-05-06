#lang racket

(require (for-syntax syntax/parse))

(struct entry (title tags)
  #:transparent)

(define-syntax (build-the-list stx)
  (syntax-parse stx
    [(build-the-list
      (title tag ...)
      ...)
     #'(list
        (entry
         (symbol->string
          (syntax->datum #'title))
         (list (symbol->string
                (syntax->datum #'tag)) ...))
        ...)]))

(define the-list
    (build-the-list
     (game1 tag1 tag2)
     (game2 tag2 tag-with-long-name)))