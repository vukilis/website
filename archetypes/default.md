---
title: "{{ replace .Name "-" " " | title | humanize | strings.Title }}"
url: /{{ .Name }}
date: {{ .Date }}
lastmod: {{ .Date }}
draft: false
license: ""

tags: [ubuntu]
categories: [Linux, Windows, Networking, Virtualization, Hacking]
description: ""

featuredImagePreview: "/images{{ replace .File.Dir "posts" ""}}{{ replace .Name "-" "_" }}/{{ replace .Name "-" "_" }}.png"


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