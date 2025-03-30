% instructions for `start`

:- dynamic is_outside/0, at_introduction/0, can_see/1, can_answer/2, answered/3, spojrz/1, odpowiedz/2, baca_hates/1, kacper_hates/1, oskarz/1, can_accuse/0, can_look/0, looked/1, looking/1.
:- discontiguous spojrz/1, spojrz_specific/1, odpowiedz/2.

:- use_module(conv).
:- use_module(img).

instructions :-
    display_instructions.
    % ...
    % add command help here

introduction :-
        assert(at_introduction),
        assert(is_outside),
        assert(can_look),
        nl,
        write('Była to zimna grudniowa noc, wybrałeś się w Tatry...'), nl,
        write('Po 5 godzinach wchodzenia pod górę, wreszcie widzisz przed sobą \e[1mschronisko\e[0m'), nl, nl,
        write('\e[2mTIP: Spróbuj \e[1mspojrzeć\e[0m\e[2m na \e[1mschronisko\e[0m'), nl, 
        write('\e[2mTIP: aby wyświetlić wszystkie rzeczy na które możesz spojrzeć wpisz \e[1mlvo.\e[0m'),
        assert(can_see(schronisko)), !, nl.

start :-
    instructions,
    introduction.


% List visited Objects Function for debugging
lvo :-
    findall(Object, can_see(Object), Objects),
    write('Mozesz spojrzec na: '), write(Objects), nl.


% user interface to spojrz command
spojrz(X) :-
    \+ can_answer(_, _), 
    !,
    spojrz_specific(X).


% general see rule
spojrz_specific(X) :-
    tty_clear,
    \+ can_see(X),
    write('Nie masz możliwości teraz tego zobaczyć.'), nl,
    write('Hint: pamiętaj, żeby nazwy obiektów wpisywać bez polskich znaków'), !, nl.

% POCZĄTEK GRY
spojrz_specific(schronisko) :-
    is_outside,
    display_hut,
    write('Z komina schroniska wydobywa się ledwo widoczny dym.'),
    write('Baca chyba zainwestował w eko-drewno'), nl,
    write('...albo gmina go zmusiła. Uznajesz, że nie ma czasu do stracenia, ładujesz się do środka'), nl, nl,
    write('Od razu po wejściu do schroniska czujesz silną woń kompotu, przed sobą dostrzegasz duży \e[1mstół\e[0m.'), nl,
    write('obok stołu znajduje się ceglany \e[1mkominek\e[0m. Przed kominkiem, na bujanym fotelu siedzi starszy \e[1mmężczyzna\e[0m'), nl,
    write('Po drugiej stronie stołu znajduje się \e[1mokienko\e[0m, które najpewniej jest recepcją oraz miejscem, z którego'), nl,
    write('przez cały dzień można pobierać ciepłe posiłki.'), nl, nl,
    write('\e[2mTIP: Możesz \e[1mspojrzeć\e[22m\e[2m na pogrubione obiekty.\e[0m'),
    assert(can_see(stol)),
    assert(can_see(kominek)),
    assert(can_see(okienko)),
    assert(can_see(mezczyzna)),
    retract(can_see(schronisko)),
    retract(is_outside), !, nl.

% TUTORIAL ODPOWIADANIA
spojrz_specific(stol) :-
    at_introduction,
    display_table,
    write('Stół jest zrobiony z silnego drewna, wygląda na lokalny wytwór. Nigdy wcześniej takiego nie widziałeś.'), nl, nl,
    write('\e[1;31m"Co tam tak sznupiesz, młody? Drewno wydaje się znajome?"\e[0m - słyszysz głos '),
    (   looked(mezczyzna) -> 
        write('\e[1mbacy\e[0m siędzącego na krześle.'),
        assert(can_answer(baca, sznupanie))
    ;   write('\e[1mmężczyzny\e[0m na krześle.'),
        assert(can_answer(mezczyzna, sznupanie))
    ),
    nl, nl,
    write('\e[2mTUTORIAL: możesz odpowiadać na pytania PRAWDZIWIE (p), FAŁSZYWIE (f) lub WYMIJAJĄCO (w)\e[0m'), nl,
    write('\e[2mMożesz odpowiedzieć za pomocą "odpowiedz(<cel>, <odpowiedź>)\e[0m'), nl,
    assert(looking(stol)),
    retract(can_see(stol)), !, nl.

    

% KOMINEK - NIC CIEKAWEGO
spojrz_specific(kominek) :-
    display_fireplace,
    write('Ogień w kominku mocno się pali, drewno musiało być dodane niedawno, całkiem tu gorąco.'), !, nl, nl.

% BACA - INTRODUCTION

spojrz_specific(mezczyzna) :-
    display_baca1,
    retract(can_see(mezczyzna)), fail.
    

spojrz_specific(mezczyzna) :-
    answered(baca, sznupanie, p),
    write('\e[1;31m"Warszawiak w górach? W taką pogodę? Zaskakjące... w każdym razie witoj w moim schronisku, jestem Baca.\e[0m'), nl, fail.

spojrz_specific(mezczyzna) :-
    answered(baca, sznupanie, f),
    write('\e[1;31m"Na drzewach może się nie znosz, ale widzę, że dałeś radę nas ugościć.. i to w taką pogodę. Jestem Baca, witom."\e[0m'), nl, fail.

spojrz_specific(mezczyzna) :-
    answered(baca, sznupanie, w),
    write('\e[1;31m"Witoj, jestem Baca. Rozgość się...\e[0m"'), nl, fail.

spojrz_specific(mezczyzna) :-
    \+ answered(baca, sznupanie, _),
    write('\e[1;31m"Ło, prawie cię nie zauważyłem. Jestem Baca, witoj w moim schronisku"\e[0m'), nl, fail.

spojrz_specific(mezczyzna) :-
    assert(looked(mezczyzna)),
    write('Baca jest starszym mężczyzną o długich, ciemnych włosach, jego sylwetka jest wyjątkowo muskularna jak na jego wiek. Musi tu ciężko pracować.'),
    !, nl.

% RECEPCJA - ZAKOŃCZENIE WSTĘPU (+ tutorial odpowiadania tak/nie)

% Odpowiedzieliśmy nie - teraz możemy wrócić do karoliny i natychmiast skończyć intro


% Karolina introduction
spojrz_specific(okienko) :-
    \+ answered(karolina, pokoj, n),
    display_karolina,
    karolina_say('"Hej! Jestem Karolina!"', 'słyszysz głos zza okienka'),
    karolina_say('"Kuchnię niestety mamy już zamkniętą... ale pewnie chciałbyś wziąć pokój na noc?"'),
    karolina_say('"z resztą co ja gadam... w takich warunkach nikt normalny nie wracałby do miasta..."'), nl,
    write('Słyszysz brzdęk kluczy...'), nl,
    karolina_say('"Proszę! numer 32!"'),
    karolina_say('"Mamy dzisiaj tylko jednego innego gościa - więc powinieneś mieć spokojną noc!"'),
    write('\e[1m"Dziękuję"\e[0m - odpowiadasz i zabierasz klucz'), nl,
    karolina_say('"Pokazać ci jak dojść do pokoju? Czy chcesz jeszcze się rozejrzeć?"'),
    write('(t - skończ intro, n - zostań)\e[0m'), nl,
    assert(can_answer(karolina, pokoj)), !, nl.


spojrz_specific(okienko) :-
    assert(can_answer(karolina, pokoj)),
    write('\e[1;36m"To jak? idziemy?" \e[22;2;39m(odpowiedz na pytanie Karoliny za pomocą t lub n)\e[0m'), !, nl.


% answer shortcuts
p :- odpowiedz(_, p).  % prawda
f :- odpowiedz(_, f).  % fałsz
w :- odpowiedz(_, w).  % wymijająco
t :- odpowiedz(_, t).  % tak
n :- odpowiedz(_, n).  % nie

% general answer rules, !!! MUST BE BEFORE OTHER ANSWER RULES
odpowiedz(X, _) :-
    \+ can_answer(X, _),
    write('Pytanie nie zostało do ciebie zadane przez '),
    write(X), write("."), !, nl.

% KONWERSACJA Z BACA PO INSPEKCJI STOŁU - ODPOWIEDZI

odpowiedz(mezczyzna, X) :-
    \+ looked(mezczyzna),
    looking(stol),
    assert(can_answer(baca, sznupanie)),
    odpowiedz(baca, X),
    retract(can_answer(mezczyzna, sznupanie)),
    retract(looking(stol)), !.

odpowiedz(baca, p) :-
    can_answer(baca, sznupanie),
    write('\e[1m"Nigdy nie widziałem takiego drzewa proszę pana, jestem z Warszawy"\e[0m - odpowiadasz'), nl,
    write('Mężczyzna krzywo się na ciebie patrzy i momentalnie odwraca wzrok.'), nl,
    assert(baca_hates(player)),
    finish_answer(baca, sznupanie, p), !, nl.

odpowiedz(baca, f) :-
    can_answer(baca, sznupanie),
    write('\e[1m"Stolik jest niezwykle solidny, od razu widać że to dąb"\e[0m - odpowiadasz z przekonaniem'), nl,
    write('\e[1;31m"Jaki dąb, widziałeś gdzieś tu bęby? To stara dobra sosna."\e[0m - odpowiada mężczyzna i przewraca oczami'), nl,
    finish_answer(baca, sznupanie, f), !, nl.

odpowiedz(baca, w) :-
    can_answer(baca, sznupanie),
    write('\e[1m"Co tam rodzaj drewna, grunt że wygląda naprawdę dobrze!"\e[0m - odpowiadasz'), nl,
    write('\e[1;31m"Ach, dziękuję. Sam go zrobiłem, ze starej sosny co się pod izbą zwaliła zeszłego lata."\e[0m - opowiada mężczyzna'), nl,
    finish_answer(baca, sznupanie, w), !, nl.


odpowiedz(karolina, t) :-
    can_answer(karolina, pokoj),
    finish_answer(karolina, pokoj, t),
    write('\e[1;36m"Chodź za mną."\e[0m'), nl,
    sleep(3),
    endintro, !, nl.

odpowiedz(karolina, n) :-
    can_answer(karolina, pokoj),
    write('\e[1;36m"Spoko, podejdź do okienka jak będziesz gotowy"\e[0m'), nl,
    finish_answer(karolina, pokoj, n), !, nl.


finish_answer(Who, Question, Answer) :-
    write("in finish answer"), nl,
    retract(can_answer(Who, Question)),
    write("in between"), nl,
    assert(answered(Who, Question, Answer)),
    write("after"), nl,
    !, nl.

endintro :-
    % tty_clear,
    retractall(can_see(_)),
    retractall(can_answer(_)),
    retractall(answered(_)),
    write('Karolina zaprowadziła cię do twojego pokoju.'), nl, nl,
    write('Rzuciłeś plecak na łóżko.'), nl,
    write('Padasz ze zmęczenia, kładziesz się w łóżku i natychmiast zasypiasz...'), nl, nl,
    write('\e[2mHINT: użyj słowa \e[1mstart_story\e[0m\e[2m aby rozpocząć następny rozdział...\e[0m'),
    retract(at_introduction),
    !, nl.

% ----------------------------------------------------------------------------- %
%                                   STAGE 1                                     %
% ----------------------------------------------------------------------------- %

% Dostępne zmienne:
%   - sznupanie

start_story :-
    tty_clear,
     \+ at_introduction,
    write('Budzisz się. Spoglądasz na zegarek. 1:12.'), nl,
    write('Czujesz suchość w ustach, zmęczenie po przyjściu do schroniska spowodowało, że zapomniałeś, że od dawna nic już nie piłeś...'), nl,
    write('Przypominasz sobie, że na stole w holu schroniska stał \e[1mkompot\e[0m. Nie możesz przestać o nim myśleć.'), nl,
    write('Czujesz, że nie będzie to łatwa noc.'), nl,
    assert(can_see(kompot)), !, nl.

spojrz_specific(kompot) :-
    display_compote,
    write('Patrzysz na kompot oczami wyobraźni. Jest piekny, pachnacy owocami, ociekajacy zimnynmi kroplami. Po prostu musisz po niego pójść.'), nl,
    write('Powoli schodzisz schodami w dół... mimo to, słyszysz ciche skrzypienie'), nl,
    write('Wchodzisz do holu... kątem oka zauważasz dziwny, spory \e[1mobiekt\e[0m na ziemii. Byłby całkowicie niewidoczny, gdyby nie kominek'),
    write(', który, dopalając się, lekko go oświetlał') , nl,
    write('Zauważasz też, że podłoga, po której chodzisz lekko się lepi... "i tyle zostało z kompotu..." - pomyślałeś'), nl,
    retract(can_see(kompot)), nl,
    assert(can_see(obiekt)), !, nl.

spojrz_specific(obiekt) :-
    display_dead_body,
    write('Zbliżasz się do dziwngo obiektu... teraz widzisz, że jest to... \e[36mKarolina\e[0m, która z zamkniętymi oczami leży na ziemi, otoczona jest plamą ciemnoczerwonego płynu... krew.'), nl,
    write('Jesteś zszokowany. Mimowolnie zaczynasz wycofywać się, ale przypadkowo uderzasz w stół, strącając z niego szklankę...'), nl,
    write('Szklanka upada na ziemię natychmiast rozbijając się, przeszywając całe schronisko głośnym hukiem.'), nl, nl,
    write('Do pomieszczenia wbiega \e[1mbaca\e[0m oraz nieznana ci wcześniej \e[1mosoba\e[0m, pewnie to gość o którym wspominała żywa jeszcze Karolina.'), nl,
    retract(can_see(obiekt)),
    assert(can_see(baca)),
    assert(can_see(osoba)), !, nl.

spojrz_specific(baca) :-
    display_baca2,
    write('Baca przybiega ze złością w oczasch'), nl,
    write('\e[1;31m"KTO W MOJEJ IZBIE PO NOCY ŁOBUZI?!"\e[0m'), nl,
    write('Jego oczy od razu spadają z ciebie na leżącą obok Karolinę'), nl,
    write('\e[1;31m"Co za bałagan, tyle kompotu z suszu wylać, wstawaj dziołcha, ktoś to musi posprzątać"\e[0m'), nl,
    write('Karolina dalej leży bez ruchu, oczy bacy znowu wpatrują się w ciebie'), nl,
    write('"\e[1;31mCo tu się wydarzyło?!"\e[0m'), nl,
    write('\e[2m(TIP: \e[1modpowiedz bacy p/f/w\e[0m) '), nl,
    retract(can_see(baca)),
    assert(can_answer(baca, cialo)), !, nl.

odpowiedz(baca, p) :-
    can_answer(baca, cialo),
    write('\e[1m"Zszedłem na dół bo chciałem się napić kompotu, Karolina już tu leżała"\e[0m - odpowiadasz'), nl,
    write('\e[1;31m"Czyli byłeś z nią sam na sam..." - odpowiada pod nosem baca i wpatruje ci się głęboko w oczy\e[0m'), nl,
    (   baca_hates(player) ->
        write('\e[1;31m"Warszawiaku...."\e[0m - mówi baca z wyraźną niechęcią'), nl
    ;   true
    ),
    finish_answer(baca, cialo, p), !, nl,
    (   answered(kacper, cialo, _) ->
        all_dialogued;
        true
    ),
    retract(can_answer(baca, cialo)), !, nl.


odpowiedz(baca, f) :-
    can_answer(baca, cialo),
    write('\e[1m"Obudził mnie huk, gdy zszedłem ten gość stał nad zwłokami Karoliny!"\e[0m'), nl,
    (   baca_hates(player) ->
        write('\e[1;31m"Tyn z Warszawy i tyn z Warszawy, wszyscy siebie warci"\e[0m - Baca nie wydaje się przekonany twoim wytłumaczeniem'), nl
    ;   write('\e[1;31m"Ja slyszał że on ze stolycy, tym nigdy nie wolno ufać"\e[0m'), nl,
        assert(baca_hates(kacper))
    ),
    finish_answer(baca, cialo, f), !, nl,
    (   answered(kacper, cialo, _) ->
        all_dialogued
    ;   true
    ),
    retract(can_answer(baca, cialo)), !, nl.

odpowiedz(baca, w) :-
    can_answer(baca, cialo),
    write('\e[1m"Nie wiem, zbiegłem na dół razem z wami"\e[0m'), nl,
    write('\e[1;31m"Dziwne, nie widziałem cię."\e[0m - odpowiedział baca z nutą niepewności'), nl,
    finish_answer(baca, cialo, w), !, nl,
    (   answered(kacper, cialo, _) ->
        all_dialogued
    ;   true
    ),
    retract(can_answer(baca, cialo)), !, nl.


spojrz_specific(osoba) :-
    display_kacper1,
    write('Gość ślamazarnie zbiega ze schodów, przez mrok ciężko ci dostrzec jego sylwetknę oraz twarz'), nl, 
    write('Na pewno jest wysoki, wydaje się być chudy, a płomienie nadają jego twarzy lekki zarys... no i te okulary'), nl,
    write('\e[1;32m"Jako student prawa nie godzę się na takie warunki. Ustawowo cisza nocna obowiązuje od godziny 22:00 do 6:00!"\e[0m - wykrzyczał'), nl, nl, 
    write('Student spojrzał na Karolinę'), nl, 
    write('\e[1;42m"AAAAAAAAAAAAAAAAAAAAAAAA\e[49;1;32m, toż to pogwałcenie artykułu 148! Musimy zawiadomić organy ścigania!!!"'), nl, 
    write('"Hej ty! Jestem Kacper. Zadzwoń po pogotowie, ja zbadam miejsce zbrodni!"\e[0m - powiedział Kacper po czym potknął się o stolik znajdujący się w salonie'), nl, nl,
    write('odpowiedz:'), nl, 
    write('t: Przecież tutaj nie ma zasięgu.'), nl, 
    write('n: O mój boże kocham prawo! Na jakim wydziale studiujesz?'), nl, 
    retract(can_see(osoba)),
    assert(can_answer(kacper, cialo)), !, nl.

odpowiedz(kacper, t) :-
    can_answer(kacper, cialo), nl,
    write('\e[1;32m"Pff, mogłem się domyślić że ten stary dziad nie wie że telelinie można poprowadzić za pośrednictwem łącza bianalogowego"\e[0m - powiedział nonszalandzko Kacper'), nl, nl,
    write('Jako student informatyki dociera do ciebie, że Kacper nie ma pojęcia o czym mówi.'), nl, nl,
    write('\e[1;32m"No nic w takim razie będziemy musieli przepowadzić resustytacje krążeniowo oddechową, ty zacznij ja poszukam gazy oraz opatrunku uciskowego"\e[0m'), nl, nl,
    write('Kacper zniknął w ciemności, usłyszałeś tylko że znowu potknął się o ten sam stolik'), nl,
    assert(kacper_hates(baca)),   
    retract(can_see(kacper)),
    finish_answer(kacper, cialo, t), !, nl,
    (   answered(baca, cialo, _) ->
        !, all_dialogued;   
        true
    ), !, nl.

odpowiedz(kacper, n) :-
    can_answer(kacper, cialo),
    write("\e[1;32mO proszę, miałem cię za prostaka jednak widzę, że napotkałem erudytę! Otóż mój drogi uczęszczam do Akademii Prawa i Filizofii w Warszawie.\e[0m"), nl,
    write('"\e[1;32mJestem niezmiernie ciekaw twojego miejsca pobierania nauk, może mamy wspólnych znajomych!\e[0m"'), nl, nl,
    write('\e[2mTIP: \e[1modpowiedz Kacprowi p/f/w\e[0m'), nl,
    finish_answer(kacper, cialo, n),
    assert(can_answer(kacper, uczelnia)), !, nl.

odpowiedz(kacper, p) :-
    can_answer(kacper, uczelnia),
    write('\e[1m"W sumie to nie studiuję prawa, jestem studentem informatyki"\e[0m - odpowiadasz'), nl,
    write('\e[1;32m"Ehhh... ścisłowiec, no nic kolego, nie twoja wina że jesteś ciemnotą"\e[0m - odparł rozczarowany Kacper'), nl,
    finish_answer(kacper, uczelnia, p),
    (   answered(baca, cialo, _) ->
        all_dialogued
    ;   true
    ), 
    retract(can_answer(kacper, uczelnia)), !, nl.   

odpowiedz(kacper, f) :-
    can_answer(kacper, uczelnia),
    finish_answer(kacper, uczelnia, f), !.

odpowiedz(kacper, w) :-
    can_answer(kacper, uczelnia),
    finish_answer(kacper, uczelnia, w), !.

all_dialogued :-
    write('\e[1;31m"Dobra, siadojcie do \e[1mstołu\e[0m. Nikt stąd nie wyjdzie dopóki nie wyłonimy mordercy."\e[0m'),
    write('- powiedział Baca i postawił na \e[1mstole\e[0m wielki dzban kompotu'), nl,
    write('\e[1;32m"Tak!! Czekałem na ten moment całe życie! Moje umiejętności społecznej dedukcji zakończą tą sprawę w sekundę!"\e[0m'),
    write('- wtrąca Kacper i siadając do stołu potyka się o jego nogę.'), nl,
    (   baca_hates(kacper) ->
        write('Baca spogląda na Kacpra z zażenowaniem'), nl
    ;   write('Ukradkiem spoglądasz na Bacę próbując zauważyć gniew w jego oczach...'), nl, true
    ),
    (   baca_hates(player) ->
        write('Baca zauważa, że się mu przyglądasz'), nl,
        write('\e[1;31m"A ty czego się patrzysz!?"\e[0m'), nl
    ;   true
    ), !,
    nl, nl,
    write('\e[2mOd teraz masz dostęp do polecenia: \e[1moskarz(baca/kacper)\e[0m'), nl,
    write('\e[2mWywołanie polecenia spowoduje oskarżenie postaci o morderstwo i natychmiastowy koniec gry.'), nl,
    write('\e[2mW zależności od twoich relacji z postaciami, oskarżenie może mieć różny wynik'), nl,
    assert(can_accuse),
    assert(can_see(stol)), !.

% ----------------------------------------------------------------------------- %
%                                    STAGE 2                                    %
% ----------------------------------------------------------------------------- %
% Rozmowy przy stole z Bacą i Kacprem, ogarnianie kto zabił Karolinę.

spojrz_specific(stol) :-
    \+ at_introduction,
    write('Zasiadasz do stołu z Bacą i Kacprem. Ogień w \e[1mkominku\e[0m już się dopala...'), nl,
    write('Przed tobą stoi najprawdopodobniej ostatnia \e[1mszklanka\e[0m słynnego kompotu \e[36mKaroliny.\e[39m'), nl,
    write('Zauważasz, że Kacper trzyma \e[1mręce\e[0m pod stołem i nerwowo spogląda naprzemiennie na ciebie i na Bacę.'), nl,
    write('Baca z kolei, wydaje się spokojny, spogląda na Ciebie oraz Kacpra z wyższością... do tego stopnia, że zaczynasz '),
    write('drugi raz zastanawiać się, czy to nie ty zabiłeś Karolinę...'), !, nl.




% ----------------------------------------------------------------------------- %
%                                    ENDINGS                                   %
% ----------------------------------------------------------------------------- %

oskarz(baca) :- % kacper nie lubi gracza, bad ending
    kacper_hates(player),
    ending_player, !.

oskarz(baca) :- % kacper nie lubi bacy
    kacper_hates(baca),
    ending_baca, !.

oskarz(baca) :-  % kacper lubi bace
    write('"\e[1mpsst... Kacper... myślę, że to Baca zabił Karolinę"'), nl,
    write('"\e[1;32mEKHM..! Czy masz jakieś oficjalne dowody podtrzymujące twoją tezę? Jeżeli nie prosiłbym o milczenie!"\e[0m'), nl, nl,
    write('Czujesz, że Kacprowi nie spodobało się twoje oskarżenie, dodatkowo zaczął on nerwowo na ciebie spoglądać...'), nl,
    assert(kacper_hates(player)), !, nl.

oskarz(kacper) :- % baca nie lubi gracza, bad ending
    baca_hates(player),
    ending_player, !.

oskarz(kacper) :- % baca nie lubi kacpra
    baca_hates(kacper),
    ending_kacper, !.

oskarz(kacper) :- % baca lubi kacpra (czy to mozliwe?)
    write('\e[1m"Baca... słuchaj... myślę, że to ten Warszawiak zabił-"'), nl,
    write('\e[1;31m"Odezwoł się! A ty niby skąd jesteś? Pomyśl trochę zanim zaczniesz takie głupstwa paplać,'),
    write('bo wezmę ciupogę i obu was stąd na zbity pysk wyrzucę!"\e[0m'),
    assert(baca_hates(player)), !.


ending_kacper :-
    display_ending_kacper,
    write(''), nl,
    write('\e[1;31m"Nie mogę już tego słuchać! Przyjacielu to oczywiste, że ten warszawiak zabił Karolinkę!"\e[0m - wykrzyczał patrząc na ciebie baca'), nl,
    write('\e[1;32m"C.Co.. TO OSZCZERSTWA, ARGUMENT AD PERSONAM! Nigdy bym jej nie zab..."\e[0m - odparł szybko Kacper'), nl,
    write('\e[1;31m"Mam już tego dość! Albo ty albo on!"\e[0m - przerwał mu rozwcieczony baca'), nl,
    write('Niepewny sytuacji wolisz nie reagować, pozostaje ci tylko patrzeć jak baca wypycha kacpra na śnieg za izbą, a następnie siada przy \e[1mpiecyku\e[0m'), nl,
    assert(can_see(piecyk)), !, nl.

spojrz_specific(piecyk) :-
    display_shady_ending,
    write(''), nl,
    write('\e[1;31m"No młody... mamy go z głowy, teraz słuchaj mnie uważnie"\e[0m - powiedział ze spokojem baca po czym usiadł przy piecyku'), nl,
    write('\e[1;31m"Jesteśmy tu tylko we dwóch. Sprzątniesz teraz ciało dziołchy i nikomu o niczym tutaj nie wspomnisz" - powiedział patrząc ci w oczy baca\e[0m'), nl,
    write('\e[1;31m"A jak usłyszę tutaj miastową straż, możesz być pewien że chłopaki z bacówki cię znajdą"\e[0m - mówiąc to wskazał na swoją ciupagę'), nl,
    write('Słowa bacy z pewnością nie napawają cię optymizmem... No cóż, przynajmniej nie ma tu już Kacpra'), !, nl.

ending_baca :-
    display_ending_baca,
    write(''), nl,
    write('\e[1;32m"Hmmmmm no nie wiem, kto to zrobił, musimy przeprowadzić głosowanie najlepiej metodą kontrpośrednich" - powiedział jak zwykle bez sensu niedoszły prawnik\e[0m'), nl,
    write('\e[1m"Kacper, to musiał zrobić baca!"\e[0m - łapiesz warszawiaka za płaszcz i potrząsasz nim'), nl,
    write('\e[1;31m"Co! W mojej izbie dwóch mieszczuchów przeciwko mnie spiskuje?!"\e[0m - wściekł się baca i złapał za ciupagę'), nl,
    write('\e[1;32m"W imię prawa nakazuję ci złożyć broń!"\e[0m - wykrzyczał kacper potykając się o stół w salonie'), nl,
    write('Kacper szczęśliwie wylądował prosto na bacy, zderzając się z nim głową. Baca oraz Kacper leżeli teraz wpółprzytomnie na \e[1mpodłodze\e[0m.'), nl,
    assert(can_see(podloga)), !, nl.

spojrz_specific(podloga) :-
    display_good_ending,
    write('Podnosisz Kacpra z podłogi. Baca dalej leży nieprzytomny, stwierdziliście że musicie wezwać tu policję... lub przynajmniej GOPR.'), nl,
    write('Wybiegacie z izby i kierujecie się w stronę najbliżego szlaku.'), nl,
    write('\e[1;32m"Wspaniale, że udało nam się uciec od tego popaprańca... teraz mamy chwilę by porozmawiać o prawie cywilnym!"\e[0m - rozpromieniał Kacper'), nl,
    write('Przez chwilę przyszło ci do głowy, że mogłeś jednak iść sam'), !, nl.

ending_player:-
    display_ending_player,
    write(''), nl,
    write('\e[1m"Ja wiem! wiem kto zabi-"\e[0m'), nl,
    write('\e[1;31m"CICHO!"\e[0m'), nl,
    write('\e[1;31m"Ja żem już wystarczająco widzoł! To ty zabiłeś dziołchę Warszawiaku"\e[0m - powiedział baca z obrzydzeniem w oczach'), nl,
    write('\e[1;32m"Pan baca ma rację, nie ma jak wezwać organy ścigania, a ja nie będę tu siedział z mordercą"\e[0m - dołączył się kacper'), nl,
    write('\e[1;31m"Nie próbuj uciekać" - odpowiedział baca chwytając cię za bark i wyrzucając na \e[39;1mdwór\e[0m"'),
    assert(can_see(dwor)), !, nl.


spojrz_specific(dwor) :-
    display_bad_ending,
    write('Nie udało się złapać mordercy, na domiar złego musisz szukać innego schornienia'), nl,
    write('Śpiesz się, robi się ciemno...'), !, nl.





% ----------------------------------------------------------------------------- %
%                                    CLEAN UP                                   %
% ----------------------------------------------------------------------------- %

% !!! UNMATCHED LOOK RULE, MUST BE AFTER OTHER SEE RULES
spojrz_specific(_) :-
    write('Patrzysz się w otchłań marząc o Warszawie'), !, nl.
    
% !!! GENERAL ANSWER RULE, MUST BE AFTER OTHER ANSWER RULES
odpowiedz(_, _) :-
    write('nie możesz tak odpowiedzieć!'), !, nl.

spojrz(_) :-
    write('Nie możesz teraz tego zrobić - jesteś w trakcie rozmowy.'), nl.
