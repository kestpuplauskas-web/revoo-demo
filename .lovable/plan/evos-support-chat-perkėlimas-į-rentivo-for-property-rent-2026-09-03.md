# Evos support chat perkėlimas į „Rentivo for Property rent"

Perkeliame visą admin asistentės Evos funkcionalumą 1:1 — tą patį UI, tuos pačius tekstus, tą patį avatarą ir tą pačią pokalbių istoriją duomenų bazėje.

## Ką gauna tikslinis projektas

- Plaukiojantis mygtukas su Evos avataru admin skydelio apačioje dešinėje.
- Šoninis pokalbio langas: pasisveikinimas, pasiūlymų mygtukai, žinučių srautas realiu laiku, mygtukai „Išvalyti" ir uždaryti.
- Asistentė tik pataria — nieko nekeičia už administratorių, neduoda SQL/kodo, neišeina už projekto ribų.
- Nuorodų mygtukai atsakymuose, vedantys į atitinkamą admin skiltį.
- Pokalbių istorija saugoma kiekvienam vartotojui atskirai ir atsistato perkrovus puslapį.
- LT/EN kalbos pagal admin sąsajos kalbą.

## Perkeliami failai (identiškai)

- `src/lib/assistant-knowledge.ts` — žinių bazė LT/EN, limitai, sisteminis promptas.
- `src/lib/assistant-context.server.ts` — dabartinių nustatymų ir objektų santrauka modeliui (jautrūs laukai slepiami).
- `src/lib/assistant-auth.server.ts` — admin teisių tikrinimas per `has_role`.
- `src/lib/assistant.functions.ts` — istorijos skaitymas ir valymas.
- `src/routes/api/assistant/chat.ts` — SSE srauto endpointas į Lovable AI.
- `src/components/admin/assistant/AssistantWidget.tsx` — visas pokalbio UI.
- `src/assets/eva-avatar.jpg.asset.json` — Evos avataras (perkeliamas kaip naujas asset'as to projekto CDN'e, identiškas vaizdas).
- `assistant.*` vertimų blokas į `src/i18n/locales/lt.json` ir `en.json`.
- `<AssistantWidget />` įterpimas į admin layout'ą.

## Duomenų bazė

Migracija tiksliniame projekte:

- lentelė `public.assistant_messages` (id, user_id, role `user|assistant`, content, created_at);
- indeksas pagal user_id + created_at;
- GRANT `authenticated` (select/insert/delete) ir `service_role`;
- RLS su „tik savo žinutės" politikomis.

## Techninės pastabos

- Tikslinis projektas jau turi tą patį admin branduolį (`property_settings`, `properties`, `user_roles`, `has_role`, i18n LT/EN), todėl žinių bazė perkeliama pažodžiui, be pritaikymų.
- Naudojamas to projekto `LOVABLE_API_KEY` (sukuriamas, jei jo dar nėra) — jokių papildomų sekretų nereikia.
- Jei tame projekte admin layout'o failo kelias skiriasi, widget'as įsegamas į jo atitikmenį, kad matytųsi visose admin skiltyse.
- Patikra: prisijungiama kaip administratorius, užduodamas klausimas, tikrinama srauto atsakymas, nuorodų mygtukas, istorijos išsaugojimas po perkrovimo ir „Išvalyti".

## Eiga

Vykdymui persijungiu į projektą „Rentivo for Property rent" ir ten atlieku visus pakeitimus; šis projektas lieka nepaliestas.
