---
title: "My Hesuvi Configuration on Linux"
url: /my-hesuvi-configuration-on-linux
date: 2023-09-17T19:28:33+02:00
lastmod: 2023-09-17T19:28:33+02:00
draft: false
license: ""

tags: [ubuntu, fedora, arch]
categories: [Linux]
description: "In this guide I will show how to setup Hesuvi (Virtual 7.1 Surround Sound) in Linux using PipeWire."

featuredImagePreview: "/images/2023/my_hesuvi_configuration_on_linux/my_hesuvi_configuration_on_linux.png"


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

---

In this guide I will show how to setup Hesuvi (Virtual 7.1 Surround Sound) in Linux using PipeWire. 

---

## Check your audio driver

Firstly, we need to check if we already running PipeWire as our audio driver. To do that we need to run next command:

```bash
pactl info | grep "Server Name"
```

If you already running PipeWire, then jump over installation process.

## Ubuntu

* Add the PipeWire PPA

```bash
sudo add-apt-repository ppa:pipewire-debian/pipewire-upstream
```
* Install the PipeWire

```bash
sudo apt update
sudo apt install pipewire pipewire-audio-client-libraries
```

* It is also recommended that you install some additional libraries if you are using Bluetooth, GStreamer, or JACK

```bash
sudo apt install gstreamer1.0-pipewire libpipewire-0.3-{0,dev,modules} libspa-0.2-{bluetooth,dev,jack,modules} pipewire{,-{audio-client-libraries,pulse,media-session,bin,locales,tests}}
```

* Run the following command to reload the daemon in systemd, disable PulseAudio and enable PipeWire

```bash
systemctl --user daemon-reload
systemctl --user --now disable pulseaudio.service pulseaudio.socket
systemctl --user --now stop pulseaudio.service pulseaudio.socket
systemctl --user --now enable pipewire.service pipewire-pulse.service
systemctl --user --now start pipewire.service pipewire-pulse.service
```

## Arch

* Install the PipeWire

```bash
sudo pacman -S pipewire
```

* It is also recommended that you install some additional libraries if you are using Bluetooth, GStreamer, or JACK, ALSA

```bash
sudo pacman -S pipewire-alsa pipewire-pulse wireplumber
```

* Run the following command to reload the daemon in systemd, disable PulseAudio and enable PipeWire

```bash
systemctl --user daemon-reload
systemctl --user --now disable pulseaudio.service pulseaudio.socket
systemctl --user --now stop pulseaudio.service pulseaudio.socket
systemctl --user --now enable pipewire.service pipewire-pulse.service wireplumber
systemctl --user --now start pipewire.service pipewire-pulse.service wireplumber
```

## Virtual surround sound configuration

* In **$HOME/.config/** make pipewire directory
* Copy **pipewire.conf** from **/usr/share/pipewire/** to **.config/**
* Check HRTF Database  
https://airtable.com/appayGNkn3nSuXkaz/shruimhjdSakUPg2m/tbloLjoZKWJDnLtTc  
Choose your desire sound profile and download **.wav** in **.config/**
* Check pipewire configuration  
https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Filter-Chain#draining


### My configuration:
https://github.com/vukilis/UltimateSetup/tree/main/dotfiles/.config/pipewire
