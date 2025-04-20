instructions :-
    display_instructions.
    -- ...
    -- add command help here

introduction :-
        assert(at_introduction),
        assert(is_outside),
        assert(can_look),
        nl,
        narrate "Była to zimna grudniowa noc, wybrałeś się w Tatry..."
        narrate "Po 5 godzinach wchodzenia pod górę, wreszcie widzisz przed sobą \x1b[1mschronisko\x1b[0m"
        write_tip "Spróbuj \x1b[1mspojrzeć\x1b[0m\x1b[2m na \x1b[1mschronisko"
        write_tip "Aby wyświetlić wszystkie rzeczy na które możesz spojrzeć wpisz \x1b[1mlvo."
        make_visible "schronisko"

start :-
    introduction.


-- List Visible Objects Function 
lvo :-
    findall(Object, can_see "Object", Objects),
    narrate "Mozesz spojrzec na: "


-- user interface to spojrz command
spojrz(X) :-
    not can_answer(_, _), 
    !,
    spojrz_specific(X).


-- general see rule
spojrz_specific "X" = do
    tty_clear,
    not can_see "X",
    narrate "Nie masz możliwości teraz tego zobaczyć."
    write_tip "Pamiętaj, żeby nazwy obiektów wpisywać bez polskich znaków"

-- POCZĄTEK GRY
spojrz_specific "schronisko" = do
    is_outside,
    display_hut,
    narrate "Z komina schroniska wydobywa się ledwo widoczny dym."
    narrate "Baca chyba zainwestował w eko-drewno."
    narrate "...albo gmina go zmusiła. Uznajesz, że nie ma czasu do stracenia, ładujesz się do środka."
    narrate "Od razu po wejściu do schroniska czujesz silną woń kompotu, przed sobą dostrzegasz duży \x1b[1mstół."
    narrate "Obok stołu znajduje się ceglany \x1b[1mkominek\x1b[0m. Przed kominkiem, na bujanym fotelu siedzi starszy \x1b[1mmężczyzna."
    narrate "Po drugiej stronie stołu znajduje się \x1b[1mokienko\x1b[0m, które najpewniej jest recepcją oraz miejscem, z którego"
    narrate "przez cały dzień można pobierać ciepłe posiłki."
    write_tip "Możesz \x1b[1mspojrzeć\x1b[22m\x1b[2m na pogrubione obiekty.\x1b"
    make_visible "stol"
    make_visible "kominek"
    make_visible "okienko"
    make_visible "mezczyzna"
    hide "schronisko"
    retract(is_outside), !, nl.

-- TUTORIAL ODPOWIADANIA
spojrz_specific "stol" = do
    at_introduction,
    display_table,
    narrate "Stół jest zrobiony z silnego drewna, wygląda na lokalny wytwór. Nigdy wcześniej takiego nie widziałeś."
    narrate "słyszysz głos \x1b[1mbacy\x1b[0m siędzącego na krześle."
    baca_say('Co tam tak sznupiesz, młody? Drewno wydaje się znajome?', Result),
    narrate "Nie masz pojęcia co to może być za drewno. Zastanawiasz się co odpowiedzieć."
    write_tip "Odpowiedz mężczyźnie p/f/w"
    write_dialogue_option "p" "Nie wiem, jestem z warszawy."
    write_dialogue_option "f" "Od razu widać, że drzewo dębowe.(wymyślasz)"
    write_dialogue_option "w" "A co tam drewno, ważne, że stolik ładny."
    write_tip "Możesz odpowiadać na pytania PRAWDZIWIE (p), FAŁSZYWIE (f) lub WYMIJAJĄCO (w)"
    write_tip "Możesz odpowiedzieć za pomocą "odpowiedz(<cel>, <odpowiedź>)"
    let ans = odpowiedz "baca" "sznupanie"
    assert(looking(stol)),
    hide "stol"

    

-- KOMINEK - NIC CIEKAWEGO
spojrz_specific "kominek" = do
    display_fireplace,
    narrate "Ogień w kominku mocno się pali, drewno musiało być dodane niedawno, całkiem tu gorąco."

-- BACA - INTRODUCTION

spojrz_specific "mezczyzna" = do
    display_baca1,
    hide "mezczyzna"
    

spojrz_specific "mezczyzna" = do
    answered "baca" "sznupanie" "p"
    baca_say "\x1b[1;31m"Warszawiak w górach? W taką pogodę? Zaskakjące... w każdym razie witoj w moim schronisku, jestem Baca."

spojrz_specific "mezczyzna" = do
    answered "baca" "sznupanie" "f"
    baca_say "Na drzewach może się nie znosz, ale widzę, że dałeś radę nas ugościć.. i to w taką pogodę. Jestem Baca, witom."

spojrz_specific "mezczyzna" = do
    answered "baca" "sznupanie" "w"
    baca_say "Witoj, jestem Baca. Rozgość się..."

spojrz_specific "mezczyzna" = do
    not answered "baca" "sznupanie" "_"
    baca_say "Ło, prawie cię nie zauważyłem. Jestem Baca, witoj w moim schronisku"

spojrz_specific "mezczyzna" = do
    assert(looked(mezczyzna)),
    narrate "Baca jest starszym mężczyzną o długich, ciemnych włosach, jego sylwetka jest wyjątkowo muskularna jak na jego wiek. Musi tu ciężko pracować."
    !, nl.

-- RECEPCJA - ZAKOŃCZENIE WSTĘPU (+ tutorial odpowiadania tak/nie)

-- Odpowiedzieliśmy nie - teraz możemy wrócić do karoliny i natychmiast skończyć intro


-- Karolina introduction
spojrz_specific "okienko" = do
    not answered "karolina" "pokoj" "n"
    display_karolina,
    karolina_say ("Hej! Jestem Karolina!", "słyszysz głos zza okienka")
    karolina_say "Kuchnię niestety mamy już zamkniętą... ale pewnie chciałbyś wziąć pokój na noc?"
    karolina_say "z resztą co ja gadam... w takich warunkach nikt normalny nie wracałby do miasta..."
    narrate "Słyszysz brzdęk kluczy..."
    karolina_say "Proszę! numer 32!"
    karolina_say "Mamy dzisiaj tylko jednego innego gościa - więc powinieneś mieć spokojną noc!"
    player_say ("Dziękuję", "odpowiadasz i zabierasz klucz")
    karolina_say "Pokazać ci jak dojść do pokoju? Czy chcesz jeszcze się rozejrzeć?"
    karolina_continue_dialog_options,
    write_info('(t - skończ intro, n - zostań)'),
    let ans = odpowiedz "karolina, pokoj)), !" "nl."


spojrz_specific "okienko" = do
    let ans = odpowiedz "karolina" "pokoj"
    karolina_say "To jak? idziemy?"
    karolina_continue_dialog_options,
    write_tip "Odpowiedz na pytanie Karoliny za pomocą t lub n)"

karolina_continue_dialog_options :-
    write_dialogue_option "t" "Tak - już się rozejrzałem."
    write_dialogue_option "n" "Chcę się jeszcze rozejrzeć."

-- answer shortcuts
p :- odpowiedz(_, p).  -- prawda
f :- odpowiedz(_, f).  -- fałsz
w :- odpowiedz(_, w).  -- wymijająco
t :- odpowiedz(_, t).  -- tak
n :- odpowiedz(_, n).  -- nie
a :- odpowiedz(_, a).
b :- odpowiedz(_, b).
c :- odpowiedz(_, c).
d :- odpowiedz(_, d).

-- general answer rules, !!! MUST BE BEFORE OTHER ANSWER RULES
odpowiedz(X, _) :-
    not can_answer(X, _),
    write_info('Pytanie nie zostało do ciebie zadane przez '),
    write(X), write("."), !, nl.

-- KONWERSACJA Z BACA PO INSPEKCJI STOŁU - ODPOWIEDZI

odpowiedz(mezczyzna, X) :-
    at_introduction,
    not looked(mezczyzna),
    looking(stol),
    let ans = odpowiedz "baca" "sznupanie"
    odpowiedz(baca, X),
    retract(can_answer(mezczyzna, sznupanie)),
    retract(looking(stol)), !.

odpowiedz_specific "baca" "p" = do
    player_say ("Nigdy nie widziałem takiego drzewa proszę pana, jestem z Warszawy", "odpowiadasz")
    narrate "Mężczyzna krzywo się na ciebie patrzy i momentalnie odwraca wzrok."
    assert(baca_hates(player)),
    add_answer "baca" "sznupanie" "p", !.

odpowiedz_specific "baca" "f" = do
    player_say ("Stolik jest niezwykle solidny, od razu widać że to dąb", "odpowiadasz z przekonaniem")
    baca_say ("Jaki dąb, widziałeś gdzieś tu bęby? To stara dobra sosna.", "odpowiada mężczyzna i przewraca oczami")
    add_answer "baca" "sznupanie" "f", !.

odpowiedz_specific "baca" "w" = do
    player_say ("Co tam rodzaj drewna, grunt że wygląda naprawdę dobrze!", "odpowiadasz")
    baca_say ("Ach, dziękuję. Sam go zrobiłem, ze starej sosny co się pod izbą zwaliła zeszłego lata.", "opowiada mężczyzna")
    add_answer "baca" "sznupanie" "w", !.


odpowiedz_specific "karolina" "t" = do
    can_answer(karolina, pokoj),
    add_answer "karolina" "pokoj" "t",
    player_say ("Tak, już się rozejrzałem", "mówisz")
    karolina_say "Chodź za mną."
    write_waiting,
    endintro, !, nl.

odpowiedz_specific "karolina" "n" = do
    can_answer(karolina, pokoj),
    player_say "Chcę się jeszcze rozejrzeć."
    karolina_say ("Spoko, podejdź do okienka jak będziesz gotowy", "powiedziała z miłym wyrazem twarzy")
    add_answer "karolina" "pokoj" "n", !, nl.


add_answer "Who" "Question" "Answer" :-
    retract(can_answer(Who, Question)),
    assert(answered "Who" "Question" "A"
    !, nl.

endintro :-
    -- tty_clear,
    retractall(can_see "_"),
    retractall(can_answer(_)),
    retractall(answered(_)),
    narrate "Karolina zaprowadziła cię do twojego pokoju."
    narrate "Rozglądasz się po pokoju - obdrapane ściany, stare drewniane meble, słabe światło pojedynczej żarówki."
    narrate "Nie wygląda najlepiej, ale luksusów nie oczekiwałeś. Wyboru dużego nie miałeś - Właściwie to nie miałeś go wcale."
    player_say ("Przynajminej na głowe nie sypie...", "mruczysz pod nosem")
    narrate "Pojechałeś w góry, licząc, że na szlaku znajdziesz trochę spokoju - ucieczkę od obowiązków i niekończących się myśli o przyszłości."
    narrate "Studia powoli dobiegają końca. Jeszcze kilka miesięcy i zostaniesz rzucony w dorosłość."
    narrate "Pracy jest więcej niż kiedykolwiek, a odpowiedzialność zaczyna ciążyć jak plecak, który niosłeś przez całą drogę tutaj."
    narrate "Zrzucasz go z siebie... Wzdychasz ciężko i padasz na materac. Niemal natychmiast zasypiasz..."
    write_tip "Użyj słowa \x1b[1mstart_story\x1b[0m\x1b[2m aby rozpocząć następny rozdział."
    retract(at_introduction),
    !, nl.

-- ----------------------------------------------------------------------------- %
--                                   STAGE 1                                     %
-- ----------------------------------------------------------------------------- %

-- Dostępne zmienne:
--   - sznupanie

start_story :-
    tty_clear,
    not at_introduction,
    narrate "Budzisz się. Spoglądasz na zegarek. 1:12."
    narrate "Czujesz suchość w ustach, zmęczenie po przyjściu do schroniska spowodowało, że zapomniałeś, że od dawna nic już nie piłeś..."
    narrate "Przypominasz sobie, że na stole w holu schroniska stał \x1b[1mkompot\x1b[0m. Nie możesz przestać o nim myśleć."
    narrate "Czujesz, że nie będzie to łatwa noc."
    make_visible "kompot"

spojrz_specific "kompot" = do
    display_compote,
    narrate "Patrzysz na kompot oczami wyobraźni. Jest piekny, pachnacy owocami, ociekajacy zimnynmi kroplami. Po prostu musisz po niego pójść."
    narrate "Powoli schodzisz schodami w dół... mimo to, słyszysz ciche skrzypienie"
    narrate "Wchodzisz do holu... kątem oka zauważasz dziwny, spory \x1b[1mobiekt\x1b[0m na ziemii. Byłby całkowicie niewidoczny, gdyby nie kominek, który, dopalając się, lekko go oświetlał"
    narrate "Zauważasz też, że podłoga, po której chodzisz lekko się lepi... "i tyle zostało z kompotu..." - pomyślałeś"
    hide "kompot"
    make_visible "obiekt"

spojrz_specific "obiekt" = do
    display_dead_body,
    narrate "Zbliżasz się do dziwngo obiektu... teraz widzisz, że jest to... \x1b[36mKarolina\x1b[0m, która z zamkniętymi oczami leży na ziemi, otoczona jest plamą ciemnoczerwonego płynu... krew."
    narrate "Jesteś zszokowany. Mimowolnie zaczynasz wycofywać się, ale przypadkowo uderzasz w stół, strącając z niego szklankę..."
    narrate "Szklanka upada na ziemię natychmiast rozbijając się, przeszywając całe schronisko głośnym hukiem."
    narrate "Do pomieszczenia wbiega \x1b[1mbaca\x1b[0m oraz nieznana ci wcześniej \x1b[1mosoba\x1b[0m, pewnie to gość o którym wspominała żywa jeszcze Karolina."
    hide "obiekt"
    make_visible "baca"
    make_visible "osoba"

spojrz_specific "baca" = do
    not exploration_stage,
    display_baca2,
    narrate "Baca przybiega ze złością w oczasch"
    baca_say "KTO W MOJEJ IZBIE PO NOCY ŁOBUZI?!"
    narrate "Jego oczy od razu spadają z ciebie na leżącą obok Karolinę"
    baca_say "Co za bałagan, tyle kompotu z suszu wylać, wstawaj dziołcha, ktoś to musi posprzątać!"
    narrate "Karolina dalej leży bez ruchu, oczy bacy znowu wpatrują się w ciebie."
    baca_say "Łoo pierunie! A cóż to sie porobiło?!"
    write_tip "Odpowiedz bacy p/f/w) "
    write_dialogue_option "p" "Zszedłem i Karolina już tu leżała"
    write_dialogue_option "f" "To on już tu był (wskazujesz na gościa stojącego obok)."
    write_dialogue_option "w" "Przecież zbiegłem razem z wami."
    hide "baca"
    let ans = odpowiedz "baca, cialo)), !" "nl."

odpowiedz_specific "baca" "p" = do
    can_answer(baca, cialo),
    player_say ("Zszedłem na dół bo chciałem się napić kompotu, Karolina już tu leżała", "odpowiadasz")
    baca_say ("Czyli byłeś z nią sam na sam...", "odpowiada pod nosem baca i wpatruje ci się głęboko w oczy")
    add_answer "baca" "cialo" "p",
    finish_baca_body_question, !,
    (   baca_hates(player) ->
        baca_say ("Warszawiaku....", "mówi baca z wyraźną niechęcią")
    ; true
    ).


odpowiedz_specific "baca" "f" = do
    can_answer(baca, cialo),
    player_say "Obudził mnie huk, gdy zszedłem ten gość stał nad zwłokami Karoliny!"
    kacper_say ("Oszczerstwo!!!", "wykrzyczał w rekacji na twoje kłamstwo")
    add_answer "baca" "cialo" "f", !,
    (   baca_hates(player) ->
        baca_say ("Tyn z Warszawy i tyn z Warszawy, wszyscy siebie warci", "Baca nie wydaje się przekonany twoim wytłumaczeniem")
    ;   baca_say ("Ja slyszał że on ze stolycy, tym nigdy nie wolno ufać", "dodał Baca")
        assert(baca_hates(kacper))
    ), finish_baca_body_question.

odpowiedz_specific "baca" "w" = do
    can_answer(baca, cialo),
    player_say "Nie wiem, zbiegłem na dół razem z wami"
    baca_say ("Dziwne, nie widziałem cię.", "odpowiedział Baca z nutą niepewności")
    add_answer "baca" "cialo" "w",
    finish_baca_body_question, !.

finish_baca_body_question :-
    answered "baca" "cialo" "_"
    (   answered "kacper" "cialo" "_"
        all_dialogued
    ; true
    ).


spojrz_specific "osoba" = do
    display_kacper1,
    narrate "Gość ślamazarnie zbiega ze schodów, przez mrok ciężko ci dostrzec jego sylwetknę oraz twarz"
    narrate "Na pewno jest wysoki, wydaje się być chudy, a płomienie nadają jego twarzy lekki zarys... no i te okulary"
    kacper_say ("Jako student prawa nie godzę się na takie warunki. Ustawowo cisza nocna obowiązuje od godziny 22:00 do 6:00!", "wykrzyczał")
    narrate "Student spojrzał na Karolinę"
    kacper_say "AAAAAAAAAAAAAAAAAAAAAAAA, toż to pogwałcenie artykułu 148! Musimy zawiadomić organy ścigania!!!"
    kacper_say ("Hej ty! Jestem Kacper. Zadzwoń po pogotowie, ja zbadam miejsce zbrodni!", "powiedział Kacper po czym potknął się o stolik znajdujący się w salonie")
    narrate "odpowiedz:"
    write_dialogue_option "t" "Tu nie ma zasięgu."
    write_dialogue_option "n" "Kocham prawo!"
    hide "osoba"
    let ans = odpowiedz "kacper, cialo)), !" "nl."

odpowiedz_specific "kacper" "t" = do
    can_answer(kacper, cialo),
    player_say ("Przecież tutaj nie ma zasięgu.", "odpowiadasz")
    kacper_say ("Pff, mogłem się domyślić że ten stary dziad nie wie że telelinie można poprowadzić za pośrednictwem łącza bianalogowego.", "powiedział nonszalandzko Kacper")
    narrate "Jako student informatyki dociera do ciebie, że Kacper nie ma pojęcia o czym mówi."
    kacper_say "No nic w takim razie będziemy musieli przepowadzić resustytacje krążeniowo oddechową, ty zacznij ja poszukam gazy oraz opatrunku uciskowego"
    narrate "Kacper zniknął w ciemności, usłyszałeś tylko że znowu potknął się o ten sam stolik"
    assert(kacper_hates(baca)),   
    add_answer "kacper" "cialo" "t", !,
    finish_kacper_body_question.

odpowiedz_specific "kacper" "n" = do
    can_answer(kacper, cialo),
    player_say ("O mój boże kocham prawo! Na jakim uniwersytecie studiujesz?", "mówisz entuzjastycznie")
    kacper_say "Proszę, proszę. Miałem cię za prostaka jednak widzę, że napotkałem erudytę! Otóż mój drogi uczęszczam do Akademii Prawa i Filizofii w Warszawie."
    kacper_say "Jestem niezmiernie ciekaw twojego miejsca pobierania nauk, może mamy wspólnych znajomych!"
    write_tip "Odpowiedz Kacprowi p/f/w"
    write_dialogue_option "p" "Właściwie to studiuje informatykę."
    write_dialogue_option "f" "Eeee... Jestem na SWPSie."
    write_dialogue_option "w" "Jeszcze będzie czas na takie rozmowy, skupmy się na problemie."
    add_answer "kacper" "cialo" "n",
    assert(kacper_likes(player)),
    let ans = odpowiedz "kacper, uczelnia))" "!."

odpowiedz_specific "kacper" "p" = do
    can_answer(kacper, uczelnia),
    player_say ("W sumie to nie studiuję prawa, jestem studentem informatyki", "odpowiadasz")
    kacper_say ("Ehhh... ścisłowiec, no nic kolego, nie twoja wina że jesteś ciemnotą", "odparł rozczarowany Kacper")
    add_answer "kacper" "uczelnia" "p", !,
    finish_kacper_body_question.

odpowiedz_specific "kacper" "f" = do
    can_answer(kacper, uczelnia),
    player_say ("Eeee... Jestem na SWPSie.", "mówisz niepewnie")
    kacper_say ("O super, moja przyjaciółka tam studiuje, podobno jest całkiem w porządku, ale do mojej uczelni się nie umywa.", "powiedział dumnie")
    narrate "Kacper wyraźnie lubi się dzielić własnymi opiniami. Nawet mu przez myśl nie przeszło, żeby zapytać, czy znasz jego koleżankę..."
    add_answer "kacper" "uczelnia" "f", !,
    finish_baca_body_question.

odpowiedz_specific "kacper" "w" = do
    can_answer(kacper, uczelnia),
    player_say "Jeszcze będzie czas na takie rozmowy. Na razie skupmy się na problemie."
    kacper_say("Co racja, to racja! Musimy rozwikłać zagadkę morderstwa!"),
    add_answer "kacper" "uczelnia" "w", !,
    finish_kacper_body_question.

finish_kacper_body_question :-
    answered "kacper" "cialo" "_"
    (   answered "baca" "cialo" "_"
        all_dialogued
    ; true
    ).

all_dialogued :-
    baca_say ("Dobra, siadojcie do stołu. Nikt stąd nie wyjdzie dopóki nie wyłonimy mordercy.", "powiedział Baca i postawił na \x1b[1mstole\x1b[0m wielki dzban kompotu")
    kacper_say ("Tak!! Czekałem na ten moment całe życie! Moje umiejętności społecznej dedukcji zakończą tą sprawę w sekundę!", "wtrąca Kacper i siadając do \x1b[1mstołu\x1b[0m potyka się o jego nogę.")
    (   baca_hates(kacper) ->
        narrate('Baca spogląda na Kacpra z zażenowaniem')
    ; narrate('Ukradkiem spoglądasz na Bacę próbując zauważyć gniew w jego oczach...')
    ),
    narrate "Baca zauważa, że się mu przyglądasz"
    (   baca_hates(player) ->
        baca_say "A ty czego się patrzysz!?"
    ;   narrate('Baca patrzy ci prosto w oczy.')
    ),
    narrate "Odwracasz spojrzenie."
--    write_info('Od teraz masz dostęp do polecenia: \x1b[1moskarz(baca/kacper)\x1b[0m'),
--    write_info('Wywołanie polecenia spowoduje oskarżenie postaci o morderstwo i natychmiastowy koniec gry.'),
--    write_info('W zależności od twoich relacji z postaciami, oskarżenie może mieć różny wynik'),
--    assert(can_accuse),
    make_visible "stol"

-- ----------------------------------------------------------------------------- %
--                                    STAGE 2                                    %
-- ----------------------------------------------------------------------------- %
-- Rozmowy przy stole z Bacą i Kacprem, ogarnianie kto zabił Karolinę.

spojrz_specific "stol" = do
    not at_introduction,
    not exploration_stage,
    narrate "Zasiadasz do stołu z Bacą i Kacprem. Ogień w kominku już się dopala..."
    narrate "Przed tobą stoi najprawdopodobniej ostatni \x1b[1mdzban\x1b[0m słynnego kompotu \x1b[36mKaroliny.\x1b[39m"
    narrate "Zauważasz, że Kacper trzyma ręce pod stołem i nerwowo spogląda naprzemiennie na ciebie i na Bacę."
    narrate "Baca z kolei, wydaje się spokojny, spogląda na Ciebie oraz Kacpra z wyższością... do tego stopnia, że zaczynasz drugi raz zastanawiać się, czy to nie ty zabiłeś Karolinę..."
    make_visible "dzban"
    !, true.

spojrz_specific "dzban" = do
    not at_introduction,
    narrate "Nalewasz kompot do szklanki i szybko pochłaniasz jej zawartość."
    player_think ("Wśród nich jest morderca. Muszę dowiedzieć się kto nim jest. No i zdobyć na to jakiś dowód...", "myślisz sobie")
    write_waiting,
    narrate "Mija dłuższa chwila milcznia - dociera do ciebie, że musisz ją przełamać - inaczej będziecie trwać w impasie."
    !, next_stage.

next_stage :-
    not at_introduction,
    display_player_talking,
    player_say "Posłuchajcie. To nie ja zabiłem Karolinę. Wczoraj, kiedy tu przyjechałem, byłem padnięty."
    player_say "Zameldowałem się tu i od razu położyłem się spać. Poza tym... Mój boże! Zabić człowieka??!"
    player_say ("I to taką miłą osobę, w życiu bym tego nie zrobił!", "przerywasz na moment aby złapać oddech")
    player_say ("I szczerze mówiąc nie wyobrażam sobie, żeby to był ktoś z was...", "starasz się brzmieć szczerze")
    narrate "Tak na prawdę wcale tak nie uważasz, po prostu chcesz się rozejrzeć."
    player_say "Nie mówie, że na pewno, ale możliwe, że to był ktoś z zewnątrz..."
    player_say "Tylko kurde... W taką zamieć? Musiał to być jakiś miejscowy."
    baca_say ("Uj ci zaraz miejscowy! Pewno jaki mieszczuch sie przypałętał i łokraść mnie chciał!", "wykrzyknął baca")
    baca_say "Tera to te mieszczuchy szczwańsze niż kiedyś..."
    baca_say "A Karolina, że dobra dziołcha, bronić chciała mojego schroniska, to jeno ją załatwił."
    player_say ("W każdym razie, jak na mój gust to musimy się rozejrzeć za znakami włamania.", "dodajesz")
    narrate "Kacper widocznie lekko się uspokoił. Entuzjazm i podekscytowanie zastąpiło niepokój na jego twarzy."
    kacper_say ("Świetnie prawisz! Poszukam monochlorku sodu i zdobędę odcisk palca złoczyńcy!", "powiedział dumnie")
    narrate "Kacper żywo wstał od stołu i ruszył szukać nieisniejącego monochlorku sodu"
    narrate "Iiiiiiii potknął się o stolik w salonie. Znowu..."
    baca_say ("Jo też sie rozejrzu.", "powiedział baca podnosząc się z krzesła")
    baca_say ("Ahhhh", "westchnął")
    baca_say "Coś mnie w krzyżu łupi. Zacznijcie sami, jo do was dołączę późnij."
    write_info('Za chwilę przejdziesz do kolejnej fazy gry, w której będziesz rozglądał się za poszlakami'),
    write_tip "Możesz do niej przejść poleceniem \x1b[1mrozpocznij_eksploracje\x1b[0m."
    assert(exploration_stage), !, true.


rozpocznij_eksploracje :-
    make_visible "kuchnia"
    narrate "Wstajesz od stołu. Chcesz się rozejrzeć"
    spojrz(kuchnia),
    write_info('Możesz teraz eksplorować schronisko, aby zakończyć eksploracje i skonfrontować znaleziska dostań się do kuchni i spojrz na stol.'),
    write_info('Przejdziesz wtedy do finalnej rozmowy z Bacą i Kacprem rzucając swoje oskarżenie i argumentując je.'),
    write_tip "Po mapie poruszasz się używając komendy \x1b[1mspojrz\x1b[0m, przydatna okazać się może komenda \x1b[1mlvo\x1b[0m - listująca widoczne obiekty"
    write_tip "Aby wyświetlić mapę użyj komendy show_map."

-- KUCHNIA

spojrz_specific "kuchnia" = do
    exploration_stage,
    retractall(can_see "_"),
    make_visible "baca"
    make_visible "lodowka"
    make_visible "zlew"
    make_visible "stol"
    make_visible "salon"
    narrate "Kuchnia to niewielkie, całkiem przytulne miejsce. W rogu stoi stara \x1b[1mlodówka\x1b[0m, cicho bucząca."
    narrate "Obok \x1b[1mlodówki\x1b[0m znajduje się kuchenny blat, a na nim \x1b[1mzlew\x1b[0m. Na środku pomieszczenia znajduje się"
    narrate "drewniany \x1b[1mstol\x1b[0m, przy którym siedzi \x1b[1mbaca\x1b[0m. Tuż obok jest przejście do \x1b[1msalonu\x1b[1m."

spojrz_specific "zlew" = do
    display_sink,
    narrate "Zlew wygląda zupełnie zwyczajnie - czysta stal, sucha powierzchnia, brak zalegających naczyń."
    narrate "Jednak gdy przyglądasz się uważniej, w prawym rogu dostrzegasz \x1b[1mzabrudzenie\x1b[0m, rozmazane i nierówno starte,"
    make_visible "zabrudzenie"

spojrz_specific "zabrudzenie" = do
    narrate "Przglądasz się zabrudzeniu, nie jest bardzo widoczne - jest rozmazane i nierówno starte."
    narrate "Kolor ma ciemnoczerwony..."
    player_think ("Teraz już jestem pewny, że to ktoś z nich! Tylko kto...", "myślisz sobie")
    player_think ("Na pewno musi słabo widzieć, skoro zmywał ten ślad i nie zauważył, że dalej jest widoczny", "wnioskujesz")
    narrate "Ta wiadomość dużo ci nie dała, oboje baca, jak i kacper słabo widzą... Kacper ma wadę wzroku, a baca jest stary."
    hide "zabrudzenie"

spojrz_specific "lodowka" = do
    display_fridge,
    narrate "Lodówka jest stara, zwyczajna, a jej biała farba w kilku miejscach zaczyna się łuszczyć. Na uchwycie zwisają kuchenne ścierki."
    narrate "Otwierasz drzwiczki - lekko skrzypią. W środku są powidła, kiełbasa, smalec i jajka - nie ma tu nic ciekawego"

spojrz_specific "baca" = do
    exploration_stage,
    display_baca_smoking,
    narrate "Baca dalej siedzi przy stole - chyba ból jeszcze go nie opuścił. Pali fajkę próbując go przeczekać."

spojrz_specific "stol" = do
    exploration_stage,
    write_info('Spojrzenie na stół będzie przeniesie cie do następnego etapu gry. Nie będziesz mógł już eksplorować'),
    write_info('Czy jesteś pewny, że chcesz przejść dalej?'),
    write_dialogue_option "t" "Tak, chcę przejść dalej."
    write_dialogue_option "n" "Nie, chcę się jescze rozejrzeć."
    let ans = odpowiedz "game, final_stage))" "!."


odpowiedz_specific "game" "t" = do
    can_answer(game, final_stage),
    retract(can_answer(game, final_stage)),
    last_stage, !.

odpowiedz_specific "game" "n" = do
    narrate "Wróć tu, gdy będziesz gotowy przejść do następnego etapu. Powodzenia!"
    retract(can_answer(game, final_stage)), !.

-- SALON

spojrz_specific "salon" = do 
    exploration_stage,
    retractall(can_see "_"),
    make_visible "kuchnia"
    make_visible "przedsionek"
    make_visible "gora"
    make_visible "piwnica"
    make_visible "pokoj_bacy"
    make_visible "kacper"
    make_visible "cialo"
    narrate "Wchodzisz do salonu, największego pomieszczenia w schronisku. Drewniane ściany są ozdobione starymi fotografiami i myśliwskimi trofeami."
    narrate "Po środku pokoju leży martwe \x1b[1mciało\x1b[0m Karoliny i kałużę krwi. Obok przy ścianie, \x1b[1mKacper\x1b[0m stoi przy kominku."
    narrate "Z prawej strony są drzwi do \x1b[1mprzedsionka\x1b[0m. Na wprost widzisz schody prowadzące na \x1b[1mgórę\x1b[0m, oraz do \x1b[1mpiwnicy\x1b[0m."
    narrate "Zaraz obok schodów znajduje się \x1b[1mpokój Bacy\x1b[0m."
    write_tip('Do pokoju Bacy odwołuj się jako pokoj_bacy').

spojrz_specific "cialo" = do
    exploration_stage,
    display_dead_body,
    narrate "W miarę jak zbliżasz się do ciała powietrze staje się coraz cięższe, a metaliczny zapach krwi bardziej wyraźny."
    narrate "Ciało Karoliny leży na drewnianej podłodze, otoczona ciemniejącą kałużą krwi. Jej oczy są szeroko otwarte,"
    narrate "jakby w ostatnich chwilach próbowała zrozumieć co się stało. Twarz zastygła w wyrazie bólu i zaskoczneia."
    narrate "Na jej swetrze zauważasz 3 głębokie rany. Ciemne plamy krwi rozlały się wokół nich, wsiąkając w materiał."
    player_think ("Wygląda mi to na rany po nożu .", "wnioskujesz")

spojrz_specific "przedsionek" = do
    exploration_stage,
    display_entryway,
    narrate "Widzisz drewniany przedsionek z prostą ławką i rzędem haczyków na ścianie. Na nich wiszą ciężkie, zimowe kurtki."
    narrate "Drewniana podłoga skrzypi lekko pod stopami. Nie ma tu nic interesującego, wychodzisz i zastanawiasz się co teraz zrobić."

spojrz_specific "kacper" = do
    exploration_stage,
    not answered "kacper" "kominek" "_"
    display_kacper_near_fireplace,
    narrate "Zbliżasz się do Kacpra. Trzymając w ręku drewno na zmianę pochyla się i prostuje. Wygląda jakby miał z czymś problem."
    kacper_say ("Czemuż nie chcesz współpracować, ty iskro z piekła rodem?!", "krzyczy do siebie")
    kacper_say "Wykład z prawa rzymskiego twierdził jasno: „Pacta sunt servanda”... a jednak drewno i ogień nie zawarły żadnego paktu. Zaiste, zdrada!"
    narrate "Widać jak na tacy, że Kacper nie potrafi otworzyć kominka, żeby dorzucić drewno. Łapiesz się za głowę..."
    narrate "Chwilę później zauważa że stoisz obok niego i mówi do Ciebie:"
    kacper_say "Próbowałem już wszystkiego: dmuchałem, pouczałem, groziłem sankcjami prawnymi… ale ogień — ten niemy barbarzyńca — nie reaguje."
    kacper_say "Jako przedstawiciel akademickiej jurysprudencji nie jestem przeszkolony w dziedzinie stosów drzewnych ani piekielnej alchemii cieplnej"
    kacper_say "Pomożesz mi dorzucić drewno? Ogień już przygasa, a i tak jest zimno. Nie chcę się rozchorować."
    player_think ("Przez całą sytuację z ciałem Karoliny nawet nie zwróciłeś uwagi na temperaturę. Faktycznie jest dość zimno.", "myślisz sobie")
    kacper_say "To jak? Pomożesz mi czy nie?"
    write_tip "Odpowiedz Kacprowi t/n"
    write_dialogue_option "t" "Pewnie."
    write_dialogue_option "n" "Teraz nie mam na to czasu - chcę się rozejrzeć"
    let ans = odpowiedz "kacper, kominek))" "!."

odpowiedz_specific "kacper" "t" = do
    exploration_stage,
    can_answer(kacper, kominek),
    player_say ("Pewnie. Może chociaż temperatura nie będzie jak w kostnicy.", "mimowolnie zarzuciłeś żartem")
    narrate "Kacper zmarszczył brwi - chyba twój żart mu się nie spodobał."
    narrate "Dorzucasz drewno do kominka. Słyszysz krzyk bacy z daleka."
    baca_say "Łoszaleliśta! Z dymem mnie puścić chcecie?! Myślicie, że drewno to z nieba spada?!"
    narrate "Obydwaj z Kacprem zdajecie się udawać, że nic nie słyszeliście."
    kacper_say ("Dzięki za pomoc. Przynajmniej nie zamarzniemy.", "powiedział")
    kacper_say "Posiedzę tu jeszcze, żeby się ogrzać. W zimnie fluorescencja w mózgu działa wadliwie"
    player_think ("Zimno jest, ale nie wytrzymam przy nim. Cały czas gada takie głupoty... Rozejrzę się.", "myślisz sobie")
    narrate "Odchodzisz od kominka"
    add_answer "kacper" "kominek" "t", !.

odpowiedz_specific "kacper" "n" = do
    exploration_stage,
    can_answer(kacper, kominek),
    player_say ("Teraz nie mam na to czasu. Chcę się rozejrzeć i jak najszybciej wyjaśnić sprawę.", "odpowidasz")
    kacper_say "Oczywiście… cóż za naiwność z mej strony. Liczyć na solidarność w czasach tak niepewnych, to jak oczekiwać jasności prawa w ustawie podatkowej"
    kacper_say "Nie szkodzi. Niech zatem zgaśnie płomień. Niech ciemność obejmie ten przybytek chłodem egzystencjalnej nicości."
    kacper_say "Skoro ogień nas opuścił, może i my powinniśmy się przygotować… na koniec."
    kacper_say "To tutaj. W tym salonie, wśród wspomnień i pleśni, zakończy się historia człowieka. Niegodnie. Zmarzniętego. Bez koca. Bez sensu. I bez nadziei"
    player_think ("Ale dramatyzuje... Idę rozglądać się dalej.", "pomyślałeś")
    add_answer "kacper" "kominek" "n", !.

spojrz_specific "kacper" = do
    exploration_stage,
    answered "kacper" "kominek" "t"
    display_kacper_warming,
    narrate "Kacper dalej stoi i wygrzewa się przy kominku. Zdaje się być zbamyślony"

spojrz_specific "kacper" = do
    exploration_stage,
    answered "kacper" "kominek" "n"
    display_kacper_near_fireplace,
    narrate "Widzisz, że Kacper dalej grzebie przy kominku. Ty mu nie pomożesz - wolisz się rozejrzeć"

-- PIWNICA

spojrz_specific "piwnica" = do
    exploration_stage,
    display_basement,
    retractall(can_see "_"),
    make_visible "salon"
    make_visible "polka"
    make_visible "obraz"
    make_visible "laptop"
    make_visible "torebka"
    narrate "Schodisz do piwnicy. Zauważasz że są tam jedne drzwi. Przechodzisz przez nie. Spodziewałeś się jakiegoś pomieszczenia gospodarczego."
    narrate "To co widzisz bardziej przypomina... zwykły pokój. No prawie... Jest jeszcze mniejszy od twojego."
    narrate "Na wprost wejścia widzisz łóżko przykryte zmiętą narzutą - jakby ktoś przed chwilą na niej leżał."
    narrate "Z lewej stoi \x1b[1mpółka\x1b[0m z książkami. Na ścianie wisi \x1b[1mobraz\x1b[0m"
    narrate "Z prawej widzisz biórko na którym leży \x1b[1mlaptop\x1b[0m oraz damska \x1b[1mtorebka\x1b[0m - Zdaje się, że to pokój Karoliny."
    narrate "I oczywiście za sobą masz schody prowadzące do \x1b[1msalonu\x1b[0m."

spojrz_specific "obraz" = do
    exploration_stage,
    display_basement_picture,
    narrate "Obraz przedstawia górala w tradycyjnym stroju, ukazanego od ramion w górę. Jego twarz"
    narrate "wyraża siłę i determinację, z charakterystycznym, mocnym spojrzeniem."
    player_think ("Mam wrażenie, że skądś kojarze tego górala...", "myślisz sobie")

spojrz_specific "polka" = do
    exploration_stage,
    display_shelf,
    narrate "Na półce dostrzegasz same klasyczne dzieła polskiej literatury - Pan Tadeusz, Dziady, Potop... Nie widzisz nic innego."
    narrate "Książki są dośc stare, ale zadbane. Każda opakowana jest w elegancką skórzaną oprawkę."

spojrz_specific "laptop" = do
    exploration_stage,
    display_laptop,
    narrate "Laptop z góry jest cały obklejony naklejkami - kompletnie ze sobą nie powiązanymi, jakby ktoś przyklejał wszystko co mu w ręce wpadło."
    narrate "Laptop jest podpięty kablem ethernet - ma dostęp do internetu"
    narrate "W każdym razie nie jego wygląd jest najważniejszy, ale czy uda się coś znaleźć w środku."
    narrate "Otwierasz laptopa... I - zabezpieczony hasłem :("
    narrate "Prawie byś już zrezygnował, ale nagle wpada ci pomysł do głowy."
    narrate "Wpisujesz hasło "1234" i wciskasz enter."
    write_waiting,
    narrate "Zostałeś pomyślnie zalogowany. Pierwsze co widać na ekranie to otwarty dymek czatu z koleżanką karoliny"
    karolina_say "to już jest gruba przesada"
    karolina_say "ten dziad kolejny miesiąc spóźnia się z wypłatą"
    karolina_say "dzisiaj to z nim skonfrontuje"
    karolina_say "jak mi nie zapłaci to będziemy się sądzić"
    narrate "Wiadomości wysłane koło godziny 19..."
    player_think ("Może byłby milszy, gdybyś do niego dotrwała", "myślisz sobie")
    assert(looked(laptop)),
    !.

spojrz_specific "torebka" = do
    exploration_stage,
    display_bag,
    narrate "Jest to zwykła kórzana torba w ciemnym brązie, z gładką powierzchnią i solidnym zamkiem."
    narrate "W jej wnętrzu dostrzegasz małą kosmetyczkę, książkę virginii woolf, oraz czarny \x1b[1mzeszyt\x1b[0m, na którego okładce napisane jest "NIE CZYTAĆ"."
    make_visible "zeszyt"
    !.

spojrz_specific "zeszyt" = do
    exploration_stage,
    narrate "Ignorując napis na okładce otwierasz zeszyt i zaczynasz go przeglądać. Szybko orientujesz się, że jest to pamiętnik."
    narrate "Przechodzisz do poszukiwania najnowszego wpisu - może on da jakąś wskazówkę."
    narrate "3 marca"
    narrate "Dziś Kacper znów próbował się do mnie zbliżyć. Na początku myślałam, że"
    narrate "tylko mi się wydaje, ale jego zachowanie staje się coraz bardziej nachalne"
    narrate "Chociaż starałam się być delikatna, powiedziałam mu wprost, że nie jestem"
    narrate "nim zainteresowana. Z resztą kto by był? To dzieciak z wybujanym ego, który"
    narrate "myśli, że używanie szykownych słówek sprawi, że będzie postrzegany jako "
    narrate ""ten inteligenty" - najgorsze, że to co mówi praktycznie nigdy nie ma sensu."
    narrate "W każdym razie, po tym zaczął zachowywać się dziwnie. To znaczy nie zrobił"
    narrate "nic strasznego, ale mam wrażenie, że zaczął być inny. Boje się, że jest"
    narrate "jakimś psycholem i coś mi zrobi - tak przynajmniej podpowiada mi intuicja."
    narrate "Ahhhh... Mam nadzieję, że jutro będzie milszy dzień."
    assert(looked(zeszyt)),
    !.


-- POKÓJ BACY

spojrz_specific "pokoj_bacy" = do
    exploration_stage,
    retractall(can_see "_"),
    make_visible "ciupaga"
    make_visible "papiery"
    make_visible "salon"
    narrate "Wchodzisz do pokoju i przymykasz za sobą drzwi do \x1b[1msalonu\x1b[0m."
    narrate "Pokój Bacy jest surowy i oszczędny, jakby odzwierciedlał charakter jego właściciela."
    narrate "Posiada zwykłe pojedyncze łóżko. W rogu pokoju, oparta o ścianę stoi góralska \x1b[1mciupaga\x1b[0m."
    narrate "Na prostym biurku leżą porozrzucane \x1b[1mpapiery\x1b[0m. W powietrzu unosi się zapach tytoniu i żywicy."


spojrz_specific "papiery" = dob
    exploration_stage,
    display_papers,
    narrate "Na biurku leży sterta porozrzucanych papierów, niechlujnie ułożonych w różnych miejscach."
    narrate "Wśród papierów wyróżniają się notatki, które wskazują na ogromne kłopoty finansowe Bacy."
    narrate "Rachunki, wezwania do zapłaty, zapiski z tak licznymi kwotami, że aż nie wierzysz własnym oczom."
    narrate "W jednym z dokumentów zauważasz szczególną pozycję, która powtarza się w różnych miejscach - leczo."
    narrate "Wydaje się, że prawie wszystkie pieniądze Bacy idą na zakup składników na to danie."
    narrate "Brzmi to podobnie jak w tej paście internetowej..."
    narrate "W każdym razie wynika z tego, że Baca tonie w długach."
    assert(looked(papiery)), !.

spojrz_specific "ciupaga" = do
    exploration_stage,
    display_ciupaga,
    narrate "Ciupaga jest stara, ale zadbana. Wykonana jest z drewna, dokładnie starrannie zdobiona."
    player_think ("WOW - wygląda nieźle", "myślisz sobie")



-- GÓRA

spojrz_specific "gora" = do
    exploration_stage,
    retractall(can_see "_"),
    make_visible "salon"
    make_visible "twoj_pokoj"
    make_visible "pokoj_kacpra"
    narrate "Wchodzisz schodami na górę. Widzisz kilka pustych pokojów, do tego \x1b[1mtwój pokój\x1b[0m, oraz"
    narrate "jak się domyślasz - \x1b[1mpokój Kacpra\x1b[0m. Dostrzegasz też drzwi do łazienki."


spojrz_specific "twoj_pokoj" = do
    exploration_stage,
    not looked(twoj_plecak),
    narrate "Wchodzisz do swojego pokoju. Zastanawiasz się w sumie po co to zrobiłeś, przecież raczej nic tu nie znajdziesz"
    narrate "Jednak dziwi cie to, że \x1b[1mtwój plecak\x1b[0m zdaje się być inaczej ułożony, niż go odkładałeś."
    make_visible "twoj_plecak"

spojrz_specific "twoj_pokoj" = do
    exploration_stage,
    looked(twoj_plecak),
    narrate "Ponownie wchodzisz do swojego pokoju i nie ma tu już nic ciekawego. Momentalnie wychodzisz."

spojrz_specific "twoj_plecak" = do
    exploration_stage,
    narrate "Nie dawało ci to spokoju - coś z tym plecakiem zdaje się być nie tak. Przeglądasz kieszonki - nic wszystko się zgadza."
    narrate "Zaglądasz do dużej kieszeni i nie możesz uwierzyć własnym oczom..."
    narrate "Widzisz opakowany w torebkę foliową nóż, ze śladami krwi."
    player_think ("Ktoś próbuje mnie wrobić! Muszę się tego jakoś pozbyć.", "myślisz sobie")
    narrate "Jak najciszej otwierasz okno i wyrzucasz przez nie nóż z całej siły."
    write_info('Gratulacje pozbyłeś się dowodu na siebie!'),
    hide "twoj_plecak"
    assert(looked(twoj_plecak)), !.

spojrz_specific "pokoj_kacpra" = do
    exploration_stage,
    narrate "Pokój Kacpra wygląda identycznie jak twój - stary, ciasny. Na szafce nocnej leżą książki z literaturą."
    narrate "Obok łóżka dostrzegasz skórzaną, ciemnobrązową \x1b[1maktówkę Kacpra\x1b[0m."
    make_visible "aktowka_kacpra"

spojrz_specific "aktowka_kacpra" = do
    exploration_stage,
    narrate "W aktówce panuje porządek - zbyt wielu rzeczy nie ma w środku - klucze, portfel, telefon i jakiś zeszyt"
    narrate "Zaglądasz do tego zeszytu. Pełen jest wierszy. Sam na wierszach się nie znasz, ale nie wydają się szczególnie górnolotne."
    narrate "Przewijasz do ostatniej najświeższej strony i zauważasz tam:"
    narrate "Odrzuciła mnie, nic nie czuję,"
    narrate "Jestem pusty, tylko cień,"
    narrate "Ona śmieje się, patrzy na mnie z góry."
    narrate "..."
    narrate "Nie pośmieje się za długo."
    assert(looked(aktowka_kacpra)), !.


show_map :-
    exploration_stage,
    display_ground_floor_map, !, true.

-- ----------------------------------------------------------------------------- %
--                                  LAST STAGE                                   %
-- ----------------------------------------------------------------------------- %


last_stage :-
    baca_hates(player),
    not looked(twoj_plecak),
    narrate "Powoli odsuwasz krzesło, siadając do stołu zauważasz, że Baca nie odrywa od ciebie wzroku..."
    player_think ("O co mu właściwie chodzi? Przecież nawet nie ma opcji, że wydaje mu- ", "nie zdążyłeś skończyć myśli")
    narrate "Słyszysz, że za twoimi plecami Kacper zbiega ze schodów"
    kacper_say "ZNALAZŁEM! ZNALAZŁEM! WIEM KTO ZABIŁ KAROLI-"
    narrate "... Nagle słyszysz głośny huk. Kacper spada ze schodów i rzuca przed siebie swoje znalezisko"
    baca_say "No no, mody... teraz to się wkopałeś..."
    narrate "Powiedział Baca, ciągle nie odrywając od ciebie wzroku... Kacper wciąż leży na ziemii..."
    baca_say "Myślałeś, że nie poznamy prawdy, warszawski morderco!?"
    narrate "Baca chwyta za ciupagę. Widzisz tylko jak w mgnieniu oka się nią zamachuje i... padasz na ziemię."
    narrate "Budzi cię krzyk kacpra..."
    kacper_say "TAK PANIE BACO!!! MAMY GO!!!"
    narrate "Chcesz wyjaśnić Kacprowi co się wydarzyło... ale przez ból nie jesteś w stanie wydobyć z siebie ani słowa..."
    narrate "Baca zauważa, że zaczynasz odzyskiwać przytomność... pewnym ruchem łapie za twoją koszulę i wyrzuca cię na \x1b[1mdwór\x1b[0m"
    make_visible "dwor"

last_stage :-
    not looked(twoj_plecak),
    narrate "Powoli odsuwasz krzesło, siadając do stołu zauważasz, że Baca ciągle patrzy na schody... jakby czegoś oczekując"
    narrate "Słyszysz, że za twoimi plecami Kacper zbiega ze schodów"
    kacper_say "ZNALAZŁEM! ZNALAZŁEM! WIEM KTO ZABIŁ KAROLI-"
    narrate "... Nagle słyszysz głośny huk. Kacper spada ze schodów i rzuca przed siebie swoje \x1b[1mznalezisko\x1b[0m"
    baca_say "No no... co my tutaj mamy..."
    narrate "Kacper szybko wstaje z ziemii..."
    kacper_say "TO ON ZABIŁ KAROLINĘ!!!"
    narrate "Kacper pokazuje na ciebie..."
    make_visible "znalezisko"

last_stage :-
    looked(twoj_plecak),
    (   answered "kacper" "kominek" "t"
        baca_reavealing_bloodstain
    ;   baca_say "I jak młodzi? Znaleźiśta coś?"
    ),
    assert(can_accuse),
    let ans = odpowiedz "baca" "odkryte_informacje"
    write_info('Jesteś w ostatniej fazie gry. Możesz skonfrontować informacje odkryte w fazie eksploracji.'),
    write_info('Dostajesz również dostęp do komendy oskarż, która spowoduje wyprowadzenie oskarżenia w stronę bacy lub kacpra'),
    write_info('Sukces twojego oskarżenia zależy od odkrytych informacji, ale też od relacji ustanowionych z innymi osobami.'),
    finale_display_possible_options, !.


finale_display_possible_options :-
    (   looked(laptop), not answered "baca" "odkryte_informacje" "a"
        write_dialog_option('a', 'Baca nie płacił Karolinie i miała to z nim skonfronotwać.')
    ;   write_dialog_option('-', 'OPCJA NIEDOSTĘPNA')
    ),
    (   looked(papiery), not answered "baca" "odkryte_informacje" "b"
        write_dialog_option('b', 'Baca tonie w długach.')
    ;   write_dialog_option('-', 'OPCJA NIEDOSTĘPNA')
    ),
    (   looked(zeszyt), not answered "baca" "odkryte_informacje" "c"
        write_dialog_option('c', 'Karolina odrzuciła Kacpra. Kobieca intuicja mówiła jej, że jest groźny')
    ;   write_dialog_option('-', 'OPCJA NIEDOSTĘPNA')
    ),
    (   looked(aktowka_kacpra), not answered "baca" "odkryte_informacje" "d"
        write_dialog_option('d', 'Kacper ma w zeszycie wiersz, który sugeruje, że jest niestabilny psychicznie.')
    ;   write_dialog_option('-', 'OPCJA NIEDOSTĘPNA')
    ), !.

last_stage_more_clues :-
    baca_say "Coś jeszcze?"
    finale_display_possible_options, !.

odpowiedz(baca, a) :-
    can_accuse,
    not answered "baca" "odkryte_informacje" "a"
    assert(answered "baca" "odkryte_informacje" "a"
    player_say "Baca nie płacił Karolinie, wczoraj miała z nim to skonfrontować i już chciała się z nim sądzić"
    baca_say "Tak, skonfrontowała to ze mną i właśnie jej zapłaciłem"
    (   answered "baca" "odkryte_informacje" "b"
        kacper_say "Ciekawe z czego! Przecież toniesz w długach"
        last_stage_more_clues
    ;   last_stage_more_clues
    ), !.

odpowiedz(baca, b) :-
    can_accuse,
    not answered "baca" "odkryte_informacje" "b"
    assert(answered "baca" "odkryte_informacje" "b"
    player_say "Baca tonie w długach. I to na takie kwoty, że aż wierzyć mi się nie chce."
    baca_say ("Jestem zadłużony, jo. Ale co to ma do zabójstwa Karoliny?", "powiedział")
    (   answered "baca" "odkryte_informacje" "a"
        kacper_say "Aha!!! Czyli nie miałeś z czego zapłacić Karolinie!"
        last_stage_more_clues
    ;   last_stage_more_clues
    ), !.

odpowiedz(baca, c) :-
    can_accuse,
    not answered "baca" "odkryte_informacje" "c"
    assert(answered "baca" "odkryte_informacje" "c"
    player_say "Karolina odrzuciła zaloty Kacpra i jej kobieca intuicja mówiła jej, że jest niebezpieczny."
    kacper_say ("Tak, odrzuciła mnie... to prawda.", "przyznał smutno")
    kacper_say "Ale to wcale nie znaczy, że ja ją skrzywdziłem."
    kacper_say ("Nigdy bym czegoś takiego nie zrobił...", "dodał")
    (   answered "baca" "odkryte_informacje" "d"
        baca_say "Oj mieszczuchu... Twoje zapiski mówią inaczej"
        last_stage_more_clues
    ;   last_stage_more_clues
    ), !.

odpowiedz(baca, d) :-
    can_accuse,
    not answered "baca" "odkryte_informacje" "d"
    assert(answered "baca" "odkryte_informacje" "d"
    player_say "Kacper napisał dziwny wiersz, który może świadczyć, że jest niestabilny psychicznie."
    baca_say ("Przynieś no ten wiersz Kacper. Zobaczymy co żeś tam napisał", "powiedział")
    narrate "Kacper przyniósł wiersz i go przeczytał"
    (   answered "baca" "odkryte_informacje" "c"
        baca_say "No powiedziałbym, żeś się na piśmie do bczynu przyznał!"
        last_stage_more_clues
    ;   last_stage_more_clues
    ), !.



baca_reavealing_bloodstain :-
    baca_say ("I jak tam młodzi?... Uuuf ale gorąco", "powiedział baca i zdjął gruby sweter")
    narrate "To co się pod nim znalazło odjęło wam mowę - zobaczyliście na jego białej góralskiej koszuli plamę krwi."
    kacper_say ("CO TO JEST?!!!!", "krzyknął w przerażeniu kacper, wskazując palcem na plamkę krwi")
    narrate "Baca spojrzał się na swoją koszulę i powiedział spokojnym głosem:"
    baca_say "Aaaa, o to wam się rozchodzi. Nie bójcie się. Zarzynałem wczoraj koguta na rosół. Musioł żem nie zauważyć, że mi na koszulę chlapło."
    narrate "Ta sytuacja wzbudziła w Kacprze podejrzliwość do bacy."
    baca_say "W każdym razie jak tam młokosy? Znaleźliśta coś?"

spojrz_specific "znalezisko" = do
    narrate "Przyglądasz się znalezisku Kacpra... zauważasz, że jest to twój plecak..."
    kacper_say "A teraz.. Panie i Panowie.. hehe.. a raczej panowie.. przejdźmy do meritum!"
    narrate "Kacper wyciąga z głównej kieszeni plecaka foliową torebkę, ale upuszcza ją na stół..."
    narrate "Z torebki wypada nóż... jest cały pokryty krwią..."
    player_think('Ten głupi student mnie wrobił...', pomyślałeś),
    player_say "Baca! To nie tak jak myślisz... Kacper ewidentnie mnie wrobił! Nie miałbym powodu zabijać Karoliny!"
    baca_say "Mhmmm.. Kacprze.. myślę, że twoje dowody stanowią.. em.. Absolutum tej sprawy.. tak.. mhm.."
    kacper_say "TAK! PANIE BACO! WIEDZIAŁEM, ŻE W KOŃCU SIĘ ZROZUMIEMY!"
    baca_say "To co, młody, wyjdziesz stąd sam, czy mam cię zmusić!?"
    kacper_say "Panie Baco! Powinniśmy najpierw zebrać dowody... na pewno GOPR jest w okolicy!"
    baca_say "Nie, Warszawiaku, załatwimy to po góralsku..."
    player_think ("Muszę teraz ostrożnie dobierać słowa...", "")
    let ans = odpowiedz "baca" "wypad"
    write_tip "Odpowiedz Bacy"
    write_dialogue_option "t" "Tym razem wygrałeś... Kacper... już wychodzę... ale wiedz, że to nie ja ją zabiłem, Baco."
    write_dialogue_option "n" "Nie wyjdę z tego pomieszczenia dopóki nie udowodnię wam swoją niewinność!"

odpowiedz_specific "baca" "t" = do
    can_answer(baca, wypad),
    narrate "Powoli zakładasz buty... Ostatni raz patrzysz na schronisko..."
    narrate "Może gdybyś dokładniej je przeszukał, udałoby ci się znaleźć mordercę..."
    narrate "Otwierasz drzwi i wychodzisz na \x1b[1mdwór\x1b[0m"
    make_visible "dwor"
    add_answer "baca" "wypad" "t", !.

odpowiedz_specific "baca" "n" = do
    baca_say "sam się o to prosiłeś, młody..."
    narrate "Baca chwyta za ciupagę. Widzisz tylko jak w mgnieniu oka się nią zamachuje i... padasz na ziemię."
    narrate "Budzi cię krzyk kacpra..."
    kacper_say "TAK PANIE BACO!!! MAMY GO!!!"
    narrate "Chcesz wyjaśnić Bacy co się wydarzyło... ale przez ból nie jesteś w stanie wydobyć z siebie ani słowa..."
    narrate "Baca zauważa, że zaczynasz odzyskiwać przytomność... pewnym ruchem łapie za twoją koszulę i wyrzuca cię na \x1b[1mdwór\x1b[0m"
    make_visible "dwor"
    add_answer "baca" "wypad" "t", !.


-- ----------------------------------------------------------------------------- %
--                                    ENDINGS                                   %
-- ----------------------------------------------------------------------------- %



oskarz(baca) :-
    can_accuse,
    retract(can_answer(baca, odkryte_informacje)),
    (   baca_accuse_success ->
        ending_baca
    ;   ending_player
    ), !.

oskarz(kacper) :-
    can_accuse,
    retract(can_answer(baca, odkryte_informacje)),
    (   kacper_accuse_success ->
        ending_kacper
    ;   ending_player
    ), !.


kacper_accuse_success :-
    BaseScore = 0,
    (answered "baca" "odkryte_informacje" "c"
    (answered "baca" "odkryte_informacje" "d"
    (baca_hates(kacper) -> Score3 is Score2 + 1 ; Score3 = Score2),
    (baca_hates(player) -> Score3 is Score3 - 1 ; Score4 = Score3),
    Score4 >= 2.

baca_accuse_success :-
    BaseScore = 0,
    (answered "baca" "odkryte_informacje" "a"
    (answered "baca" "odkryte_informacje" "b"
    (answered "kacper" "kominek" "t"
    (kacper_hates(baca) -> Score4 is Score3 + 1 ; Score4 = Score3),
    (kacper_hates(player) -> Score5 is Score4 - 1 ; Score5 = Score4),
    Score5 >= 3.



-- oskarz(baca) :- % kacper nie lubi gracza, bad ending
--     kacper_hates(player),
--     ending_player, !.
-- 
-- oskarz(baca) :- % kacper nie lubi bacy
--     kacper_hates(baca),
--     ending_baca, !.
-- 
-- oskarz(baca) :-  % kacper lubi bace
--     player_say "psst... Kacper... myślę, że to Baca zabił Karolinę"
--     kacper_say "EKHM..! Czy masz jakieś oficjalne dowody podtrzymujące twoją tezę? Jeżeli nie prosiłbym o milczenie!"
--     narrate "Czujesz, że Kacprowi nie spodobało się twoje oskarżenie, dodatkowo zaczął on nerwowo na ciebie spoglądać..."
--     assert(kacper_hates(player)), !, nl.
-- 
-- oskarz(kacper) :- % baca nie lubi gracza, bad ending
--     baca_hates(player),
--     ending_player, !.
-- 
-- oskarz(kacper) :- % baca nie lubi kacpra
--     baca_hates(kacper),
--     ending_kacper, !.
-- 
-- oskarz(kacper) :- % baca lubi kacpra (czy to mozliwe?)
--     player_say "Baca... słuchaj... myślę, że to ten Warszawiak zabił-""
--     baca_say "Odezwoł się! A ty niby skąd jesteś? Pomyśl trochę zanim zaczniesz takie głupstwa paplać,"
--     baca_say "bo wezmę ciupogę i obu was stąd na zbity pysk wyrzucę!"\x1b[0m"
--     assert(baca_hates(player)), !.






ending_kacper :-
    display_ending_kacper,
    player_say "Myślę, że to był kacper, ale może jeszcze chwilę się zastanówmy."
    baca_say ("Nie mogę już tego słuchać! Przyjacielu to oczywiste, że ten warszawiak zabił Karolinkę!", "wykrzyczał patrząc na ciebie baca")
    kacper_say ("C.Co.. TO OSZCZERSTWA, ARGUMENT AD PERSONAM! Nigdy bym jej nie zab...", "odparł szybko Kacper")
    baca_say ("Mam już tego dość! Albo ty albo on!", "przerwał mu rozwcieczony baca")
    narrate "Niepewny sytuacji wolisz nie reagować, pozostaje ci tylko patrzeć jak baca wypycha kacpra na śnieg za izbą, a następnie siada przy \x1b[1mpiecyku\x1b[0m"
    make_visible "piecyk"

spojrz_specific "piecyk" = do
    display_shady_ending,
    baca_say ("No młody... mamy go z głowy, teraz słuchaj mnie uważnie", "powiedział ze spokojem baca po czym usiadł przy piecyku")
    baca_say ("Jesteśmy tu tylko we dwóch. Sprzątniesz teraz ciało dziołchy i nikomu o niczym tutaj nie wspomnisz", "powiedział patrząc ci w oczy baca\x1b[0m")
    baca_say ("A jak usłyszę tutaj miastową straż, możesz być pewien że chłopaki z bacówki cię znajdą", "mówiąc to wskazał na ciebie swoją ciupagę")
    narrate "Słowa bacy z pewnością nie napawają cię optymizmem... No cóż, przynajmniej nie ma tu już Kacpra"
    outro.

ending_baca :-
    display_ending_baca,
    kacper_say ("Hmmmmm no nie wiem, kto to zrobił, musimy przeprowadzić głosowanie najlepiej metodą kontrpośrednich", "powiedział jak zwykle bez sensu niedoszły prawnik")
    player_say ("Kacper, to musiał zrobić baca!", "łapiesz warszawiaka za płaszcz i potrząsasz nim")
    baca_say ("Co?! W mojej izbie dwóch mieszczuchów przeciwko mnie spiskuje?!", "wściekł się baca i złapał za ciupagę")
    kacper_say ("W imię prawa nakazuję ci złożyć broń!", "wykrzyczał kacper potykając się o stół w salonie")
    narrate "Kacper szczęśliwie wylądował prosto na bacy, zderzając się z nim głową. Baca oraz Kacper leżeli teraz wpółprzytomnie na \x1b[1mpodłodze\x1b[0m."
    make_visible "podloga"
b
spojrz_specific "podloga" = do
    display_good_ending,
    narrate "Podnosisz Kacpra z podłogi. Baca dalej leży nieprzytomny, stwierdziliście że musicie wezwać tu policję... lub przynajmniej GOPR."
    narrate "Wybiegacie z izby i kierujecie się w stronę najbliżego szlaku."
    kacper_say ("Wspaniale, że udało nam się uciec od tego popaprańca... teraz mamy chwilę by porozmawiać o prawie cywilnym!", "rozpromieniał Kacper")
    narrate "Przez chwilę przyszło ci do głowy, że mogłeś jednak iść sam"
    outro.

ending_player:-
    display_ending_player,
    player_say "Ja wiem! wiem kto zabi-"
    baca_say ("CICHO!", "krzyczy baca nie dając ci skończyć zdania")
    baca_say ("Ja żem już wystarczająco widzoł! To ty zabiłeś dziołchę Warszawiaku", "powiedział baca z obrzydzeniem w oczach")
    kacper_say ("Pan baca ma rację, nie ma jak wezwać organy ścigania, a ja nie będę tu siedział z mordercą", "dołączył się kacper")
    baca_say ("Nie próbuj uciekać", "odpowiedział baca chwytając cię za bark i wyrzucając na \x1b[39;1mdwór\x1b[0m"")
    make_visible "dwor"


spojrz_specific "dwor" = do
    display_bad_ending,
    narrate "Nie udało się złapać mordercy, na domiar złego musisz szukać innego schornienia"
    narrate "Śpiesz się, robi się ciemno..."
    outro.





-- ----------------------------------------------------------------------------- %
--                                    CLEAN UP                                   %
-- ----------------------------------------------------------------------------- %

-- !!! UNMATCHED LOOK RULE, MUST BE AFTER OTHER SEE RULES
spojrz_specific "_" = do
    narrate "Patrzysz się w otchłań marząc o Warszawie"
    
-- !!! GENERAL ANSWER RULE, MUST BE AFTER OTHER ANSWER RULES
odpowiedz(_, _) :-
    narrate('nie możesz tak odpowiedzieć!').

spojrz(_) :-
    narrate('Nie możesz teraz tego zrobić - jesteś w trakcie rozmowy.').

oskarz(_) :-
    narrate('Nie możesz tego zrobić.').
