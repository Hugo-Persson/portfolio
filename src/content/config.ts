// Import utilities from `astro:content`
import { z, defineCollection } from "astro:content";
// Define a `type` and `schema` for each collection
export const basePostSchema = {
  title: z.string(),
  pubDate: z.date(),
  description: z.string(),
  tags: z.array(z.string()),
  keywords: z.array(z.string()),
  draft: z.boolean(),
};

const postsCollection = defineCollection({
  type: "content",
  schema: ({ image }) =>
    z.object({
      ...basePostSchema,
      cover: image(),
    }),
});
const devLogCollection = defineCollection({
  type: "content",
  schema: z.object({
    name: z.string(),
    date: z.date(),
  }),
});
const experienceCollection = defineCollection({
  type: "content",
  schema: z.object({}),
});
// Export a single `collections` object to register your collection(s)
export const collections = {
  blog: postsCollection,
  devlog: devLogCollection,
  experience: experienceCollection,
};
