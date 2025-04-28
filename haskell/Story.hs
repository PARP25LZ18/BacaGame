{-
    Odpowiednik baca.pl
    Tutaj cała historia, każde polecenie powinno działać już podobnie do tego w prologu
    Nie robiłem jeszcze odpowiedzi, trzeba bedzie dodac w game state
-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}

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
    --display_fireplace,
    narrate "Ogień w kominku mocno się pali, drewno musiało być dodane niedawno, całkiem tu gorąco."

spojrz_specific "stol" = do
    --display_table,
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
    --display_baca1,
    maybeAns <- how_answered "baca" "sznupanie"
    case maybeAns of
        Just "p" -> baca_say "\x1b[1;31mWarszawiak w górach? W taką pogodę? Zaskakjące... w każdym razie witoj w moim schronisku, jestem Baca."
        Just "f" -> baca_say "Na drzewach może się nie znosz, ale widzę, że dałeś radę nas ugościć.. i to w taką pogodę. Jestem Baca, witom."
        Just "w" -> baca_say "Witoj, jestem Baca. Rozgość się..."
        Nothing  -> baca_say "Ło, prawie cię nie zauważyłem. Jestem Baca, witoj w moim schronisku"
    hide "mezczyzna"
    narrate "Baca jest starszym mężczyzną o długich, ciemnych włosach, jego sylwetka jest wyjątkowo muskularna jak na jego wiek. Musi tu ciężko pracować."

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

