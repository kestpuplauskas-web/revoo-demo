import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";
import { assertDeveloper } from "./users.server";

export type SystemSnapshotRow = {
  id: string;
  name: string;
  createdAt: string;
  counts: Record<string, number>;
};

export const listSystemSnapshots = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<SystemSnapshotRow[]> => {
    await assertDeveloper(context);
    const { supabaseAdmin } = await import("@/integrations/supabase/client.server");
    const { data, error } = await supabaseAdmin
      .from("system_snapshots")
      .select("id, name, created_at, payload")
      .order("created_at", { ascending: false })
      .limit(20);
    if (error) throw new Error(error.message);
    return (data ?? []).map((r) => {
      const payload = (r.payload ?? {}) as Record<string, unknown[]>;
      const counts: Record<string, number> = {};
      for (const [k, v] of Object.entries(payload)) counts[k] = Array.isArray(v) ? v.length : 0;
      return { id: r.id, name: r.name, createdAt: r.created_at, counts };
    });
  });

export const createSystemSnapshot = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ name: z.string().trim().max(120).optional() }).parse(d))
  .handler(async ({ data, context }) => {
    await assertDeveloper(context);
    const { supabaseAdmin } = await import("@/integrations/supabase/client.server");
    const { data: id, error } = await supabaseAdmin.rpc("create_system_snapshot", {
      _name: data.name ?? "",
      _created_by: context.userId,
    });
    if (error) throw new Error(error.message);
    return { ok: true, id };
  });

export const restoreSystemSnapshot = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ snapshotId: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    await assertDeveloper(context);
    const { supabaseAdmin } = await import("@/integrations/supabase/client.server");
    const { error } = await supabaseAdmin.rpc("restore_system_snapshot", {
      _snapshot_id: data.snapshotId,
    });
    if (error) throw new Error(error.message);
    return { ok: true };
  });

export const deleteSystemSnapshot = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ snapshotId: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    await assertDeveloper(context);
    const { supabaseAdmin } = await import("@/integrations/supabase/client.server");
    const { error } = await supabaseAdmin
      .from("system_snapshots")
      .delete()
      .eq("id", data.snapshotId);
    if (error) throw new Error(error.message);
    return { ok: true };
  });
