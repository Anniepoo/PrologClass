:- use_module(library(pengines)).

main :-
    pengine_create([
        server('https://pengines.swi-prolog.org'),
        src_text("
            q(X) :- p(X).
            p(a). p(b). p(c).
        ")
    ]),
    pengine_event_loop(handle, []).


handle(create(ID, _)) :-
    pengine_ask(ID, q(_X), []).
handle(success(_ID, [X], false)) :-
    writeln(X).
handle(success(ID, [X], true)) :-
    writeln(X),
    pengine_next(ID, []).
