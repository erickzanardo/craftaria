import { handleRequest, type Env } from "./router.ts";

export { Zone } from "./zone_durable_object.ts";

export default {
  fetch: (request, env) => handleRequest(request, env),
} satisfies ExportedHandler<Env>;
