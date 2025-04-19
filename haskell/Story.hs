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

-- command definitions
spojrz :: Object -> Game ()
spojrz_specific :: Object -> Game ()

-- story

spojrz obj = do
    visible <- can_see obj
    if visible
        then spojrz_specific obj
        else do
            narrate "Nie możesz teraz tego zobaczyć"

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
    narrate "widzisz kominek"
