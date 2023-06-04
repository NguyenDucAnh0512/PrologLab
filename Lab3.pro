% Copyright
/*
Имя: Нгуен Дык Ань
Группа: НКНбд01-21
Студ. билет: 1032215251
*/
/*
Какие шоу доступны в кинотеатре, и их информация?
Сколько фильмов показывают в каких кинотеатрах и названия фильмов.
Информация о кинотеатрах, показывающих фильм, и прибыли, полученной от фильма.
Информация о фильмах, которые показывает театр.
Информация о кинопоказе театра.
*/

implement main
    open core, stdio

domains
    show_info = show_info(string NameFilm, string Date, string Time, integer TicketPrice).
    film_info = film_info(string NameFilm, string PublishingYear, string Director, string Genre).
    cinema_info = cinema_info(string NameCinema, string Address, string Telephone).

class facts - anh
    cinema : (string IdCinema, string NameCinema, string Address, string Telephone, integer Seat).
    film : (string IdFilm, string NameFilm, string PublishingYear, string Director, string Genre).
    show : (string IdCinema, string IdFilm, string Date, string Time, integer Price).

class predicates
    length : (A*) -> integer N.
    sum_elem : (real* List) -> real Sum.

clauses
    length([]) = 0.
    length([_ | T]) = length(T) + 1.

    sum_elem([]) = 0.
    sum_elem([H | T]) = sum_elem(T) + H.

class predicates
    list_show : (string NameCinema) -> show_info* determ.
    list_film : (string NameCinema) -> string* Films determ.
    amount_of_film : (string NameCinema) -> integer N determ.
    list_cinema : (string NameFilm) -> string* Cinemas determ.
    film_profit : (string NameFilm) -> real Film_profit determ.
    list_film_info : (string NameCinema) -> film_info* determ.
    list_cinema_info : (string NameFilm) -> cinema_info* determ.

clauses
    %Написать названия фильмов, которые показывали в кинотеатре, и количество показываемых фильмов.
    list_film(NameCinema) = ListFilm :-
        cinema(IdCinema, NameCinema, _, _, _),
        !,
        ListFilm =
            [ NameFilm ||
                show(IdCinema, IdFilm, _, _, _),
                film(IdFilm, NameFilm, _, _, _)
            ].
    amount_of_film(NameCinema) = length(list_film(NameCinema)).

    %Написать называния кинотеатров, в которых показывают этот фильм
    list_cinema(NameFilm) = ListCinema :-
        film(IdFilm, NameFilm, _, _, _),
        !,
        ListCinema =
            [ NameCinema ||
                show(IdCinema, IdFilm, _, _, _),
                cinema(IdCinema, NameCinema, _, _, _)
            ].

    %Написать информацию о фильмах, показываемых в этом кинотеатре
    list_film_info(NameCinema) =
            [ film_info(NameFilm, PublishsingYear, Director, Genre) ||
                film(IdFilm, NameFilm, PublishsingYear, Director, Genre),
                cinema(IdCinema, NameCinema, _, _, _),
                show(IdCinema, IdFilm, _, _, _)
            ] :-
        cinema(IdCinema, NameCinema, _, _, _),
        !.

    %Написать информации кинотеатров, в которых показывают этот фильм
    list_cinema_info(NameFilm) =
            [ cinema_info(NameCinema, Address, Telephone) ||
                film(IdFilm, NameFilm, _, _, _),
                cinema(IdCinema, NameCinema, Address, Telephone, _),
                show(IdCinema, IdFilm, _, _, _)
            ] :-
        film(IdFilm, NameFilm, _, _, _),
        !.

    %Написать информации о шоу, которые идут в этом театре
    list_show(NameCinema) =
            [ show_info(NameFilm, Date, Time, Price) ||
                film(IdFilm, NameFilm, _, _, _),
                cinema(IdCinema, NameCinema, _, _, _),
                show(IdCinema, IdFilm, Date, Time, Price)
            ] :-
        cinema(IdCinema, NameCinema, _, _, _),
        !.

    %Вычислять прибыль, полученную от показа фильма в кинотеатрах (стоимость билета * места в кинотеатре)
    film_profit(NameFilm) =
            sum_elem(
                [ Price * Seat ||
                    cinema(IdCinema, _, _, _, Seat),
                    show(IdCinema, IdFilm, _, _, Price)
                ]) :-
        film(IdFilm, NameFilm, _, _, _),
        !.

class predicates
    write_film_info : (film_info* X).
    write_cinema_info : (cinema_info* X).
    write_show_info : (show_info* X).

clauses
    write_film_info(L) :-
        foreach film_info(NameFilm, PublishingYear, Director, Genre) = list::getMember_nd(L) do
            writef("\t%s\t%s\t%s\t%s\n", NameFilm, PublishingYear, Director, Genre)
        end foreach.
    write_cinema_info(L) :-
        foreach cinema_info(NameCinema, Address, Telephone) = list::getMember_nd(L) do
            writef("\t%s\t%s\t%s\n", NameCinema, Address, Telephone)
        end foreach.
    write_show_info(L) :-
        foreach show_info(NameFilm, Date, Time, TkPrice) = list::getMember_nd(L) do
            writef("\t%s\t%s\t%s\t%s\n", NameFilm, Date, Time, toString(TkPrice))
        end foreach.

clauses
    run() :-
        console::init(),
        file::consult("..\\examples.txt", anh),
        fail.
    run() :-
        NameCinema = "World of Art",
        L = list_film(NameCinema),
        write("Cinema ", NameCinema, " had shown: \n"),
        write(L),
        write("\nAmount of film: ", amount_of_film(NameCinema)),
        nl,
        nl,
        fail.
    run() :-
        NameFilm = "Interstellar",
        L = list_cinema(NameFilm),
        write("Film ", NameFilm, " is showed at cinema: \n"),
        write(L),
        nl,
        write("Film ", NameFilm, " 's profit (rub): ", film_profit(NameFilm)),
        nl,
        nl,
        fail.
    run() :-
        NameCinema = "World of Art",
        write("List of film's info (Film's name, Director, Publishing Year, Genre)  of cinema ", NameCinema, ":\n"),
        write_film_info(list_film_info(NameCinema)),
        nl,
        fail.
    run() :-
        NameFilm = "Fight Club",
        write("List of cinema (Cinema's name, address, telephone), that shows film ", NameFilm, ": \n"),
        write_cinema_info(list_cinema_info(NameFilm)),
        nl,
        nl,
        fail.
    run() :-
        NameCinema = "GUM Cinema",
        write("Cinema ", NameCinema, " have shows (Film's name, date, time, ticket price (rub)) today: \n"),
        write_show_info(list_show(NameCinema)),
        nl,
        fail.
    run() :-
        succeed.

end implement main

goal
    console::run(main::run).
