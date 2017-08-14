% CSCI3180 Principles of Programming Languages
%
% --- Declaration ---
% I declare that the assignment here submitted is original except for source material explicitly
% acknowledged. I also acknowledge that I am aware of University policy and regulations on
% honesty in academic work, and of the disciplinary guidelines and procedures applicable to
% breaches of such policy and regulations, as contained in the website
% http://www.cuhk.edu.hk/policy/academichonesty/
%
% Assignment 4
% Name:
% Student ID:
% Email Addr:


% Q1 ------------------------------
:- use_module(library(clpfd)).
:- use_module(library(lists)).

% a) define product(X,Y,Z):
product(X,Y,Z) :- Z #= X*Y.

% b) product(3,4,Ans).

% c) product(Ans,8,4).

% d) factors(Ans,6).
factors(F,M) :-
    findall(P, factor_pair(P,M), List),
    flatten(List, Flat),
    list_to_set(Flat, F).
factor_pair([X,Y], M) :-
    [X,Y] ins 1..M,
    product(X,Y,M),
    label([X,Y]).

% e) define exp(X,Y,Z):
exp(X,Y,Z) :- Z #= X^Y.

% f) exp(2,3,Ans).

% g) exp(2,Ans,8).


% Q2 ------------------------------

% a) transitions:
transition(a,0,c).
transition(a,1,a).
transition(b,0,c).
transition(b,1,a).
transition(c,0,c).
transition(c,1,b).

% b) define state(N):
state(N) :-
    findall(F,transition(F,_,_),States),
    member(N, States).

% c) define walk(S,B,E):
walk(S,B,E) :-
    length(S,0),
    B == E.
walk(S,B,E) :-
    length(S,1),
    [X|_] = S,
    transition(B,X,E).
walk(S,B,E) :-
    [Head|Tail] = S,
    transition(B,Head,I),
    walk(Tail,I,E).

