---
title: "How to Find Last Modified Files Recursively"
url: /how-to-find-latest-modified-files-recursively
date: 2023-11-06T22:55:36+01:00
lastmod: 2023-11-06T22:55:36+01:00
draft: false
license: ""

tags: [bash, scripts]
categories: [Linux]
description: "In this post I will show a bash script which show how to find most recent modified files recursively..."

featuredImagePreview: "/images/2023/how_to_find_latest_modified_files_recursively/how_to_find_latest_modified_files_recursively.png"


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

In this post I will show a bash script which show how to find most recent modified files recursively in Linux using **find** command.

---

## Script

last_modified_files.sh

```txt
echo -ne "\n"
echo -ne "date created  | time modified  | file name
------------------------------------------\n"
find . -mindepth 1 -printf '%T@\t%P\n'|  tail -n 10 |\
        sort -nr -k1|\
        awk -F\\t '
          {
            topdir=$2;
            gsub(/\/.*/, "", topdir);
            if (topdir=="") { topdir="." };
            if (!seen[topdir]) { 
              seen[topdir]=1;
              print strftime("%Y.%m.%d    | %Hh:%Mm",$1) "        | " $2;
            }
          }'
```

## Example

```bash
chmod +x last_modified_files.sh
./last_modified_files.sh
```

{{< image src="Font" src_s="/images/2023/how_to_find_latest_modified_files_recursively/last_modified_files.png" src_l="/images/2023/how_to_find_latest_modified_files_recursively/last_modified_files.png" width="100%">}}