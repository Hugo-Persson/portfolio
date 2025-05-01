import { defineConfig } from "astro/config";
import cloudflare from "@astrojs/cloudflare";
import expressiveCode from "astro-expressive-code";
import sitemap from "@astrojs/sitemap";
import { remarkReadingTime } from "./remark-reading-time.mjs";
import tailwindcss from "@tailwindcss/vite";

import mdx from "@astrojs/mdx";

// https://astro.build/config
export default defineConfig({
  site: "https://hugopersson.com",
  integrations: [expressiveCode(), sitemap(), mdx()],
  vite: {
    plugins: [tailwindcss()],
  },
  output: "server",
  adapter: cloudflare({}),
  markdown: {
    remarkPlugins: [remarkReadingTime],
  },
});
