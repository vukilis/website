---
title: "Windows 10/11 Optimizer & Debloater"
url: /Windows_11_Optimizer_Debloater
date: 2024-05-07T23:54:16+02:00
lastmod: 2025-08-07T19:38:00+02:00
draft: false
license: ""

tags: [windows, automation, scripts, winget, debloat]
categories: [Windows]
description: "This Utility show basic system information, install programs, debloat and optimize Windows..."

featuredImagePreview: "/images/2024/Windows_11_Optimizer_Debloater/Windows_11_Optimizer_Debloater.png"


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

![GitHub Release](https://img.shields.io/github/v/release/vukilis/Windows11-Optimizer-Debloater?style=flat&logo=futurelearn&logoColor=%2332a850&label=LATEST%20RELEASE&color=%2332a850)
[![changelog](https://img.shields.io/badge/📋-RELEASE%20NOTES-00B2EE.svg)](https://github.com/vukilis/Windows11-Optimizer-Debloater/blob/dev/CHANGELOG.md) 
[![Total number of downloads](https://img.shields.io/github/downloads/vukilis/Windows11-Optimizer-Debloater/total?style=flat&label=TOTAL%20DOWNLOADS&labelColor=444&logo=hack-the-box&logoColor=white&cacheSeconds=600)](https://github.com/ungive/discord-music-presence/releases)
[![Number of downloads of the latest version](https://img.shields.io/github/downloads/vukilis/Windows11-Optimizer-Debloater/latest/total?style=flat&label=Downloads%20%40latest&labelColor=444&logo=hack-the-box&logoColor=white&cacheSeconds=600)](https://github.com/ungive/discord-music-presence/releases/latest)
[![Number of GitHub stars](https://img.shields.io/github/stars/vukilis/Windows11-Optimizer-Debloater?style=flat&label=STARS&logo=github&labelColor=444&color=DAAA3F&cacheSeconds=3600)](https://star-history.com/#ungive/discord-music-presence&Date)
[![Buy me a beer](https://img.shields.io/badge/BUY%20ME%20A%20BEER-black?style=flat&logo=buymeacoffee&logoColor=black&color=FFDD00)](https://buymeacoffee.com/vukilis)
[![ko-fi](https://shields.io/badge/KO--FI-BEER-ff5f5f?logo=ko-fi&style=for-the-badgeKo-fi)](https://ko-fi.com/vukilis)

For a long time I wanted to create a script that would automate various settings after a new Windows installation. Following the channel @ChrisTitusTech who made a very good utillity I got the inspiration to make my own utillity with my personal settings. Over time it evolved into a much bigger utillity that is useful for other people. I recommend that this script be used after a fresh installation of Windows and occasionally used for optimization.


## One Command - Download and Usage

Requires you to launch PowerShell or Windows Terminal As **ADMINISTRATOR!**

Launch Command:

```powershell
iwr -useb vukilis.com/win11deb | iex
```

If you are having TLS 1.2 Issues or You cannot find or resolve `vukilis.com/win11deb` then run with the following command:

```powershell
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;iex(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/vukilis/Windows11-Optimizer-Debloater/main/win11deb.ps1')
```

## Parts of Utility

This utility show basic system information, install programs, debloat and optimize Windows with tweaks, troubleshoot with config, and fix Windows updates.

It has 7 main tabs:

* **INFO** - Show basic system information about OS and hardware.

{{< image src="info" src_s="/images/2024/Windows_11_Optimizer_Debloater/info.png" src_l="/images/2024/Windows_11_Optimizer_Debloater/info.png" width="100%">}}

* I**NSTALL** - Install/Uninstall/Upgrade winget, chocolatey and python packages

{{< image src="install" src_s="/images/2024/Windows_11_Optimizer_Debloater/install.png" src_l="/images/2024/Windows_11_Optimizer_Debloater/install.png" width="100%">}}

* **DEBLOAT** - Removes all necessary pre-installed apps comes with Windows

{{< image src="debloat" src_s="/images/2024/Windows_11_Optimizer_Debloater/debloat.png" src_l="/images/2024/Windows_11_Optimizer_Debloater/debloat.png" width="100%">}}

* **OPTIMIZATION** - Disable Telemetry, optimizes Windows and reduces running processes. 

{{< image src="optimization" src_s="/images/2024/Windows_11_Optimizer_Debloater/optimization.png" src_l="/images/2024/Windows_11_Optimizer_Debloater/optimization.png" width="100%">}}

* **SERVICES** - Shows services status and cut down on running background services.

{{< image src="services" src_s="/images/2024/Windows_11_Optimizer_Debloater/services.png" src_l="/images/2024/Windows_11_Optimizer_Debloater/services.png" width="100%">}}

* **UPDATES** - Change Windows Update to only use Security Updates, Pause Updates for 5 weeks or Disable them altogether. Also, Fix Updates if you have problem and back to Default Settings.

{{< image src="updates" src_s="/images/2024/Windows_11_Optimizer_Debloater/updates.png" src_l="/images/2024/Windows_11_Optimizer_Debloater/updates.png" width="100%">}}

* **CONFIG** - Configure your system and launch legacy Win7 Control Panels.

{{< image src="config" src_s="/images/2024/Windows_11_Optimizer_Debloater/config.png" src_l="/images/2024/Windows_11_Optimizer_Debloater/config.png" width="100%">}}

## Conclusion

Check *Windows11-Optimizer-Debloater* script on github:  
https://github.com/vukilis/Windows11-Optimizer-Debloater

If you encounter any challenges or problems with the script, submit them via the **"Issues"** tab on the GitHub repository. By filling out the provided template, you can provide specific details about the issue.

To contribute new code, please ensure that it is submitted to the **DEV BRANCH**. Please note that merges will not be performed directly on the MAIN branch.

When creating pull requests, it is essential to thoroughly **document** all changes made. Any code lacking sufficient documentation may also be denied.