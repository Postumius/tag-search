#lang racket

; functions for reading and formatting the list

(require "tag-compare.rkt")

(provide
 
 ; an entry has a title and a set of tags
 (struct-out entry)

 ; reads from text file into list of entries
 build-the-list

 ; formats list into nice string
 format-the-list)



(define (read-string filename)
  [define in (open-input-file filename)]
  [define str (port->string in)]
  (close-input-port in)
  str)

(define (write-string str filename)
  [define out (open-output-file filename #:exists 'truncate)]
  (display str out)
  (close-output-port out))

(define (clean-split pat str)
  (filter
   (λ(s) (not (equal? "" s)))
   (map trim-whitespace (regexp-split pat str))))

(define (trim-whitespace str)
  (first (regexp-match #px"\\S.*\\S|\\S|$" str)))

; rewrites the given file with lines in order
(define (sort-file-lines filename)
  [define str (read-string filename)]
  [define ordered-ls (sort (clean-split "\n" str)
                           (tag-compare string<?))]
  [define formatted
    (for/fold ([acc ""]) ([title (in-list ordered-ls)])
      (string-append acc title "\n"))]
  (write-string formatted filename))

(struct entry (title tags)
  #:transparent)

(define path-to-list "the-list.txt")

(define (build-the-list)
  [define str (read-string path-to-list)]
  
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


(define/contract (format-the-list ls)
  ((listof entry?) . -> . string?)
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

(define (rewrite-formatted-list)
  (write-string (format-the-list (build-the-list))
                "formatted.txt"))