{-
    Odpowiednik baca.pl
    Tutaj cała historia, każde polecenie powinno działać już podobnie do tego w prologu
    Nie robiłem jeszcze odpowiedzi, trzeba bedzie dodac w game state
-}

module Story where

import Img  -- ASCII art
import Game  -- GameState, pomocnicze funkcje (lvo, make_visible, hide, itd)
import Say  -- kod od mowienia, na podstawie prologowego lukasza

import Control.Monad.State
import System.IO (hFlush, stdout)

-- command definitions
spojrz :: Object -> Game ()
spojrz_specific :: Object -> Game ()
odpowiedz :: Who -> Question -> Game ()
odpowiedz_specific :: Who -> Question -> Answer -> Game ()

-- story

------------------------------------------------------------
------------------------ SPOJRZ ---------------------------- 
------------------------------------------------------------

spojrz obj = do
    visible <- can_see obj
    if visible
        then spojrz_specific obj
        else do
            narrate "Nie możesz teraz tego zobaczyć"

odpowiedz who question = do
    liftIO $ putStr "\n> " >> hFlush stdout
    input <- liftIO getLine
    if input `elem` ["p", "f", "w", "t", "n"]
        then odpowiedz_specific who question input
        else narrate "Nie możesz tak odpowiedzieć"

spojrz_specific "schronisko" = do
    display "schronisko"
    narrate "Z komina schroniska wydobywa się ledwo widoczny dym."
    narrate "Baca chyba zainwestował w eko-drewno."
    narrate "...albo gmina go zmusiła. \n\nUznajesz, że nie ma czasu do stracenia, ładujesz się do środka."
    narrate "Od razu po wejściu do schroniska czujesz silną woń kompotu, przed sobą dostrzegasz duży \x1b[1mstół."
    narrate "Obok stołu znajduje się ceglany \x1b[1mkominek\x1b[0m. Przed kominkiem, na bujanym fotelu siedzi starszy \x1b[1mmężczyzna."
    narrate "Po drugiej stronie stołu znajduje się \x1b[1mokienko\x1b[0m, które najpewniej jest recepcją oraz miejscem, z którego"
    narrate "przez cały dzień można pobierać ciepłe posiłki."
    write_tip "Możesz \x1b[1mspojrzeć\x1b[22m\x1b[2m na pogrubione obiekty."
    make_visible "stol"
    make_visible "okienko"
    make_visible "mezczyzna"
    make_visible "kominek"
    hide "schronisko"
    
spojrz_specific "kominek" = do
    display "fireplace"
    narrate "Ogień w kominku mocno się pali, drewno musiało być dodane niedawno, całkiem tu gorąco."

spojrz_specific "stol" = do
    display "table"
    narrate "Stół jest zrobiony z silnego drewna, wygląda na lokalny wytwór. Nigdy wcześniej takiego nie widziałeś."
    narrate "słyszysz głos \x1b[1mbacy\x1b[0m siędzącego na krześle."
    baca_say "Co tam tak sznupiesz, młody? Drewno wydaje się znajome?"
    narrate "Nie masz pojęcia co to może być za drewno. Zastanawiasz się co odpowiedzieć."
    write_tip "Odpowiedz mężczyźnie p/f/w"
    write_dialogue_option "p" "Nie wiem, jestem z warszawy."
    write_dialogue_option "f" "Od razu widać, że drzewo dębowe.(wymyślasz)"
    write_dialogue_option "w" "A co tam drewno, ważne, że stolik ładny."
    write_tip "Możesz odpowiadać na pytania PRAWDZIWIE (p), FAŁSZYWIE (f) lub WYMIJAJĄCO (w)"
    write_tip "Możesz odpowiedzieć za pomocą odpowiedz(<cel>, <odpowiedź>)"
    odpowiedz "baca" "sznupanie"
    --assert(looking(stol)),
    hide "stol"

spojrz_specific "mezczyzna" = do
    display "baca1"
    maybeAns <- how_answered "baca" "sznupanie"
    case maybeAns of
        Just "p" -> baca_say "\x1b[1;31mWarszawiak w górach? W taką pogodę? Zaskakjące... w każdym razie witoj w moim schronisku, jestem Baca."
        Just "f" -> baca_say "Na drzewach może się nie znosz, ale widzę, że dałeś radę nas ugościć.. i to w taką pogodę. Jestem Baca, witom."
        Just "w" -> baca_say "Witoj, jestem Baca. Rozgość się..."
        Nothing  -> baca_say "Ło, prawie cię nie zauważyłem. Jestem Baca, witoj w moim schronisku"
    hide "mezczyzna"
    narrate "Baca jest starszym mężczyzną o długich, ciemnych włosach, jego sylwetka jest wyjątkowo muskularna jak na jego wiek. Musi tu ciężko pracować."


spojrz_specific "okienko" = do
    display "karolina"
    maybeAns <- how_answered "karolina" "pokoj"
    case maybeAns of
        Just "n" -> karolina_say "O, witam ponownie!"
        Nothing  -> do  karolina_say ("Hej! Jestem Karolina!", "słyszysz głos zza okienka")
                        karolina_say "Kuchnię niestety mamy już zamkniętą... ale pewnie chciałbyś wziąć pokój na noc?"
                        karolina_say "z resztą co ja gadam... w takich warunkach nikt normalny nie wracałby do miasta..."
                        narrate "Słyszysz brzdęk kluczy..."
                        karolina_say "Proszę! numer 32!"
                        karolina_say "Mamy dzisiaj tylko jednego innego gościa - więc powinieneś mieć spokojną noc!"
                        player_say ("Dziękuję", "odpowiadasz i zabierasz klucz")
    karolina_say "Pokazać ci jak dojść do pokoju? Czy chcesz jeszcze się rozejrzeć?"
    write_tip("(t - skończ intro, n - zostań)")
    odpowiedz "karolina" "pokoj"

spojrz_specific "kompot" = do
    display "compote"
    narrate "Patrzysz na kompot oczami wyobraźni. Jest piekny, pachnacy owocami, ociekajacy zimnynmi kroplami. Po prostu musisz po niego pójść."
    narrate "Powoli schodzisz schodami w dół... mimo to, słyszysz ciche skrzypienie"
    narrate "Wchodzisz do holu... kątem oka zauważasz dziwny, spory \x1b[1mobiekt\x1b[0m na ziemii. Byłby całkowicie niewidoczny, gdyby nie kominek, który, dopalając się, lekko go oświetlał"
    narrate "Zauważasz też, że podłoga, po której chodzisz lekko się lepi... \"i tyle zostało z kompotu...\" - pomyślałeś"
    hide "kompot"
    make_visible "obiekt"

spojrz_specific "obiekt" = do
    display "dead_body"
    narrate "Zbliżasz się do dziwngo obiektu... teraz widzisz, że jest to... \x1b[36mKarolina\x1b[0m, która z zamkniętymi oczami leży na ziemi, otoczona jest plamą ciemnoczerwonego płynu... krew."
    narrate "Jesteś zszokowany. Mimowolnie zaczynasz wycofywać się, ale przypadkowo uderzasz w stół, strącając z niego szklankę..."
    narrate "Szklanka upada na ziemię natychmiast rozbijając się, przeszywając całe schronisko głośnym hukiem."
    narrate "Do pomieszczenia wbiega \x1b[1mbaca\x1b[0m oraz nieznana ci wcześniej \x1b[1mosoba\x1b[0m, pewnie to gość o którym wspominała żywa jeszcze Karolina."
    hide "obiekt"
    make_visible "baca"
    make_visible "osoba"

spojrz_specific "baca" = do
    display "baca2"
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
    odpowiedz "baca" "cialo"

------------------------------------------------------------
------------------------- STAGES --------------------------- 
------------------------------------------------------------

end_intro = do
    liftIO $ putStr "\n> " >> hFlush stdout
    hide "stol"
    hide "okienko"
    hide "mezczyzna"
    hide "kominek"
    narrate "Karolina zaprowadziła cię do twojego pokoju."
    narrate "Rozglądasz się po pokoju - obdrapane ściany, stare drewniane meble, słabe światło pojedynczej żarówki."
    narrate "Nie wygląda najlepiej, ale luksusów nie oczekiwałeś. Wyboru dużego nie miałeś - Właściwie to nie miałeś go wcale."
    player_say ("Przynajminej na głowe nie sypie...", "mruczysz pod nosem")
    narrate "Pojechałeś w góry, licząc, że na szlaku znajdziesz trochę spokoju - ucieczkę od obowiązków i niekończących się myśli o przyszłości."
    narrate "Studia powoli dobiegają końca. Jeszcze kilka miesięcy i zostaniesz rzucony w dorosłość."
    narrate "Pracy jest więcej niż kiedykolwiek, a odpowiedzialność zaczyna ciążyć jak plecak, który niosłeś przez całą drogę tutaj."
    narrate "Zrzucasz go z siebie... Wzdychasz ciężko i padasz na materac. Niemal natychmiast zasypiasz..."
    write_tip "Użyj słowa \x1b[1mstart_story\x1b[0m\x1b[2m aby rozpocząć następny rozdział."

start_story = do
    liftIO $ putStr "\n> " >> hFlush stdout
    narrate "Budzisz się. Spoglądasz na zegarek. 1:12."
    narrate "Czujesz suchość w ustach, zmęczenie po przyjściu do schroniska spowodowało, że zapomniałeś, że od dawna nic już nie piłeś..."
    narrate "Przypominasz sobie, że na stole w holu schroniska stał \x1b[1mkompot\x1b[0m. Nie możesz przestać o nim myśleć."
    narrate "Czujesz, że nie będzie to łatwa noc."
    make_visible "kompot"
------------------------------------------------------------
----------------------- ODPOWIEDZ -------------------------- 
------------------------------------------------------------

odpowiedz_specific "baca" "sznupanie" "p" = do
    player_say ("Nigdy nie widziałem takiego drzewa proszę pana, jestem z Warszawy", "odpowiadasz")
    narrate "Mężczyzna krzywo się na ciebie patrzy i momentalnie odwraca wzrok."
    baca_hate "player"
    add_answer "baca" "sznupanie" "p"

odpowiedz_specific "baca" "sznupanie" "f" = do
    player_say ("Stolik jest niezwykle solidny, od razu widać że to dąb", "odpowiadasz z przekonaniem")
    baca_say ("Jaki dąb, widziałeś gdzieś tu bęby? To stara dobra sosna.", "odpowiada mężczyzna i przewraca oczami")
    add_answer "baca" "sznupanie" "f"

odpowiedz_specific "baca" "sznupanie" "w" = do
    player_say ("Co tam rodzaj drewna, grunt że wygląda naprawdę dobrze!", "odpowiadasz")
    baca_say ("Ach, dziękuję. Sam go zrobiłem, ze starej sosny co się pod izbą zwaliła zeszłego lata.", "opowiada mężczyzna")
    add_answer "baca" "sznupanie" "w"

odpowiedz_specific "karolina" "pokoj" "n" = do
    add_answer "karolina" "pokoj" "n"
    spojrz_specific "schronisko"

odpowiedz_specific "karolina" "pokoj" "t" = do
    add_answer "karolina" "pokoj" "n"
    end_intro

odpowiedz_specific "baca" "cialo" "p" = do
    player_say ("Zszedłem na dół bo chciałem się napić kompotu, Karolina już tu leżała", "odpowiadasz")
    baca_say ("Czyli byłeś z nią sam na sam...", "odpowiada pod nosem baca i wpatruje ci się głęboko w oczy")
    add_answer "baca" "cialo" "p"
    hatesPlayer <- do_baca_hate "player"
    if hatesPlayer == True
        then baca_say ("Warszawiaku....", "mówi baca z wyraźną niechęcią")
        else return ()
    hide "baca"

odpowiedz_specific "baca" "cialo" "f" = do
    player_say "Obudził mnie huk, gdy zszedłem ten gość stał nad zwłokami Karoliny!"
    kacper_say ("Oszczerstwo!!!", "wykrzyczał w rekacji na twoje kłamstwo")
    add_answer "baca" "cialo" "f"
    hatesPlayer <- do_baca_hate "player"
    if hatesPlayer == True
        then baca_say ("Tyn z Warszawy i tyn z Warszawy, wszyscy siebie warci", "Baca nie wydaje się przekonany twoim wytłumaczeniem")
        else do
            baca_say ("Ja slyszał że on ze stolycy, tym nigdy nie wolno ufać", "dodał Baca")
            baca_hate "kacper"
    hide "baca"

odpowiedz_specific "baca" "cialo" "w" = do
    player_say "Nie wiem, zbiegłem na dół razem z wami"
    baca_say ("Dziwne, nie widziałem cię.", "odpowiedział Baca z nutą niepewności")
    add_answer "baca" "cialo" "w"
    hide "baca"