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

  DELETE FROM public.signed_contracts WHERE true;
  DELETE FROM public.payment_transactions WHERE true;
  DELETE FROM public.invoices WHERE true;
  DELETE FROM public.booking_notifications WHERE true;
  DELETE FROM public.bookings WHERE true;
  DELETE FROM public.content_translations WHERE true;
  DELETE FROM public.contract_templates WHERE true;
  DELETE FROM public.content_templates WHERE true;
  DELETE FROM public.expenses WHERE true;
  DELETE FROM public.property_maintenance WHERE true;
  DELETE FROM public.property_investments WHERE true;
  DELETE FROM public.property_events WHERE true;
  DELETE FROM public.property_documents WHERE true;
  DELETE FROM public.housekeeping_comments WHERE true;
  DELETE FROM public.housekeeping_tasks WHERE true;
  DELETE FROM public.room_status WHERE true;
  DELETE FROM public.property_settings WHERE true;
  DELETE FROM public.properties WHERE true;

  INSERT INTO public.properties SELECT * FROM jsonb_populate_recordset(NULL::public.properties, p->'properties');
  DELETE FROM public.room_status WHERE true;
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