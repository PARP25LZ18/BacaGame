:- module(outro, [outro/0]).

:- use_module(rendering).

outro :-
    write('\e[1m'),
    play_outro_audio,
    display_output_line('                                                                  '),
    display_output_line('                                                                  '),
    display_output_line('                                                                  '),
    display_output_line('                                                                  '),
    display_output_line('                                                                  '),
    display_output_line('                                        GRA AUTORSTWA:            '),
    display_output_line('                                       ŁUKASZ SUCHOŁBIAK          '),
    display_output_line('                                        BARTOSZ NOWAK             '),
    display_output_line('                                       MACIEJ SCHEFFER            '),
    display_output_line('                                                                  '),
    display_output_line('                                                                  '),
    display_output_line('                                    DZIĘKUJEMY ZA ZAGRANIE        '),
    display_output_line('                                 LICZYMY, ŻE GRA SIĘ PODOBAŁA     '),
    display_output_line('                                                                  '),
    display_output_line('                                                                  '),
    display_output_line('                            POJAWIĄ SIĘ JESZCZE WERSJE NAPISANE W:'),
    display_output_line('                                          HASKELLU                '),
    display_output_line('                                         SMALLTALKU               '),
    display_output_line('                                                                  '),
    display_output_line('                                                                  '),
    display_output_line('                                                                  '),
    display_output_line('                                                                  '),
    display_output_line('                                                                  '),
    display_output_line('                                                                  '),
    display_output_line('                                                                  '),
    display_output_line('                                                                  ').





display_output_line(Line) :-
    typewriter_write_text(Line), nl.

play_outro_audio :-
    process_create(path(sh),
    ['-c', 'ffplay -nodisp -autoexit ../audio/outro.wav >/dev/null 2>&1 &'],
    []).
