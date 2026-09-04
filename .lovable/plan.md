# Perkėlimo instrukcija į „Rentivo for Property rent"

Į kitą projektą tiesiogiai rašyti negaliu — kitų projektų kodą matau tik skaitymo režimu. Todėl paruošiu tikslią, kopijuojamą užduotį, kurią įklijavus Rentivo projekte tenykštis agentas atliks perkėlimą identiškai.

## Ką paruošiu

1. **Kopijuojama žinutė** (pateiksiu tiesiai pokalbyje ir kaip `.md` failą atsisiuntimui), kurioje bus:
   - nuoroda į šaltinio projektą (Revoo demo, `b0a80806-831d-41b1-ae8b-e94ded94143e`) su `@` referencija;
   - tikslus šiandien pakeistų / naujų failų sąrašas;
   - aiškios ribos: liesti tik frontend; nekeisti `src/routes/api/`, `src/routes/_authenticated/`, `src/components/admin/`, `supabase/`, `runtime-env.server.ts`, `rentivo.functions.ts`, `src/routeTree.gen.ts`;
   - darbų eiliškumas ir patikros žingsniai.

2. **Perkeliamų pakeitimų apimtis** (šiandienos darbas):
   - Home V2 kaip vienintelė pradinė versija; sena Home V1 (`Hero.tsx`, `AvailabilityBand.tsx`, `Ratings.tsx`) šalinama; `/home-v2` → redirect į `/`.
   - Nauji: `HeroV2.tsx`, `RatingsAndTestimonials.tsx`, `Testimonials.tsx`, `src/components/search/*` (`SearchBar`, `DateRangeField`, `GuestsField`, `plural.ts`), `BookingDateRange.tsx`.
   - Naujas rezultatų puslapis `/laisvi-kambariai` ir `/en/laisvi-kambariai` su inline kalendoriumi kairėje ir kambarių kortelėmis dešinėje.
   - Hero kalendoriaus UX (auto uždarymas pasirinkus abi datas, Esc), navigacijos papildymas (`src/data/nav.ts`), `SiteHeader`, `Logo`, `LocationSection` pataisos.
   - `free_units` palaikymas: `src/lib/availability-schemas.ts` + `src/lib/availability.server.ts` (kad rodytų kainas ir likutį paieškos rezultatuose).
   - Turinys/vertimai: `src/content/lt/common.ts`, `src/content/en/common.ts`.
   - Stilių papildymai: scoped radius (tik svetainės daliai, admin nekeičiamas) ir kalendoriaus mobile taisyklės.
   - Nauji paveikslėliai `src/assets/` (hero, lokacija, banketinė salė, restobaras, logotipas) — `.jpg` + `.webp`.

3. **Patikros sąrašas** Rentivo projektui: home, `/home-v2` redirect, `/laisvi-kambariai` (LT/EN) su kainomis, admin skydelis nepakitęs, tipų patikra švari.

## Techninė pastaba

Instrukcijoje bus nurodyta naudoti `@`-referenciją į Revoo demo projektą, kad tenykštis agentas galėtų nuskaityti failus 1:1. Jei `@` neveikia (skirtingos workspace), alternatyva — paruošiu ZIP paketą su failais.
