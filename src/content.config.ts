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
    tags: z.array(z.string()).optional(),
    categories: z.array(z.string()).optional(),
    featured: z.boolean().default(false),
  }),
});

const projectsDesign = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/projects/design' }),
  schema: z.object({
    title: z.string(),
    description: z.string(),
    image: z.string().optional(),
    link: z.string().optional(),
    github: z.string().optional(),
    tags: z.array(z.string()).optional(),
    categories: z.array(z.string()).optional(),
    featured: z.boolean().default(false),
  }),
});

const projectsMusic = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/projects/music' }),
  schema: z.object({
    title: z.string(),
    description: z.string(),
    image: z.string().optional(),
    link: z.string().optional(),
    github: z.string().optional(),
    tags: z.array(z.string()).optional(),
    categories: z.array(z.string()).optional(),
    featured: z.boolean().default(false),
  }),
});

export const collections = { blog, projectsIT, projectsDesign, projectsMusic };
