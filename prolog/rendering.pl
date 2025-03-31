:- module(rendering, [
    write_img_line/1,
    typewriter_write_text/1,
    typewriter_write/2
]).

write_img_line(Text) :-
    typewriter_write(Text, 0.0005), nl.

typewriter_write_text(Text) :-
    typewriter_write(Text, 0.02).

typewriter_write(Text, Sleep) :-
    string_chars(Text, Chars),
    typewriter_write_char(Chars, Sleep).


typewriter_write_char([], _).
typewriter_write_char([Char | Rest], Sleep) :-
    write(Char),
    flush_output,
    sleep(Sleep),
    typewriter_write_char(Rest, Sleep).