# Perkelti Dharma Stay Boutique frontend'ą (Home V2, /laisvi-kambariai, dizaino standartas)

Šaltinis: `marazinas1/dharma-stay-boutique` (commit `455474a`, 2026-09-04). Palyginau abu projektus — skirtumai apsiriboja viešąja (svetainės) dalimi. Backend, admin ir personalo dalys lieka nepaliestos.

## Kas bus padaryta

### 1. Nauji failai (kopijuojami 1:1)
- `src/pages/laisvi-kambariai.tsx`
- `src/routes/laisvi-kambariai.tsx`, `src/routes/en/laisvi-kambariai.tsx`
- `src/routes/home-v2.tsx`, `src/routes/en/home-v2.tsx` (301 → `/` ir `/en`)
- `src/components/home/HeroV2.tsx`, `RatingsAndTestimonials.tsx`, `Testimonials.tsx`
- `src/components/search/SearchBar.tsx`, `DateRangeField.tsx`, `GuestsField.tsx`, `plural.ts`
- `src/components/site/BookingDateRange.tsx`
- Trūkstamos nuotraukos: `stay-standard`, `stay-cottage`, `stay-terrace`, `restobaras-chef` (jpg + webp) — įkeliamos kaip šio projekto asset'ai (tik jei jas naudoja perkeliami komponentai; šiuo metu kode nenaudojamos, tad įkelsiu tik tas, kurių reikia).

### 2. Perrašomi tik prezentaciniai failai
- `src/pages/home.tsx` — Home V2 tampa vieninteliu pradiniu puslapiu; senos V1 sekcijos pašalinamos.
- `src/data/nav.ts`, `src/components/site/SiteHeader.tsx` — vienas „Pradžia" punktas, permatoma antraštė virš hero.
- `src/content/lt/common.ts`, `src/content/en/common.ts` — atsiliepimai, rezultatų puslapio ir kortelių tekstai.
- `src/components/site/BookingDialog.tsx` — kalendorius su užimtomis datomis, naujas UX (neužsidaro pasirinkus abi datas; užsidaro tik su „Gerai"/„Ieškoti" arba paspaudus šalia; atvykimo data pradeda naują diapazoną).
- Likę `src/components/home/*`, `src/components/site/*`, `src/components/stay/*`, `src/pages/*` — apvalinimų / 1344 px pločio / mobile perpildymo pataisos (`rounded-2xl` → `rounded-md`, `rounded-full` → `rounded-md`, `max-w-[84rem]`).

### 3. Sujungiama atsargiai (NE perrašoma)
- `src/styles.css` — perkeliama: nauja radius skalė, Ken Burns utility, kalendoriaus mobile taisyklės. **Radius skalė taikoma tik `.site-theme` apvalkale**, kad admin skydelio išvaizda (teal `#5B9A90` / smėlinė `#F7F2E7`, `--radius: 0.875rem`) nepasikeistų. Root spalvų tokenai ir `.site-theme` blokas lieka.
- `src/components/site/LanguageSwitcher.tsx` — perkeliami tik stiliaus pakeitimai; **išsaugoma** šio projekto EN-pagal-nutylėjimą peradresavimo logika ir `NON_SITE_PREFIXES` apsauga.
- `src/routes/__root.tsx` — **neliečiamas** (turi sąlyginį core/site layout'ą, i18n, Toaster, Evos widget'ą). Jei naujam SiteHeader'iui reikia kitokio wrapper'io — pritaikoma minimaliai.
- `src/lib/availability-schemas.ts` + `src/lib/availability.server.ts` — pridedamas TIK `free_units` laukas (`availabilityUnitSchema` {id, total, currency}; `free_units` masyvas su `.default([])`; serveryje `free.map(...)`). Viešas `/api/public/v1/availability` atsakas praplečiamas atgaliniu būdu suderinamai.

### 4. Neliečiama
`supabase/`, `src/routes/api/`, `src/routes/_authenticated/`, `src/components/admin/`, `src/lib/runtime-env.server.ts`, `src/lib/rentivo.functions.ts`, `src/lib/error-capture.ts`, `src/routeTree.gen.ts` (persigeneruoja pats), `src/i18n/*`, Evos asistentas.

## Darbų eiga
1. Nukopijuoti naujus failus ir prezentacinius perrašymus; įkelti trūkstamas nuotraukas.
2. Sujungti `styles.css` (radius tik `.site-theme`), `LanguageSwitcher.tsx`.
3. Perkelti `free_units` į schemą ir serverio skaičiavimą.
4. Ištrinti nebenaudojamas Home V1 sekcijas / komponentus, kurių niekas nebeimportuoja.
5. Patikra: `tsgo` tipų patikra, build log; Playwright — `/`, `/en`, `/home-v2` → 301, `/laisvi-kambariai?from&to&guests` rodo kainas iš `free_units`, hero kalendoriaus UX, kortelės („Daugiau", fullscreen galerija, Esc), atsiliepimų blokas, mobile 375 px be horizontalaus slinkimo; `/admin` išvaizda nepakitusi.

## Techninės pastabos
- Šis projektas nuotraukas laiko kaip `*.asset.json` pointerius, todėl repo `src/assets/*.jpg|webp` nekopijuojami tiesiogiai — importai `@/assets/x.jpg` veikia per esamus pointerius; trūkstamos 4 nuotraukos įkeliamos per asset įrankį.
- Šaltinio `--radius: 6px` yra `:root` lygyje; čia jis dedamas į `.site-theme { --radius: 6px; --radius-sm/md/lg/xl ... }`, kad shadcn komponentai admin dalyje liktų apvalesni.
- `home-v2` maršrutai naudoja `beforeLoad` + `redirect({ statusCode: 301 })`.
