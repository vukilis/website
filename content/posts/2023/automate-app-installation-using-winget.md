---
title: "Automate App Installation Using Winget"
url: /automate-app-installation-using-winget
date: 2023-07-16T14:25:21+02:00
lastmod: 2023-07-16T14:25:21+02:00
draft: false
license: ""

tags: [winget, automation]
categories: [Windows]
description: "I will show my simple script which automate install..."

featuredImagePreview: "/images/2023/automate_app_installation_using_winget/automate_app_installation_using_winget.png"


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

I will show my simple script which automate install multiple windows apps using winget.

---

## How To Start

* Download script from github https://github.com/vukilis/Windows10AppScript  
or  
run following command in terminal (**terminal must be run as Admin**):
```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://git.io/JDBpN'))
```

## Prepare App List

* You have to create json file with your packages.

* If you downloaded script from github you will have in directory example file **"package.json"**.  

* In this file provide name of your apps.

{{< image src="Font" src_s="/images/2023/automate_app_installation_using_winget/packages.png" src_l="/images/2023/automate_app_installation_using_winget/packages.png" width="70%">}}

* App name can be found with next command (example):
```powershell
winget search sumatra
```
{{< image src="Font" src_s="/images/2023/automate_app_installation_using_winget/search.png" src_l="/images/2023/automate_app_installation_using_winget/search.png" width="100%">}}

## Install

* When you run the script enter your json file. Location can be **local (absolute path)** or **url**.  
* Proceed the installation.

{{< image src="Font" src_s="/images/2023/automate_app_installation_using_winget/install.png" src_l="/images/2023/automate_app_installation_using_winget/install.png" width="100%">}}