#lang racket

(provide (struct-out entry) build-the-list)

(define path-to-list "the-list.txt")

(define (read-string filename)
  [define file (open-input-file filename)]
  [define (file->string)
    [define line (read-line file)]
    (if (eof-object? line)
        ""
        (string-append line "\n" (file->string)))]
  [define str (file->string)]
  (close-input-port file)
  str)

(define (trim str)
  (first (regexp-match #px"\\S.*\\S|\\S|$" str)))

(struct entry (title tags)
  #:transparent)

(define (build-the-list)
  [define str path-to-list]
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

(define (format-tags i tags)
  (match tags
    ['() "\n"]
    [(cons t '()) (string-append t "\n")]
    [(cons t ts)
     (string-append
      t (if (zero? (modulo (- i 2) 3)) ",\n" ", ")
      (format-tags (add1 i) ts))]))

