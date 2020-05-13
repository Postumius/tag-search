#lang racket

(require "tag-compare.rkt")

(provide (struct-out entry) build-the-list format-the-list)

(define path-to-list "the-list.txt")

(define (read-string filename)
  [define in (open-input-file filename)]
  [define str (port->string in)]
  (close-input-port in)
  str)

(define (write-string str filename)
  [define out (open-output-file filename #:exists 'truncate)]
  (display str out)
  (close-output-port out))

(define (trim str)
  (first (regexp-match #px"\\S.*\\S|\\S|$" str)))

(struct entry (title tags)
  #:transparent)

(define (build-the-list)
  [define str (read-string path-to-list)]
  [define (clean-split pat str)
    (filter
     (λ(s) (not (equal? "" s)))
     (map trim (regexp-split pat str)))]
  [define split
    (map (curry clean-split #rx"\n+")
         (clean-split #rx"~+" str))]
  (map (match-lambda
         [(cons title tags)
          (entry title (make-immutable-tag-set tags))])
       split))


(define (format-tag-set line-len str-set)
  [define (rec len lst)
    (match lst
      ['() "\n\n"]
      [(cons l ls)
       [define len-next (string-length l)]
       (cond
         [(len-next . > . line-len)
          (string-append "\n      " l "\n      "
                         (rec line-len ls))]
         [(len-next . > . len)
          (string-append "\n      " (rec line-len lst))]
         [else
          (string-append l " " (rec (- len len-next 1) ls))])])]
  (rec line-len
    (sort (set->list str-set) (tag-compare string<?))))

(define (format-the-list ls)
  (foldl
   (λ(ent str)
     (string-append
      "title: " (entry-title ent)
      "\ntags: " (format-tag-set 30 (entry-tags ent))
      str))
   ""
   (sort ls (λ(e1 e2)
              ((tag-compare string>?)
               (entry-title e1)
               (entry-title e2))))))

(define (format-title-list)
  [define titles-sorted
    (sort (map entry-title (build-the-list))
          (tag-compare string<?))]
  (for/fold ([str ""]) ([title titles-sorted])
    (string-append str "\n" title)))

