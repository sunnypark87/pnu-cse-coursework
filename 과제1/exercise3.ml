type pair = {
    mutable car : pair option;
    mutable cdr : pair option;
};;

(* 순환(Cycle)을 탐지하는 함수 *)
let check_cycle p = 
  let visited = ref [] in
  
  let rec aux p = 
    match p with 
    | None -> false
    | Some x -> 
      if List.exists (fun q -> q == x) !visited then
        true
      else (
        visited := x :: !visited;
        aux x.cdr
      )
    in 
    aux p

(* Exercise1에서 7을 반환했던 케이스 - 순환(Cycle) 미포함 *)
let pair_1 = {
    car = None;
    cdr = None;
};;
let pair_2 = {
    car = None;
    cdr = None;
};;
let pair_3 = {
    car = None;
    cdr = None;
};;

pair_1.car <- Some pair_2;;
pair_1.cdr <- Some pair_2;;
pair_2.car <- Some pair_3;;
pair_2.cdr <- Some pair_3;;

print_endline "순환(Cycle)을 포함하지 않은 경우 : ";;
print_endline (string_of_bool (check_cycle (Some pair_1)));;
print_newline ();;

(* Exercise1의 마지막 케이스 - 순환(Cycle) 포함 *)
let pair_4 = {
    car = None;
    cdr = None;
};;
let pair_5 = {
    car = None;
    cdr = None;
};;
let pair_6 = {
    car = None;
    cdr = None;
};;

pair_4.cdr <- Some pair_5;;
pair_5.cdr <- Some pair_6;;
pair_6.cdr <- Some pair_5;;

print_endline "순환(Cycle)을 포함한 경우 : ";;
print_endline (string_of_bool (check_cycle (Some pair_4)));;
print_newline ();;