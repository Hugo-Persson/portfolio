import catppuccin from "@catppuccin/daisyui";

/** @type {import('tailwindcss').Config} */
export default {
  content: ["./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}"],
  theme: {
    extend: {},
  },
  plugins: [
    require("@catppuccin/tailwindcss"),
    require("daisyui"),
    require("@tailwindcss/typography"),
  ],
  daisyui: {
    themes: [
      catppuccin("latte", { neutral: "surface0" }),
      catppuccin("frappe"),
    ],
  },
};
