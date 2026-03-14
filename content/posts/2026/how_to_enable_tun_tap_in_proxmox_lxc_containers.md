---
title: "How to Enable Tun/Tap in Proxmox LXC Containers"
url: /how_to_enable_tun_tap_in_proxmox_lxc_containers
date: 2026-03-14T17:52:34+01:00
lastmod: 2026-03-14T17:52:34+01:00
draft: false
license: ""

tags: [homelab, linux, debian, proxmox]
categories: [Linux, Virtualization, Homelab]
description: "To facilitate secure tunneling and virtual networking, Linux utilizes `/dev/net/tun` as..."

featuredImagePreview: "/images/2026/how_to_enable_tun_tap_in_proxmox_lxc_containers/how_to_enable_tun_tap_in_proxmox_lxc_containers.png"


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

To facilitate secure tunneling and virtual networking, Linux utilizes `/dev/net/tun` as a specialized device file for managing TUN/TAP interfaces. It provides the necessary hooks for VPN clients to process packets directly, operating at Layer 3 (IP for TUN) or Layer 2 (Ethernet for TAP) level to route traffic through software rather than traditional network cards. When a program opens this device and uses ioctl() calls, the kernel creates a new tunXX or tapXX interface, effectively bridging network traffic between the kernel and the application.

## Getting Started

By default, Proxmox LXC containers are restricted from accessing these kernel level devices for security reasons. If you have ever seen the error: `Cannot open /dev/net/tun: No such file or directory`, it means your container is "blind" to the host's tunneling capabilities. Here is how to fix it.

### Step 1: Identify your Container ID

To allow an LXC container to manage virtual interfaces, we have to explicitly **passthrough** the device from the Proxmox host.

Ensure you know the ID of the container you want to modify (e.g., 100, 101). You should perform these steps from the Proxmox host shell.

### Step 2: Modify the Configuration

```bash
nano /etc/pve/lxc/ID.conf
```

> Replace ID with your actual container number.

### Step 3: Add Device Permissions

```ini
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
```

> `c 10:200:` Refers to the character device major/minor numbers for the TUN set.  
> `bind,create=file:` Ensures the device node is created inside the container's /dev/net/ directory if it doesn't exist.

### Step 4: Restart and Verify

For the changes to take effect, the container must be fully restarted:

```bash
pct stop ID
pct start ID
```

Verify inside the Container:

```bash
ls -l /dev/net/tun
```

### 🚨 A Note on Security

Important to address a common "shortcut" found in some older tutorials: `Disabling AppArmor`.

**Warning**: If you are new to Proxmox or Linux security, do not consider `disabling AppArmor` a solution.
Disabling security profiles to get a service working is as very unsafe and `I DO NOT RECOMMENDED!!!`

The method outlined in this guide (using device passthrough and specific cgroup permissions) is the correct and secure way to enable TUN/TAP. It grants the container exactly what it needs to function without stripping away the security layers that protect your Proxmox host.

## Conclusion

This configuration is particularly useful for those running Docker inside an LXC. If you are looking to containerize your services further, mapping the TUN/TAP interface into your LXC allows you to run high performance VPN stackers like Gluetun.

With this setup, your Docker containers can route all their traffic through a secure, encrypted tunnel managed within the LXC, providing a robust and isolated environment for privacy applications. Once `/dev/net/tun` is verified inside your LXC, you are ready to deploy your stack and look into advanced routing without the overhead of a full VM.