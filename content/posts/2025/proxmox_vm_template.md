---
title: "Proxmox VM Template"
url: /proxmox_vm_template
date: 2025-05-18T00:23:40+02:00
lastmod: 2025-05-18T00:23:40+02:00
draft: false
license: "MIT"

tags: [homelab, linux, debian, template, proxmox]
categories: [Linux, Virtualization, Homelab]
description: "This guide will show how I made my virtual machine (VM) template on proxmox..."

featuredImagePreview: "/images/2025/proxmox_vm_template/proxmox_vm_template.png"


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

This guide will show how I made my virtual machine (VM) template on proxmox. This template is based on Debian (bookworm) Cloud Images.

These, are special images provided, which includes support for cloud-init. For this example, we will specifically be leveraging the "genericcloud" image, which is suitable for our VMs.

This- image does not include many bare metal hardware drivers, which aren't needed, since the focus of this post is creating a VM template.

For more information about proxmox virtual machines check this link: https://pve.proxmox.com/wiki/QEMU/KVM_Virtual_Machines


## Getting Started

### Step 1. Acquire Cloud Image

From Debian Official Cloud Images https://cloud.debian.org/images/cloud/, we want to select the Bookworm/Latest folder at the bottom of the page.

Inside of this folder we want, the `genericcloud`-`amd64`.qcow2 image. Its name is `debian-12-genericcloud-amd64.qcow2`.  
Can be downloaded directly from this link: https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2

We will now store this image on one of our Proxmox nodes or Windows/Linux machine in a temporary location:

```bash
wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2
```

---

### Step 2. Customize Image

I like to customize my images, to install a few basic tools. First, we need to install the `libguestfs-tools` package for that, via your package manager.

```bash
sudo apt-get install libguestfs-tools
```

Install packages into the base image:

```bash
virt-customize -a debian-12-genericcloud-amd64.qcow2 --install qemu-guest-agent,curl,iotop,bash-completion,tcpdump,net-tools,elinks,bind9-dnsutils,netcat-traditional,wget,unzip,zip,zstd,lsof,dos2unix,traceroute,iptraf,acpid,plocate,vim,lshw,sysstat,ltrace,strace,pciutils,ethtool,telnet,tmux,rsync,nano,sudo,molly-guard,pydf,ncdu,atop,atop,lsof,iperf3,htop
```

(Optional) Fix DHCP Issue:

By default, cloud images use the hostname as the DHCP identifier. This works fine, unless it sends the default template name for every cloned image.

A simple fix is to update the logic to use the hardware/MAC address instead."

```bash
virt-customize -a debian-12-genericcloud-amd64.qcow2 --run-command "sed -i 's|send host-name = gethostname();|send dhcp-client-identifier = hardware;|' /etc/dhcp/dhclient.conf"
```

Reset machine-id:

If this step is left out, machines will each acquire the same IP address when using DHCP (Regardless if your MAC is different)

```bash
virt-customize -a debian-12-genericcloud-amd64.qcow2 --run-command "echo -n > /etc/machine-id"
```

Disable root login via SSH and disable password login:

```bash
virt-customize -a debian-12-genericcloud-amd64.qcow2 \
  --run-command "sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config" \
  --run-command "sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config"
```

Clear logs and temporary files:

```bash
virt-customize -a debian-12-genericcloud-amd64.qcow2 \
  --run-command "journalctl --vacuum-time=1s" \
  --run-command "rm -rf /tmp/*" \
  --run-command "rm -rf /var/tmp/*"
```

Allow our sudo user to run any command using sudo without being prompted for his password:

```bash
virt-customize -a debian-12-genericcloud-amd64.qcow2 \
  --run-command "sed -i 's|^%sudo[[:space:]]\+ALL=(ALL:ALL) ALL|%sudo ALL=(ALL) NOPASSWD: ALL|' /etc/sudoers" \
  --run-command "visudo -c"
```

Disable root logins via shell and remove shell history:

```bash
virt-customize -a debian-12-genericcloud-amd64.qcow2 \
  --run-command "usermod -s /usr/sbin/nologin root" \
  --run-command "sh -c '> /root/.bash_history'"
```

(Optional) Compress and shrink the image:

```bash
qemu-img convert -O qcow2 -c -o preallocation=off debian-12-genericcloud-amd64.qcow2 debian-12-genericcloud-amd64-shrink.qcow2
```

> This saved around 300M, which is pretty impressive when you consider the file was only 700M originally.

### Step 3. Create a VM

Now that we have a suitable image, we need to build a base VM template. I will be doing this step through the GUI.

Create CT:

- General:

| Name | Value |
| --- | --- |
| Node | your-node-name |
| VM ID | enter-id |
| Name | vm-name |
| Tags | template |

- OS:

For the OS Tab- click `don't use any media`. No other changes are needed here.

- System:

On the system tab, I enabled the checkbox for Qemu-Agent.

- Disk:

On the disks tab, you will want to REMOVE the default disks. We will add disks later.

- Disks & CPU & Memory:

For CPU / Memory tab- just set whatever defaults you want.

I chose 2 CPU cores, x86-64-v2-AES on the type as its easily compatible with all of my nodes.

For memory, I allocated 2048G of ram, and disabled ballooning. Remember- we will clone this template for creating VMs, and adjust the CPU/RAM there.

- Network & DNS:

For network, I chose my default interface, where I typically create new nodes. I did select firewall.

| Name | Value |
| --- | --- |
| Bridge | vmbr0 |
| Firewall | yes |

> On the confirm tab don't select start after created.

After the virtual machine is created and we can procced to next step.

### Step 4. Attach qcow2 image to VM

Next, we will attach the .qcow2 image we downloaded earlier.

I'm using samba share and I will copy from shared disk to pve host:

```bash
mkdir template
cd template
cp /mnt/pve/proxmox-shared/images/debian-12-genericcloud-amd64-shrink.qcow2 .
```

Next, attach it, using qm importdisk $VM_ID $IMAGEPATH $YOUR_STORAGE

I want to store my template on default disk, which is named `local-lvm`:

```bash
qm importdisk 100 debian-12-genericcloud-amd64-shrink.qcow2 local-lvm
```

### Step 5. Template Tweaks

Lets go back to the VM in the GUI now.

**Hardware Tab**:  

* Remove the CD/DVD drive (Unless- you need one.)
* Attach the disk we created from the qcow2:
  1. Click on the unused disk, then click edit. Set Bus/Device to "VirtIO Block" as position 0
  2. Click Add.
* Next- Click Add -> CloudInit Device
  1. Select your storage. I leave IDE selected as the default bus.
* Edit the network interface on your template. Ensure its MAC Address to 00:00:00:00:00:00 (This will cause a random MAC address to be generated for every new clone)

**Cloud Init Tab**

* Now we can customize the cloud init tab, with a default user, password (if desired), dns, ip, and ssh information.  
* For the IP Config, I set dhcp as the default.

**Options Tab**

* Boot order:
  1. I always uncheck network boot, since I don't use it. As well, make sure to unselect the cloudinit drive.
  2. We only want the primary disk, containing our cloned qcow2 selected here

**Firewall**

* I have a firewall rule defined for only allowing ssh access, for known, good hosts.
* If you do plan on including firewall rules, make sure to enable "Firewall" under Firewall -> Options. It is not enabled by default.


### Step 6. Create Template (VM)

To convert this to a template go Right click on the VM, and select, Convert to template.


### Additional 

To add disk-space after cloning you can do this via proxmox console or GUI:

Using the Command Line (CLI):

```bash
qm resize <VMID> <disk-id> +<size>
```

Using the Proxmox Web UI:

* Shut Down the VM (if necessary)
* Resize the Virtual Disk
  1. Go to Proxmox Web UI
  2. Select your VM from the left panel
  3. Go to the Hardware tab
  4. Select the disk you want to resize (e.g., scsi0, virtio0, etc.)
  5. Click Resize Disk at the top
  6. Enter the amount to add (example, "10G" to add 10 GB)
  7. Click Resize Disk to apply

### Bugs

When we boot for first time we can get error message `kernel panic not syncing: attempted to kill init!`.  

Beacuse of this error we cant normally poweroff our machine, to solve this go to pve host console and kill the proccess of machine:

```bash
ps aux | grep kvm | grep 351
kill -9 2928598
```

Once the machine is powered on, everything should work as expected.

## Conclusion

This is how I made my template for my virtual machines.  
When I want to create a new VM I can use this template and create as a linked or full clone with all preinstalled packages I want and also have some basic security properties.
