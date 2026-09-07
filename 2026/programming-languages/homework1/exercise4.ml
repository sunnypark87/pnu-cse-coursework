type pair = {
    mutable car : pair option;
    mutable cdr : pair option;
};;

(* 두 칸 이동하는 함수 *)
let double_step p = 
  match p.cdr with
  | None -> None
  | Some first -> 
    match first.cdr with
    | None -> None
    | Some second -> Some second

(* 순환(Cycle)을 탐지하는 함수 *)
let check_cycle p = 
  let temp  = ref p in
  
  let rec aux x =  
    match double_step !temp with
    | None -> false
    | Some second -> 
      if x == second then
        true
      else (
        temp := second;
        match x.cdr with
        | None -> false
        | Some next ->
          aux next
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
print_endline (string_of_bool (check_cycle pair_1));;
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
print_endline (string_of_bool (check_cycle pair_4));;
print_newline ();;