---
title: "Scan Your Network With Nmap"
url: /scan-your-network-with-nmap
date: 2023-07-11T19:32:29+02:00
lastmod: 2023-07-11T19:32:29+02:00
draft: false
license: ""

tags: [nmap, forensics]
categories: [Networking, Hacking]
description: "How to scan and find Network Vulnerabilities with nmap tool. With just one command..."

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

---

How to scan and find Network Vulnerabilities with nmap tool. With just one command found out what Operating System are running, what ports are open and found vulnerabilities that can be exploit. 

---

## Ping Scanning

* **Scan your network to see active IP** 

```bash
nmap -sP 192.168.0.1/24
```

## Port Scanning

* **Scan open ports in specific range**

```bash
nmap -p 1-999 192.168.0.113
```
* **Show what port is open/filtered with Xmas scan**

```bash
nmap -sX 192.168.0.113 -Pn -vv
```

* **Scan ports using tcp connection**

```bash
nmap -sT 192.168.0.113
```

* **Scan ports with stealth mode**

```bash
nmap -sS 192.168.0.113
```

## OS Scanning

* **Detect system, one of the most powerful features of the tool**

```bash
nmap -O 192.168.0.113
```

* **Enable system detection, script scanning, version detection, and traceroute. (Aggressive mode)**

```bash
nmap -A 192.168.0.113
```

## Scripts

* **Run set of scripts distributed with Nmap or write custom scripts**  
https://nmap.org/nsedoc/scripts/

```bash
nmap --script vuln 192.168.0.113
```

## Example

```bash
nmap -Pn -sS -T2 -p- -vvv 192.168.0.113
nmap -Pn -sV -A -p- -vvv 192.168.0.113
nmap -sV -sT -p- --script safe 192.168.0.113
```

* **Cheatsheet**     
{{< image src="Nmap" src_s="/images/2023/scan_your_network_with_nmap/cheatsheet.png" src_l="/images/2023/scan_your_network_with_nmap/cheatsheet.png" width="200">}}