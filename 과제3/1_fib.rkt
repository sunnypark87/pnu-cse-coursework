#lang racket

(require racket/stream)

(define (add-streams s1 s2)
  (cond [(stream-empty? s1) s2]
        [(stream-empty? s2) s1]
        [else
         (stream-cons (+ (stream-first s1) (stream-first s2))
                      (add-streams (stream-rest s1) (stream-rest s2)))]))

(define fibs
  (stream-cons 0
               (stream-cons 1
                            (add-streams fibs (stream-rest fibs)))))

(displayln "=== fibonacci stream (first 15 elements) ===")
;;(displayln '(0 1 1 2 3 5 8 13 21 34 55 89 144 233 377)
(displayln (stream->list (stream-take fibs 15)))