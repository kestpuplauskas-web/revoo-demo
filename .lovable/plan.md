# AI pagalbininkas administratoriams („Revoo asistentas“)

Plaukiojantis pokalbio langas visame admin skydelyje, kuris trumpai ir konkrečiai paaiškina, **kur ir kaip** administratorius pats atlieka norimą veiksmą. Asistentas nieko nekeičia – jis neturi jokių įrankių rašyti į duomenų bazę ar keisti nustatymus.

## Ką matys administratorius

- Apačioje dešinėje visuose `/admin/*` puslapiuose – apvalus mygtukas su pokalbio ikona.
- Paspaudus atsidaro šoninė panelė (mobiliame – per visą ekraną) su pokalbiu, įvesties lauku ir mygtuku „Išvalyti pokalbį“.
- Vienas tęstinis pokalbis kiekvienam vartotojui, išsaugomas duomenų bazėje – istorija išlieka tarp sesijų ir įrenginių.
- Atsakymai srautu (žodis po žodžio), ta kalba, kuri pasirinkta admin sąsajoje (LT arba EN).
- Trumpi atsakymai: 2–5 sakiniai arba trumpas žingsnių sąrašas su tiksliu keliu, pvz.:
  „Objektai → pasirinkite kambarį → Redaguoti → Nuotraukos → įkelkite / pertempkite tvarką → Išsaugoti.“
- Kai tinka, atsakyme – mygtukas-nuoroda „Atidaryti Objektai“, kuri nuveda į reikiamą admin puslapį (tik navigacija, jokių pakeitimų).
- Pradžioje – 3–4 pasiūlyti klausimai („Kaip pakeisti kambarių nuotraukas?“, „Kaip įjungti automatinį rezervacijų patvirtinimą?“ ir pan.).

## Ką asistentas žino

1. **Sistemos žinių bazė** (statinė, laikoma kode, LT ir EN):
   - Kiekviena admin sritis: Suvestinė, Rezervacijos (sukūrimas, būsenos, mokėjimai, sąskaitos, sutartys), Objektai (pavadinimai, aprašai, nuotraukos, kainos, patogumai, iCal, durų kodas, vertimai), Kambarinės, Sutartys, Išlaidos, Turinys (laiškų šablonai, kintamieji, testinis laiškas), Bendrieji nustatymai (visos 9 skiltys su kiekvieno lauko paaiškinimu), Integracijos, API prieiga, Vartotojai (kvietimai, rolės, slaptažodžio atstatymas).
   - Kiekvienam laukui: ką jis daro, kokią įtaką turi svetainei/laiškams/sąskaitoms, kur jį rasti.
2. **Dabartinės nustatymų reikšmės** (tik skaitymas) – asistentas gali pasakyti „šiuo metu PVM 21 %, minimalus nakvynių skaičius 2“. Jautrūs laukai (IBAN, įmonės kodas, API raktai, durų kodai) į kontekstą **neperduodami**.
3. **Objektų sąrašas** (pavadinimai, kategorijos, aktyvumas, nuotraukų skaičius) – kad galėtų atsakyti apie konkretų kambarį.
4. **Dabartinis puslapis** – klientas siunčia aktyvų kelią, kad asistentas žinotų, kur vartotojas yra.

## Ribos (griežtai)

- Jokių įrankių (tool calls) – asistentas negali nieko keisti, kurti ar trinti; tik teksto atsakymas.
- Sisteminėje instrukcijoje: atsakinėti tik apie šios sistemos naudojimą; neaiškinti kodo, nesiūlyti keisti kodo ar duomenų bazės, nesiūlyti kreiptis į Lovable; klausimams už ribų – mandagiai pasakyti, kad padeda tik su viešbučio valdymu šioje sistemoje.
- Jei funkcija sistemoje neegzistuoja – pasakyti tiesiai, o ne išgalvoti.
- Prieinamas tik prisijungusiems vartotojams su `admin` role (kambarinėms nerodomas).
- Limitas: 30 žinučių per valandą vienam vartotojui, žinutė iki 1000 simbolių.

## Techninės detalės

**Duomenų bazė (migracija)**
- `assistant_messages` (id, user_id, role `user|assistant`, content text, created_at). GRANT `authenticated` (select/insert/delete) + `service_role`; RLS – tik savos eilutės (`auth.uid() = user_id`). Vienas pokalbis = visos vartotojo eilutės; „Išvalyti“ = ištrinti savas eilutes.
- Istorijos į modelį perduodama paskutinės ~20 žinučių.

**Serveris**
- `src/routes/api/assistant/chat.ts` – srautinis (SSE) endpointas. Tikrina bearer token per esamą auth middleware logiką ir `has_role(admin)`; validuoja įvestį (zod); įrašo vartotojo žinutę, kviečia Lovable AI Gateway (chat completions, `stream: true`, esamas `google/gemini-3.7-flash` kaip vertimuose), streamina tekstą klientui ir baigus išsaugo atsakymą. Klaidų kodai 402/403/429 rodomi vartotojui aiškiu tekstu.
- `src/lib/assistant.functions.ts` – `getAssistantHistory`, `clearAssistantHistory` (su `requireSupabaseAuth`).
- `src/lib/assistant-context.server.ts` – surenka nejautrų kontekstą: `property_settings` (be IBAN/įmonės kodų/raktų), objektų sąrašo santrauką, aktyvų puslapį.
- `src/lib/assistant-knowledge.ts` – žinių bazė LT/EN (markdown tekstas apie kiekvieną sritį ir lauką), sisteminis promptas su ribomis ir atsakymo formatu (trumpai, žingsniais, `[[link:/admin/properties|Objektai]]` žymos nuorodoms).

**Klientas**
- `src/components/admin/assistant/AssistantWidget.tsx` – plaukiojantis mygtukas + `Sheet` panelė; žinučių sąrašas, „rašo…“ indikatorius, įvesties laukas (fokusas išlaikomas), „Išvalyti“, pasiūlyti klausimai. Žymos `[[link:...]]` paverčiamos į `Link` mygtukus.
- Įterpiama į `src/routes/_authenticated/admin.tsx` layout'ą (rodoma tik kai `role.isAdmin`).
- Vertimai `lt.json` / `en.json` (`assistant.*` raktai); kalba į serverį perduodama iš `i18n.language`.

**Patikra**
- Playwright: atidaryti widget'ą, paklausti „Kaip pakeisti kambarių nuotraukas?“, patikrinti trumpą atsakymą su keliu ir nuoroda; perkrauti – istorija išlieka; „Išvalyti“ – ištrina; klausimas ne į temą – mandagus atsisakymas.
