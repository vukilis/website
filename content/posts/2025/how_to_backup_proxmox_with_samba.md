---
title: "How to Backup Proxmox With Samba"
url: /how_to_backup_proxmox_with_samba
date: 2025-04-15T20:28:38+02:00
lastmod: 2025-04-15T20:28:38+02:00
draft: false
license: ""

tags: [homelab, linux, backup, proxmox]
categories: [Linux, Virtualization, Homelab]
description: "This is the guide how to make backup for proxmox using Samba Share (SMB) Protocol..."

featuredImagePreview: "/images/2025/how_to_backup_proxmox_with_samba/how_to_backup_proxmox_with_samba.png"


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

This is the guide how to make backup for proxmox using Samba Share (SMB) Protocol and store backup on windows machine.  
We will use **Proxmox Backup Server** as our backup method and I highly recommend to use this method.

## Why Proxmox Backup Server

Proxmox Backup Server is an enterprise backup solution, for backing up and restoring VMs, containers, and physical hosts. By supporting incremental, fully deduplicated backups, Proxmox Backup Server significantly reduces network load and saves valuable storage space. With strong encryption and methods of ensuring data integrity, you can feel safe when backing up data, even to targets which are not fully trusted.

## Planing And Creating Our Backup Directories

For SMB share we need to configure Windows OS to share our directories to others on local network.
Check official microsoft tutorial https://support.microsoft.com/en-us/windows/file-sharing-over-a-network-in-windows-b58704b2-f53a-4b82-7bc1-80f9994725bf

We need to plan our backup location:

> This is my plan

* I will use a separate hard drive for my backup
* I will create next directories:
    1. **proxmox-backup** - storing my backup for CTs & VMs
    2. **proxmox-backup-server** - storing my manual backup for *Proxmox Backup Server* using for migration
    3. **proxmox-host** - storing my backup for all proxmox node configuration using for migration
    4. **proxmox-shared** - storing .iso and .templates

After this step we can proceed to creating and configuring your directories.  
I will skip this step but most important thing is that we need share to **@everyone with read & write permissions**.

## Add Storage To Proxmox

For adding storage follow next steps:

* Go to Proxmox **Web GUI**
* Select **Datacenter** and select **Storage**

> This step we need to repeat for all storages 

* Select **Add** and select **SMB/CIFS**

* **proxmox-backup**:
    - **ID**: proxmox-backup
    - **Server**: [your-windows-ip-address]
    - **Username**: [your-windows-username]
    - **Password**: [your-windows-password]
    - **Share**: proxmox-backup
    - **Nodes**: [your-pve-node]
    - **Enabled**: yes
    - **Content**: Backup, Container, Snippets

* **proxmox-backup-server**:
    - **ID**: proxmox-backup-server
    - **Server**: [your-windows-ip-address]
    - **Username**: [your-windows-username]
    - **Password**: [your-windows-password]
    - **Share**: proxmox-backup-server
    - **Nodes**: [your-pve-node]
    - **Enabled**: yes
    - **Content**: Backup, Container, Snippets

* **proxmox-host**:
    - **ID**: proxmox-host
    - **Server**: [your-windows-ip-address]
    - **Username**: [your-windows-username]
    - **Password**: [your-windows-password]
    - **Share**: proxmox-host
    - **Nodes**: [your-pve-node]
    - **Enabled**: yes
    - **Content**: Backup

* **proxmox-shared**:
    - **ID**: proxmox-shared*
    - **Server**: [your-windows-ip-address]
    - **Username**: [your-windows-username]
    - **Password**: [your-windows-password]
    - **Share**: proxmox-shared*
    - **Nodes**: [your-pve-node]
    - **Enabled**: yes
    - **Content**: ISO Image, Container Template

After finish click **OK**.

## Setup Proxmox Backup Server

We have 2 method how to install and setup our **Proxmox Backup Server**, download iso and install or using script from **Proxmox VE Helper-Scripts**.  
I will use second method as LXC container, link to the script: https://community-scripts.github.io/ProxmoxVE/scripts?id=proxmox-backup-server   
Follow link instruction and install **Proxmox Backup Server**

### Install And Setup SMB Share 

Login to _shell of **proxmox-backup-server** and install **cifs**:

```bash
apt install cifs-utils
```

Configurate fstab:

```bash
nano /etc/fstab
```

```ini
//192.168.0.152/proxmox-backup /mnt/proxmox-backup        cifs    credentials=/etc/.smb_creds,rw,noperm,uid=100000        0       0
```

Create samba credentials:

```bash
nano /etc/.smb_creds
```

```ini
username=[your-windows-username]
password=[your-windows-password]
```

Create share directory:

```bash
mkdir /mnt/proxmox-backup
```

Mount and reload daemon:

```bash
mount -a
systemctl daemon-reload
```

List shared directory:

```bash
ls /mnt/proxmox-backup/
```

### Setup User and Datastore

Make a new user for backup:

* Go to Proxmox Backup Server **Web GUI**
* Select **Access Controll** under **Configuration** and select **Add**:
    - **User name**: name@proxmox-backup
    - **Password**: [your-password]
    - **Confirm password**: [your-password]
    - **Expire**: never 
    - **Enabled**: yes
    - **First name**: [your-name]
    - **E-Mail**: [your-mail]

Add a new Datastore:

* Go to Proxmox Backup Server **Web GUI**
* Select **Add Datastore** under **Datastore**:
    - **Name**: backup
    - **Backing path**: /mnt/proxmox-backup
    - **GC Schedule**: Friday 21:00
    - **Prune Schedule**: Friday 21:00 
* For prune job keep last 2 backup

### Add Storage for Proxmox Backup Server 

* Go to Proxmox **Web GUI**
* Select **Datacenter** and select **Storage**
* Select **Add** and select **Proxmox Backup Server**
* **pbs**:
    - **ID**: pbs
    - **Server**: [your-proxmox-backup-server-ip-address]
    - **Username**: root@pam
    - **Password**: [your-proxmox-backup-server-password]
    - **Nodes**: [your-pve-node]
    - **Enabled**: yes
    - **Datastore**: backup
    - **Fingerprint**: [your-proxmox-backup-server-fingerprint]

After finish click **OK**.

> To get fingerprint go to Proxmox Backup Server **Web GUI**, select **backup** under **Datastore** and select **Show Connection Information**

### Create Backup Job

* Go to Proxmox **Web GUI**
* Select **Datacenter** and select **Backup**
* Select **Add**
* **pbs**:
    - **Node**: [your-pve-node]
    - **Storage**: pbs
    - **Schedule**: Friday 21:00
    - **Selection mode**: Exclude selected VMs
    - **Notification mode**: Notification system
    - **Compression**: ZSTD (Fast and good)
    - **Mode**: Snapshot
    - **Enable**: yes


## Additional

In beginning we made **proxmox-migrate** directory where we will store our manually created backup for **proxmox-backup-server**.

`Why we will do this?`  
*Because for me this is a great way to migrate our proxmox server to a new server.*  
`How we can do this?`  
*After backup we can follow instruction to install our **proxmox-backup-server** on a new server and restore from backup.*   
*Use **proxmox-backup-server** to restore all our CTs & VMs.*

---

Create manualy backup

* Go to Proxmox **Web GUI**
* Select our container **proxmox-backup-server** and select **Backup**
* Select **Storage** and select **pbs**
* Run **backup**

## Conclusion

After this our backup server is ready!  
Proxmox Backup Server will backup our CTs & VMs every Friday at 21:00. Backup will be stored on our windows machine in proxmox-backup directory. 
To see how to migrate our proxmox host to a new server check this [post](https://vukilis.com/proxmox_migration_to_a_new_server/).