# „Boom" — pakeitimų perkėlimas viena fraze

Sprendimas: pradėti nuo **A varianto**. Tai greičiausias būdas išbandyti norimą patirtį be didelių struktūrinių pertvarkymų.

## Kaip tai veiks

1. Po kiekvieno užbaigto pakeitimo čia automatiškai išsaugosiu „perkėlimo kortelę" — failą su tiksliais pakeitimais, ribomis ir patikros žingsniais.
2. Rašote `Boom @projektas` (arba `Boom patogumų ikonos @projektas`).
3. Aš nuskaitau tikslinio projekto momentinę kopiją, pritaikau kortelės turinį prie jo failų ir paruošiu vieną galutinę žinutę, kurią įklijuojate į kito projekto pokalbį.
4. Kito projekto asistentas įdiegia pakeitimą identiškai.

## Ką reikia padaryti dabar

1. Įrašyti į projekto atmintį taisyklę, kad `Boom [raktažodis] @projektas` visada reikštų paskutinio pakeitimo perkėlimą identiškai.
2. Sukurti perkėlimo kortelę paskutiniam pakeitimui — patogumų ikonoms.
3. Paruošti ją taip, kad ją įklijavus į Rentivo projektą veiktų be papildomų klausimų.

## Pirmas testas

Išbandysime su `@Rentivo for Property rent`. Jei pavyks sklandžiai, vėliau galėsime svarstyti C variantą (vienas projektas su prekės ženklais), jei perkėlimų bus daug ir jie taps varginantys.

## Techninės detalės

- Kortelės vieta: `.lovable/transfers/<data>-<pavadinimas>.md`.
- Kiekvienoje kortelėje: nauji failai, pakeisti fragmentai, ko neliesti, kaip patikrinti.
- Apribojimai: neliesti `src/routes/api/`, `src/routes/_authenticated/`, `src/components/admin/`, `supabase/`, `src/integrations/`, nekopijuoti `src/routeTree.gen.ts`.
