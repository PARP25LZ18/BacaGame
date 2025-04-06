# BacaGame - Przebieg Rozgrywki

Grę możemy rozpocząć używając predykatu `start/0`.

Gracz zaczyna grę wchodząc do schroniska w górach, pierwszym etapem gry jest intro, w którym gracz zapoznaje się z mechanikami gry, dostępnymi poleceniami oraz głównymi postaciami. Gracz ma możliwość obejrzenia otaczającego go środowiska za pomocą predykatu `spojrz/1`. Może on również odpowiadać na zadane pytania za pomocą `odpowiedz/2`, gdzie dozwolonymi odpowiedziami są **t** (tak), **n** (nie) lub **w** (wymijająco), **p** (prawda), **f** (fałsz), a każda z odpowiedzi dostępna jest również jako predykat (np. `t/0`).

Aby zakończyć intro, gracz musi spojrzeć na okienko recepcji za pomocą `spojrz(okienko)`, a następnie odpowiedzieć Karolinie używając `odpowiedz(karolina, t)` lub `t`

Następnie, po zapoznaniu się z mechanikami, gracz jest prowadzony przez sekwencję wstępu, w której musi on kolejno "spoglądać" na pogrubione obiekty.
Sekwencja wstępu kończy się wejściem do pomieszczenia Bacy oraz Kacpra. Od tego momentu gracz decyduje o następnych krokach

Gra kończy się w momencie oskarżenia jednego z bohaterów poleceniem `oskarz/1` po wcześniejszym spojrzeniu na stół (`spojrz(stol)`).

W grze dostępne są 3 zakończenia.
- Oskarżenie Bacy
- Oskarżenie Kacpra
- Oskarżenie Gracza przez Bacę i Kacpra

## 2. Polecenia dla przykładowej rozgrywki

Poniżej przedstawiona jest przykładowa rozgrywka. W tym przykładzie nie dochodzi do etapu oskarżania ze względu na przeoczenie przez gracza podłożonego przeciwko niemu dowodu. Jeśli ten dowód zostałby znaleziony, etap oskarżania odbyłby się normalnie (W skrócie, przykład przedstawia jedno ze złych zakończeń)

```
start.
spojrz(schronisko).
spojrz(stol).
p.
spojrz(kominek).
spojrz(mezczyzna).
spojrz(okienko).
t.
start_story.
spojrz(kompot).
spojrz(obiekt).
spojrz(baca).
p.
spojrz(osoba).
t.
spojrz(stol).
spojrz(dzban).
rozpocznij_eksploracje.
show_map.
spojrz(baca).
spojrz(lodowka).
spojrz(salon).
spojrz(kacper).
t.
spojrz(pokoj_bacy).
spojrz(ciupaga).
spojrz(papiery).
spojrz(cialo)
spojrz(gora).
spojrz(pokoj_kacpra).
spojrz(salon).
spojrz(przedsionek).
spojrz(kuchnia).
spojrz(zabrudzenie).
spojrz(stol).
t.
spojrz(dwor).
```
