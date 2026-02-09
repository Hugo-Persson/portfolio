// Import utilities from `astro:content`
import { z, defineCollection } from "astro:content";

const experienceCollection = defineCollection({
  type: "content",
  schema: z.object({}),
});
// Export a single `collections` object to register your collection(s)
export const collections = {
  experience: experienceCollection,
};
