/*readToFile(File, Stream):-
    open(File,write,Stream),
    (   elements(Points),
        get_set(Eq, Points),
        alpha_isotone(Eq, Points),
        write(Stream,Eq),nl(Stream),
        false
        ;
        close(Stream)
    ).*/

/*:- module(leq,[leq/2]).
:- use_module(library(chr)).

:- chr_constraint leq/2.
reflexivity  @ leq(X,X) <=> true.
antisymmetry @ leq(X,Y), leq(Y,X) <=> X = Y.
idempotence  @ leq(X,Y) \ leq(X,Y) <=> true.
transitivity @ leq(X,Y), leq(Y,Z) ==> leq(X,Z).*/

readFromFile(File):-
    open(File,read,Stream),
    get_char(Stream,Char1),
    process_the_stream(Char1,Stream),
    close(Stream).

% Exit condition
process_the_stream(end_of_file,_):-
    !.

process_the_stream(Char,Stream):-
    print(Char),
    get_char(Stream,Char2),
    process_the_stream(Char2,Stream).

start(Stream):-
    FilePath = 'C:/Users/Uzer/Downloads/MinesweeperProlog-master/MinesweeperProlog-master/output.txt',
    tell(FilePath),write(Stream),told.

start:-
    FilePath = '/home/pavel/PycharmProjects/Saper/input.txt',
    FilePath2 = '/home/pavel/PycharmProjects/Saper/output.txt',
    see(FilePath),read(Out),write(Out),seen,told.

begin:-
    FilePath = '/home/pavel/PycharmProjects/Saper/input.txt',
    FilePath2 = '/home/pavel/PycharmProjects/Saper/output.txt',
    see(FilePath),read(Out),whilee(Out),seen.

whilee(Out):- Out='*'.
whilee(Out):- write(Out),read(Out2),whilee(Out2).

prnt_smth:- write(1).

load_file(Data_file):- see(Data_file), tell('/home/pavel/PycharmProjects/Saper/output.txt'), repeat, read(F), write(F), (F=end_of_file, !, seen, told; assert(F), fail).
/* start:-
     FilePath = 'C:/Users/Uzer/Downloads/MinesweeperProlog-master/MinesweeperProlog-master/input.txt',
     readFromFile(FilePath).
     */