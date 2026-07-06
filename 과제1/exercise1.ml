type pair = {
    mutable car : pair option;
    mutable cdr : pair option;
};;

let rec count_pairs p = 
    match p with
    | None -> 0
    | Some x -> count_pairs x.car + count_pairs x.cdr + 1;;


(* 3을 반환하는 경우 *)
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

pair_1.cdr <- Some pair_2;;
pair_2.cdr <- Some pair_3;;

print_endline "3을 반환하는 경우 : ";;
print_int (count_pairs (Some pair_1));;
print_newline ();;

(* 4를 반환하는 경우 *)
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
pair_5.car <- Some pair_6;;
pair_5.cdr <- Some pair_6;;

print_endline "4를 반환하는 경우 : ";;
print_int (count_pairs (Some pair_4));;
print_newline ();;

(* 7을 반환하는 경우 *)
let pair_7 = {
    car = None;
    cdr = None;
};;
let pair_8 = {
    car = None;
    cdr = None;
};;
let pair_9 = {
    car = None;
    cdr = None;
};;

pair_7.car <- Some pair_8;;
pair_7.cdr <- Some pair_8;;
pair_8.car <- Some pair_9;;
pair_8.cdr <- Some pair_9;;

print_endline "7을 반환하는 경우 : ";;
print_int (count_pairs (Some pair_7));;
print_newline ();;

(* 반복하지 못하고 무한 루프에 빠지는 경우 *)
let pair_10 = {
    car = None;
    cdr = None;
};;
let pair_11 = {
    car = None;
    cdr = None;
};;
let pair_12 = {
    car = None;
    cdr = None;
};;

pair_10.cdr <- Some pair_11;;
pair_11.cdr <- Some pair_12;;
pair_12.cdr <- Some pair_11;;

print_endline "무한루프에 빠지는 경우 : ";;
print_int (count_pairs (Some pair_10));;
print_newline ();;