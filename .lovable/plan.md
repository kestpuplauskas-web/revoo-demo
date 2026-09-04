# „Boom" — pakeitimų perkėlimas į kitą projektą viena fraze

Tikslas: parašius `Boom @projektas` (arba `Boom` ir projekto pavadinimą), paskutinis šiame projekte padarytas pakeitimas būtų perkeltas į nurodytą projektą 1:1, be papildomų paaiškinimų.

## Kaip tai veiks

1. Kiekvieną kartą, kai baigiu pakeitimą čia, automatiškai išsaugau jo „perkėlimo kortelę" — tikslų failų ir pakeitimų sąrašą.
2. Parašius `Boom @projektas`, paimu paskutinę kortelę ir paruošiu perkėlimo užduotį tam projektui.
3. Jei norite perkelti ne paskutinį, o ankstesnį darbą, rašote `Boom ikonos @projektas` — raktažodis parenka kortelę.

## Ką reikia įrašyti į projekto atmintį

Taisyklė (visada galiojanti):

- `Boom [raktažodis] @projektas` = perkelti nurodytą (arba paskutinį) pakeitimą į tą projektą identiškai, nekeičiant nieko kito.
- Po kiekvieno užbaigto pakeitimo išsaugoti perkėlimo kortelę faile `.lovable/transfers/<data>-<pavadinimas>.md`.

## Perkėlimo kortelės turinys

- Pakeitimo pavadinimas ir data
- Nauji failai (visas turinys arba kelias)
- Pakeisti failai su tiksliais fragmentais
- Duomenų bazės pakeitimai (jei buvo)
- Ko neliesti tiksliniame projekte
- Patikros žingsniai

## Apribojimai, kuriuos verta žinoti

Vienu pranešimu dirbu tik viename projekte, todėl `Boom` veiks taip: aš paruošiu tikslią, paruoštą įklijuoti užduotį (arba, jei projektai susieti, pats perskaitysiu tikslinio projekto failus per cross-project įrankį). Praktiškai jums lieka vienas veiksmas — atidaryti kitą projektą ir įklijuoti paruoštą tekstą.

## Pirmas žingsnis, kai patvirtinsite

1. Įrašau `Boom` taisyklę į projekto atmintį.
2. Atgaline data sukuriu kortelę ką tik įdiegtoms patogumų ikonoms — kad galėtumėte iš karto išbandyti `Boom @Rentivo for Property rent`.
