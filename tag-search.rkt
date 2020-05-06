#lang racket

(require (for-syntax syntax/parse) racket/function)

(struct entry (title tags)
  #:transparent)

(define (build-the-list str)
  (define (split-remove-empty pat str)
    (filter
     (λ(s) (not (equal? "" s)))
     (regexp-split pat str)))
  [define split
    (map (curry split-remove-empty #rx"\n+")
         (split-remove-empty #rx"~+" str))]
  (map (match-lambda
         [(cons title tags) (entry title tags)])
       split))

(define (f-and a b) (and a b))
(define (f-or a b) (or a b))

(define (compose-preds op p1 p2)
  (λ(val) (op (p1 val) (p2 val))))

(define (AND . tags)
  (match tags
    ['() (λ(st) #t)]
    [(cons t ts)
     (if (procedure? t)
         (compose-preds f-and t (apply AND ts))
         (compose-preds
          f-and (curryr set-member? t) (apply AND ts)))]))

(define (OR . tags)
  (match tags
    ['() (λ(st) #f)]
    [(cons t ts)
     (if (procedure? t)
         (compose-preds f-or t (apply OR ts))
         (compose-preds
          f-or (curryr set-member? t) (apply OR ts)))]))

(define (NOT tag)
  (if (procedure? tag)
      (compose not tag)
      (compose not (curryr set-member? tag))))



(define st (set "1" "2" "3"))