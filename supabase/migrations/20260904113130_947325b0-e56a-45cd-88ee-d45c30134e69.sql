-- developer inherits admin rights
CREATE OR REPLACE FUNCTION public.has_role(_user_id uuid, _role app_role)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = _user_id
      AND (role = _role OR (_role = 'admin' AND role = 'developer'))
  )
$function$;

-- promote the owner account to developer
DO $$
DECLARE v_uid uuid;
BEGIN
  SELECT id INTO v_uid FROM auth.users WHERE lower(email) = 'kest.puplauskas@gmail.com' LIMIT 1;
  IF v_uid IS NOT NULL THEN
    DELETE FROM public.user_roles WHERE user_id = v_uid AND role = 'admin';
    INSERT INTO public.user_roles (user_id, role) VALUES (v_uid, 'developer')
    ON CONFLICT (user_id, role) DO NOTHING;
  END IF;
END $$;

-- snapshots table (service role only)
CREATE TABLE public.system_snapshots (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL DEFAULT '',
  payload jsonb NOT NULL,
  created_by uuid,
  created_at timestamptz NOT NULL DEFAULT now()
);
GRANT ALL ON public.system_snapshots TO service_role;
ALTER TABLE public.system_snapshots ENABLE ROW LEVEL SECURITY;
CREATE POLICY "No direct access to snapshots" ON public.system_snapshots FOR ALL TO authenticated USING (false) WITH CHECK (false);

CREATE OR REPLACE FUNCTION public.create_system_snapshot(_name text, _created_by uuid)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $$
DECLARE v_payload jsonb; v_id uuid;
BEGIN
  v_payload := jsonb_build_object(
    'properties', (SELECT COALESCE(jsonb_agg(to_jsonb(t)), '[]'::jsonb) FROM public.properties t),
    'property_settings', (SELECT COALESCE(jsonb_agg(to_jsonb(t)), '[]'::jsonb) FROM public.property_settings t),
    'room_status', (SELECT COALESCE(jsonb_agg(to_jsonb(t)), '[]'::jsonb) FROM public.room_status t),
    'housekeeping_tasks', (SELECT COALESCE(jsonb_agg(to_jsonb(t)), '[]'::jsonb) FROM public.housekeeping_tasks t),
    'housekeeping_comments', (SELECT COALESCE(jsonb_agg(to_jsonb(t)), '[]'::jsonb) FROM public.housekeeping_comments t),
    'property_documents', (SELECT COALESCE(jsonb_agg(to_jsonb(t)), '[]'::jsonb) FROM public.property_documents t),
    'property_events', (SELECT COALESCE(jsonb_agg(to_jsonb(t)), '[]'::jsonb) FROM public.property_events t),
    'property_investments', (SELECT COALESCE(jsonb_agg(to_jsonb(t)), '[]'::jsonb) FROM public.property_investments t),
    'property_maintenance', (SELECT COALESCE(jsonb_agg(to_jsonb(t)), '[]'::jsonb) FROM public.property_maintenance t),
    'expenses', (SELECT COALESCE(jsonb_agg(to_jsonb(t)), '[]'::jsonb) FROM public.expenses t),
    'content_templates', (SELECT COALESCE(jsonb_agg(to_jsonb(t)), '[]'::jsonb) FROM public.content_templates t),
    'contract_templates', (SELECT COALESCE(jsonb_agg(to_jsonb(t)), '[]'::jsonb) FROM public.contract_templates t),
    'content_translations', (SELECT COALESCE(jsonb_agg(to_jsonb(t)), '[]'::jsonb) FROM public.content_translations t),
    'bookings', (SELECT COALESCE(jsonb_agg(to_jsonb(t)), '[]'::jsonb) FROM public.bookings t),
    'booking_notifications', (SELECT COALESCE(jsonb_agg(to_jsonb(t)), '[]'::jsonb) FROM public.booking_notifications t),
    'invoices', (SELECT COALESCE(jsonb_agg(to_jsonb(t)), '[]'::jsonb) FROM public.invoices t),
    'payment_transactions', (SELECT COALESCE(jsonb_agg(to_jsonb(t)), '[]'::jsonb) FROM public.payment_transactions t),
    'signed_contracts', (SELECT COALESCE(jsonb_agg(to_jsonb(t)), '[]'::jsonb) FROM public.signed_contracts t)
  );
  INSERT INTO public.system_snapshots (name, payload, created_by) VALUES (COALESCE(_name, ''), v_payload, _created_by) RETURNING id INTO v_id;
  RETURN v_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.restore_system_snapshot(_snapshot_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $$
DECLARE p jsonb;
BEGIN
  SELECT payload INTO p FROM public.system_snapshots WHERE id = _snapshot_id;
  IF p IS NULL THEN RAISE EXCEPTION 'Snapshot not found'; END IF;

  -- delete children first
  DELETE FROM public.signed_contracts;
  DELETE FROM public.payment_transactions;
  DELETE FROM public.invoices;
  DELETE FROM public.booking_notifications;
  DELETE FROM public.bookings;
  DELETE FROM public.content_translations;
  DELETE FROM public.contract_templates;
  DELETE FROM public.content_templates;
  DELETE FROM public.expenses;
  DELETE FROM public.property_maintenance;
  DELETE FROM public.property_investments;
  DELETE FROM public.property_events;
  DELETE FROM public.property_documents;
  DELETE FROM public.housekeeping_comments;
  DELETE FROM public.housekeeping_tasks;
  DELETE FROM public.room_status;
  DELETE FROM public.property_settings;
  DELETE FROM public.properties;

  INSERT INTO public.properties SELECT * FROM jsonb_populate_recordset(NULL::public.properties, p->'properties');
  -- trigger auto-created room_status rows; replace them with snapshot rows
  DELETE FROM public.room_status;
  INSERT INTO public.property_settings SELECT * FROM jsonb_populate_recordset(NULL::public.property_settings,
    (SELECT COALESCE(jsonb_agg(e - 'updated_by'), '[]'::jsonb) FROM jsonb_array_elements(p->'property_settings') e));
  INSERT INTO public.room_status SELECT * FROM jsonb_populate_recordset(NULL::public.room_status,
    (SELECT COALESCE(jsonb_agg(e - 'assigned_to' - 'updated_by'), '[]'::jsonb) FROM jsonb_array_elements(p->'room_status') e));
  INSERT INTO public.housekeeping_tasks SELECT * FROM jsonb_populate_recordset(NULL::public.housekeeping_tasks,
    (SELECT COALESCE(jsonb_agg(e - 'assigned_to' - 'updated_by'), '[]'::jsonb) FROM jsonb_array_elements(p->'housekeeping_tasks') e));
  INSERT INTO public.housekeeping_comments SELECT * FROM jsonb_populate_recordset(NULL::public.housekeeping_comments,
    (SELECT COALESCE(jsonb_agg(e - 'author_id'), '[]'::jsonb) FROM jsonb_array_elements(p->'housekeeping_comments') e));
  INSERT INTO public.property_documents SELECT * FROM jsonb_populate_recordset(NULL::public.property_documents,
    (SELECT COALESCE(jsonb_agg(e - 'uploaded_by'), '[]'::jsonb) FROM jsonb_array_elements(p->'property_documents') e));
  INSERT INTO public.property_events SELECT * FROM jsonb_populate_recordset(NULL::public.property_events, p->'property_events');
  INSERT INTO public.property_investments SELECT * FROM jsonb_populate_recordset(NULL::public.property_investments, p->'property_investments');
  INSERT INTO public.property_maintenance SELECT * FROM jsonb_populate_recordset(NULL::public.property_maintenance, p->'property_maintenance');
  INSERT INTO public.expenses SELECT * FROM jsonb_populate_recordset(NULL::public.expenses, p->'expenses');
  INSERT INTO public.content_templates SELECT * FROM jsonb_populate_recordset(NULL::public.content_templates,
    (SELECT COALESCE(jsonb_agg(e - 'updated_by'), '[]'::jsonb) FROM jsonb_array_elements(p->'content_templates') e));
  INSERT INTO public.contract_templates SELECT * FROM jsonb_populate_recordset(NULL::public.contract_templates, p->'contract_templates');
  INSERT INTO public.content_translations SELECT * FROM jsonb_populate_recordset(NULL::public.content_translations,
    (SELECT COALESCE(jsonb_agg(e - 'updated_by'), '[]'::jsonb) FROM jsonb_array_elements(p->'content_translations') e));
  INSERT INTO public.bookings SELECT * FROM jsonb_populate_recordset(NULL::public.bookings, p->'bookings');
  INSERT INTO public.booking_notifications SELECT * FROM jsonb_populate_recordset(NULL::public.booking_notifications, p->'booking_notifications');
  INSERT INTO public.invoices SELECT * FROM jsonb_populate_recordset(NULL::public.invoices, p->'invoices');
  INSERT INTO public.payment_transactions SELECT * FROM jsonb_populate_recordset(NULL::public.payment_transactions, p->'payment_transactions');
  INSERT INTO public.signed_contracts SELECT * FROM jsonb_populate_recordset(NULL::public.signed_contracts, p->'signed_contracts');
END;
$$;

REVOKE EXECUTE ON FUNCTION public.create_system_snapshot(text, uuid) FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.restore_system_snapshot(uuid) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.create_system_snapshot(text, uuid) TO service_role;
GRANT EXECUTE ON FUNCTION public.restore_system_snapshot(uuid) TO service_role;