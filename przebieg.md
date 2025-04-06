# BacaGame - Przebieg Rozgrywki

Grę możemy rozpocząć używając predykatu `start/0`.

Gracz zaczyna grę wchodząc do schroniska w górach, pierwszym etapem gry jest intro, w którym gracz zapoznaje się z mechanikami gry, dostępnymi poleceniami oraz głównymi postaciami. Gracz ma możliwość obejrzenia otaczającego go środowiska za pomocą predykatu `spojrz/1`. Może on również odpowiadać na zadane pytania za pomocą `odpowiedz/2`, gdzie dozwolonymi odpowiedziami są **t** (tak), **n** (nie) lub **w** (wymijająco), **p** (prawda), **f** (fałsz), a każda z odpowiedzi dostępna jest również jako predykat (np. `t/0`).

Aby zakończyć intro, gracz musi spojrzeć na okienko recepcji za pomocą `spojrz(okienko)`, a następnie odpowiedzieć Karolinie używając `odpowiedz(karolina, t)` lub `t`

Następnie, po zapoznaniu się z mechanikami, gracz jest prowadzony przez sekwencję wstępu, w której musi on kolejno "spoglądać" na pogrubione obiekty.
Sekwencja wstępu kończy się wejściem do pomieszczenia Bacy oraz Kacpra. Od tego momentu gracz decyduje o następnych krokach

Gra kończy się w momencie oskarżenia jednego z bohaterów poleceniem `oskarz/1` po wcześniejszym spojrzeniu na stół (`spojrz(stol)`).

## 2. Polecenia dla przykładowej rozgrywki
