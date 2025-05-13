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
import Text.XHtml (clear)
import Distribution.Compat.Lens (set)

-- command definitions
start_game :: Game()
spojrz :: Object -> Game ()
spojrz_specific :: Object -> Game ()
odpowiedz :: Who -> Question -> Game ()
odpowiedz_specific :: Who -> Question -> Answer -> Game ()
show_map :: Game ()
last_stage :: Game()
finale_display_possible_options :: Game ()
oskarz_baca :: Game ()
oskarz_kacper :: Game ()
kacperAccuseSuccess :: Game Bool
bacaAccuseSuccess :: Game Bool

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
    possible_answers <- get_possible_answers
    if input `elem` possible_answers
        then do 
            odpowiedz_specific who question input
            clear_possible_answers
        else do 
            narrate "Nie możesz tak odpowiedzieć, spróbuj jeszcze raz."
            odpowiedz who question

---------- STAGE 1 ----------
start_game = do
    set_stage Introduction
    narrate "Była to zimna grudniowa noc, wybrałeś się w Tatry..."
    narrate "Po 5 godzinach wchodzenia pod górę, wreszcie widzisz przed sobą \x1b[1mschronisko\x1b[0m"
    write_tip "Spróbuj \x1b[1mspojrzeć\x1b[22m\x1b[2m na \x1b[1mschronisko\x1b[0m"
    make_visible "schronisko"


spojrz_specific "schronisko" = do
    display "schronisko"
    narrate "Z komina schroniska wydobywa się ledwo widoczny dym."
    narrate "Baca chyba zainwestował w eko-drewno."
    narrate "...albo gmina go zmusiła. \n\nUznajesz, że nie ma czasu do stracenia, ładujesz się do środka."
    narrate "Od razu po wejściu do schroniska czujesz silną woń kompotu, przed sobą dostrzegasz ręcznie wykonany \x1b[1mmebel."
    narrate "Obok stołu znajduje się ceglany \x1b[1mkominek\x1b[0m. Przed kominkiem, na bujanym fotelu siedzi starszy \x1b[1mmężczyzna."
    narrate "Po drugiej stronie stołu znajduje się \x1b[1mokienko\x1b[0m, które najpewniej jest recepcją oraz miejscem, z którego"
    narrate "przez cały dzień można pobierać ciepłe posiłki."
    write_tip "Możesz \x1b[1mspojrzeć\x1b[22m\x1b[2m na pogrubione obiekty."
    make_visible "mebel"
    make_visible "okienko"
    make_visible "mezczyzna"
    make_visible "kominek"
    hide "schronisko"
    --------------------------------------
    
spojrz_specific "kominek" = do
    display "fireplace"
    narrate "Ogień w kominku mocno się pali, drewno musiało być dodane niedawno, całkiem tu gorąco."

spojrz_specific "mebel" = do
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
    set_possible_answers ["p", "f", "w"]
    odpowiedz "baca" "sznupanie"
    hide "mebel"

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
    write_tip "(t - skończ intro, n - zostań)"
    set_possible_answers ["t", "n"]
    odpowiedz "karolina" "pokoj"
    clear_possible_answers

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
    stage <- get_stage
    case stage of 
        MainStory -> do
            spojrz_specific_baca_main_story
        Exploration -> do
            display "baca_smoking"
            narrate "Baca dalej siedzi przy stole - chyba ból jeszcze go nie opuścił. Pali fajkę próbując go przeczekać."
        _ -> do
            narrate "TODO: catch_all_spojrz_baca"



spojrz_specific "osoba" = do
    display "kacper1"
    narrate "Gość ślamazarnie zbiega ze schodów, przez mrok ciężko ci dostrzec jego sylwetknę oraz twarz"
    narrate "Na pewno jest wysoki, wydaje się być chudy, a płomienie nadają jego twarzy lekki zarys... no i te okulary"
    kacper_say ("Jako student prawa nie godzę się na takie warunki. Ustawowo cisza nocna obowiązuje od godziny 22:00 do 6:00!", "wykrzyczał")
    narrate "Student spojrzał na Karolinę"
    kacper_say "AAAAAAAAAAAAAAAAAAAAAAAA, toż to pogwałcenie artykułu 148! Musimy zawiadomić organy ścigania!!!"
    kacper_say ("Hej ty! Jestem Kacper. Zadzwoń po pogotowie, ja zbadam miejsce zbrodni!", "powiedział Kacper po czym potknął się o stolik znajdujący się w salonie")
    narrate "odpowiedz:"
    write_dialogue_option "t" "Tu nie ma zasięgu."
    write_dialogue_option "n" "Kocham prawo!"
    set_possible_answers ["t", "n"]
    hide "osoba"
    odpowiedz "kacper" "cialo"

---------- STAGE 2 ----------

spojrz_specific "stol" = do
    stage <- get_stage
    case stage of
        MainStory -> spojrz_specific_stol_main_story
        Exploration -> spojrz_specific_stol_exploration
        _ -> narrate "TODO: catch_all_spojrz_stol"

spojrz_specific "dzban" = do
    narrate "Nalewasz kompot do szklanki i szybko pochłaniasz jej zawartość."
    player_think ("Wśród nich jest morderca. Muszę dowiedzieć się kto nim jest. No i zdobyć na to jakiś dowód...", "myślisz sobie")
    narrate "Mija dłuższa chwila milcznia - dociera do ciebie, że musisz ją przełamać - inaczej będziecie trwać w impasie."
    display "player_talking"
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
    hide "dzban"
    rozpocznij_eksploracje

-- Kuchnia

spojrz_specific "kuchnia" = do
    hide_all
    make_visible "baca"
    make_visible "lodowka"
    make_visible "zlew"
    make_visible "stol"
    make_visible "salon"
    narrate "Kuchnia to niewielkie, całkiem przytulne miejsce. W rogu stoi stara \x1b[1mlodówka\x1b[0m, cicho bucząca."
    narrate "Obok \x1b[1mlodówki\x1b[0m znajduje się kuchenny blat, a na nim \x1b[1mzlew\x1b[0m. Na środku pomieszczenia znajduje się"
    narrate "drewniany \x1b[1mstol\x1b[0m, przy którym siedzi \x1b[1mbaca\x1b[0m. Tuż obok jest przejście do \x1b[1msalonu\x1b[0m."

spojrz_specific "zlew" = do
    display "sink"
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
    display "fridge"
    narrate "Lodówka jest stara, zwyczajna, a jej biała farba w kilku miejscach zaczyna się łuszczyć. Na uchwycie zwisają kuchenne ścierki."
    narrate "Otwierasz drzwiczki - lekko skrzypią. W środku są powidła, kiełbasa, smalec i jajka - nie ma tu nic ciekawego"

-- SALON

spojrz_specific "salon" = do 
    hide_all
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
    narrate "Zaraz obok schodów znajduje się \x1b[1mpokoj_bacy\x1b[0m."

spojrz_specific "cialo" = do
    display "dead_body"
    narrate "W miarę jak zbliżasz się do ciała powietrze staje się coraz cięższe, a metaliczny zapach krwi bardziej wyraźny."
    narrate "Ciało Karoliny leży na drewnianej podłodze, otoczona ciemniejącą kałużą krwi. Jej oczy są szeroko otwarte,"
    narrate "jakby w ostatnich chwilach próbowała zrozumieć co się stało. Twarz zastygła w wyrazie bólu i zaskoczneia."
    narrate "Na jej swetrze zauważasz 3 głębokie rany. Ciemne plamy krwi rozlały się wokół nich, wsiąkając w materiał."
    player_think ("Wygląda mi to na rany po nożu.", "wnioskujesz")

spojrz_specific "przedsionek" = do
    display "entryway"
    narrate "Widzisz drewniany przedsionek z prostą ławką i rzędem haczyków na ścianie. Na nich wiszą ciężkie, zimowe kurtki."
    narrate "Drewniana podłoga skrzypi lekko pod stopami. Nie ma tu nic interesującego, wychodzisz i zastanawiasz się co teraz zrobić."

spojrz_specific "kacper" = do
    kacperAns <- how_answered "kacper" "kominek"
    case kacperAns of
        Just "t" -> narrate "Kacper dalej stoi i wygrzewa się przy kominku. Zdaje się być zamyślony"
        Just "n" -> narrate "Widzisz, że Kacper dalej grzebie przy kominku. Ty mu nie pomożesz - wolisz się rozejrzeć"
        Nothing  -> do
            display "kacper_near_fireplace"
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
            set_possible_answers ["t", "n"]
            odpowiedz "kacper" "kominek"
            clear_possible_answers

-- PIWNICA

spojrz_specific "piwnica" = do
    display "basement"
    hide_all
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
    display "basement_picture"
    narrate "Obraz przedstawia górala w tradycyjnym stroju, ukazanego od ramion w górę. Jego twarz"
    narrate "wyraża siłę i determinację, z charakterystycznym, mocnym spojrzeniem."
    player_think ("Mam wrażenie, że skądś kojarze tego górala...", "myślisz sobie")

spojrz_specific "polka" = do
    display "shelf"
    narrate "Na półce dostrzegasz same klasyczne dzieła polskiej literatury - Pan Tadeusz, Dziady, Potop... Nie widzisz nic innego."
    narrate "Książki są dośc stare, ale zadbane. Każda opakowana jest w elegancką skórzaną oprawkę."

spojrz_specific "laptop" = do
    display "laptop"
    narrate "Laptop z góry jest cały obklejony naklejkami - kompletnie ze sobą nie powiązanymi, jakby ktoś przyklejał wszystko co mu w ręce wpadło."
    narrate "Laptop jest podpięty kablem ethernet - ma dostęp do internetu"
    narrate "W każdym razie nie jego wygląd jest najważniejszy, ale czy uda się coś znaleźć w środku."
    narrate "Otwierasz laptopa... I - zabezpieczony hasłem :("
    narrate "Prawie byś już zrezygnował, ale nagle wpada ci pomysł do głowy."
    narrate "Wpisujesz hasło \"1234\" i wciskasz enter."
    narrate "Zostałeś pomyślnie zalogowany. Pierwsze co widać na ekranie to otwarty dymek czatu z koleżanką karoliny"
    karolina_say "to już jest gruba przesada"
    karolina_say "ten dziad kolejny miesiąc spóźnia się z wypłatą"
    karolina_say "dzisiaj to z nim skonfrontuje"
    karolina_say "jak mi nie zapłaci to będziemy się sądzić"
    narrate "Wiadomości wysłane koło godziny 19..."
    player_think ("Może byłby milszy, gdybyś do niego dotrwała", "myślisz sobie")
    looked "laptop"

spojrz_specific "torebka" = do
    display "bag"
    narrate "Jest to zwykła kórzana torba w ciemnym brązie, z gładką powierzchnią i solidnym zamkiem."
    narrate "W jej wnętrzu dostrzegasz małą kosmetyczkę, książkę virginii woolf, oraz czarny \x1b[1mzeszyt\x1b[0m, na którego okładce napisane jest \"NIE CZYTAĆ\"."
    make_visible "zeszyt"

spojrz_specific "zeszyt" = do
    narrate "Ignorując napis na okładce otwierasz zeszyt i zaczynasz go przeglądać. Szybko orientujesz się, że jest to pamiętnik."
    narrate "Przechodzisz do poszukiwania najnowszego wpisu - może on da jakąś wskazówkę."
    narrate "3 marca"
    narrate "Dziś Kacper znów próbował się do mnie zbliżyć. Na początku myślałam, że"
    narrate "tylko mi się wydaje, ale jego zachowanie staje się coraz bardziej nachalne"
    narrate "Chociaż starałam się być delikatna, powiedziałam mu wprost, że nie jestem"
    narrate "nim zainteresowana. Z resztą kto by był? To dzieciak z wybujanym ego, który"
    narrate "myśli, że używanie szykownych słówek sprawi, że będzie postrzegany jako "
    narrate "\"ten inteligenty\" - najgorsze, że to co mówi praktycznie nigdy nie ma sensu."
    narrate "W każdym razie, po tym zaczął zachowywać się dziwnie. To znaczy nie zrobił"
    narrate "nic strasznego, ale mam wrażenie, że zaczął być inny. Boje się, że jest"
    narrate "jakimś psycholem i coś mi zrobi - tak przynajmniej podpowiada mi intuicja."
    narrate "Ahhhh... Mam nadzieję, że jutro będzie milszy dzień."
    hide "zeszyt"
    looked "zeszyt"

-- POKÓJ BACY

spojrz_specific "pokoj_bacy" = do
    hide_all
    make_visible "ciupaga"
    make_visible "papiery"
    make_visible "salon"
    narrate "Wchodzisz do pokoju i przymykasz za sobą drzwi do \x1b[1msalonu\x1b[0m."
    narrate "Pokój Bacy jest surowy i oszczędny, jakby odzwierciedlał charakter jego właściciela."
    narrate "Posiada zwykłe pojedyncze łóżko. W rogu pokoju, oparta o ścianę stoi góralska \x1b[1mciupaga\x1b[0m."
    narrate "Na prostym biurku leżą porozrzucane \x1b[1mpapiery\x1b[0m. W powietrzu unosi się zapach tytoniu i żywicy."

spojrz_specific "papiery" = do
    display "papers"
    narrate "Na biurku leży sterta porozrzucanych papierów, niechlujnie ułożonych w różnych miejscach."
    narrate "Wśród papierów wyróżniają się notatki, które wskazują na ogromne kłopoty finansowe Bacy."
    narrate "Rachunki, wezwania do zapłaty, zapiski z tak licznymi kwotami, że aż nie wierzysz własnym oczom."
    narrate "W jednym z dokumentów zauważasz szczególną pozycję, która powtarza się w różnych miejscach - leczo."
    narrate "Wydaje się, że prawie wszystkie pieniądze Bacy idą na zakup składników na to danie."
    narrate "Brzmi to podobnie jak w tej paście internetowej..."
    narrate "W każdym razie wynika z tego, że Baca tonie w długach."
    looked "papiery"

spojrz_specific "ciupaga" = do
    display "ciupaga"
    narrate "Ciupaga jest stara, ale zadbana. Wykonana jest z drewna, dokładnie starrannie zdobiona."
    player_think ("wow, wygląda nieźle", "myślisz sobie")

-- GÓRA

spojrz_specific "gora" = do
    hide_all
    make_visible "salon"
    make_visible "twoj_pokoj"
    make_visible "pokoj_kacpra"
    narrate "Wchodzisz schodami na górę. Widzisz kilka pustych pokojów, do tego \x1b[1mtwoj_pokoj\x1b[0m, oraz"
    narrate "jak się domyślasz - \x1b[1mpokój Kacpra\x1b[0m. Dostrzegasz też drzwi do łazienki."

spojrz_specific "twoj_pokoj" = do
    didLook <- did_look "twoj_plecak"
    if didLook
        then narrate "Ponownie wchodzisz do swojego pokoju i nie ma tu już nic ciekawego. Momentalnie wychodzisz."
        else do
            narrate "Wchodzisz do swojego pokoju. Zastanawiasz się w sumie po co to zrobiłeś, przecież raczej nic tu nie znajdziesz"
            narrate "Jednak dziwi cie to, że \x1b[1mtwój plecak\x1b[0m zdaje się być inaczej ułożony, niż go odkładałeś."
            make_visible "twoj_plecak"

spojrz_specific "twoj_plecak" = do
    narrate "Nie dawało ci to spokoju - coś z tym plecakiem zdaje się być nie tak. Przeglądasz kieszonki - nic wszystko się zgadza."
    narrate "Zaglądasz do dużej kieszeni i nie możesz uwierzyć własnym oczom..."
    narrate "Widzisz opakowany w torebkę foliową nóż, ze śladami krwi."
    player_think ("Ktoś próbuje mnie wrobić! Muszę się tego jakoś pozbyć.", "myślisz sobie")
    narrate "Jak najciszej otwierasz okno i wyrzucasz przez nie nóż z całej siły."
    write_info "Gratulacje pozbyłeś się dowodu na siebie!"
    hide "twoj_plecak"
    looked "twoj_plecak"

spojrz_specific "pokoj_kacpra" = do
    narrate "Pokój Kacpra wygląda identycznie jak twój - stary, ciasny. Na szafce nocnej leżą książki z literaturą."
    narrate "Obok łóżka dostrzegasz skórzaną, ciemnobrązową \x1b[1maktówkę Kacpra\x1b[0m."
    make_visible "aktowka_kacpra"

spojrz_specific "aktowka_kacpra" = do
    narrate "W aktówce panuje porządek - zbyt wielu rzeczy nie ma w środku - klucze, portfel, telefon i jakiś zeszyt"
    narrate "Zaglądasz do tego zeszytu. Pełen jest wierszy. Sam na wierszach się nie znasz, ale nie wydają się szczególnie górnolotne."
    narrate "Przewijasz do ostatniej najświeższej strony i zauważasz tam:"
    narrate "Odrzuciła mnie, nic nie czuję,"
    narrate "Jestem pusty, tylko cień,"
    narrate "Ona śmieje się, patrzy na mnie z góry."
    narrate "..."
    narrate "Nie pośmieje się za długo."
    looked "aktowka_kacpra"


spojrz_specific "znalezisko" = do
    narrate "Przyglądasz się znalezisku Kacpra... zauważasz, że jest to twój plecak..."
    kacper_say "A teraz.. Panie i Panowie.. hehe.. a raczej panowie.. przejdźmy do meritum!"
    narrate "Kacper wyciąga z głównej kieszeni plecaka foliową torebkę, ale upuszcza ją na stół..."
    narrate "Z torebki wypada nóż... jest cały pokryty krwią..."
    player_think("Ten głupi student mnie wrobił...", "pomyślałeś")
    player_say "Baca! To nie tak jak myślisz... Kacper ewidentnie mnie wrobił! Nie miałbym powodu zabijać Karoliny!"
    baca_say "Mhmmm.. Kacprze.. myślę, że twoje dowody stanowią.. em.. Absolutum tej sprawy.. tak.. mhm.."
    kacper_say "TAK! PANIE BACO! WIEDZIAŁEM, ŻE W KOŃCU SIĘ ZROZUMIEMY!"
    baca_say "To co, młody, wyjdziesz stąd sam, czy mam cię zmusić!?"
    kacper_say "Panie Baco! Powinniśmy najpierw zebrać dowody... na pewno GOPR jest w okolicy!"
    baca_say "Nie, Warszawiaku, załatwimy to po góralsku..."
    player_think ("Muszę teraz ostrożnie dobierać słowa...", "")
    write_tip "Odpowiedz Bacy"
    write_dialogue_option "t" "Tym razem wygrałeś... Kacper... już wychodzę... ale wiedz, że to nie ja ją zabiłem, Baco."
    write_dialogue_option "n" "Nie wyjdę z tego pomieszczenia dopóki nie udowodnię wam swoją niewinność!"
    set_possible_answers ["t", "n"]
    hide "znalezisko"
    odpowiedz "baca" "wypad"
    clear_possible_answers

--- Endings ---

spojrz_specific "dwor" = do
    hide_all
    display "bad_ending"
    narrate "Nie udało się złapać mordercy, na domiar złego musisz szukać innego schornienia"
    narrate "Śpiesz się, robi się ciemno..."

spojrz_specific "piecyk" = do
    hide_all
    display "shady_ending"
    baca_say ("No młody... mamy go z głowy, teraz słuchaj mnie uważnie", "powiedział ze spokojem baca po czym usiadł przy piecyku")
    baca_say ("Jesteśmy tu tylko we dwóch. Sprzątniesz teraz ciało dziołchy i nikomu o niczym tutaj nie wspomnisz", "powiedział patrząc ci w oczy baca\x1b[0m")
    baca_say ("A jak usłyszę tutaj miastową straż, możesz być pewien że chłopaki z bacówki cię znajdą", "mówiąc to wskazał na ciebie swoją ciupagę")
    narrate "Słowa bacy z pewnością nie napawają cię optymizmem... No cóż, przynajmniej nie ma tu już Kacpra"
    
spojrz_specific "podloga" = do
    hide_all
    display "good_ending"
    narrate "Podnosisz Kacpra z podłogi. Baca dalej leży nieprzytomny, stwierdziliście że musicie wezwać tu policję... lub przynajmniej GOPR."
    narrate "Wybiegacie z izby i kierujecie się w stronę najbliżego szlaku."
    kacper_say ("Wspaniale, że udało nam się uciec od tego popaprańca... teraz mamy chwilę by porozmawiać o prawie cywilnym!", "rozpromieniał Kacper")
    narrate "Przez chwilę przyszło ci do głowy, że mogłeś jednak iść sam"

------------------------------------------------------------
-------------------------- OTHER --------------------------- 
------------------------------------------------------------

end_intro = do
    liftIO $ putStr "\n> " >> hFlush stdout
    hide_all
    narrate "Karolina zaprowadziła cię do twojego pokoju."
    narrate "Rozglądasz się po pokoju - obdrapane ściany, stare drewniane meble, słabe światło pojedynczej żarówki."
    narrate "Nie wygląda najlepiej, ale luksusów nie oczekiwałeś. Wyboru dużego nie miałeś - Właściwie to nie miałeś go wcale."
    player_say ("Przynajminej na głowe nie sypie...", "mruczysz pod nosem")
    narrate "Pojechałeś w góry, licząc, że na szlaku znajdziesz trochę spokoju - ucieczkę od obowiązków i niekończących się myśli o przyszłości."
    narrate "Studia powoli dobiegają końca. Jeszcze kilka miesięcy i zostaniesz rzucony w dorosłość."
    narrate "Pracy jest więcej niż kiedykolwiek, a odpowiedzialność zaczyna ciążyć jak plecak, który niosłeś przez całą drogę tutaj."
    narrate "Zrzucasz go z siebie... Wzdychasz ciężko i padasz na materac. Niemal natychmiast zasypiasz..."
    narrate ". . ."
    start_story

start_story = do
    set_stage MainStory
    liftIO $ putStr "\n> " >> hFlush stdout
    narrate "Budzisz się. Spoglądasz na zegarek. 1:12."
    narrate "Czujesz suchość w ustach, zmęczenie po przyjściu do schroniska spowodowało, że zapomniałeś, że od dawna nic już nie piłeś..."
    narrate "Przypominasz sobie, że na stole w holu schroniska stał \x1b[1mkompot\x1b[0m. Nie możesz przestać o nim myśleć."
    narrate "Czujesz, że nie będzie to łatwa noc."
    make_visible "kompot"

all_dialogued = do
    baca_say ("Dobra, siadojcie do stołu. Nikt stąd nie wyjdzie dopóki nie wyłonimy mordercy.", "powiedział Baca i postawił na \x1b[1mstole\x1b[0m wielki dzban kompotu")
    kacper_say ("Tak!! Czekałem na ten moment całe życie! Moje umiejętności społecznej dedukcji zakończą tą sprawę w sekundę!", "wtrąca Kacper i siadając do \x1b[1mstołu\x1b[0m potyka się o jego nogę.")
    narrate "Baca spogląda na Kacpra z zażenowaniem"
    bacaHatesPlayer <- do_baca_hate "player"
    if bacaHatesPlayer
        then baca_say "A ty czego się patrzysz!?"
        else narrate "Baca patrzy ci prosto w oczy."
    narrate "Momentalnie odwracasz spojrzenie."
    hide "kompot"
    make_visible "stol"

finish_body_question = do
    kacperAnswered <- how_answered "kacper" "cialo"
    bacaAnswered <- how_answered "baca" "cialo"
    if kacperAnswered /= Nothing && bacaAnswered /= Nothing
        then all_dialogued
        else return()

rozpocznij_eksploracje = do
    set_stage Exploration
    narrate "Wstajesz od stołu. Chcesz się rozejrzeć"
    write_info "Możesz teraz eksplorować schronisko, aby zakończyć eksploracje i skonfrontować znaleziska dostań się do kuchni i spojrz na stol."
    write_info "Przejdziesz wtedy do finalnej rozmowy z Bacą i Kacprem rzucając swoje oskarżenie i argumentując je."
    write_tip "Po mapie poruszasz się używając komendy \x1b[1mspojrz\x1b[22m\x1b[2m, przydatna okazać się może komenda \x1b[1mlvo\x1b[22m\x1b[2m - listująca widoczne obiekty"
    write_tip "Aby wyświetlić mapę użyj komendy show_map."
    make_visible "kuchnia"

show_map = do
    stage <- get_stage
    case stage of 
        Exploration -> do
            display "ground_floor_map"
        _ -> do
            narrate "Nie możesz teraz tego zrobić. Przeglądanie mapy jest możliwe tylko w fazie eksploracji."

last_stage = do
    hide_all

    bacaHatesPlayer <- do_baca_hate "player"
    didLookAtBackPack <- did_look "twoj_plecak"
    answeredKacperKominek <- how_answered "kacper" "kominek"

    if bacaHatesPlayer && not didLookAtBackPack
        then do
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
            return()
        else if not didLookAtBackPack
            then do
                narrate "Powoli odsuwasz krzesło, siadając do stołu zauważasz, że Baca ciągle patrzy na schody... jakby czegoś oczekując"
                narrate "Słyszysz, że za twoimi plecami Kacper zbiega ze schodów"
                kacper_say "ZNALAZŁEM! ZNALAZŁEM! WIEM KTO ZABIŁ KAROLI-"
                narrate "... Nagle słyszysz głośny huk. Kacper spada ze schodów i rzuca przed siebie swoje \x1b[1mznalezisko\x1b[0m"
                baca_say "No no... co my tutaj mamy..."
                narrate "Kacper szybko wstaje z ziemii..."
                kacper_say "TO ON ZABIŁ KAROLINĘ!!!"
                narrate "Kacper pokazuje na ciebie..."
                make_visible "znalezisko"
                return()
            else do
                case answeredKacperKominek of
                    Just "t" -> do
                        baca_say ("I jak tam młodzi?... Uuuf ale gorąco", "powiedział baca i zdjął gruby sweter")
                        narrate "To co się pod nim znalazło odjęło wam mowę - zobaczyliście na jego białej góralskiej koszuli plamę krwi."
                        kacper_say ("CO TO JEST?!!!!", "krzyknął w przerażeniu kacper, wskazując palcem na plamkę krwi")
                        narrate "Baca spojrzał się na swoją koszulę i powiedział spokojnym głosem:"
                        baca_say "Aaaa, o to wam się rozchodzi. Nie bójcie się. Zarzynałem wczoraj koguta na rosół. Musioł żem nie zauważyć, że mi na koszulę chlapło."
                        narrate "Ta sytuacja wzbudziła w Kacprze podejrzliwość do bacy."
                        baca_say "W każdym razie jak tam młokosy? Znaleźliśta coś?"
                    _ -> do
                        baca_say "I jak młodzi? Znaleźiśta coś?"

                write_info "Jesteś w ostatniej fazie gry. Możesz skonfrontować informacje odkryte w fazie eksploracji."
                write_info "Dostajesz również dostęp do komendy oskarż, która spowoduje wyprowadzenie oskarżenia w stronę bacy lub kacpra"
                write_info "Sukces twojego oskarżenia zależy od odkrytych informacji, ale też od relacji ustanowionych z innymi osobami."
                finale_display_possible_options

finale_display_possible_options = do
    lookedAtLaptop <- did_look "laptop"
    lookedAtPapiery <- did_look "papiery"
    lookedAtZeszyt <- did_look "zeszyt"
    lookedAtAktowkaKacpra <- did_look "aktowka_kacpra"

    answeredA <- answered "baca" "odkryte_informacje" "a"
    answeredB <- answered "baca" "odkryte_informacje" "b"
    answeredC <- answered "baca" "odkryte_informacje" "c"
    answeredD <- answered "baca" "odkryte_informacje" "d"

    let possibleAnswers = concat 
            [ ["a" | lookedAtLaptop && not answeredA]
            , ["b" | lookedAtPapiery && not answeredB]
            , ["c" | lookedAtZeszyt && not answeredC]
            , ["d" | lookedAtAktowkaKacpra && not answeredD]
            , ["oskarz baca"]
            , ["oskarz kacper"]
            ]

    if lookedAtLaptop && not answeredA
        then write_dialogue_option "a" "Baca nie płacił Karolinie i miała to z nim skonfrontować."
        else write_dialogue_option "-" "OPCJA NIEDOSTĘPNA"

    if lookedAtPapiery && not answeredB
        then write_dialogue_option "b" "Baca tonie w długach."
        else write_dialogue_option "-" "OPCJA NIEDOSTĘPNA"

    if lookedAtZeszyt && not answeredC
        then write_dialogue_option "c" "Karolina odrzuciła Kacpra. Kobieca intuicja mówiła jej, że jest groźny."
        else write_dialogue_option "-" "OPCJA NIEDOSTĘPNA"

    if lookedAtAktowkaKacpra && not answeredD
        then write_dialogue_option "d" "Kacper ma w zeszycie wiersz, który sugeruje, że jest niestabilny psychicznie."
        else write_dialogue_option "-" "OPCJA NIEDOSTĘPNA"
    
    write_info "Masz dostęp do polecenia: \x1b[1moskarz baca/kacper\x1b[0m"
    write_info "Wywołanie polecenia spowoduje oskarżenie postaci o morderstwo i natychmiastowy koniec gry."
    write_info "W zależności od twoich relacji z postaciami, oskarżenie może mieć różny wynik"
    set_possible_answers possibleAnswers
    odpowiedz "baca" "odkryte_informacje"

last_stage_more_clues = do
    baca_say "Coś jeszcze?"
    finale_display_possible_options

--- Oskarzanie 

oskarz_baca = do
    success <- bacaAccuseSuccess
    if success
        then ending_baca
        else ending_player

oskarz_kacper = do
    success <- kacperAccuseSuccess
    if success
        then ending_kacper
        else ending_player

bacaAccuseSuccess = do
    answeredA <- answered "baca" "odkryte_informacje" "a"
    answeredB <- answered "baca" "odkryte_informacje" "b"
    helpedKominek <- answered "kacper" "kominek" "t"

    hatesFromKacper <- do_kacper_hate "baca"
    hatesFromKacperToPlayer <- do_kacper_hate "player"

    let score = sum
            [ if answeredA then 1 else 0
            , if answeredB then 1 else 0
            , if helpedKominek then 1 else 0
            , if hatesFromKacper then 1 else 0
            , if hatesFromKacperToPlayer then -1 else 0
            ]

    return (score >= 3)

kacperAccuseSuccess = do
    answeredC <- answered "baca" "odkryte_informacje" "c"
    answeredD <- answered "baca" "odkryte_informacje" "d"

    hatesFromBaca <- do_baca_hate "kacper"
    hatesFromBacaToPlayer <- do_baca_hate "player"

    let score = sum
            [ if answeredC then 1 else 0
            , if answeredD then 1 else 0
            , if hatesFromBaca then 1 else 0
            , if hatesFromBacaToPlayer then -1 else 0
            ]

    return (score >= 2) 


--- Endings

ending_kacper = do
    display "ending_kacper"
    player_say "Myślę, że to był kacper, ale może jeszcze chwilę się zastanówmy."
    baca_say ("Nie mogę już tego słuchać! Przyjacielu to oczywiste, że ten warszawiak zabił Karolinkę!", "wykrzyczał patrząc na ciebie baca")
    kacper_say ("C.Co.. TO OSZCZERSTWA, ARGUMENT AD PERSONAM! Nigdy bym jej nie zab...", "odparł szybko Kacper")
    baca_say ("Mam już tego dość! Albo ty albo on!", "przerwał mu rozwcieczony baca")
    narrate "Niepewny sytuacji wolisz nie reagować, pozostaje ci tylko patrzeć jak baca wypycha kacpra na śnieg za izbą, a następnie siada przy \x1b[1mpiecyku\x1b[0m"
    make_visible "piecyk"


ending_baca = do
    display "ending_baca"
    kacper_say ("Hmmmmm no nie wiem, kto to zrobił, musimy przeprowadzić głosowanie najlepiej metodą kontrpośrednich", "powiedział jak zwykle bez sensu niedoszły prawnik")
    player_say ("Kacper, to musiał zrobić baca!", "łapiesz warszawiaka za płaszcz i potrząsasz nim")
    baca_say ("Co?! W mojej izbie dwóch mieszczuchów przeciwko mnie spiskuje?!", "wściekł się baca i złapał za ciupagę")
    kacper_say ("W imię prawa nakazuję ci złożyć broń!", "wykrzyczał kacper potykając się o stół w salonie")
    narrate "Kacper szczęśliwie wylądował prosto na bacy, zderzając się z nim głową. Baca oraz Kacper leżeli teraz wpółprzytomnie na \x1b[1mpodłodze\x1b[0m."
    make_visible "podloga"

ending_player = do
    display "ending_player"
    player_say "Ja wiem! wiem kto zabi-"
    baca_say ("CICHO!", "krzyczy baca nie dając ci skończyć zdania")
    baca_say ("Ja żem już wystarczająco widzoł! To ty zabiłeś dziołchę Warszawiaku", "powiedział baca z obrzydzeniem w oczach")
    kacper_say ("Pan baca ma rację, nie ma jak wezwać organy ścigania, a ja nie będę tu siedział z mordercą", "dołączył się kacper")
    baca_say ("Nie próbuj uciekać", "odpowiedział baca chwytając cię za bark i wyrzucając na \x1b[39;1mdwór\x1b[0m")
    make_visible "dwor"

------------------------------------------------------------
----------------------- ODPOWIEDZ -------------------------- 
------------------------------------------------------------


--- Baca Sznupanie ---

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

--- Karolina Pokój ---

odpowiedz_specific "karolina" "pokoj" "n" = do
    add_answer "karolina" "pokoj" "n"
    write_tip "Użyj komendy \x1b[1mlvo\x1b[22m\x1b[2m, aby wyświetlić widoczne obiekty"

odpowiedz_specific "karolina" "pokoj" "t" = do
    add_answer "karolina" "pokoj" "t"
    end_intro

--- Baca Ciało ---

odpowiedz_specific "baca" "cialo" "p" = do
    player_say ("Zszedłem na dół bo chciałem się napić kompotu, Karolina już tu leżała", "odpowiadasz")
    baca_say ("Czyli byłeś z nią sam na sam...", "odpowiada pod nosem baca i wpatruje ci się głęboko w oczy")
    add_answer "baca" "cialo" "p"
    hatesPlayer <- do_baca_hate "player"
    if hatesPlayer == True
        then baca_say ("Warszawiaku....", "mówi baca z wyraźną niechęcią")
        else return ()
    hide "baca"
    finish_body_question

odpowiedz_specific "baca" "cialo" "f" = do
    player_say "Obudził mnie huk, gdy zszedłem ten gość stał nad zwłokami Karoliny!"
    kacper_say ("Oszczerstwo!!!", "wykrzyczał w rekacji na twoje kłamstwo")
    add_answer "baca" "cialo" "f"
    hatesPlayer <- do_baca_hate "player"
    if hatesPlayer
        then baca_say ("Tyn z Warszawy i tyn z Warszawy, wszyscy siebie warci", "Baca nie wydaje się przekonany twoim wytłumaczeniem")
        else do
            baca_say ("Ja slyszał że on ze stolycy, tym nigdy nie wolno ufać", "dodał Baca")
            baca_hate "kacper"
    hide "baca"
    finish_body_question

odpowiedz_specific "baca" "cialo" "w" = do
    player_say "Nie wiem, zbiegłem na dół razem z wami"
    baca_say ("Dziwne, nie widziałem cię.", "odpowiedział Baca z nutą niepewności")
    add_answer "baca" "cialo" "w"
    hide "baca"
    finish_body_question

--- Kacper Ciało ---

odpowiedz_specific "kacper" "cialo" "t" = do
    add_answer "kacper" "cialo" "t"
    player_say ("Przecież tutaj nie ma zasięgu.", "odpowiadasz")
    kacper_say ("Pff, mogłem się domyślić że ten stary dziad nie wie że telelinie można poprowadzić za pośrednictwem łącza bianalogowego.", "powiedział nonszalandzko Kacper")
    narrate "Jako student informatyki dociera do ciebie, że Kacper nie ma pojęcia o czym mówi."
    kacper_say "No nic w takim razie będziemy musieli przepowadzić resustytacje krążeniowo oddechową, ty zacznij ja poszukam gazy oraz opatrunku uciskowego"
    narrate "Kacper zniknął w ciemności, usłyszałeś tylko że znowu potknął się o ten sam stolik"
    kacper_hate "baca"
    finish_body_question


odpowiedz_specific "kacper" "cialo" "n" = do
    add_answer "kacper" "cialo" "n"
    player_say ("O mój boże kocham prawo! Na jakim uniwersytecie studiujesz?", "mówisz entuzjastycznie")
    kacper_say "Proszę, proszę. Miałem cię za prostaka jednak widzę, że napotkałem erudytę! Otóż mój drogi uczęszczam do Akademii Prawa i Filizofii w Warszawie."
    kacper_say "Jestem niezmiernie ciekaw twojego miejsca pobierania nauk, może mamy wspólnych znajomych!"
    write_tip "Odpowiedz Kacprowi p/f/w"
    write_dialogue_option "p" "Właściwie to studiuje informatykę."
    write_dialogue_option "f" "Eeee... Jestem na SWPSie."
    write_dialogue_option "w" "Jeszcze będzie czas na takie rozmowy, skupmy się na problemie."
    set_possible_answers ["p", "f", "w"]
    odpowiedz "kacper" "uczelnia"

--- Kacper Uczelnia ---

odpowiedz_specific "kacper" "uczelnia" "p" = do
    add_answer "kacper" "uczelnia" "p"
    player_say ("W sumie to nie studiuję prawa, jestem studentem informatyki", "odpowiadasz")
    kacper_say ("Ehhh... ścisłowiec, no nic kolego, nie twoja wina że jesteś ciemnotą", "odparł rozczarowany Kacper")
    finish_body_question

odpowiedz_specific "kacper" "uczelnia" "f" = do
    add_answer "kacper" "uczelnia" "f"
    player_say ("Eeee... Jestem na SWPSie.", "mówisz niepewnie")
    kacper_say ("O super, moja przyjaciółka tam studiuje, podobno jest całkiem w porządku, ale do mojej uczelni się nie umywa.", "powiedział dumnie")
    narrate "Kacper wyraźnie lubi się dzielić własnymi opiniami. Nawet mu przez myśl nie przeszło, żeby zapytać, czy znasz jego koleżankę..."
    finish_body_question

odpowiedz_specific "kacper" "uczelnia" "w" = do
    add_answer "kacper" "uczelnia" "w"
    player_say "Jeszcze będzie czas na takie rozmowy. Na razie skupmy się na problemie."
    kacper_say "Co racja, to racja! Musimy rozwikłać zagadkę morderstwa!" 
    finish_body_question

--- Game FinalStage
    
odpowiedz_specific "game" "final_stage" "t" = do
    last_stage

odpowiedz_specific "game" "final_stage" "n" = do
    narrate "Wróć tu, gdy będziesz gotowy przejść do następnego etapu. Powodzenia!"

--- Kacper Kominek

odpowiedz_specific "kacper" "kominek" "t" = do
    add_answer "kacper" "kominek" "t"
    player_say ("Pewnie. Może chociaż temperatura nie będzie jak w kostnicy.", "mimowolnie zarzuciłeś żartem")
    narrate "Kacper zmarszczył brwi - chyba twój żart mu się nie spodobał."
    narrate "Dorzucasz drewno do kominka. Słyszysz krzyk bacy z daleka."
    baca_say "Łoszaleliśta! Z dymem mnie puścić chcecie?! Myślicie, że drewno to z nieba spada?!"
    narrate "Obydwaj z Kacprem zdajecie się udawać, że nic nie słyszeliście."
    kacper_say ("Dzięki za pomoc. Przynajmniej nie zamarzniemy.", "powiedział")
    kacper_say "Posiedzę tu jeszcze, żeby się ogrzać. W zimnie fluorescencja w mózgu działa wadliwie"
    player_think ("Zimno jest, ale nie wytrzymam przy nim. Cały czas gada takie głupoty... Rozejrzę się.", "myślisz sobie")
    narrate "Odchodzisz od kominka"

odpowiedz_specific "kacper" "kominek" "n" = do
    add_answer "kacper" "kominek" "n"
    player_say ("Teraz nie mam na to czasu. Chcę się rozejrzeć i jak najszybciej wyjaśnić sprawę.", "odpowidasz")
    kacper_say "Oczywiście… cóż za naiwność z mej strony. Liczyć na solidarność w czasach tak niepewnych, to jak oczekiwać jasności prawa w ustawie podatkowej"
    kacper_say "Nie szkodzi. Niech zatem zgaśnie płomień. Niech ciemność obejmie ten przybytek chłodem egzystencjalnej nicości."
    kacper_say "Skoro ogień nas opuścił, może i my powinniśmy się przygotować… na koniec."
    kacper_say "To tutaj. W tym salonie, wśród wspomnień i pleśni, zakończy się historia człowieka. Niegodnie. Zmarzniętego. Bez koca. Bez sensu. I bez nadziei"
    player_think ("Ale dramatyzuje... Idę rozglądać się dalej.", "pomyślałeś")

--- Baca Odkryte Informacje

odpowiedz_specific "baca" "odkryte_informacje" "a" = do
    bacaAnswered <- how_answered "baca" "odkryte_informacje"
    add_answer "baca" "odkryte_informacje" "a"
    player_say "Baca nie płacił Karolinie, wczoraj miała z nim to skonfrontować i już chciała się z nim sądzić"
    baca_say "Tak, skonfrontowała to ze mną i właśnie jej zapłaciłem"
    case bacaAnswered of
        Just "b" -> kacper_say "Ciekawe z czego! Przecież toniesz w długach"
        _ -> return()
    last_stage_more_clues

odpowiedz_specific "baca" "odkryte_informacje" "b" = do
    bacaAnswered <- how_answered "baca" "odkryte_informacje"
    add_answer "baca" "odkryte_informacje" "b"
    player_say "Baca tonie w długach. I to na takie kwoty, że aż wierzyć mi się nie chce."
    case bacaAnswered of
        Just "a" -> kacper_say "Aha!!! Czyli nie miałeś z czego zapłacić Karolinie!"
        _ -> return()
    last_stage_more_clues

odpowiedz_specific "baca" "odkryte_informacje" "c" = do
    bacaAnswered <- how_answered "baca" "odkryte_informacje"
    add_answer "baca" "odkryte_informacje" "c"
    player_say "Karolina odrzuciła zaloty Kacpra i jej kobieca intuicja mówiła jej, że jest niebezpieczny."
    kacper_say ("Tak, odrzuciła mnie... to prawda.", "przyznał smutno")
    kacper_say "Ale to wcale nie znaczy, że ja ją skrzywdziłem."
    kacper_say ("Nigdy bym czegoś takiego nie zrobił...", "dodał")
    case bacaAnswered of
        Just "d" -> baca_say "Oj mieszczuchu... Twoje zapiski mówią inaczej"
        _ -> return()
    last_stage_more_clues

odpowiedz_specific "baca" "odkryte_informacje" "d" = do
    bacaAnswered <- how_answered "baca" "odkryte_informacje"
    add_answer "baca" "odkryte_informacje" "d"
    player_say "Kacper napisał dziwny wiersz, który może świadczyć, że jest niestabilny psychicznie."
    baca_say ("Przynieś no ten wiersz Kacper. Zobaczymy co żeś tam napisał", "powiedział")
    narrate "Kacper przyniósł wiersz i go przeczytał"
    case bacaAnswered of
        Just "c" -> baca_say "No powiedziałbym, żeś się na piśmie do czynu przyznał!"
        _   -> return ()
    last_stage_more_clues

odpowiedz_specific "baca" "odkryte_informacje" "oskarz baca" = do
    add_answer "baca" "odkryte_informacje" "oskarz baca"
    oskarz_baca

odpowiedz_specific "baca" "odkryte_informacje" "oskarz kacper" = do
    add_answer "baca" "odkryte_informacje" "oskarz kacper"
    oskarz_kacper


--- Baca Wypad

odpowiedz_specific "baca" "wypad" "t" = do
    narrate "Powoli zakładasz buty... Ostatni raz patrzysz na schronisko..."
    narrate "Może gdybyś dokładniej je przeszukał, udałoby ci się znaleźć mordercę..."
    narrate "Otwierasz drzwi i wychodzisz na \x1b[1mdwór\x1b[0m"
    make_visible "dwor"

odpowiedz_specific "baca" "wypad" "n" = do
    baca_say "sam się o to prosiłeś, młody..."
    narrate "Baca chwyta za ciupagę. Widzisz tylko jak w mgnieniu oka się nią zamachuje i... padasz na ziemię."
    narrate "Budzi cię krzyk kacpra..."
    kacper_say "TAK PANIE BACO!!! MAMY GO!!!"
    narrate "Chcesz wyjaśnić Bacy co się wydarzyło... ale przez ból nie jesteś w stanie wydobyć z siebie ani słowa..."
    narrate "Baca zauważa, że zaczynasz odzyskiwać przytomność... pewnym ruchem łapie za twoją koszulę i wyrzuca cię na \x1b[1mdwór\x1b[0m"
    make_visible "dwor"



--- SPOJRZ SPECIFIC CONDITIONAL ON GAME STAGE HANDLERS
spojrz_specific_baca_main_story = do
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
    set_possible_answers ["p", "f", "w"]
    hide "baca"
    odpowiedz "baca" "cialo"

spojrz_specific_stol_main_story = do
    narrate "Zasiadasz do stołu z Bacą i Kacprem. Ogień w kominku już się dopala..."
    narrate "Przed tobą stoi najprawdopodobniej ostatni \x1b[1mdzban\x1b[0m słynnego kompotu Karoliny."
    narrate "Zauważasz, że Kacper trzyma ręce pod stołem i nerwowo spogląda naprzemiennie na ciebie i na Bacę."
    narrate "Baca z kolei, wydaje się spokojny, spogląda na Ciebie oraz Kacpra z wyższością... do tego stopnia, że zaczynasz drugi raz zastanawiać się, czy to nie ty zabiłeś Karolinę..."
    make_visible "dzban"
    hide "stol"

spojrz_specific_stol_exploration = do
    write_info "Spojrzenie na stół będzie przeniesie cie do następnego etapu gry. Nie będziesz mógł już eksplorować"
    write_info "Czy jesteś pewny, że chcesz przejść dalej?"
    write_dialogue_option "t" "Tak, chcę przejść dalej."
    write_dialogue_option "n" "Nie, chcę się jescze rozejrzeć."
    set_possible_answers ["t", "n"]
    odpowiedz "game" "final_stage"
