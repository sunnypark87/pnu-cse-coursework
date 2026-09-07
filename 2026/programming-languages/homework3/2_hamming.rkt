#lang racket

(require racket/stream)

(define (scale-stream s factor)
  (if (stream-empty? s)
      empty-stream
      (stream-cons (* (stream-first s) factor)
                   (scale-stream (stream-rest s) factor))))

(define (merge s1 s2)
  (cond [(stream-empty? s1) s2]
        [(stream-empty? s2) s1]
        [else
         (let ([car-s1 (stream-first s1)]
               [car-s2 (stream-first s2)])
           (cond [(< car-s1 car-s2)
                  (stream-cons car-s1 (merge (stream-rest s1) s2))]
                 [(> car-s1 car-s2)
                  (stream-cons car-s2 (merge s1 (stream-rest s2)))]
                 [else
                  (stream-cons car-s1 (merge (stream-rest s1) (stream-rest s2)))]))]))

(define S
  (stream-cons 1
               (merge (scale-stream S 2)
                      (merge (scale-stream S 3)
                             (scale-stream S 5)))))

(displayln "=== Hamming number stream (first 20) ===")
(displayln (stream->list (stream-take S 20)))