#lang racket

(require racket/stream)

(define integers
  (stream-cons 1
               (stream-map add1 integers)))

(define (factorial i)
  (cond [(= i 0) 0]
        [(= i 1) 1]
        [else
         (* i (factorial (- i 1)))]))
  
(define (taylor-sine s)
  (if (stream-empty? s)
      empty-stream
      (let* ([car-s (stream-first s)]
             [num (if (even? car-s) 1 -1)]
             [denom (factorial (+ 1 (* 2 car-s)))])
        (stream-cons 0
                     (stream-cons (* num (/ 1 denom))
                                  (taylor-sine (stream-rest s)))))))
  
(define sine-series
  (stream-cons 0
               (stream-cons 1
                            (taylor-sine integers))))

(define (taylor-cos s)
  (if (stream-empty? s)
      empty-stream
      (let* ([car-s (stream-first s)]
             [num (if (even? car-s) 1 -1)]
             [denom (factorial (* 2 car-s))])
        (stream-cons (* num (/ 1 denom))
                     (stream-cons 0
                                  (taylor-cos (stream-rest s)))))))

(define cosine-series
  (stream-cons 1
               (stream-cons 0
                            (taylor-cos integers))))

(define (eval-series s x n)
  (let loop ([i 0] [series s] [x-pow 1] [sum 0])
    (if (>= i n)
        sum
        (let ([car-s (stream-first series)])
          (loop (+ i 1) (stream-rest series) (* x-pow x) (+ (* car-s x-pow) sum))))))
  

;; ----------------------------------------------------
;; 테스트 및 정확도 확인
;; ----------------------------------------------------
(define pi 3.141592653589793)

(displayln (stream->list (stream-take sine-series 10)))


(displayln "=== 사인 함수 근사 (x = pi/4) ===")
(displayln (format "실제 내장 함수 값: ~a" (sin (/ pi 4))))
(displayln (format " 5항 근사값      : ~a" (eval-series sine-series (/ pi 4) 5)))
(displayln (format "10항 근사값      : ~a" (eval-series sine-series (/ pi 4) 10)))
(displayln (format "20항 근사값      : ~a" (eval-series sine-series (/ pi 4) 20)))

(displayln (stream->list (stream-take cosine-series 10)))

(displayln "\n=== 코사인 함수 근사 (x = pi/3) ===")
(displayln (format "실제 내장 함수 값: ~a" (cos (/ pi 3))))
(displayln (format " 5항 근사값      : ~a" (eval-series cosine-series (/ pi 3) 5)))
(displayln (format "10항 근사값      : ~a" (eval-series cosine-series (/ pi 3) 10)))
(displayln (format "20항 근사값      : ~a" (eval-series cosine-series (/ pi 3) 20)))