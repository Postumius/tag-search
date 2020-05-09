#lang racket

(provide (struct-out entry) build-the-list)

(define path-to-list "the-list.txt")

(define (read-string filename)
  [define in (open-input-file filename)]
  [define (file->string)
    [define line (read-line in)]
    (if (eof-object? line)
        ""
        (string-append line "\n" (file->string)))]
  [define str (file->string)]
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
         [(cons title tags) (entry title (list->set tags))])
       split))

(define (format-tags tags)
  (define (inner i ls)
    (match ls
      ['() "\n\n"]
      [(cons t '()) (string-append t "\n\n")]
      [(cons t ts)
       (string-append
        t (if (zero? (modulo (- i 2) 3)) ",\n      " ", ")
        (inner (add1 i) ts))]))
  (inner 0 (sort (set->list tags) string<?)))

(define (line-split len strls)
  (match strls
    ['() '()]
    [(cons s ss)
     (if ((length s) . <= . len)
         (cons s (line-split (- len (length s)) ss))
         strls)]))

(define (format-the-list ls)
  (foldl
   (λ(ent str)
     (string-append
      "title: " (entry-title ent)
      "\ntags: " (format-tags (entry-tags ent))
      str))
   ""
   (sort ls (λ(e1 e2)
              (string>? (entry-title e1) (entry-title e2))))))

