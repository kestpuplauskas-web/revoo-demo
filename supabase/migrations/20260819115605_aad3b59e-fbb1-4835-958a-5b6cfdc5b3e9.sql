-- 1) Durų kodas nebeprieinamas viešai: atimame stulpelio skaitymo teisę.
--    Įrašymas (admin forma) ir skaitymas per admin_get_door_code() lieka.
REVOKE SELECT (door_code) ON public.properties FROM anon, authenticated;

-- 2) SECURITY DEFINER funkcijos: paliekame vykdymo teisę tik tam, kam tikrai reikia.
DO $$
DECLARE r record;
BEGIN
  FOR r IN
    SELECT p.oid::regprocedure AS sig
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
  LOOP
    EXECUTE format('REVOKE ALL ON FUNCTION %s FROM PUBLIC, anon, authenticated', r.sig);
    EXECUTE format('GRANT EXECUTE ON FUNCTION %s TO service_role', r.sig);
  END LOOP;
END $$;

-- Rolės tikrinimas ir durų kodo gavimas kviečiami prisijungusio naudotojo vardu.
GRANT EXECUTE ON FUNCTION public.has_role(uuid, public.app_role) TO authenticated;
GRANT EXECUTE ON FUNCTION public.admin_get_door_code(uuid) TO authenticated;