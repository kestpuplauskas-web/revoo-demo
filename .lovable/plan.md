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

## Ką darysiu, kai pasirinksite A

1. Įrašysiu į projekto atmintį taisyklę: `Boom [raktažodis] @projektas` = perkelti nurodytą (arba paskutinį) pakeitimą į tą projektą identiškai, nieko kito nekeičiant.
2. Po kiekvieno užbaigto darbo automatiškai išsaugosiu „perkėlimo kortelę" (nauji failai, pakeisti fragmentai, duomenų bazės pakeitimai, ko neliesti, kaip patikrinti).
3. Sukursiu kortelę ką tik įdiegtoms patogumų ikonoms, kad galėtumėte iš karto išbandyti.

## Techninės detalės

- Kortelės: `.lovable/transfers/<data>-<pavadinimas>.md`.
- Prieš ruošdamas užduotį, nuskaitau tikslinio projekto momentinę kopiją ir suderinu failų kelius bei komponentų pavadinimus, kad įklijuota užduotis nesukeltų konfliktų.
- Kiekvienoje kortelėje fiksuojamos ribos: neliesti `src/routes/api/`, `src/routes/_authenticated/`, `src/components/admin/`, `supabase/`, `src/integrations/`, niekada nekopijuoti `src/routeTree.gen.ts`.
