% Copyright
/*
Имя: Нгуен Дык Ань
Группа: НКНбд-01-21
Студ. билет: 1032215251
*/
/*
Найти информации кинотеатр, показывающие фильм.
Найти информации кинотеатр, показывающие фильм с жанром.
Найти фильмы, показывающие в выбиранном дне.
Вычислять выручка кинотеатра
*/

implement main
    open core, file, stdio

class facts - anh
    cinema : (string IdCinema, string NameCinema, string Address, string Telephone, integer Seat).
    film : (string IdFilm, string NameFilm, string PublishingYear, string Director, string Genre).
    show : (string IdCinema, string IdFilm, string Date, string Time, integer Price).

class predicates
    film_show_at_cinema : (string NameFilm) failure. /*Найти информации кинотеатр, показывающие фильм.*/
    film_with_genre_show_at_cinema : (string NameFilm) failure. /*Найти информации кинотеатр, показывающие фильм с жанром.*/
    on_date : (string Date) failure. /*Найти фильмы, показывающие в выбиранном дне.*/
    profit_cinema : (string NameCinema) nondeterm. /*Вычислять выручка кинотеатра*/

class facts
    s : (integer Sum) single.

clauses
    s(0).

clauses
    film_show_at_cinema(NameFilm) :-
        film(IdFilm, NameFilm, _, _, _),
        write("Film ", NameFilm, " shows at cinema:\n"),
        cinema(IdCinema, NameCinema, Address, _, _),
        show(IdCinema, IdFilm, Date, Time, _),
        write(NameCinema, ", address: ", Address, ". At: ", Date, ", ", Time, "\n"),
        nl,
        fail.

    film_with_genre_show_at_cinema(Genre) :-
        film(IdFilm, NameFilm, _, _, Genre),
        write("Genre ", Genre, ": \n"),
        cinema(IdCinema, NameCinema, Address, _, _),
        show(IdCinema, IdFilm, Date, Time, _),
        write(NameFilm, " shows at cinema: ", NameCinema, ", address: ", Address, ". At: ", Date, ", ", Time, "\n"),
        nl,
        fail.

    on_date(Date) :-
        show(IdCinema, IdFilm, Date, Time, _),
        write("On ", Date, " has show: \n"),
        film(IdFilm, NameFilm, _, _, _),
        cinema(IdCinema, NameCinema, Address, _, _),
        write(NameFilm, " at cinema ", NameCinema, ". Address: ", Address, " at ", Time, "\n"),
        nl,
        fail.

    profit_cinema(NameCinema) :-
        assert(s(0)),
        cinema(IdCinema, NameCinema, _, _, Seat),
        show(IdCinema, _, _, _, Price),
        s(Sum),
        asserta(s(Sum + Seat * Price)),
        fail.
    profit_cinema(NameCinema) :-
        cinema(_, NameCinema, _, _, _),
        s(Sum),
        write("Profit cinema ", NameCinema, " is: ", Sum, " rub"),
        nl.

    run() :-
        console::init(),
        reconsult("..\\examples.txt", anh),
        film_show_at_cinema("The Green Mile"),
        fail.
    run() :-
        film_with_genre_show_at_cinema("drama"),
        fail.
    run() :-
        on_date("09/06/2023"),
        fail.
    run() :-
        profit_cinema("World of Art"),
        fail.
    run() :-
        succeed.

end implement main

goal
    console::run(main::run).
