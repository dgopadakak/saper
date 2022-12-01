/**---------------------------------------**/
/**                                       **/
/**            GAME INTERFACE             **/
/**                                       **/
/**---------------------------------------**/

/*
    1 - chr_constraint
    EN: Defining the parameter constraint for the methods

    2 - info/3
    EN: In info/3 this statement will be used: info(X,Y,Mines)
    where X (line) and Y (column) is the boundary of the array of the minesweeper and N eh the number of pumps
*/
:- chr_constraint info/3, start_prompt_bot/0, prompt_bot/2.

/*
    EN: Main:
    A standard option 10x10 can be chosen with manually allocated bombs, or a field with AxB with
    random bombs;

    Can also be choosed if you want to know where bombs are allocated if a random option be choosen;
    %request_info(X,Y,Mines),info(X,Y,Mines),minesweeper(X,Y),mines(Mines), get_time(StartTime), asserta(start_time(StartTime)), used_time(Seconds), write('[Текущее время: '), write(Seconds), write(' секунд]'), nl, print_field, nl
*/


main :-
    write('Введите 0 для минного поля размером 10х10 либо для места взрыва;'), nl,
    write('Введите 1 для пользовательского минного поля и случайных бомб:  '), read(Escolha),

    Escolha = 0 -> input_bombs;

    nl,

    write('Введите 0, чтобы узнать, где находятся бомбы;'), nl,
    write('Введите 1, чтобы не узнавать координаты бомб:     '), read(Escolha2),

    Escolha2 = 0 -> see_random_bombs;

    request_info(X,Y,Mines),info(X,Y,Mines),minesweeper(X,Y),mines(Mines),

    get_time(StartTime), asserta(start_time(StartTime)),

    write('Введите 0, чтобы сыграть в игру'), nl,
    write('Введите 1, чтобы сыграла машина:  '), read(Escolha_bot),

    (Escolha_bot = 1 -> start_prompt_bot;

    nl, tell('/home/pavel/PycharmProjects/Saper/output2.txt'), print_store, told,

    prompt).

/*
    EN: Manually allocate 10 bombs;
    Note: Strings translated below
    Line: "nl, write('[The bombs must be arranged in coordinates (1,1) =< (X,Y) =< (10,10)]'), nl,";
    Lines: Coordinates XN and YN;
*/
input_bombs :-
    nl, write('[Бомбы должны быть расположены в координатах (1,1) =< (X,Y) =< (10,10)]'), nl,

    minesweeper(10,10), nl,
    write('  Координата X1:  '), read(X1),
    write('  Координата Y1:  '), read(Y1), nl,
    write('  Координата X2:  '), read(X2),
    write('  Координата Y2:  '), read(Y2), nl,
    write('  Координата X3:  '), read(X3),
    write('  Координата Y3:  '), read(Y3), nl,
    write('  Координата X4:  '), read(X4),
    write('  Координата Y4:  '), read(Y4), nl,
    write('  Координата X5:  '), read(X5),
    write('  Координата Y5:  '), read(Y5), nl,
    write('  Координата X6:  '), read(X6),
    write('  Координата Y6:  '), read(Y6), nl,
    write('  Координата X7:  '), read(X7),
    write('  Координата Y7:  '), read(Y7), nl,
    write('  Координата X8:  '), read(X8),
    write('  Координата Y8:  '), read(Y8), nl,
    write('  Координата X9:  '), read(X9),
    write('  Координата Y9:  '), read(Y9), nl,
    write('  Координата X10:  '), read(X10),
    write('  Координата Y10:  '), read(Y10), nl,

    minesweeper(10,10), mine(X1,Y1), mine(X2,Y2), mine(X3,Y3), mine(X4,Y4), mine(X5,Y5), mine(X6,Y6), mine(X7,Y7), mine(X8,Y8), mine(X9,Y9), mine(X10,Y10),

    info(10,10,10),

    write('Введите 0, чтобы сыграть в игру'), nl,
    write('Введите 1, чтобы сыграла машина:  '), read(Escolha_bot),

    get_time(StartTime),
    asserta(start_time(StartTime)),

    (Escolha_bot = 1 -> start_prompt_bot;

    nl,

    prompt).

/*
    EN: See where the bombs are;
    Note: Strings translated below
    Line: "l, write('[Where the bombs are]'), nl,";
*/
see_random_bombs :-

    request_info(X,Y,Mines),
    info(X,Y,Mines),
    minesweeper(X,Y),
    mines(Mines),

    nl, write('[Местоположение бомб]'), nl,
    print_store, nl,

    write('Введите 0, чтобы сыграть в игру'), nl,
    write('Введите 1, чтобы сыграла машина:  '), read(Escolha_bot),

    get_time(StartTime),
    asserta(start_time(StartTime)),

    (Escolha_bot = 1 -> start_prompt_bot;

    nl,

    prompt).

/*
    EN: Used to debug and see where the bombs are;
*/
print_store :- chr_show_store(minesweeper).

/*
    EN: Shown on screen whenever the player selects a field;
    Note: Strings translated below
    Line: "write('[Current Field - '), write(Seconds), write(' Seconds]'), nl,";
    Line: "write('[Check Location]'), nl,";
    Line: "write('  Row:      '), read(X),";
    Line: "write('  Column:   '), read(Y), nl,";
*/
prompt :-
    used_time(Seconds),
    write('[Текущее поле: '), write(Seconds), write(' секунд]'), nl,
    print_field, nl,
    write('[Выбрать местоположение]'), nl,
    write('  Строка:    '), read(X),
    write('  Столбец:   '), read(Y), nl,
    check(X,Y),
    prompt.

    /*
        EN: Used to make automatic moves,
        displayed whenever the computer selects a field;
    */
start_prompt_bot :-

    %EN: Picking up minesweepers data
    get_info(Xcm,Ycm,_Minescm),

    %EN: Choosing a house (X,Y) randomly within the game boundary
    random_between(1,Xcm,X), random_between(1,Ycm,Y),
    nl, write('Игра: '), write("("), write(X), write(","), write(Y), write(")"), nl,
    check(X,Y),
    print_field, nl,

    start_prompt_bot.

/*
    EN: Timer - Used to show the time the player took to reach a final solution
*/
used_time(Seconds) :-
    start_time(Start),
    get_time(Now),
    Seconds is round(Now - Start).

/*
    EN: Used to receive minesweeper information (number of rows, columns and mines);
    Note: Strings translated below
    Line: "nl, write('[Initialization]'), nl,";
    Line: "write('  Number of Rows:    '), read(X),";
    Line: "write('  Number of Columns: '), read(Y),";
    Line: "write('  Number of Mines:   '), read(Mines).";

    nl, write('[Инициализация]'), nl,
    write('  Число строк:  '), read(X),
    write('  Число столбцов: '), read(Y),
    write('  Число мин:   '), read(Mines), nl.
*/
%можно задать дефолтные значения
request_info(X,Y,Mines) :-
    X is 10, Y is 9, Mines is 20.

/*
    EN: It shows the minesweeper, updating with every move, besides showing when the player wins;
*/
print_field :-
    get_field(Field,OpenFields),
    get_info(_X,_Y,Mines),
    (
        Mines =:= OpenFields,
        solved
    ;
        Mines =\= OpenFields,
        print_field(Field)
    ).

/*
    EN: Shows when wins, and stop the execution of the game;
    Note: Strings translated below
    Line: "write('Congratulations! You won in '), write(Seconds), write(' seconds!'),";

    used_time(Seconds),
    write('Поздравляю! Вы выиграли за '), write(Seconds), write(' секунд!'), nl,
    halt.
*/
solved :-
    used_time(Seconds),
    write('Поздравляю! Вы выиграли за '), write(Seconds), write(' секунд!'), nl.

%########################################################################################################################################
/*
    EN: Beginning of the minesweeper template for print in the terminal
*/

/*
    EN: Method for printing the line and column numbers in the minesweeper
*/
repeat(_Char,0).
repeat(Char,N) :-
    N > 0, Nm is N-1,
    write(Char),
    repeat(Char,Nm).

/*
    EN: Method for printing the line and column numbers in the minesweeper
*/
write_width(Value,Width) :-
    atom_length(Value,ValueWidth),
    Spaces is Width-ValueWidth,
    repeat(' ',Spaces),
    write(Value).

/*
    EN: Method for printing the minesweeper
*/
print_field(Field) :-
    %EN: Get dimensions
    length(Field,DimRows),
    Field = [Row|_Rows],
    length(Row,DimCols),
    RowWidth is ceil(log10(DimRows+1)),
    ColWidth is ceil(log10(DimCols+1)),
    print_header(1,DimRows,DimCols,RowWidth,ColWidth),
    print_seperator(1,DimRows,DimCols,RowWidth,ColWidth),
    print_field(Field,1,DimRows,DimCols,RowWidth,ColWidth),
    print_seperator(1,DimRows,DimCols,RowWidth,ColWidth),
    print_header(1,DimRows,DimCols,RowWidth,ColWidth).

/*
    EN: Method for printing the limiters
*/
print_header(1,DimRows,DimCols,RowWidth,ColWidth) :-
    write(' '),
    repeat(' ',RowWidth), write(' | '),
    write_width(1,ColWidth), write(' '),
    print_header(2,DimRows,DimCols,RowWidth,ColWidth).
print_header(N,DimRows,DimCols,RowWidth,ColWidth) :-
    N < DimCols, N > 1,
    write_width(N,ColWidth), write(' '),
    Np is N+1,
    print_header(Np,DimRows,DimCols,RowWidth,ColWidth).
print_header(DimCols,_DimRows,DimCols,RowWidth,ColWidth) :-
    write_width(DimCols,ColWidth), write(' | '),
    repeat(' ',RowWidth),
    write(' '), nl.

/*
    EN: Method for printing a separator at the ends of the minesweeper
*/
print_seperator(1,DimRows,DimCols,RowWidth,ColWidth) :-
    write('-'),
    repeat('-',RowWidth),
    write('-+-'),
    repeat('-',ColWidth), write('-'),
    print_seperator(2,DimRows,DimCols,RowWidth,ColWidth).
print_seperator(N,DimRows,DimCols,RowWidth,ColWidth) :-
    N < DimCols, N > 1,
    repeat('-',ColWidth), write('-'),
    Np is N+1,
    print_seperator(Np,DimRows,DimCols,RowWidth,ColWidth).
print_seperator(DimCols,_DimRows,DimCols,RowWidth,ColWidth) :-
    repeat('-',ColWidth),
    write('-+-'),
    repeat('-',RowWidth),
    write('-'), nl.

/*
    EN: Method for printing a separator column at the ends of the minesweeper
*/
print_field([],_CurrRow,_DimRows,_DimCols,_RowWidth,_ColWidth).
print_field([Row|Rows],CurrRow,DimRows,DimCols,RowWidth,ColWidth) :-
    write(' '),
    write_width(CurrRow,RowWidth), write(' | '),
    print_row(Row,DimCols,ColWidth),
    write('| '), write_width(CurrRow,RowWidth),
    write(' '), nl,
    CurrRowN is CurrRow+1,
    print_field(Rows,CurrRowN,DimRows,DimCols,RowWidth,ColWidth).

/*
    EN: Method to add empty space in the minesweeper
*/
print_row([],_DimCols,_ColWidth).
print_row([Col|Cols],DimCols,ColWidth) :-
    write_width(Col,ColWidth), write(' '),
    print_row(Cols,DimCols,ColWidth).

/*
    EN: End of the minesweeper template for print in the terminal
*/
%########################################################################################################################################

/*
    1 - chr_constraint
    EN: Defining the parameter constraint for the methods

    2 - get_field/2
    EN: In get_field/2 this statement will be used: get_field()
*/
:- chr_constraint get_field/2, get_field/4.

%Iniciando o campo minado com os valores recebidos/Запуск минного поля с полученными значениями

get_field(Field,OpenFields), minesweeper(X,Y) ==> var(Field), var(OpenFields) | get_field(X,Y,[[]],0).

get_field(Field,OpenFieldsV), get_field(1,0,Mines,OpenFields) <=> var(Field), var(OpenFieldsV) | Field = Mines, OpenFieldsV = OpenFields.

minesweeper(_,Y) \ get_field(X,0,Field,OpenFields) <=> X > 1 | Xm is X-1, get_field(Xm,Y,[[]|Field],OpenFields).

field(X,Y,Mines) \ get_field(X,Y,[Row|Rows],OpenFields) <=> Y > 0, X > 0 |
    (
        Mines = 0,
        MinesToShow = '*'
    ;
        %EN: To debug the bombs shown
        % field(X,Y,Mines), write(Mines),
        Mines =\= 0,
        MinesToShow = Mines
    ),
    Ym is Y-1, get_field(X,Ym,[[MinesToShow|Row]|Rows],OpenFields).
get_field(X,Y,[Row|Rows],OpenFields) <=> Y > 0 | Ym is Y-1, OpenFieldsP is OpenFields+1, get_field(X,Ym,[['.'|Row]|Rows],OpenFieldsP).

/*
    1 - chr_constraint
    EN: Defining the parameter constraint for the methods

    2 - get_info\/
    EN: In get_info/3 this statement will be used: get_info(X,Y,Mines)
    copying the received data info(X, Y, Mines)
*/
:- chr_constraint get_info/3.

info(X,Y,Mines) \ get_info(Xg,Yg,Minesg) <=> Xg = X, Yg = Y, Minesg = Mines.