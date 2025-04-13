---
title: "Hugo Static Site Guide"
url: /hugo_static_site_guide
date: 2024-07-10T18:59:13+02:00
lastmod: 2024-07-10T18:59:13+02:00
draft: false
license: ""

tags: [linux, homelab, website]
categories: [Linux, Homelab, Website]
description: "In this guide I want to show how I setup my website..."

featuredImagePreview: "/images/2024/hugo_static_site_guide/hugo_static_site_guide.png"


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

In this guide I want to show how I setup my website using Hugo static site generator. As a fan of Markdown language Hugo is a perfect solution for my needs.  
Bellow I will show steps how I setup my website to work.

## Setup My Linux Distribution

I'm using Arch distribution, link to download: https://archlinux.org/download/

After download and run .iso file we can use **archinstall** script provide by Arch for easly installation of process.  
Run next command and follow the procedute to finish installation:

```bash
archinstall
```

---

After installation is finished reboot PC and ready to setup Arch for basic usage.  
I'm using my script to do that.

First, I like to use script from Chris Titus Tech **linxutil** to install some basic packages:

```bash
curl -fsSL https://christitus.com/linux | sh
```

---

After that I'm using my **dotfiles** to setup configs for packages, and copy all to **~/.confing/** location.  
My **dotfiles** https://github.com/vukilis/vukilis-dotfiles

```bash
cd Desktop
git@github.com:vukilis/vukilis-dotfiles.git
cp -r vukilis-dotfiles/* ~/.config/
```

---

When all packages that I need have their configuration, I will proceed with installation of shell and terminal that I'm using:  
Depend what shell you are using, if you are already on zsh run **terminal-setup-zsh.sh**. After installation run kitty.  
My **terminal_zsh_script** https://github.com/vukilis/terminal_zsh_script

```bash
cd Desktop
git@github.com:vukilis/terminal_zsh_script.git
sudo ./terminal-setup.sh
```

---

Because I'm using some custom command alias I will install required packages.
I'm using my **ArchSetup** project for that.  
My **ArchSetup** https://github.com/vukilis/ArchSetup

```bash
cd Desktop
git@github.com:vukilis/ArchSetup.git
sudo ./setup.bash
```

---

After all of this my Arch distribution is ready for making Hugo website.

## Using Nix Package Manager

Nix package manager is amazing and very easy to use.  
We are going to use Nix for install Hugo.

> Note: I’d recommend multi-user install if it prompts for it.

```bash
curl -L https://nixos.org/nix/install | sh
```

---

### Usage

Here is the basic usage of nix, most revolve around the nix-env command. These are manually managed and require user intervention.

* List Installed packages `nix-env -q`
* Install Packages `nix-env -iA nixpkgs.packagename`
* Erase Packages `nix-env -e packagename`
* Update All Packages `nix-env -u`
* Update Specific Packages `nix-env -u packagename`
* Hold Specific Package `nix-env --set-flag keep true packagename`
* List Backups (Generations) `nix-env --list-generations`
* Rollback to Last Backup `nix-env --rollback`
* Rollback to Specific Generation `nix-env --switch-generation #`  

### Troubleshooting

Programs not showing up in start menu.

NIX stores all the .desktop files for the programs it installs `@ /home/$USER/.nix-profile/share/applications/` and a simple symlink will fix them not showing up in your start menu:

```bash
ln -s /home/$USER/.nix-profile/share/applications/* /home/$USER/.local/share/applications/
```

## Install Hugo

We are using https://lazamar.co.uk/ to find all versions of a package that were available in a channel and the revision.

My website is run under 0.115.0 version and I will install that version:

```bash
nix-env -iA hugo -f https://github.com/NixOS/nixpkgs/archive/50a7139fbd1acd4a3d4cfa695e694c529dd26f3a.tar.gz
```

---

After that I will download my website from github https://github.com/vukilis/website

```bash 
cd Desktop
git clone git@github.com:vukilis/website.git
```

Im using **LoveIt** Hugo theme and I will update submodule as well:

```bash
cd website/themes/LoveIt
git submodule update --init --recursive
```

---

My website is ready and now I can continue my work on it.

To run Hugo local in **dev environment** we can use next command:

```bash
hugo server --noHTTPCache --disableFastRender --bind "IP server" --baseURL "IP server"
```

## Conclusion

This is already builded website, you can just follow installation and after that use official documentation of **Hugo** **https://gohugo.io/documentation/**.

Choose you own theme and of course you can use latest version of **Hugo**.

That's it for now!
