---
title: "Changing UUID for VirtualBox VMs"
date: 2023-06-21T01:48:51+02:00
lastmod: 2023-06-21T01:48:51+02:00
draft: false
license: ""

tags: [virtualization, linux, windows]
categories: [Virtualization]
description: "The Problem When I want to copy existing VMs to create a new project / VM, my new created VM have..."

featuredImagePreview: "/images/2023/vbox_uuid/vbox_uuid.png"


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

## The Problem

---

When I want to copy existing VMs to create a new project / VM, my new created VM have the same UUID.   
So, if I try to open newly copied VM, error message apear where says that I can't run VM because already existing one with same UUID.   

---

## The Solution

1. Open Terminal and navigate to folder where you have installed Oracle Virtual Box. 

2. Run next command twice to generate an UUID:

```shell
$ VBoxManage internalcommands sethduuid "VDI/VMDK file location"
```

3. Open the **.vbox** file in a text editor

4. Replace the **UUID** found in **Machine uuid="{...}"** with **first** generated UUID

5. replace the **UUID** found in **HardDisk uuid="{...}"** and in **Image uuid="{}"** *(located at the end of the file)* with **second** generated UUID