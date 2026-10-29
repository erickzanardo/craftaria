import { isValidSecret, issueGuestToken } from "./auth.ts";

export interface Env {
  ZONE: DurableObjectNamespace;
  /** Token signing secret. Set with `wrangler secret put AUTH_SECRET`. */
  AUTH_SECRET?: string;
  /** Comma separated origins allowed to call the HTTP API, or "*". */
  ALLOWED_ORIGINS?: string;
}

/** Zones that exist. Each one is a Durable Object named after it. */
export const ZONES: ReadonlySet<string> = new Set(["overworld"]);

const zoneSocketPath = /^\/zones\/([a-z0-9-]{1,32})\/ws$/;

function corsHeaders(request: Request, env: Env): Record<string, string> {
  const origin = request.headers.get("Origin");
  const allowed = (env.ALLOWED_ORIGINS ?? "")
    .split(",")
    .map((value) => value.trim())
    .filter(Boolean);
  if (origin === null || !(allowed.includes("*") || allowed.includes(origin))) {
    return {};
  }
  return {
    "Access-Control-Allow-Origin": origin,
    "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type",
    Vary: "Origin",
  };
}

function json(body: unknown, status: number, headers: Record<string, string>) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...headers, "Content-Type": "application/json" },
  });
}

export async function handleRequest(request: Request, env: Env): Promise<Response> {
  const url = new URL(request.url);
  const cors = corsHeaders(request, env);

  if (request.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: cors });
  }

  if (url.pathname === "/health" && request.method === "GET") {
    return json({ ok: true }, 200, cors);
  }

  if (url.pathname === "/auth/guest" && request.method === "POST") {
    if (!isValidSecret(env.AUTH_SECRET)) {
      // Fail closed rather than sign tokens with a weak or missing secret.
      return json({ error: "server misconfigured" }, 500, cors);
    }
    const { token, claims } = await issueGuestToken(env.AUTH_SECRET);
    return json({ token, playerId: claims.sub }, 200, cors);
  }

  const zoneMatch = zoneSocketPath.exec(url.pathname);
  if (zoneMatch !== null) {
    const zone = zoneMatch[1]!;
    if (!ZONES.has(zone)) return json({ error: "unknown zone" }, 404, cors);
    if (request.headers.get("Upgrade")?.toLowerCase() !== "websocket") {
      return json({ error: "expected websocket" }, 426, cors);
    }
    return env.ZONE.get(env.ZONE.idFromName(zone)).fetch(request);
  }

  return json({ error: "not found" }, 404, cors);
}
