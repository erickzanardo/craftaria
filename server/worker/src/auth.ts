// Guest tokens: base64url(JSON claims) + "." + base64url(HMAC-SHA256).
//
// The signing secret only ever comes from the AUTH_SECRET binding (a wrangler
// secret in production, .dev.vars locally). Never hardcode it.

export const MIN_SECRET_LENGTH = 32;

export interface GuestClaims {
  /** Player id. */
  readonly sub: string;
  /** Issued at, in milliseconds since epoch. */
  readonly iat: number;
}

const encoder = new TextEncoder();
const decoder = new TextDecoder();

function toBase64Url(bytes: Uint8Array): string {
  let binary = "";
  for (const byte of bytes) binary += String.fromCharCode(byte);
  return btoa(binary).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

function fromBase64Url(value: string): Uint8Array {
  const binary = atob(value.replace(/-/g, "+").replace(/_/g, "/"));
  return Uint8Array.from(binary, (char) => char.charCodeAt(0));
}

export function isValidSecret(secret: string | undefined): secret is string {
  return typeof secret === "string" && secret.length >= MIN_SECRET_LENGTH;
}

function importKey(secret: string): Promise<CryptoKey> {
  return crypto.subtle.importKey(
    "raw",
    encoder.encode(secret),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign", "verify"],
  );
}

export async function issueGuestToken(
  secret: string,
  claims: GuestClaims = { sub: crypto.randomUUID(), iat: Date.now() },
): Promise<{ token: string; claims: GuestClaims }> {
  const payload = toBase64Url(encoder.encode(JSON.stringify(claims)));
  const key = await importKey(secret);
  const signature = await crypto.subtle.sign("HMAC", key, encoder.encode(payload));
  return {
    token: `${payload}.${toBase64Url(new Uint8Array(signature))}`,
    claims,
  };
}

/** Returns the token's claims, or null when it is malformed or forged. */
export async function verifyToken(
  secret: string,
  token: string,
): Promise<GuestClaims | null> {
  const [payload, signature, ...rest] = token.split(".");
  if (!payload || !signature || rest.length > 0) return null;

  try {
    const key = await importKey(secret);
    const valid = await crypto.subtle.verify(
      "HMAC",
      key,
      fromBase64Url(signature),
      encoder.encode(payload),
    );
    if (!valid) return null;

    const claims: unknown = JSON.parse(decoder.decode(fromBase64Url(payload)));
    if (
      typeof claims === "object" &&
      claims !== null &&
      typeof (claims as GuestClaims).sub === "string" &&
      typeof (claims as GuestClaims).iat === "number"
    ) {
      return { sub: (claims as GuestClaims).sub, iat: (claims as GuestClaims).iat };
    }
    return null;
  } catch {
    return null;
  }
}
