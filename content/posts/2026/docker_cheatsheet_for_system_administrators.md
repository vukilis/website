---
title: "Docker Cheatsheet for System Administrators"
url: /docker_cheatsheet_for_system_administrators
date: 2026-03-17T19:23:11+01:00
lastmod: 2026-03-17T19:23:11+01:00
draft: false
license: ""

tags: [linux, docker, containers]
categories: [Linux, Homelab]
description: "Managing a complex environment requires a reliable set of tools, so I have put together..."

featuredImagePreview: "/images/2026/docker_cheatsheet_for_system_administrators/docker_cheatsheet_for_system_administrators.png"


hiddenFromHomePage: false
hiddenFromSearch: false
twemoji: false
lightgallery: true
ruby: true
fraction: true
fontawesome: true
linkToMarkdown: true
rssFullText: false

toc:
    enable: true
    auto: true
comment:
    enable: true
code:
    copy: true
    maxShownLines: 50
math:
    enable: false
share:
    enable: true
    HackerNews: true
    Reddit: true
    VK: true
    Line: false
    Weibo: false
---
<!--more-->

Managing a complex environment requires a reliable set of tools, so I have put together this guide to the specific Docker commands I find myself typing into my terminal most often.

## Getting Started

### Step 1: Container Management

Runs a container in detached mode:

```bash
docker run -d --name <name> <image>
```

Lists all containers, including those that are stopped

```bash
docker ps -a
```

Lists all active containers:

```bash
docker ps
```

Run a command inside a container:

```bash
docker exec -it [id] [command]
```

### Step 2: Image Management

Displays all locally stored images:

```bash
docker images
```

Builds an image from a Dockerfile in the current directory:

```bash
docker build -t <name>:<tag> .
```

Cleans up "dangling" images that no longer have a tag, usually left over from previous builds.  
Very safe, it only clears out "orphaned" layers:

```bash
docker rmi $(docker images --quiet --filter "dangling=true")
```

### Step 3: System Maintenance & Cleanup

Shows how much disk space Docker is using for images, containers, and volumes:

```bash
docker system df
```

Get Docker Group ID which is often essential when mapping permissions:

```bash
echo "DOCKER_GID=$(getent group docker | cut -d: -f3)"
```

Removes all stopped containers, unused networks, and dangling images:

```bash
docker system prune -a
```

What it deletes: 
-  All stopped containers
-  All unused networks
-  All dangling images
-  All unused images: *If you have an image like nginx:latest that you downloaded but are not currently running in a container, it will be deleted, even if it has a name and tag*

> Note: Use with caution. If you are working offline later, you’ll have to re-download everything you just deleted.

### Step 4: Volumes and Networking

List all available volumes:

```bash
docker volume ls
```

Inspect Volume Details:

```bash
docker volume inspect [volume_name]
```

To see the volume file path on your host machine:

```bash
docker volume inspect --format '{{ .Mountpoint }}' [volume_name]
```

> Note: Replace `volume_name` with the specific name or ID of the volume you want to investigate.

A powerful command to wipe all existing volumes, use this with caution when you need a completely fresh start:

```bash
docker volume ls -q | xargs docker volume rm
```

List all available networks:

```bash
docker network ls
```

This filters networks specifically and pulls their full inspection data, which is great for debugging IP assignments across multiple stacks:

```bash
docker network ls -q --filter 'driver=[name]' | xargs -I '{}' docker network inspect '{}'
```

> Note: Change `name` to your specific driver

### Step 5: Docker Compose

Command to build, create, and start containers defined in your `docker-compose.yml` in detached mode:

```bash
docker compose up -d
```

Lists the status of all running containers associated with the current stack, showing their state and port mappings:

```bash
docker compose ps
```

Stops the stack:

```bash
docker compose down
or 
docker compose stop
```

Stops the stack and removes containers, networks, and volumes. The `--remove-orphans` flag is particularly useful for cleaning up services that were removed from the YAML file but are still running:

```bash
docker compose down --volumes --remove-orphans
```

Follows the logs for a specific service while skipping the historical clutter, perfect for debugging a failing database or API:

```bash
docker compose logs -f --tail=100 [service_name]
```

Drops you directly into a specific service's shell without needing to look up a dynamic container ID:

```bash
docker compose exec -it [service_name] [/bin/shell]
```

> Note: Shell usually can be `sh` or `bash`


Validates and renders your Compose file. It is a great way to catch syntax errors or see how environment variables are being interpolated before you attempt to deploy:

```bash
docker compose config
```

## Conclusion

These are the essential commands that keep my servers running smoothly day-to-day, and I hope they serve as a helpful reference for your own workflow.