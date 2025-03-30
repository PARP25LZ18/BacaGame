:- module(conv, [
    karolina_say/1,
    karolina_say/2,
    baca_say/1,
    baca_say/2,
    write_tip/1,
    narrate/1,
    write_info/1,
    player_say/1,
    player_say/2
]).


karolina_say(Message) :-
    say_with_color('\e[1;36m', Message),
    nl.

karolina_say(Message, Description) :-
    say_with_color('\e[1;36m', Message),
    add_description(Description),
    nl.

baca_say(Message) :-
    say_with_color('\e[1;31m', Message),
    nl.

baca_say(Message, Description) :-
    say_with_color('\e[1;31m', Message),
    add_description(Description),
    nl.

kacper_say(Message) :-
    say_with_color('\e[1;32m', Message),
    nl.

kacper_say(Message, Description) :-
    say_with_color('\e[1;32m', Message),
    add_description(Description),
    nl.

player_say(Message) :-
    say_with_color('\e[1m', Message),
    nl.

player_say(Message, Description) :-
    say_with_color('\e[1m', Message),
    add_description(Description),
    nl.

say_with_color(Color, Message) :-
    write(Color),
    typewriter_write('"'),
    typewriter_write(Message),
    typewriter_write('"'),
    write('\e[0m').


add_description(Description) :-
    write(' - '),
    typewriter_write(Description).


narrate(Message) :-
    typewriter_write(Message),
    nl.

write_tip(Tip) :-
    write('\e[2mTIP: '),
    typewriter_write(Tip),
    write('\e[0m'), nl.

write_info(Message) :-
    write('\e[2mINFO: '),
    typewriter_write(Message),
    write('\e[0m'), nl.


typewriter_write(Text) :-
    string_chars(Text, Chars),
    typewriter_write_char(Chars).


typewriter_write_char([]).
typewriter_write_char([Char | Rest]) :-
    write(Char),
    flush_output,
    sleep(0.02),
    typewriter_write_char(Rest).