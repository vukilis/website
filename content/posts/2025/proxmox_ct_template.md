---
title: "Proxmox CT Template"
url: /proxmox_ct_template
date: 2025-05-01T22:11:34+02:00
lastmod: 2025-05-01T22:11:34+02:00
draft: false
license: ""

tags: [homelab, linux, debian, template, proxmox]
categories: [Linux, Virtualization, Homelab]
description: "This guide will show how I made my container (CT) template on proxmox..."

featuredImagePreview: "/images/2025/proxmox_ct_template/proxmox_ct_template.png"


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

This guide will show how I made my container (CT) template on proxmox. This template is based on debian 12 bookworm version. 
For more information about proxmox linux containers check this link: https://pve.proxmox.com/wiki/Linux_Container

## Choose And Create Container (CT)

I like to use **Debian** as a most stable linux distributions for my servers, but can be used any other, I recommend: Debian, Ubuntu, Rocky Linux and AlmaLinux.

First we need to download our distribution, we have 3 ways to do that:  
- download **.iso** file and upload to proxmox storage
- download from **URL**
- using **templates** provided by Proxmox

I will use template to download my debian distribution.

Create CT:

- General:

| Name | Value |
| --- | --- |
| Node | your-node-name |
| CT ID | enter-id |
| Unprivileged container | yes |
| Nesting | yes |
| Password | your-password |
| Confirm password | your-password |
| SSH public key(s) | upload or paste your public SSH key |
| Tags | template |

- Template:

| Name | Value |
| --- | --- |
| Storage | local |
| template | debian-12-standard_12.7-1_amd64.tar.zst |

- Disks & CPU & Memory:

| Name | Value |
| --- | --- |
| Storage | local-lvm |
| Disk Size(GiB) | 20 |
| ACLs | Default |
| | |
| Cores | 2 |
| CPU limit | default |
| CPU units | Default |
| | |
| Memory (MiB) | 2048 |
| Swap (MiB) | 512 |
| CPU units | Default |

- Network & DNS:

| Name | Value |
| --- | --- |
| Name: | eth0 |
| Bridge | vmbr0 |
| CPU units | Default |
| IPv4 | Static |
| IPv4/CIDR | 192.168.0.200 |
| Gateway (IPv4) | 192.168.0.1 |
| | |
| DNS domain | adblock.local |
| DNS servers | 192.168.0.202 |

After the container is created we can procced to next step.

## Prepare Our Container For Template

Update debian to the latest version:

```bash
apt update && apt upgrade
```

Install usefull packages:

```bash
apt install -y curl iotop bash-completion tcpdump net-tools elinks bind9-dnsutils netcat-traditional wget unzip zip zstd lsof dos2unix traceroute iptraf acpid plocate vim lshw sysstat ltrace strace pciutils ethtool telnet tmux rsync nano sudo molly-guard pydf ncdu atop atop lsof iperf3 htop
```

Set-up Default Editor, I like to use nano `:)`:

```bash
update-alternatives --config editor
1
```

Create new user and add to sudo group:

```bash
adduser homelab
usermod -aG sudo homelab
```

Deletes the local repository of downloaded and remove packages that were installed as dependencies for other packages but are no longer needed:

```bash
apt clean
apt autoremove
```

Allow our user `homelab` to run any command using sudo without being prompted for his password:

```bash
visudo
%sudo   ALL=(ALL) NOPASSWD: ALL
```

Login to our created `homelab` user and add your ssh key:

```bash
mkdir -p .ssh
chmod 700 .ssh
echo "your public ssh key" > .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
```

Remove shell history for `homelab` user:

```bash
history -c
> ~/.bash_history
```

Login as root again:

```bash
sudo su -
```

Regenerate ssh host keys, first we can create a one-time systemd service in the template that generates host keys at first boot:

```bash
cat <<EOF > /etc/systemd/system/regen-ssh-hostkeys.service
[Unit]
Description=Regenerate SSH host keys
Before=ssh.service
ConditionPathExists=!/etc/ssh/ssh_host_rsa_key

[Service]
Type=oneshot
ExecStart=/usr/bin/ssh-keygen -A

[Install]
WantedBy=multi-user.target
EOF
```

Enable our one-time service:

```bash
systemctl enable regen-ssh-hostkeys.service
```

Remove existing host keys in the template:

```bash
rm -rf /etc/ssh/ssh_host_*
```

Disable root login via SSH and disable password login:

```bash
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
```

Clean machine-id and D-Bus ID:

```bash
truncate -s 0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id
```

Clear logs and temporary files:

```bash
journalctl --rotate
journalctl --vacuum-time=1s
rm -rf /tmp/*
rm -rf /var/tmp/*
```

Disable root logins via shell:

```bash
usermod -s /usr/sbin/nologin root
```

Remove shell history `root` user:

```bash
history -c
> ~/.bash_history
```

> After finish shutdown the container

### Create Template (CT)

Our container is now ready to be converted to template.

- Right click to container and select **Convert to template**.


## Conclusion

This is how I made my template for my containers.  
When I want to create a new container I can use this template and create as a linked or full clone with all preinstalled packages I want and also have some basic security properties.