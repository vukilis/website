---
title: "Scan Your Network With Nmap"
url: /scan-your-network-with-nmap
date: 2023-07-12T19:32:29+02:00
lastmod: 2023-07-12T19:32:29+02:00
draft: false
license: ""

tags: [ubuntu]
categories: [Linux, Windows, Networking]
description: ""

featuredImagePreview: "/images/2023/scan_your_network_with_nmap/scan_your_network_with_nmap.png"


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




* ping scanning
    > nmap -sP 192.168.0.1/24
* Port Scanning
    > nmap -p 1-999 192.168.0.1/24
    > nmap -sX 192.168.0.1/24
    > nmap -sT 192.168.0.1/24
    > nmap -sS 192.168.0.1/24
* OS Scanning
    > nmap -O 192.168.0.1/24
    > nmap -A 192.168.0.1/24
* Scripts 
    > nmap --script vuln 192.168.0.1/24