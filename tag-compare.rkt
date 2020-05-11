#lang racket

(provide tag-compare tag-set? make-immutable-tag-set)

(define ((tag-compare op) tag1 tag2)
  (op (string-upcase tag1) (string-upcase tag2)))

(define-custom-set-types
  tag-set
  #:elem? string?
  (tag-compare string=?))