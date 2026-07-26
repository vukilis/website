import { defineConfig } from 'astro/config';
import remarkToc from 'remark-toc';
import rehypeSlug from 'rehype-slug';
import rehypeAutolinkHeadings from 'rehype-autolink-headings';
import sitemap from '@astrojs/sitemap';
import { visit } from 'unist-util-visit';
import mdx from '@astrojs/mdx';
import expressiveCode from 'astro-expressive-code';

function rehypeLazyImages() {
  return (tree) => {
    visit(tree, 'element', (node) => {
      if (node.tagName === 'img' && !node.properties.loading) {
        node.properties.loading = 'lazy';
        node.properties.decoding = 'async';
      }
    });
  };
}

export default defineConfig({
  site: 'https://kpab.github.io',
  trailingSlash: 'always',

  markdown: {
    remarkPlugins: [[remarkToc, { heading: 'contents' }]],
    rehypePlugins: [rehypeSlug, rehypeLazyImages, [rehypeAutolinkHeadings, { behavior: 'append' }]],
  },

  // Note: Place expressiveCode() BEFORE mdx()
  integrations: [expressiveCode(), sitemap(), mdx()],
});