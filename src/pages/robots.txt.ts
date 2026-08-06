import type { APIRoute } from 'astro';

const getRobotsTxt = (sitemapURL: URL, rssURL: URL) => `\
User-agent: *
Allow: /

Sitemap: ${sitemapURL.href}
RSS: ${rssURL.href}
`;

export const GET: APIRoute = ({ site }) => {
  const sitemapURL = new URL('sitemap-index.xml', site);
  const rssURL = new URL('rss.xml', site);
  return new Response(getRobotsTxt(sitemapURL, rssURL));
};