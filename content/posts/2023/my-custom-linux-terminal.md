---
title: "My Custom Linux Terminal"
url: /my-custom-linux-terminal
date: 2023-06-26T01:57:12+02:00
lastmod: 2023-06-26T01:57:12+02:00
draft: false
license: ""

tags: [terminal, customization, zsh]
categories: [Linux]
description: "In this article, I will show my 3 favourite terminal with implementation of ZSH shell..."

featuredImagePreview: "/images/2023/my_custom_linux_terminal/my_custom_linux_terminal.png"


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
    HackerNews: false
    Reddit: true
    VK: true
    Line: false
    Weibo: false
---
<!--more-->

---

In this article, I will show my 3 favourite terminal with implementation of ZSH shell.

---

## ZSH Shell

**ZSH** is an amazing shell that just makes everything a bit easier from auto suggestions, autojump and completing tasks you do regularly considerably faster.

- Theme I'm using for ZSH is Powerlevel10k.

## Terminal

[**Kitty**](https://sw.kovidgoyal.net/kitty/) is very fast and configurable, uses threaded rendering for absolutely minimal latency and designed for power keyboard users.

- Main config file is **kitty.conf**

[**Alacritty**](https://alacritty.org/) is a modern terminal emulator that comes with sensible defaults, but allows for extensive configuration and manages to provide a flexible set of features with high performance.

- Main config file is **lacritty.toml**

[**Terminator**](https://gnome-terminator.org/) has become The Robot Future of Terminals. Gnome based terminal, It has multi window support and great tiling function. Definitely one of the best to ssh into different remote machines.

- Main config file is **terminator.conf**

## Requirements

If you are **Arch** user you need to install **AUR** package manager

```bash
git clone "https://aur.archlinux.org/yay.git"
cd yay
makepkg -si --noconfirm
yay -Sy
```

## How To Install

I built a script to install and customize terminal. Script only support distributions based on Debian and Arch.
Check the script [here](https://github.com/vukilis/terminal_zsh_script) on my github.

```bash
git clone git@github.com:vukilis/terminal_zsh_script.git
cd terminal-zsh-script
./terminal-setup.sh
```

![Script](https://raw.githubusercontent.com/vukilis/terminal_zsh_script/main/script.png)