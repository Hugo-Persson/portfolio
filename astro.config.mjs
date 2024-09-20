import { defineConfig } from "astro/config";
import tailwind from "@astrojs/tailwind";
import cloudflare from "@astrojs/cloudflare";
import expressiveCode from "astro-expressive-code";
import sitemap from "@astrojs/sitemap";
import { remarkReadingTime } from "./remark-reading-time.mjs";

import mdx from "@astrojs/mdx";

// https://astro.build/config
export default defineConfig({
  site: "https://hugopersson.com",
  integrations: [tailwind(), expressiveCode(), sitemap(), mdx()],
  output: "server",
  adapter: cloudflare({}),
  markdown: {
    remarkPlugins: [remarkReadingTime],
  },
});
