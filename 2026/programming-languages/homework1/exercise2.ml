type pair = {
    mutable car : pair option;
    mutable cdr : pair option;
};;

let visited : pair list ref = ref []

let rec count_pairs p = 
    match p with
    | None -> 0
    | Some x -> 
      if List.exists (fun q -> q == x) !visited then
        0
      else begin
        visited := x :: !visited;
        count_pairs x.car + count_pairs x.cdr + 1
      end

(* Exercise1에서 7을 반환했던 케이스 *)
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

print_endline "고유한 쌍의 개수 : ";;
print_int (count_pairs (Some pair_1));;
print_newline ();;