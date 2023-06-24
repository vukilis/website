---
title: "First_post"
date: 2023-06-20T00:29:15+02:00
lastmod: 2023-06-20T00:29:15+02:00
draft: false
license: ""

tags: [ubuntu]
categories: [Linux, Windows, Networking]
description: "This is first post for testing purposes..."

featuredImagePreview: "/images/home.jpg"

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
<!--more-->

[Hugo]^(An open-source static site generator)

That is so funny! :(far fa-grin-tears):

## 1. Shadow.BG
<!-- ![Screenshot](https://i.imgur.com/FAC6GCC.png) -->

![Screenshot](/images/home.jpg)

Deployed [backend (Go)](https://github.com/vukilis/shadowbg-backend/tree/79ceaa36b6e2d467096a517f37763a003b988292) and [frontend (Next.js)](https://github.com/vukilis/shadowbg-frontend/tree/75e62fd98c505adfc0286de03e944481b43859c7) with Docker  
Easier search RARBG backup database

###### Prerequisites
- [Docker](https://docs.docker.com/desktop/)

###### Steps to build
You need to [download]() the `rarbg_db.zip` file, unzip it and rename `rarbg_db.sqlite` to `db.sqlite` (Or you can change the `main.go` code to use any other name you want to rename the file to. After that, move `db.sqlite` to shadowbg-backend folder.

````shell
git clone https://github.com/vukilis/shadowbg && cd shadowbg
cp shadowbg-frontend/.env.example shadowbg-frontend/.env
sudo docker-compose -f docker-compose-prod.yml up -d
````
###### Mention
Forked from [xav1erenc](https://github.com/xav1erenc) who wrote app in Go and Next.js