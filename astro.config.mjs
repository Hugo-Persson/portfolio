import { defineConfig } from "astro/config";
import tailwind from "@astrojs/tailwind";
import cloudflare from "@astrojs/cloudflare";
import expressiveCode from "astro-expressive-code";

import sitemap from "@astrojs/sitemap";

// https://astro.build/config
export default defineConfig({
  site: "https://hugopersson.com",
  integrations: [tailwind(), expressiveCode(), sitemap()],
  output: "server",
  adapter: cloudflare({}),
});

