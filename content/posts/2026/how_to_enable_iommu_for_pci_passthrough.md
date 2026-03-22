---
title: "How to Enable IOMMU for PCI Passthrough"
url: /how_to_enable_iommu_for_pci_passthrough
date: 2026-03-22T20:06:02+01:00
lastmod: 2026-03-22T20:06:02+01:00
draft: false
license: ""

tags: [linux, debian, proxmox, homelab]
categories: [Linux, Homelab, Virtualization]
description: "PCI Passthrough in Proxmox allows you to bypass the host's hypervisor layer to give a specific..."

featuredImagePreview: "/images/2026/how_to_enable_iommu_for_pci_passthrough/how_to_enable_iommu_for_pci_passthrough.png"


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

PCI Passthrough in Proxmox allows you to bypass the host's hypervisor layer to give a specific virtual machine direct, exclusive access to physical hardware like a GPU or NIC. This enables the VM to operate the device with near-native performance.


## Getting Started

To enable IOMMU, we need to modify the GRUB bootloader configuration and update the kernel parameters.

### Step 1: Edit the GRUB Configuration

Open your GRUB default configuration file using a text editor like `nano`:

```bash
nano /etc/default/grub
```

### Step 2: Modify the Kernel Command Line

Locate the line starting with `GRUB_CMDLINE_LINUX_DEFAULT`. You will need to append the specific IOMMU flag based on your processor.

- For Intel CPUs

```ini
GRUB_CMDLINE_LINUX_DEFAULT="nowatchdog nmi_watchdog=0 loglevel=3 intel_iommu=on"
```

- For AMD CPUs

```ini
GRUB_CMDLINE_LINUX_DEFAULT="nowatchdog nmi_watchdog=0 loglevel=3 amd_iommu=on"
```

> Note:  
> The `nowatchdog` and `loglevel=3` flags are optional but help in reducing system overhead and keeping the boot logs clean.   

> `nowatchdog` & `nmi_watchdog=0`: These disable the "watchdog" timers that monitor for system hangs. Turning them off frees up CPU resources (specifically one hardware counter) and prevents the system from automatically rebooting if it experiences a brief, non-critical stall—common when performing hardware passthrough or heavy virtualization.  

> `loglevel=3`: This sets the intensity of boot messages sent to your screen. Level 3 restricts output to Errors and higher, hiding the "wall of text" (warnings and info) that usually scrolls by, making the boot process look much cleaner.  

> `intel_iommu=on`: This is the "master switch" for Intel CPUs that enables the IOMMU (Input-Output Memory Management Unit). It allows the hardware to isolate PCI devices into their own memory spaces, which is the foundational requirement for passing a GPU or other hardware directly to a VM.


### Step 3: Update Changes and Reboot

After saving the file, you must update the bootloader and restart the host for the changes to take effect.

```bash
update-grub
reboot
```

### Steps: Verify the Configuration

Once the system is rebooted, verify that IOMMU has been successfully initialized by checking the kernel ring buffer:

```bash
dmesg | grep -e DMAR -e IOMMU
```

If you see lines indicating `"IOMMU enabled"` or directed memory access remapping (DMAR) logs, your hardware is ready for passthrough.

## VFIO Modules (Highly Recommended)

If you are using Proxmox 8.x or newer, the kernel is quite `smart`. However, if you are passing through a GPU (which is the most common use case), skipping this step often leads to the host **grabbing** the GPU for its own console output, which makes it nearly impossible to hand over to a VM later.

To complete the setup, you need to ensure the Proxmox kernel loads the specific drivers that **soft-bind** the PCI devices so they can be passed to a VM instead of being used by the host.


### Load the VFIO Kernel Modules

Once IOMMU is active, you must tell Proxmox to load the Virtual Function I/O (VFIO) modules. These act as the bridge between your physical hardware and the virtual machine.

Open the kernel modules configuration file:

```bash
nano /etc/modules
```

Add the following four lines to the bottom of the file:

```ini
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```

### Refresh the Configuration

To apply these module changes without another full reboot (though a reboot is always the safest way to ensure clean binding), run:

```bash
update-initramfs -u -k all
```

## Conclusion

By enabling IOMMU and loading the VFIO modules, you have successfully prepared the Proxmox kernel for high-performance virtualization. Your host is now capable of handing off raw power to your guests, whether you are building a virtualized workstation or a high-end media server.