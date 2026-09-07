#lang racket

(require racket/stream)

(define cache (make-hash))

(define (sqrt-approx s x)
  (if (stream-empty? s)
      empty-stream
      (let ([car-s (stream-first s)])
        (stream-cons (/ (+ car-s (/ x car-s)) 2)
                     (sqrt-approx (stream-rest s) x)))))

(define (sqrt-stream x)
  (hash-ref! cache x (lambda ()
                       (define sqrt-memory
                         (stream-cons 1
                                      (sqrt-approx sqrt-memory x)))
                       sqrt-memory)))

;; ----------------------------------------------------
;; 테스트 및 메모제이션 동작 확인
;; ----------------------------------------------------

;; 1. 처음 호출 시 (새로운 스트림 생성됨)
(displayln "=== 첫 번째 호출: (sqrt-stream 2) ===")
(define stream-for-2 (sqrt-stream 2))
(displayln (stream->list (stream-take stream-for-2 5)))

;; 2. 동일한 x값으로 두 번째 호출 시 (캐싱된 스트림 반환 확인)
(displayln "\n=== 두 번째 호출: (sqrt-stream 2) ===")
(define stream-for-2-cached (sqrt-stream 2))
(displayln (stream->list (stream-take stream-for-2-cached 5)))

;; 3. 다른 x값으로 호출 시 (새로운 스트림 생성됨)
(displayln "\n=== 다른 값 호출: (sqrt-stream 9) ===")
(define stream-for-9 (sqrt-stream 9))
(displayln (stream->list (stream-take stream-for-9 5)))