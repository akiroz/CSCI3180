(*
 * CSCI3180 Principles of Programming Languages
 * --- Declaration ---
 * I declare that the assignment here submitted is original except for source material explicitly
 * acknowledged. I also acknowledge that I am aware of University policy and regulations on
 * honesty in academic work, and of the disciplinary guidelines and procedures applicable to
 * breaches of such policy and regulations, as contained in the website
 * http://www.cuhk.edu.hk/policy/academichonesty/
 * Assignment 4
 * Name:
 * Student ID:
 * Email Addr:
 *)


(* Q3 ------------------------- *)
datatype 'a bTree = nil | bt of 'a bTree * 'a * 'a bTree;

(* a) in-order traversal *)
fun inorder(nil) = []
  | inorder(bt(l,v,r)) =
      inorder(l) @ [v] @ inorder(r)

(* b) pre-order traversal *)
fun preorder(nil) = []
  | preorder(bt(l,v,r)) =
      [v] @ preorder(l) @ preorder(r)

(* c) post-order traversal *)
fun postorder(nil) = []
  | postorder(bt(l,v,r)) =
      postorder(l) @ postorder(r) @ [v]


(* Q4 ------------------------- *)

(* a) define symmetric *)
fun symmetric(l,n,i) = (List.nth(l,i) = List.nth(l,n-1-i))

(* b) define palindrome *)
fun palindrome(l,n) = 
    List.all(fn i => symmetric(l,n,i))(List.tabulate(floor(real(n)/2.0), fn x => x))

(* c) define rev *)
fun rev([]) = []
  | rev(a::b) = rev(b) @ [a]
  

