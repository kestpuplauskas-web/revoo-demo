export async function assertAdmin(ctx: { supabase: any; userId: string }) {
  const { data, error } = await ctx.supabase.rpc("has_role", {
    _user_id: ctx.userId,
    _role: "admin",
  });
  if (error) throw new Error(error.message);
  if (!data) throw new Error("Neturite administratoriaus teisių.");
}

export async function assertDeveloper(ctx: { supabase: any; userId: string }) {
  const { data, error } = await ctx.supabase.rpc("has_role", {
    _user_id: ctx.userId,
    _role: "developer",
  });
  if (error) throw new Error(error.message);
  if (!data) throw new Error("Šį veiksmą gali atlikti tik programuotojas.");
}
