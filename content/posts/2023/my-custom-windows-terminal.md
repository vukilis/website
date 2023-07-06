---
title: "My Custom Windows Terminal"
url: /my-custom-windows-terminal
date: 2023-07-05T22:29:02+02:00
lastmod: 2023-07-05T22:29:02+02:00
draft: false
license: ""

tags: [terminal, customization]
categories: [Windows]
description: "I will show how I made my windows terminal look better and how made me more productive..."

featuredImagePreview: "/images/2023/my_custom_windows_terminal/my_custom_windows_terminal.png"


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

I will show how I made my windows terminal look better and how made me more productive.

---

## Font Settings

We need one of the [**Nerd Fonts**](https://www.nerdfonts.com/font-downloads), I'm going to use a Meslo. Download and install the font.

Open your Windows Terminal, go to settings and choose "Default" tab from left menu and click "Appearance". You will see "Font face" option and then choose your font you are previously downloaded. Save changes!  

If somehow you don't have installed windows terminal install it via [**Microsoft Store**](https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701) or run next command:
```powershell
winget install -e -i --id=9N0DX20HK701 --source=msstore
```

{{< image src="Cyberpunk" src_s="/images/2023/my_custom_windows_terminal/font_settings.png" src_l="/images/2023/my_custom_windows_terminal/font_settings.png" width="100%">}}

## Install PowerShell

We will using PowerShell app from MS Store as new, better and active develop PowerShell. At this moment as I write this article, version of PowerShell from MS Store is 7.3.5 while default Windows PowerShell is 5.1.

We have two ways to install PowerShell, via MS Store and powershell command.

1. Install PowerShell via MS Store [**here**](https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701)
2. Install PowerShell via terminal with next command:
```powershell  
winget install -e -i --id=9MZ1SNWT0N5D --source=msstore
```

## Install Oh-My-Posh

This amazing tool will give us exactly what we want, **BEAUTIFUL** terminal. We can use many themes included out-of-the-box.
Check [**official site**](https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701) and choose theme you like.

We have two ways to install Oh-My-Posh, via MS Store and powershell command.

1. Install Oh-My-Posh via MS Store [**here**](https://apps.microsoft.com/store/detail/ohmyposh/XP8K0HKJFRXGCK)
2. Install Oh-My-Posh via terminal with next command:
```powershell  
winget install -e -i --id=XP8K0HKJFRXGCK --source=msstore
```

# Final Setup 

My configuration files: https://github.com/vukilis/oh-my-windows-terminal

```powershell
git clone https://github.com/vukilis/oh-my-windows-terminal
```

- Steps:  

    - Copy **powerlevel10k_vuk1lis.omp.json** to ```**oh-my-posh\themes**``` directory  
        > location of ```**oh-my-posh\themes**``` depends how you install app. With next command you can check **env** of oh-my-posh with full path

        ```powershell
        ls env: | Where-Object name -like posh_theme*
        ```

    - Make default Microsoft.PowerShell_profile.ps1 script with next command:

        ```powershell
        New-Item -Path $PROFILE -Type File -Force
        ```

    - Copy my **Microsoft.PowerShell_profile.ps1** to ```**"%user%\Documents\PowerShell"**```

    - Copy my **settings.json** to ```**"%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"**```

    - Now We are installing following powershell modules to make us more productive:
        - PSReadLine
        - Terminal-Icons
        - AllowClobber

        Run next commands to install modules:

        ```powershell
        Install-Module -Name PSReadLine -Force
        Install-Module -Name Terminal-Icons
        Install-Module -Name z -AllowClobber
        ``` 

    - Now we need to active our customised powershell profile with next command:

        ```powershell
        . $PROFILE
        ```

        {{< image src="Cyberpunk" src_s="/images/2023/my_custom_windows_terminal/terminal.png" src_l="/images/2023/my_custom_windows_terminal/terminal.png" width="100%">}}

- If you want to delete history of stored input lines run ```delete_history.ps1``` script

---

Voilà! We have now a better and amazing powershell.