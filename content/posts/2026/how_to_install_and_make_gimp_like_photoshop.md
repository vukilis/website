---
title: "How To Install and Make Gimp Like Photoshop"
url: /how_to_install_and_make_gimp_like_photoshop
date: 2026-03-03T19:48:47+01:00
lastmod: 2026-03-03T19:48:47+01:00
draft: false
license: ""

tags: [debian, arch, ubuntu, fedora, customization, apps]
categories: [Linux]
description: ""

featuredImagePreview: "/images/2026/how_to_install_and_make_gimp_like_photoshop/how_to_install_and_make_gimp_like_photoshop.png"


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

This guide is all about how I set up GIMP to stop it from driving me crazy. I have spent years in Photoshop, and honestly, jumping into GIMP for the first time was a bit of a "meh". It’s a great piece of software, but the default layout is just... weird if you are used to Adobe. My muscle memory kept failing me, so I decided to tweak it until it actually felt like Photoshop. In this guide, I will show you how I made GIMP look and act more like the Photoshop setup I am used to.

For more information about GIMP’s core features and documentation, check this link: https://www.gimp.org/docs/

## Getting Started

### Step 1. Install GIMP

I decide to install GIMP via `flatpak` software utility for software deployment and package management.

Next command will install GIMP from flathub:

```bash
flatpak install flathub org.gimp.GIMP
```

### Step 2. Open GIMP

Since we are using `PhotoGIMP`, we need to open GIMP once and then close it. This creates the configuration folders that `PhotoGIMP` needs to work.

You can launch GIMP from the terminal or however you usually open your apps:

```bash
flatpak run flathub org.gimp.GIMP
```

## Install PhotoGIMP

PhotoGIMP is a free, community-driven patch that transforms GIMP (GNU Image Manipulation Program) into a layout that feels familiar to Adobe Photoshop users. If you're switching from Photoshop to GIMP and want to feel at home right away, PhotoGIMP is for you.

Official github url: https://github.com/Diolinux/PhotoGIMP

### Step 1. Install PhotoGIMP

1. Download the latest release: [Download PhotoGIMP for Linux (.zip)](https://github.com/Diolinux/PhotoGIMP/releases/download/3.0/PhotoGIMP-linux.zip)

2. Extract the .zip file into your home folder (~).
    - This will place files into ~/.config and ~/.local, which are hidden folders.
    - To see hidden folders in your file manager, press Ctrl + H.
    - When prompted about existing files, choose "Replace" or "Overwrite".

    ```bash
    unzip -o PhotoGIMP-linux.zip
    cp -rf PhotoGIMP-linux/.config/* ~/.config/ && cp -rf PhotoGIMP-linux/.local/* ~/.local/
    rm -rf PhotoGIMP-linux
    ```
3. Open GIMP — you should see the new PhotoGIMP layout! 


## Additional Plugins

I am going to walk you through installing a few of my favorite plugins to really power up the workflow.

**Resynthesizer**: This is GIMP’s answer to Photoshop’s "Content-Aware Fill", it is a lifesaver for removing objects or healing textures seamlessly.

**G'MIC**: Think of this as a massive toolbox, it adds hundreds of professional filters and effects that GIMP doesn't have by default.

**GEGL**: This allows GIMP to have access to all sorts of cool text styling effects

### Install Plugins

We can list all the available GIMP plugins from Flatpak using this command:

```bash
flatpak search gimp.plugin
```

- Resynthesizer & G'MIC

I am choosing to install the versions compatible with GIMP 3.0.

```bash
flatpak install org.gimp.GIMP.Plugin.Resynthesizer
```

```bash
flatpak install org.gimp.GIMP.Plugin.GMic
```

- GEGL

Official github url: https://github.com/linuxbeaver

[Download all plugins for Linux here](https://github.com/LinuxBeaver/LinuxBeaver/releases/download/Gimp_GEGL_Plugin_download_page/LinuxBinaries_all_plugins.zip)

> Includes Linux binaries and Source Code

FLATPAK Linux (INCLUDES CHROMEBOOK GIMP AS FLATPAK):

so. file filter binaries go in `~/.var/app/org.gimp.GIMP/data/gegl-0.4/plug-ins` then restart Gimp and open GEGL Operation.

```bash
cd ~/.var/app/org.gimp.GIMP/data/gegl-0.4/plug-ins
cp ~/LinuxBinaries_all_plugins.zip . 
unzip LinuxBinaries_all_plugins.zip  
rm source_code_of_all_GEGL_plugins.zip
rm LinuxBinaries_all_plugins.zip
mv LinuxBinaries/* .
rm -r LinuxBinaries
```

### Run GIMP

Run GIMP and test plugins!

## Conclusion

This is exactly how I use GIMP every day. By switching to this layout and adding these specific plugins, I have managed to bridge the gap between my old Photoshop habits and my current Linux workflow.