# Programming Languages

> 부산대학교 프로그래밍 언어론 수업에서 진행한 과제 모음입니다. OCaml과 Racket을 사용해 함수형 프로그래밍, 재귀적 자료구조, 지연 평가, 무한 스트림, 문법 설계 개념을 직접 구현해보았습니다.

## 레포지토리 개요

```text
.
├── 과제1/
│   ├── exercise1.ml
│   ├── exercise2.ml
│   ├── exercise3.ml
│   └── exercise4.ml
├── 과제2/
│   └── PL_과제2_202055543_박재선.md
└── 과제3/
    ├── 1_fib.rkt
    ├── 2_hamming.rkt
    ├── 3_integer_pairs.rkt
    ├── 4_power_series.rkt
    └── 5_sqrt_approximation.rkt
```

| 구분 | 언어 | 주요 내용 |
| --- | --- | --- |
| 과제1 | OCaml | mutable pair 구조, pair counting, cycle detection |
| 과제2 | Markdown / BNF | 논리식 문법 설계, 연산자 우선순위, EBNF 표현 |
| 과제3 | Racket | lazy stream, infinite sequence, memoization, numerical approximation |

## 현재 코드의 내용

### 과제1: OCaml 자료구조와 순환 탐지

`과제1`은 SICP의 pair 구조 문제를 OCaml로 옮긴 형태입니다. `car`, `cdr`를 가진 mutable record를 정의하고, pair 구조를 순회하면서 개수를 세거나 순환 여부를 판별합니다.

- `exercise1.ml`: 단순 재귀로 pair 개수를 세는 함수입니다. 공유된 pair를 중복해서 세거나, cycle이 있으면 무한 재귀에 빠지는 한계를 예제로 보여줍니다.
- `exercise2.ml`: 방문한 pair를 리스트에 저장하고, OCaml의 참조 동일성 비교 연산자 `==`를 사용해 이미 방문한 노드를 다시 세지 않도록 개선했습니다.
- `exercise3.ml`: `cdr` 방향으로 이동하면서 방문 여부를 기록해 cycle을 탐지합니다.
- `exercise4.ml`: 한 포인터는 한 칸, 다른 포인터는 두 칸씩 이동하는 방식으로 cycle을 탐지합니다. Floyd cycle detection과 유사한 접근입니다.

이 과제에서는 단순 재귀 구현이 공유 구조와 순환 구조에서 어떤 문제를 만드는지 확인하고, 방문 기록 또는 two-pointer 방식으로 보완하는 흐름을 다뤘습니다.

### 과제2: BNF와 파싱 규칙 설계

`과제2`는 논리식 문법을 BNF와 EBNF로 표현한 문서입니다. `OR`, `AND`, `NOT`, 비교 연산의 우선순위를 문법 계층으로 나누어 표현했습니다.

핵심 설계는 다음과 같습니다.

- `AND`가 `OR`보다 높은 우선순위를 갖도록 `<and_expr>`를 `<or_expr>`보다 깊은 단계에 배치했습니다.
- `NOT`은 재귀 규칙으로 표현해 중첩된 부정 연산을 처리할 수 있게 했습니다.
- 괄호 처리를 위해 `<expr>`를 다시 포함하는 규칙을 추가했습니다.
- EBNF 표현을 통해 반복되는 `OR`, `AND`, `NOT` 패턴을 더 간결하게 정리했습니다.

이 과제는 실제 파서를 구현하지는 않았지만, 프로그래밍 언어의 구문 구조와 연산자 우선순위를 문법으로 모델링하는 연습입니다.

### 과제3: Racket 지연 스트림

`과제3`은 Racket의 `racket/stream`을 사용해 무한 스트림과 수치 계산을 구현한 과제입니다.

- `1_fib.rkt`: 자기참조 스트림으로 피보나치 수열을 생성합니다.
- `2_hamming.rkt`: 2, 3, 5의 배수 스트림을 병합해 Hamming number stream을 만듭니다. 중복 제거를 포함한 merge 로직을 구현했습니다.
- `3_integer_pairs.rkt`: 정수 쌍의 무한 스트림을 만들고, `interleave`와 weighted merge를 사용해 스트림이 한쪽으로만 치우치지 않도록 구성했습니다.
- `4_power_series.rkt`: sine, cosine Taylor series 계수를 스트림으로 만들고, 항 개수에 따른 근삿값을 계산합니다.
- `5_sqrt_approximation.rkt`: Newton method 기반 제곱근 근사 스트림을 만들고, 같은 입력값에 대한 스트림을 hash table로 캐싱합니다.

이 과제에서는 즉시 모든 값을 계산하지 않고 필요한 만큼만 값을 꺼내는 lazy evaluation의 장점을 실험했습니다.

## 코드 수정, 보완 방향

현재 코드는 과제의 핵심 개념을 확인하기에는 충분하지만, 알고리즘의 정확성, 일반성, 효율성 관점에서는 다음과 같은 개선 여지가 있습니다.

1. Pair counting의 의미 명확화
   - `exercise1.ml`의 `count_pairs`는 구조 안에 등장하는 모든 pair 참조를 재귀적으로 세기 때문에, 같은 pair가 여러 경로에서 공유되면 중복 카운트됩니다.
   - `exercise2.ml`처럼 참조 동일성 기준의 방문 기록을 두면 "도달 가능한 고유 pair 개수"를 셀 수 있습니다.
   - 개선 방향은 두 함수를 단순히 정답/오답으로 나누기보다, 하나는 "경로 기준 카운트", 다른 하나는 "객체 identity 기준 고유 노드 카운트"로 의미를 분리하는 것입니다.

2. OCaml 전역 상태 제거와 재호출 안정성
   - `exercise2.ml`의 `visited`는 전역 `ref`로 정의되어 있어 `count_pairs`를 여러 번 호출하면 이전 호출의 방문 기록이 남을 수 있습니다.
   - 방문 리스트를 `count_pairs` 내부 지역 상태로 옮기면 함수 호출이 독립적이고 재사용 가능해집니다.
   - pair 수가 많아질 경우 리스트 기반 방문 검사는 `O(n)`이므로, 해시 테이블이나 집합 구조를 사용하면 전체 순회 비용을 줄일 수 있습니다.

3. Cycle detection의 범위 확장
   - `exercise3.ml`과 `exercise4.ml`은 주로 `cdr` 방향의 연결 리스트 형태를 기준으로 cycle을 탐지합니다.
   - 하지만 `pair`는 `car`와 `cdr` 두 방향을 모두 가지므로, 일반적인 그래프처럼 보면 `car` 쪽에만 존재하는 cycle은 탐지 범위에서 벗어날 수 있습니다.
   - 개선 방향은 "list cycle detection"과 "graph cycle detection"을 구분하고, `car`와 `cdr` 양쪽 간선을 모두 탐색하는 DFS 기반 cycle 탐지로 확장하는 것입니다.

4. Floyd cycle detection 구현 정교화
   - `exercise4.ml`은 빠른 포인터와 느린 포인터를 사용하지만, `temp`를 외부 `ref`로 두고 재귀 인자와 함께 갱신하는 방식이라 알고리즘의 상태 흐름이 직관적으로 드러나지 않습니다.
   - `(slow, fast)` 두 포인터를 재귀 함수의 인자로 함께 전달하면 Floyd 알고리즘의 불변식이 더 명확해집니다.
   - 추가로 cycle 존재 여부뿐 아니라 cycle 시작 위치나 cycle 길이를 구하는 단계까지 확장할 수 있습니다.

5. BNF 문법의 실제 파서 구현 가능성 보완
   - 과제2의 BNF는 우선순위를 표현하는 데 적합하지만, `<or_expr> -> <or_expr> OR <and_expr>`처럼 좌재귀가 포함되어 있습니다.
   - 이 문법은 개념 설명에는 자연스럽지만 recursive descent parser에 바로 사용하기는 어렵습니다.
   - 개선 방향은 좌재귀를 제거한 LL 형태 문법으로 바꾸거나, Pratt parser 또는 precedence climbing 방식으로 실제 파서를 구현해보는 것입니다.

6. Stream merge의 공정성과 중복 처리 일반화
   - `2_hamming.rkt`의 `merge`는 정렬된 두 스트림을 병합하며 중복을 제거합니다. 이 방식은 Hamming number 생성에 적합합니다.
   - `3_integer_pairs.rkt`의 `interleave`와 `merge-weighted`는 무한 스트림을 다룰 때 특정 분기가 영원히 평가되지 않는 문제를 피하기 위한 핵심 장치입니다.
   - 개선 방향은 스트림 병합 함수들이 정렬성, 중복 제거, 공정성 중 어떤 성질을 보장하는지 명확히 나누고, 여러 가중치 함수에 재사용할 수 있도록 일반화하는 것입니다.

7. Power series와 수치 근사의 정확도 개선
   - `4_power_series.rkt`의 factorial은 `0! = 1`이어야 하므로 수학적 정의에 맞게 수정할 필요가 있습니다.
   - sine/cosine 계수를 직접 나열하는 방식 대신, 미분/적분 관계를 이용한 power series 연산으로 확장하면 언어론 수업의 stream abstraction과 더 잘 연결됩니다.
   - `5_sqrt_approximation.rkt`는 Newton method의 반복값을 스트림으로 만들지만, 현재는 고정된 개수만 출력합니다. 오차 기준을 받아 수렴할 때까지 값을 꺼내는 함수로 확장하면 알고리즘적으로 더 완성도가 높아집니다.

8. Lazy stream의 메모이제이션 비용 분석
   - `5_sqrt_approximation.rkt`는 입력값별로 sqrt stream을 캐싱합니다.
   - 캐싱은 같은 계산을 반복하지 않는 장점이 있지만, 입력값이 많아질수록 해시 테이블에 스트림이 계속 남을 수 있습니다.
   - 개선 방향은 memoization의 이점과 메모리 사용량을 비교하고, 어떤 경우에 캐싱이 필요한지 분석하는 것입니다.

## 추가적으로 공부하면 좋을 것

프로그래밍 언어론 수업의 흐름과 현재 과제의 알고리즘적 요소를 기준으로 보면, 다음 주제를 심화해서 공부하기 좋습니다.

1. 참조, aliasing, mutation의 의미론
   - 과제1의 pair 구조는 같은 객체가 여러 경로에서 공유될 수 있고, `mutable` 필드를 통해 그래프 형태로 바뀔 수 있습니다.
   - 이와 연결해 environment model, store model, aliasing, side effect가 프로그램 의미에 어떤 영향을 주는지 공부하면 좋습니다.
   - OCaml의 `=`와 `==` 차이를 단순 문법이 아니라 structural equality와 physical equality의 의미론 차이로 이해할 수 있습니다.

2. 재귀적 자료구조를 그래프로 해석하는 관점
   - pair/list를 단순 선형 리스트가 아니라 directed graph로 보면 공유 노드, cycle, 도달 가능성 문제가 자연스럽게 등장합니다.
   - 관련 알고리즘으로 DFS/BFS, visited set, graph cycle detection, strongly connected components를 공부할 수 있습니다.
   - `count_pairs` 문제는 garbage collection의 reachability analysis와도 연결해서 이해할 수 있습니다.

3. Cycle detection 알고리즘
   - Floyd's tortoise and hare 알고리즘은 `O(1)` 추가 공간으로 연결 리스트 cycle을 찾는 대표적인 방법입니다.
   - Brent's algorithm도 함께 공부하면 pointer 이동 횟수와 비교 비용 관점에서 cycle detection을 더 깊게 이해할 수 있습니다.
   - 일반 그래프 cycle detection과 연결 리스트 cycle detection이 어떤 조건에서 다른 문제인지 비교해보면 좋습니다.

4. Context-free grammar와 parser 설계
   - 과제2의 BNF는 CFG, terminal/non-terminal, derivation, parse tree 개념과 직접 연결됩니다.
   - 우선순위와 결합 방향을 문법 계층으로 표현하는 방식, 좌재귀 제거, left factoring을 공부하면 실제 파서 구현으로 확장할 수 있습니다.
   - LL parser, LR parser, Pratt parser, precedence climbing을 비교하면 같은 수식을 서로 다른 방식으로 파싱하는 방법을 이해할 수 있습니다.

5. 지연 평가와 무한 데이터 구조
   - 과제3의 Racket stream은 필요한 값만 계산하는 lazy evaluation의 예시입니다.
   - strict evaluation과 lazy evaluation의 차이, thunk, delay/force, call-by-name, call-by-need를 함께 공부하면 stream의 동작을 언어 평가 전략 관점에서 이해할 수 있습니다.
   - 무한 리스트를 다룰 때 생산성(productivity)과 공정성(fairness)이 왜 중요한지도 함께 볼 수 있습니다.

6. Stream processing 알고리즘
   - Hamming number 생성은 정렬된 무한 스트림 병합과 중복 제거 문제입니다.
   - integer pairs 생성은 무한한 2차원 탐색 공간을 어떤 순서로 순회할 것인지에 대한 문제입니다.
   - diagonal enumeration, fair interleaving, weighted merge, priority queue 기반 lazy generation을 공부하면 현재 구현을 더 일반화할 수 있습니다.

7. Power series를 자료구조로 다루는 방법
   - sine/cosine Taylor series는 계수 스트림으로 볼 수 있고, 덧셈, 곱셈, 적분, 미분 같은 연산을 stream combinator로 정의할 수 있습니다.
   - 이는 SICP에서 강조하는 "수학적 대상을 데이터 구조로 표현하고 연산을 추상화하는 방식"과 잘 연결됩니다.
   - formal power series와 generating function을 함께 공부하면 피보나치, 수열, 근사 계산을 하나의 관점으로 묶어볼 수 있습니다.

8. 수치해석과 고정점 반복
   - sqrt 근사는 Newton method와 fixed-point iteration의 예시입니다.
   - 수렴 조건, 오차 한계, 반복 종료 조건, 발산 가능성을 공부하면 단순히 앞의 몇 항을 출력하는 수준에서 알고리즘의 신뢰성을 분석하는 단계로 확장할 수 있습니다.
   - lazy stream으로 반복 근삿값을 표현하면 "계산 과정 전체를 값처럼 다루는" 함수형 프로그래밍 관점을 더 잘 이해할 수 있습니다.

## 코드 실행

### OCaml 실행

OCaml이 설치되어 있다면 각 파일을 다음처럼 실행할 수 있습니다.

```bash
cd 과제1
ocaml exercise1.ml
ocaml exercise2.ml
ocaml exercise3.ml
ocaml exercise4.ml
```

컴파일해서 실행하려면 다음과 같이 사용할 수 있습니다.

```bash
ocamlc -o exercise1 exercise1.ml
./exercise1
```

### Racket 실행

Racket이 설치되어 있다면 각 파일을 다음처럼 실행할 수 있습니다.

```bash
cd 과제3
racket 1_fib.rkt
racket 2_hamming.rkt
racket 3_integer_pairs.rkt
racket 4_power_series.rkt
racket 5_sqrt_approximation.rkt
```

### 실행 환경

이 저장소의 코드는 다음 환경을 전제로 합니다.

- OCaml: `ocaml`, `ocamlc` 명령 사용
- Racket: `racket` 명령 사용
- macOS 또는 Unix-like shell

