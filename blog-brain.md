# BLOG BRAIN — SYSTEM SPECIFICATION & RULES FOR TECHNICAL MDX POSTS

This document is the single source of truth for generating technical MDX blog posts for `vukilis.com`.

---

## 1. FRONTMATTER SCHEMA

Every post must start with valid YAML frontmatter strictly formatted as follows:

```yaml
---
title: "Descriptive Post Title"
url: /post-slug
pubDate: 2026-10-29T12:00:00+02:00
lastmod: 2026-10-29T12:00:00+02:00
draft: false
license: "MIT"
description: "A concise 1-sentence summary for SEO and cards (max ~160 chars)."
tags: [linux, gaming, proton]
categories: [Linux]
share:
  enable: true
  link: true
  twitter: true
  reddit: true
  bluesky: true
  hackernews: true
---
```

### General Naming & Formatting Rules
* **`title`**: Sentence case, concise, no markdown tags.
* **`url`**: Lowercase kebab-case slug prefixed with a slash (`/slug-name`).
* **`pubDate` / `lastmod`**: Standard ISO 8601 timestamp with explicit timezone offset (`YYYY-MM-DDTHH:MM:SS+TZ`).
* **`tags`**: Lowercase kebab-case array (`[linux, steam-deck, nvidia]`). Avoid overly generic tags.
* **`categories`**: Must contain EXACTLY ONE single most relevant Title Case category string (e.g., `[Linux]`, `[DevOps]`, `[Homelab]`, `[Gaming]`, `[Security]`, `[Networking]`, or `[Other]`). Never include multiple categories.
---

## 2. FILE & ASSET NAMING CONVENTIONS

```text
src/
├── assets/images/YYYY/slug/
│   ├── cover.webp
│   └── screenshot-01.webp
└── content/blog/YYYY/
    └── slug.mdx
```

* **Blog Path**: `src/content/blog/YYYY/slug.mdx` (matches `pubDate` year and frontmatter `url`).
* **Cover Asset**: `src/assets/images/YYYY/slug/cover.webp` (WebP format required).
* **Inline Assets**: `src/assets/images/YYYY/slug/descriptive-name.webp`.

---

## 3. MDX IMPORTS & ASTRO COMPONENTS

Place Astro imports immediately after the frontmatter closing `---`:

```mdx
import { Image } from 'astro:assets';
import coverImg from '../../../assets/images/YYYY/slug/cover.webp';

<Image
  src={coverImg}
  alt="Descriptive accessibility text"
  widths={[640, 960, 1280, 1600]}
  sizes="(max-width: 768px) 100vw, 900px"
  formats={['avif', 'webp']}
  quality={80}
  loading="lazy"
/>
```

---

## 4. CODE BLOCKS & CALLOUTS

### Expressive Code Syntax
Annotate fenced code blocks for custom frames and titles:

````markdown
```bash frame="terminal" title="Install Package"
sudo pacman -S ollama
```
````

* **Supported Languages**: `bash`, `ini`.

### Admonitions
Use bolded blockquotes for callouts:

```markdown
> **Note:** Configuration reloads automatically on boot.
> **Warning:** Modifying EFI bootloader entries requires root privileges.
```

---

## 5. TONE & WRITING STYLE

1. **Perspective**: Practical, hands-on first-person ("On my setup...", "I keep my config in...").
2. **No AI Padding**: Do not use "In today's digital world...", "In conclusion...", or marketing hype.
3. **Imperative Steps**: Use direct instructions ("Run...", "Edit...", "Configure...").
4. **Sign-off**: Concise conclusion ending with a thematic callout (e.g., **Happy Ricing!**).

## 6. Ideas Folder Workflow

### Source Files

Located at `ideas/*.txt` with format:

```text
Title: Ollama Installation on Linux
Key points:
- 
-
-
```

### Processing Rules

1. **Read idea file** → extract title and key points
2. **Generate slug** from title: lowercase, kebab-case, max 60 chars
3. **Determine year** from current date (or target pubDate)
4. **Create frontmatter** using today's date in CEST/CET
5. **Draft content** following structure template
6. **Create cover image** placeholder or generate prompt
7. **Save as** `src/content/blog/YYYY/slug.mdx`
8. **Move idea file** to `ideas/archive/`

## 7. Quality Checklist (Pre-Publish)

- [ ] Frontmatter complete and valid per schema
- [ ] Cover image imported and displayed
- [ ] All images have descriptive `alt` text
- [ ] Code blocks have correct language annotations
- [ ] No broken internal/external links
- [ ] Headings follow H2→H3 hierarchy
- [ ] Callouts use `> **Label:**` format
- [ ] Tables use GFM syntax with header row
- [ ] Mermaid diagrams render (if used)
- [ ] Description ≤160 chars, includes keyword
- [ ] Tags lowercase, kebab-case, relevant
- [ ] Categories Title Case, from approved list
- [ ] `pubDate` timezone matches author location (CEST/CET)
- [ ] `lastmod` = `pubDate` for new posts
- [ ] `draft: false`
- [ ] License specified
- [ ] Conclusion section present

## 8. Generation Prompt Template

When generating a new post from an idea file, use this prompt structure:

> **Input**: `ideas/<topic>.txt`
> **Output**: `src/content/blog/YYYY/slug.mdx`
> 
> Create a technical blog post following `blog-brain.md` specification.
> - Use the idea file's key points as section outline
> - Write in the established voice: technical, imperative steps, personal experience
> - Include cover image import (use placeholder path if image not ready)
> - Add realistic frontmatter with today's date in CEST/CET
> - Include if needs code block with `frame="terminal"`
> - Add troubleshooting table if applicable
> - End with conclusion and "Happy [topic]!" sign-off