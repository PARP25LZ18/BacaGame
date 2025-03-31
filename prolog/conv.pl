:- module(conv, [
    karolina_say/1,
    karolina_say/2,
    baca_say/1,
    baca_say/2,
    write_tip/1,
    narrate/1,
    write_info/1,
    player_say/1,
    player_say/2,
    write_waiting/0
]).

:- use_module(rendering).

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
    typewriter_write_text('"'),
    typewriter_write_text(Message),
    typewriter_write_text('"'),
    write('\e[0m').


add_description(Description) :-
    typewriter_write_text(' - '),
    typewriter_write_text(Description).


narrate(Message) :-
    write('\e[0m'),
    typewriter_write_text(Message),
    nl.

write_tip(Tip) :-
    typewriter_write_text('\e[2mTIP: '),
    typewriter_write_text(Tip),
    write('\e[0m'), nl.

write_info(Message) :-
    typewriter_write_text('\e[2mINFO: '),
    typewriter_write_text(Message),
    write('\e[0m'), nl.

write_waiting :-
    typewriter_write('...', 0.2), nl.
