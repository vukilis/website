---
title: "Proxmox Migration To A New Server"
url: /proxmox_migration_to_a_new_server
date: 2025-01-20T20:16:14+02:00
lastmod: 2025-01-20T20:16:14+02:00
draft: false
license: ""

tags: [homelab, linux, backup]
categories: [Linux, Virtualization, Homelab]
description: "This is the guide how to migrate existing proxmox host to a new server..."

featuredImagePreview: "/images/2025/proxmox_migration_to_a_new_server/proxmox_migration_to_a_new_server.png"


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

This is the guide how to migrate existing proxmox host to a new server with all confinguration and prepare for backup LXC containers and VM machines.  
Before continue reading this post first check the post [how to backup proxmox with samba.](https://vukilis.com/how_to_backup_proxmox_with_samba/)

## Proxmox PVE Host Backup

Create PVE host backup script, for more information check https://gist.github.com/mrpeardotnet/6bdc4b504f43ce57fa7eaee96d376edf


To create backup script that will be executed every day we can create backup script in /etc/cron.daily/ folder. We need to make it writeable by root (creator) only, but readable and executable by everyone:

```bash
touch /etc/cron.daily/pvehost-backup
chmod 755 /etc/cron.daily/pvehost-backup
```

Copy and paste following script into the created file:


> This is my configuration

```bash
#!/bin/sh
BACKUP_PATH="/mnt/pve/proxmox-host/dump"
BACKUP_FILE="pve-host"
KEEP_DAYS=2
PVE_BACKUP_SET="/etc/pve/ /etc/lvm/ /etc/modprobe.d/ /etc/network/interfaces /etc/vzdump.conf /etc/sysctl.conf /etc/resolv conf /etc/ksmtuned.conf /etc/host>"
PVE_CUSTOM_BACKUP_SET=""

tar -czf $BACKUP_PATH$BACKUP_FILE-$(date +%Y_%m_%d-%H_%M_%S).tar.gz --absolute-names $PVE_BACKUP_SET $PVE_CUSTOM_BACKUP_SET
find $BACKUP_PATH$BACKUP_FILE-* -mindepth 0 -maxdepth 0 -depth -mtime +$KEEP_DAYS -delete
```

---

You can modify variables to fit backups for your individual hosts:

- BACKUP_PATH to specifiy where to store backups,
- BACKUP_FILE to specify backups file prefix,
- KEEP_DAYS to specify how many old backups to keep (in days)
- PVE_CUSTOM_BACKUP_SET to add your installation specific folders and/or files,
- PVE_BACKUP_SET defines standard set of folders and config files for generic PVE host.

Run test:

```bash
run-parts /etc/cron.daily/
```

## Recover Backup On New PVE Host

Copy backup to new pve host:

```bash
scp -r [name].tar.gz root@[IP_ADDRESS]:/tmp
```

To avoid having more then one node, best solution is to remove existing default node:

```bash
rm -rf /etc/pve/nodes/*
```

Now we can restore backup:

```bash
cd /tmp
tar --overwrite -xzf /tmp/dumppve-host-2025_04_19-18_11_58.tar.gz -C /
```

Reboot proxmox:

```bash
reboot
```

## Potential Problems

Network configuration may be different on the new server or if we testing this solution on virtual machine.  
If we want to change some network configuration we can start from here:

```bash
nano /etc/network/interfaces
systemctl restart networking.service
```

Also check network configuration under the node.

---

We may face the problem that the logical volume is missing, we have to create it manually, but this process is explained in this [post](https://vukilis.com/how_to_restore_proxmox/).


## Conclusion

After this process we will have all our configuration on the new proxmox server.

That's it for now!

