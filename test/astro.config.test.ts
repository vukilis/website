import { describe, it, expect } from 'vitest';
import config from '../astro.config.mjs';

describe('Astro configuration', () => {
  it('should have a site URL defined', () => {
    expect(config.site).toBeDefined();
    expect(config.site).toMatch(/^https:\/\//);
  });

  it('should have trailingSlash set to always', () => {
    expect(config.trailingSlash).toBe('always');
  });

  it('should have integrations configured', () => {
    expect(config.integrations).toBeDefined();
    expect(config.integrations.length).toBeGreaterThan(0);
  });
});
