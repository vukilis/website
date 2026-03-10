---
title: "Betterlockscreen On CachyOS"
url: /betterlockscreen_on_cachyos
date: 2026-03-09T23:45:35+01:00
lastmod: 2026-03-09T23:45:35+01:00
draft: false
license: ""

tags: [arch, cachyos, lockscreen, dwm, rofi]
categories: [Linux]
description: "This guide will show how I set up a lock screen on my CachyOS (Arch Linux) system..."

featuredImagePreview: "/images/2026/betterlockscreen_on_cachyos.md/betterlockscreen_on_cachyos.png"


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

This guide will show how I set up a lock screen on my **CachyOS** (Arch Linux) system. I prefer using **betterlockscreen** because it’s fast and features a great looking blur effect.

## Getting Started

Betterlockscreen is an **i3lock** wrapper for Linux that provides a fast, customizable lock screen by pre caching images with effects (blur, dim, pixelate).

Official link to **betterlockscreen**: https://github.com/betterlockscreen/betterlockscreen

### Step 1. Install

You have a few different ways to grab the package. Using the AUR (Recommended). You can use either yay or paru:

- Using yay

```bash
yay -S betterlockscreen
```

- Using paru

```bash
paru -S betterlockscreen
```

### Step 2. Verification

Once installed, you should verify that it's working by checking the version. This ensures all dependencies are correctly installed.

```bash
betterlockscreen -v
```

## Configuration 

To make betterlockscreen work with your setup, you need to initialize your wallpaper and tell dwm how to trigger it.

### Step 1. Initialize Your Wallpaper Lockscreen

```bash
betterlockscreen -u ~/path/to/your/wallpaper
```

You can now try lockscreen via termial:

```bash
betterlockscreen -l blur
```

> Note: You only need to run this once, or whenever you change your wallpaper.

### Step 2. Adding The Keybinding To DWN

Since I am using dwm, I need to add a shortcut to my **config.h**. I am using the SHCMD macro I already have defined to keep things simple.

```ini 
{ MODKEY|ControlMask|ShiftMask, XK_l,                      spawn,          SHCMD("betterlockscreen -l blur")}
```

After saving, it need to be recompile:

```bash
sudo make clean install
```

> The steps above are specifically for dwm. If you are using a different window manager like i3, bspwm, or Hyprland, the way you bind keys will be different (e.g., editing ~/.config/i3/config or hyprland.conf). Please check the official documentation for your specific WM to see how to execute a spawn command.

### Step 3. Integration With Rofi Powermenu

If you are using a Rofi powermenu script (from adi1090x), make sure the "lock" case is calling the command correctly. Search for the lock section in your script and update it:

```ini
# Inside your powermenu.sh
"${lock}")
    betterlockscreen -l blur
    ;;
```

> if you are using a different Rofi powermenu script, the variable names or the location of the script might vary. Always check the official documentation or the specific config files for your environment to ensure the spawn commands and file paths are correct.


## Conclusion

That’s it! You now have a functional, high performance lock screen with a beautiful blur effect on your CachyOS system.  

By combining betterlockscreen with dwm and Rofi, I maintain a minimalist workflow without sacrificing aesthetics.

**Happy Ricing!**