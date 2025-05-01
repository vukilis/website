---
title: "How to Restore Proxmox"
url: /how_to_restore_proxmox
date: 2025-04-20T01:59:30+02:00
lastmod: 2025-04-20T01:59:30+02:00
draft: false
license: ""

tags: [homelab, linux, backup, proxmox]
categories: [Linux, Virtualization, Homelab]
description: "This is the guide how to migrate our proxmox server to a new server, this process..."

featuredImagePreview: "/images/2025/how_to_restore_proxmox/how_to_restore_proxmox.png"


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

This is the guide how to migrate our proxmox server to a new server, this process can be a very tricky.

Before continue reading this post first check the post [how to backup proxmox with samba](https://vukilis.com/how_to_backup_proxmox_with_samba/) and to see how to migrate our proxmox host to a new server check the post [proxmox migration to a new server](https://vukilis.com/proxmox_migration_to_a_new_server/). 

## Check For Missing Logical Volume And Configuration

Problem we are facing after migration our proxmox host to a new server is that we don't have created logical volumes for our LXC containers. We can list all logical volumes from our LXC containers with next commands:

```bash
lvs
```

We can list all congif files from our LXC containers with next command:

```bash
ls /etc/pve/lxc/
```

## Create Missing Logical Volumes and Configuration

To create our missing logical volume we can run next command:

```bash
lvcreate -n vm-204-disk-0 -L 1M pve
```

> We can give only 1M to our LXC container because after we backup LXC will have anyway same as before, example 20GB

## Using Script

But, we can make it even more easily and better using script for creating LVS:

```bash
tee create_lvs.sh << 'EOF'
#!/bin/bash

conf_dir="/etc/pve/lxc"

for conf_file in "$conf_dir"/*.conf; do
    vm_id=$(basename "$conf_file" .conf)
    lvcreate -n "vm-${vm_id}-disk-0" -L 1M pve
    echo "Created LV for vm-${vm_id}-disk-0"
done
EOF
sudo chmod +x /path/to/your/script/create_lvs.sh
```

Make script executable:

```bash
chmod +x create_lvs.sh
```

Now, we can run our script and make all LVS we need:

```bash
./create_lvs.sh
```

***All this steps is only to get LXC working and prepared for restoring.***

## Restore Proxmox Backup Server

In the post [how to backup proxmox with samba](https://vukilis.com/how_to_backup_proxmox_with_samba/) we created proxmox-backup-server that we can manualy backup our Proxmox Backup Server.

First we want to restore Proxmox Backup Server:

* Go to Proxmox **Web GUI**
* Select our **container** and select **Backup**
* Select **storage** and select **proxmox-backup-server**
* Select our last backup and select **Backup now**

Our Proxmox Backup Server is ready and we can now procces to next step to restore our LXC containers. 

## Restore Our LXC Container From Backup

* Go to Proxmox **Web GUI**
* Select our **container** and select **Backup**
* Select **storage** and select **pbs**
* Select our last backup and select **Backup now**

After the backup is finished, we have our LXC container restored!

> Potential bug can be that we need to wait some time to appear our bash console, this is only when we restore our container

> We can use pve host to try connect to our container console: `pct console 204`

## Addtional

If we want to remove created volume we can use next command:

```bash
lvremove -y /dev/pve/vm-204-disk-1
```

or delete all exsiting, example:

```bash
echo {201..214} | tr ' ' '\n' | xargs -I {} pct destroy {} --force
```

If we want to list all mounted volumes run next command:

```bash
ls /dev/pve/
```

## Conclusion

For me this is very good way to migrate our proxmox to another server and restore our backup.