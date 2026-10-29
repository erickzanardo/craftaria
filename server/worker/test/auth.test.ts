import { describe, expect, it } from "vitest";
import {
  isValidSecret,
  issueGuestToken,
  MIN_SECRET_LENGTH,
  verifyToken,
} from "../src/auth.ts";

const secret = "s".repeat(MIN_SECRET_LENGTH);
const encode = (value: string) =>
  btoa(value).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");

describe("auth", () => {
  it("isValidSecret requires a long enough string", () => {
    expect(isValidSecret(undefined)).toBe(false);
    expect(isValidSecret("short")).toBe(false);
    expect(isValidSecret(secret)).toBe(true);
  });

  it("issues tokens that verify back to their claims", async () => {
    const { token, claims } = await issueGuestToken(secret);
    expect(claims.sub).toMatch(/^[0-9a-f-]{36}$/);
    await expect(verifyToken(secret, token)).resolves.toEqual(claims);
  });

  it("rejects tokens signed with another secret", async () => {
    const { token } = await issueGuestToken("o".repeat(MIN_SECRET_LENGTH));
    await expect(verifyToken(secret, token)).resolves.toBeNull();
  });

  it("rejects tampered payloads", async () => {
    const { token } = await issueGuestToken(secret, { sub: "a", iat: 1 });
    const [, signature] = token.split(".");
    const forged = `${encode(JSON.stringify({ sub: "b", iat: 1 }))}.${signature}`;
    await expect(verifyToken(secret, forged)).resolves.toBeNull();
  });

  it("rejects malformed tokens", async () => {
    for (const token of ["", "abc", "a.b.c", "!!!.???", ".sig"]) {
      await expect(verifyToken(secret, token)).resolves.toBeNull();
    }
  });

  it("rejects validly signed payloads with the wrong shape", async () => {
    for (const claims of [null, { sub: 1, iat: 1 }, { sub: "a", iat: "1" }]) {
      const { token } = await issueGuestToken(secret, claims as never);
      await expect(verifyToken(secret, token)).resolves.toBeNull();
    }
  });
});
