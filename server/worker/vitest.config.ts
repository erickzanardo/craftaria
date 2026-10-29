import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    coverage: {
      provider: "v8",
      include: ["src/**"],
      // Runtime glue that only runs inside workerd; logic it delegates to is
      // covered through ZoneServer and router tests.
      exclude: ["src/index.ts", "src/zone_durable_object.ts"],
      thresholds: { 100: true },
    },
  },
});
