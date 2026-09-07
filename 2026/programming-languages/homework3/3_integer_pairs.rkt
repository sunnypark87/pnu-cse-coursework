#lang racket

(require racket/stream)

(define integers
  (stream-cons 1
               (stream-map add1 integers)))

(define (interleave s1 s2)
  (cond [(stream-empty? s1) s2]
        [(stream-empty? s2) s1]
        [else
         (let ([car-s1 (stream-first s1)]
               [car-s2 (stream-first s2)]
               [rest-s1 (stream-rest s1)]
               [rest-s2 (stream-rest s2)])
           (stream-cons car-s1
                        (stream-cons car-s2
                                     (interleave rest-s1 rest-s2))))]))
         
(define (pairs s)
  (if (stream-empty? s)
      empty-stream
      (let ([car-s (stream-first s)])
        (stream-cons (cons car-s car-s)
                     (interleave (stream-map (lambda (x) (cons car-s x)) (stream-rest s))
                                 (pairs (stream-rest s)))))))
           
(define all-pairs
   (pairs integers))

(define (weight x y) (+ x y))

(define (merge-weighted s1 s2 w-function)
  (cond [(stream-empty? s1) s2]
        [(stream-empty? s2) s1]
        [else
         (let* ([car-s1 (stream-first s1)]
                [car-s2 (stream-first s2)]
                [rest-s1 (stream-rest s1)]
                [rest-s2 (stream-rest s2)]
                [weight-s1 (w-function (car car-s1) (cdr car-s1))]
                [weight-s2 (w-function (car car-s2) (cdr car-s2))])
           (if (> weight-s1 weight-s2)
               (stream-cons car-s2 (merge-weighted s1 rest-s2 w-function))
               (stream-cons car-s1 (merge-weighted rest-s1 s2 w-function))))]))
                  
(define (weighted-pairs s)
  (if (stream-empty? s)
      empty-stream
      (let ([car-s (stream-first s)]
            [rest-s (stream-rest s)])
       (stream-cons (cons car-s car-s)
                    (merge-weighted (stream-map (lambda (x) (cons car-s x)) rest-s)
                                    (weighted-pairs rest-s)
                                    weight)))))

(define sorted-weighted-pairs
  (weighted-pairs integers))

(displayln "=== pairs stream (first 15) ===")
(displayln (stream->list (stream-take all-pairs 15)))

(displayln "\n=== weighted pairs stream (first 15) ===")
(displayln (stream->list (stream-take sorted-weighted-pairs 15)))