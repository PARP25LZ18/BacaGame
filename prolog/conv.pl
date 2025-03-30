:- module(conv, [karolina_say/1, karolina_say/2]).


karolina_say(Message) :-
    say_with_color('\e[1;36m', Message),
    nl.

karolina_say(Message, Description) :-
    say_with_color('\e[1;36m', Message),
    add_description(Description),
    nl.



say_with_color(Color, Message) :-
    write(Color),
    typewriter_write(Message),
    write('\e[0m').


add_description(Description) :-
    write(' - '),
    typewriter_write(Description).


typewriter_write(Text) :-
    string_chars(Text, Chars),
    typewriter_write_char(Chars).


typewriter_write_char([]).
typewriter_write_char([Char | Rest]) :-
    write(Char),
    flush_output,
    sleep(0.033),
    typewriter_write_char(Rest).