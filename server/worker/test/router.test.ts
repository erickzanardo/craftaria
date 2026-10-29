import { describe, expect, it, vi } from "vitest";
import { MIN_SECRET_LENGTH, verifyToken } from "../src/auth.ts";
import { type Env, handleRequest } from "../src/router.ts";

const secret = "s".repeat(MIN_SECRET_LENGTH);

function makeEnv(overrides: Partial<Env> = {}) {
  const stubFetch = vi.fn(async () => new Response("from zone"));
  const env = {
    ZONE: {
      idFromName: vi.fn((name: string) => `id:${name}`),
      get: vi.fn(() => ({ fetch: stubFetch })),
    } as unknown as DurableObjectNamespace,
    AUTH_SECRET: secret,
    ALLOWED_ORIGINS: "http://localhost:8080, https://craftaria.example",
    ...overrides,
  };
  return { env, stubFetch };
}

const request = (path: string, init?: RequestInit) =>
  new Request(`https://api.example${path}`, init);

describe("handleRequest", () => {
  it("answers health checks", async () => {
    const response = await handleRequest(request("/health"), makeEnv().env);
    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toEqual({ ok: true });
  });

  it("issues verifiable guest tokens", async () => {
    const response = await handleRequest(
      request("/auth/guest", { method: "POST" }),
      makeEnv().env,
    );
    expect(response.status).toBe(200);
    const body = (await response.json()) as { token: string; playerId: string };
    await expect(verifyToken(secret, body.token)).resolves.toMatchObject({
      sub: body.playerId,
    });
  });

  it("refuses to issue tokens without a strong secret", async () => {
    for (const AUTH_SECRET of [undefined, "weak"]) {
      const response = await handleRequest(
        request("/auth/guest", { method: "POST" }),
        makeEnv({ AUTH_SECRET }).env,
      );
      expect(response.status).toBe(500);
    }
  });

  it("adds CORS headers for allowed origins only", async () => {
    const allowed = await handleRequest(
      request("/health", { headers: { Origin: "https://craftaria.example" } }),
      makeEnv().env,
    );
    expect(allowed.headers.get("Access-Control-Allow-Origin")).toBe(
      "https://craftaria.example",
    );

    const denied = await handleRequest(
      request("/health", { headers: { Origin: "https://evil.example" } }),
      makeEnv().env,
    );
    expect(denied.headers.get("Access-Control-Allow-Origin")).toBeNull();

    const noOrigin = await handleRequest(request("/health"), makeEnv().env);
    expect(noOrigin.headers.get("Access-Control-Allow-Origin")).toBeNull();

    const wildcard = await handleRequest(
      request("/health", { headers: { Origin: "https://any.example" } }),
      makeEnv({ ALLOWED_ORIGINS: "*" }).env,
    );
    expect(wildcard.headers.get("Access-Control-Allow-Origin")).toBe(
      "https://any.example",
    );

    const unset = await handleRequest(
      request("/health", { headers: { Origin: "https://any.example" } }),
      makeEnv({ ALLOWED_ORIGINS: undefined }).env,
    );
    expect(unset.headers.get("Access-Control-Allow-Origin")).toBeNull();
  });

  it("answers preflight requests", async () => {
    const response = await handleRequest(
      request("/auth/guest", {
        method: "OPTIONS",
        headers: { Origin: "http://localhost:8080" },
      }),
      makeEnv().env,
    );
    expect(response.status).toBe(204);
    expect(response.headers.get("Access-Control-Allow-Methods")).toContain("POST");
  });

  it("forwards websocket upgrades to the zone durable object", async () => {
    const { env, stubFetch } = makeEnv();
    const response = await handleRequest(
      request("/zones/overworld/ws", { headers: { Upgrade: "websocket" } }),
      env,
    );
    await expect(response.text()).resolves.toBe("from zone");
    expect(env.ZONE.idFromName).toHaveBeenCalledWith("overworld");
    expect(stubFetch).toHaveBeenCalledOnce();
  });

  it("rejects unknown zones and non-websocket zone requests", async () => {
    const unknown = await handleRequest(
      request("/zones/nowhere/ws", { headers: { Upgrade: "websocket" } }),
      makeEnv().env,
    );
    expect(unknown.status).toBe(404);

    const plain = await handleRequest(request("/zones/overworld/ws"), makeEnv().env);
    expect(plain.status).toBe(426);
  });

  it("404s everything else", async () => {
    const response = await handleRequest(request("/nope"), makeEnv().env);
    expect(response.status).toBe(404);
  });
});
