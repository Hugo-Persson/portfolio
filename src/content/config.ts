// Import utilities from `astro:content`
import { z, defineCollection } from "astro:content";
// Define a `type` and `schema` for each collection
const base = {
  title: z.string(),
  pubDate: z.date(),
  description: z.string(),
  tags: z.array(z.string()),
  keywords: z.array(z.string()),
  draft: z.boolean(),
};
export const postSchema = z.object(base);

const postsCollection = defineCollection({
  type: "content",
  schema: ({ image }) =>
    z.object({
      ...base,
      cover: image(),
    }),
});
// Export a single `collections` object to register your collection(s)
export const collections = {
  blog: postsCollection,
};
