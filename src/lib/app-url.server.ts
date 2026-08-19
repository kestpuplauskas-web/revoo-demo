/** Atsarginis kanoninis adresas — naudojamas, kai kliento origin nežinomas. */
export const APP_BASE_URL = "https://demo.revoo.site";

/**
 * Grąžina absoliučią nuorodą.
 * Pirmenybė kliento perduotam origin (kad laiško nuoroda vestų į tą pačią aplinką).
 */
export function appLink(path: string, requestedOrigin?: string): string {
  let base = APP_BASE_URL;
  if (requestedOrigin) {
    try {
      const u = new URL(requestedOrigin);
      if (u.protocol === "http:" || u.protocol === "https:") base = u.origin;
    } catch {
      /* ignore */
    }
  }
  return `${base}${path.startsWith("/") ? path : `/${path}`}`;
}
