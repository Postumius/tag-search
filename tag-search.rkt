#lang racket

(require "read-list.rkt")

(define (f-and a b) (and a b))
(define (f-or a b) (or a b))

(define (tag?->pred tag/pred)
  (if (procedure? tag/pred)
      tag/pred
      (curryr set-member? tag/pred)))

(define (make-tag-operator op acc)
  [define (compose-preds op p1 p2)
    (λ(val) (op (p1 val) (p2 val)))]
  (λ tags
    (foldl (λ(t/p t) (compose-preds op (tag?->pred t/p) t))
           acc
           tags)))

(define AND (make-tag-operator f-and (λ(st) #t)))

(define OR (make-tag-operator f-or (λ(st) #f)))

(define (NOT t/p)
  (compose not (tag?->pred t/p)))

(define (tag-search ls tag/pred)
  (filter (compose (tag?->pred tag/pred) entry-tags) ls))


(define st (set "1" "2" "3"))

(define the-list
  (build-the-list))