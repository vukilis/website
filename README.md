<img src="https://status.vukilis.com/api/badge/1/status?style=for-the-badge"/>

## website
[`vukilis.com`](http://vukilis.com)


## Prerequisites

- [Nix](https://nixos.org/) with flakes enabled
- A [Cloudflare account](https://dash.cloudflare.com)

## Local Development

### Enter the Nix Dev Shell

```sh
nix develop
```

This provides Node.js 22 and `pnpm` automatically. The shell hook prints the versions on entry.

### Install Dependencies

```sh
pnpm install
```

### Run the Dev Server

```sh
pnpm dev --host 0.0.0.0
```

The site is available at:  
┃ Local    http://localhost:4321/  
┃ Network  http://ip.address:4321/

## pnpm Commands

```sh
pnpm install          # Install dependencies
pnpm dev              # Start the Astro dev server (alias for `astro dev`)
pnpm start            # Alias for `pnpm dev`
pnpm build            # Build the site for production
pnpm preview          # Preview the production build locally
pnpm check            # Run Astro type checks
pnpm test             # Run the test suite (vitest)
```

## Astro Commands

Astro is also available directly via pnpm:

```sh
pnpm astro --help
pnpm astro check
```

## Cloudflare Worker Deployment

This project deploys as a Cloudflare Worker using [Wrangler](https://developers.cloudflare.com/workers/wrangler/).

### CI / Build Settings

- **Build command:** `pnpm astro build`
- **Deploy command:** `pnpm wrangler deploy`
- **Output directory:** `/`