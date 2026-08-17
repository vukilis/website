import { defineCollection } from 'astro:content';
import { z } from 'astro/zod';
import { glob } from 'astro/loaders';

const blog = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/blog' }),
  schema: z.object({
    title: z.string(),
    description: z.string(),
    pubDate: z.coerce.date(),
    lastmod: z.coerce.date().optional(),
    heroImage: z.string().optional(),
    tags: z.array(z.string()).optional(),
    categories: z.array(z.string()).optional(),
    license: z.string().optional(),
    draft: z.boolean().default(false),
    share: z.object({
      enable: z.boolean().default(false),
      link: z.boolean().default(true),
      twitter: z.boolean().default(true),
      reddit: z.boolean().default(true),
      bluesky: z.boolean().default(true),
      hackernews: z.boolean().default(true),
    }).optional(),
  }),
});

const projectsIT = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/projects/it' }),
  schema: z.object({
    title: z.string(),
    description: z.string(),
    image: z.string().optional(),
    link: z.string().optional(),
    github: z.string().optional(),
    blog: z.string().optional(),
    tags: z.array(z.string()).optional(),
    categories: z.array(z.string()).optional(),
    featured: z.boolean().default(false),
    draft: z.boolean().default(false),
    status: z.enum(['normal', 'active', 'archived']).default('normal'),
    license: z.string().optional(),
  }),
});

const projectsDesign = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/projects/design' }),
  schema: z.object({
    cat: z.array(z.string()),
    type: z.string(),
    year: z.number(),
    src: z.string().optional(),
    id: z.string().optional(),
    cover: z.string(),
    title: z.string(),
    pubDate: z.coerce.date(),
    draft: z.boolean().default(false),
  }),
});

const projectsMusic = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/projects/music' }),
  schema: z.object({
    cat: z.array(z.string()),
    type: z.string(),
    year: z.number(),
    id: z.string(),
    cover: z.string(),
    title: z.string(),
    description: z.string(),
    pubDate: z.coerce.date(),
    tags: z.array(z.string()).optional(),
    duration: z.string().optional(),
    lyrics: z.string(),
  }),
});

const yerbaMate = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/yerbamate' }),
  schema: z.object({
    name: z.string(),
    category: z.string().default('yerba'),
    image: z.string(),
    rating: z.string(),
    type: z.string(),
    complexity: z.string(),
    body: z.string(),
    durability: z.string(),
    effect: z.string(),
    level: z.string(),
    pubDate: z.coerce.date(),
    draft: z.boolean().default(false),
  }),
});

const legal = defineCollection({
  loader: glob({ pattern: '{privacy,terms}.md', base: './src/content' }),
  schema: z.object({
    title: z.string(),
    pubDate: z.coerce.date(),
    lastmod: z.coerce.date().optional(),
    draft: z.boolean().default(false),
  }),
});

export const collections = { blog, projectsIT, projectsDesign, projectsMusic, yerbaMate, legal };
