#lang racket


(require "read-list.rkt" "tag-compare.rkt")

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

(define (tag-search ls filt)
  (display
   (format-the-list
    (filter (compose (tag?->pred filt) entry-tags) ls))))



(define the-list
  (build-the-list))

(define-namespace-anchor a)
(define ns (namespace-anchor->namespace a))

(define (main)
  (eval (append '(tag-search the-list)
                (list (syntax->datum (read-syntax))))
        ns)
  (main))

(main)