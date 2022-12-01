/*
    EN: Import the CHR module available in SWI-PROLOG
*/
:- use_module(library(chr)).

/*
    1 - chr_constraint
    EN: Defining the parameter constraint for the methods

    2 - mines/1
    EN: At mines/1 this statement will be used: mines (X)
    defining in X the number of bombs in the minesweeper.

    3 - mine/2
    EN: At mines/1 this statement will be used: mines (X, Y)
    defining in X (line) and Y (column) where it will have a bomb in the minesweeper.

    4 - minesweeper/2
    EN: At minesweeper/2 this statement will be used: minesweeper(X,Y)
    defining the dimensions X (rows) and Y (columns) of the minesweeper field.

    5 - check/2
    EN: At check/2 this statement will be used: check(A, B)
    putting A (line) and B (column) and verifying that house of the array of the minesweeper.

    6 - field/3
    EN: In field/3 this statement will be used: field(X,Y,N)
    where X (line) and Y (column) is one house of the array of the minesweeper and N is the number of bombs around it
*/
:- chr_constraint mines/1, mine/2, minesweeper/2, check/2, field/3.

/*
    First Step:

    EN: The stop statement will be "mines(0) <=> true.", that is,
    that the minesweeper method will stop executing and the code execution will continue;

    In minesweeper, the X and Y are received and the number of bombs there be setted in N,
    the bombs will be distributed randomly in the minefield;

    In the condition "mine (Xm, Ym), [..]" there will be a check which will be explained below,
    and in "[..], mines (NN)." execution returns to the initial verification of the method, until
    arrives in the stop condition, which is to have no more bombs to distribute ("mines (0) <=> true.")!
*/
mines(0) <=> true.
minesweeper(X,Y) \ mines(N) <=> NN is N-1,
    random_between(1,X,Xm), random_between(1,Y,Ym),
    mine(Xm,Ym), mines(NN).

/*
    EN: Second step (Replace duplicates):

    The expression "mine(X,Y) \\ mine(X,Y) <=> mines(1)." says there is still one more
    bomb to be allocated in the minesweeper, which induces the reallocation of the duplicate bomb;

    Then the expression "check(A,B) \\ check(A,B) <=> true." sets the value "true"
    in checking, removing the duplicate bomb from the minefield.
*/
mine(X,Y) \ mine(X,Y) <=> mines(1).
check(A,B) \ check(A,B) <=> true.

/*
    EN: Third step (Remove "check/2" beyond the "minesweeper/2" boundaries):

    In "minesweeper (Xmax,Ymax)" there is received the maximum X and Y of the array;

    In "check (X,Y)" will be checked the house (X,Y) of the array of the minesweeper, and checked if
    and only if, the following conditions are NOT met, which are defined in
    "X < 1; Y < 1; X > Xmax; Y > Ymax", which is nothing more than: X and Y can they can not be smaller
     or greater than the lower and upper limits of the array, respectively.
*/
minesweeper(Xmax,Ymax) \ check(X,Y) <=> X < 1; Y < 1; X > Xmax; Y > Ymax | true.

/*
    EN: Fourth step (Check: Mine found)

    In the expression "check(X,Y), mine(X,Y) <=> write('Voce perdeu! Ai tinha uma bomba!')
    is checked a bomb field that returns the message "You lose! That was a mine!"
    and the execution is finished. (halt == break)
*/
check(X,Y), mine(X,Y) <=> write('Ты проиграл! Это была мина!'), nl. %EN: 'You lose! That was a mine!'

/*
    EN: Fifth step (Check: Count neighboring mines)

    In "check(X,Y), mine(Xmine,Ymine)" the house (X,Y) from the array of the minesweeper will be checked, as also,
    will be compared to a coordinate (Xmine,Ymine) of a neighboring bomb that is around this house (X,Y);

    That is, in the two expressions, listed below, the neighbors of the house (X,Y) checked,
    when checking that there is a bomb it increases the 'neighboring bomb counter' with "field(X,Y,1)";

    After all the checks, in "field(X,Y,N1), field(X,Y,N2) <=> N is N1 + N2 | field(X,Y,N)." is replaced
    the value of N of the house (X,Y) checked by the sum of all the pumps found.

    Note: The sum is done every two bombs found, ie if there are three bombs around, "A", "B" and "C", for example,
    will be added "A" + "B", 1 + 1, updating the value of N of the house (X,Y) to 2, then the code returns to add
    the remainder of the missing bombs, in this case only one more, "C", then the value of N + 1 will be added,
    so the value of N will be 3, which is the number of pumps around this house (X,Y).
*/
check(X,Y), mine(Xmine,Ymine) ==>
    Xmine =< X+1, Xmine >= X-1,
    Ymine =< Y+1, Ymine >= Y-1 |
    field(X,Y,1).

field(X,Y,N1), field(X,Y,N2) <=> N is N1+N2 | field(X,Y,N).

/*
    EN: Sixth step (Check: Add default field/3)

    In the expression, listed below, all fields which have no bombs as neighbors,
    receive the value of zero mines in the vicinity of said field.

    Note: When it is discovered that there are no bombs, an empty field  " " is shown.
*/
check(X,Y) ==> field(X,Y,0).

/*
    EN: Seventh step (Check all neighbors of field(X,Y,0))

    In the expression, listed below, all the neighboring fields of the house (X,Y) of the array of the minesweeper,
    are checked and given the appropriate values ??in relation to the bombs surrounding it,
    each check is performed from the logic of the individual check described above.
*/
check(X,Y), field(X,Y,0) ==> Xm is X-1, Xp is X+1, Ym is Y-1, Yp is Y+1,
    check(X,Ym), check(X,Yp),
    check(Xm,Y), check(Xp,Y),
    check(Xm,Ym), check(Xm,Yp),
    check(Xp,Ym), check(Xp,Yp).

:- include('play.pl').
