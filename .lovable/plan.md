# „Boom" — pakeitimų perkėlimas į kitą projektą viena fraze

Tikslas: parašius `Boom @projektas`, paskutinis šiame projekte padarytas pakeitimas atsirastų ir nurodytame projekte — kuo mažiau jūsų rankinio darbo.

## Svarbu apie ribas

Iš šio pokalbio galiu tik **skaityti** kitą projektą (matau visą jo kodą), bet **rašyti** į jį negaliu — kiekvienas projektas turi savo pokalbį, ir keitimus jame daro tik ten dirbantis asistentas. Todėl visiškai be jokio veiksmo kitame projekte neapsieisime. Yra trys realūs būdai, kaip veiksmą sumažinti iki minimumo.

## Trys būdai

**A. Vienas paspaudimas (rekomenduoju)**
Rašote `Boom @projektas`. Aš perskaitau tikslinio projekto kodą, pritaikau pakeitimą prie jo failų ir paruošiu vieną galutinę žinutę. Jums lieka atidaryti tą projektą ir nusiųsti paruoštą tekstą — be jokio galvojimo, be redagavimo. Tai vienintelis būdas, veikiantis iš karto, be papildomos infrastruktūros.

**B. Bendras kodas per GitHub**
Abu projektai sujungiami su GitHub. Bendros dalys (pvz., patogumų ikonos) gyvena viename bendrame pakete, kurį naudoja abu projektai. Tada pakeitimas vienoje vietoje automatiškai pasiekia abu. Vienkartinis paruošimas didesnis, bet ateityje kopijuoti nebereikia visai.

**C. Vienas projektas vietoj dviejų**
Jei abu projektai iš esmės tas pats produktas skirtingiems klientams, juos galima sujungti į vieną su keliais „prekės ženklais". Tada perkėlimo klausimo nebelieka.

## Detalus C variantas: vienas projektas, keli prekės ženklai

### Ką tai reiškia

Bendras backendas, admin panelė, rezervacijų logika, duomenų bazė ir visi UI komponentai lieka vienodi. Skiriasi tik tai, ką mato galutinis lankytojas: logotipas, spalvų paletė, numatytoji kalba, valiuta, pagrindinio puslapio turinys ir savas domenas.

### Kaip atrodytų techniškai

- Savas duomenų įrašas kiekvienam prekės ženklui: pvz., lentelė `public.brands` su laukais `slug`, `name`, `domains`, `logo_asset`, `primary_color`, `default_locale`, `default_currency`.
- Puslapis nustato prekės ženklą pagal `window.location.hostname` arba pagal `?brand=...` parametrą, kai kuriamas turinys.
- Turinio failai (`src/content/lt.ts`, `src/content/en.ts` ir pan.) pakeičiami į funkcijas, kurios priima `brand` ir grąžina tekstus bei nuotraukas pagal pasirinktą ženklą.
- `src/styles.css` gauna CSS kintamuosius, kuriuos `BrandProvider` perrašo dinamiškai, arba naudoja skirtingas klases pagal brand slapyvardį.
- Nuotraukos, logotipai ir socialiniai vaizdai gali būti skirtingi pagal prekės ženklą; jie saugomi `brand_assets` lentelėje arba atskiruose kataloguose.
- Domeno lygmenyje: `demo.revoo.site` rodo Revoo, o `demo.rentivo.lt` — Rentivo. Tai konfigūruojama publikavimo / CDN nustatymuose, ne kode.

### Ką gautumėte

- Bet koks funkcionalumas įdiegtas vienoje sistemoje matomas visuose prekės ženkluose be jokio kopijavimo.
- Vienas duomenų šaltinis, viena priežiūra, bendra statistika, bendros rezervacijos.
- Galimybė paleisti naują prekės ženklą per kelias minutes: tik įrašas duomenų bazėje + domenas + logotipas.

### Ką prarastumėte / ką reikia apsvarstyti

- Jei vienas prekės ženklas turi labai skirtingą dizainą, gali tekti daugiau sąlyginio UI.
- Visi klientai dalijasi ta pačia infrastruktūra, todėl trikdis paliečia visus.
- Migracija iš dviejų projektų į vieną reikalauja vienkartinio duomenų perkėlimo ir testavimo.

### Kada C variantas tinka

Tinka, kai abu projektai yra to paties tipo produktas (pvz., būsto nuomos platforma), tik su skirtingu klientų pristatymu. Netinka, jei ateityje vienas projektas turės visiškai kitokią verslo logiką.

## Ką darysiu, kai pasirinksite A

1. Įrašysiu į projekto atmintį taisyklę: `Boom [raktažodis] @projektas` = perkelti nurodytą (arba paskutinį) pakeitimą į tą projektą identiškai, nieko kito nekeičiant.
2. Po kiekvieno užbaigto darbo automatiškai išsaugosiu „perkėlimo kortelę" (nauji failai, pakeisti fragmentai, duomenų bazės pakeitimai, ko neliesti, kaip patikrinti).
3. Sukursiu kortelę ką tik įdiegtoms patogumų ikonoms, kad galėtumėte iš karto išbandyti.

## Techninės detalės

- Kortelės: `.lovable/transfers/<data>-<pavadinimas>.md`.
- Prieš ruošdamas užduotį, nuskaitau tikslinio projekto momentinę kopiją ir suderinu failų kelius bei komponentų pavadinimus, kad įklijuota užduotis nesukeltų konfliktų.
- Kiekvienoje kortelėje fiksuojamos ribos: neliesti `src/routes/api/`, `src/routes/_authenticated/`, `src/components/admin/`, `supabase/`, `src/integrations/`, niekada nekopijuoti `src/routeTree.gen.ts`.
