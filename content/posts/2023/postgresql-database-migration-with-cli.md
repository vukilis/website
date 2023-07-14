---
title: "PostgreSQL Database Migration With CLI"
url: /postgresql-database-migration-with-cli
date: 2023-07-14T20:30:58+02:00
lastmod: 2023-07-14T20:30:58+02:00
draft: false
license: ""

tags: [postgresql, sql, cli]
categories: [Database]
description: "In this guide I will show how I migrate my data between..."

featuredImagePreview: "/images/2023/postgresql_database_migration_with_cli/postgresql_database_migration_with_cli.png"


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

In this guide I will show how I migrate my data between different servers and databases using pgAdmin with CLI commands.
This migration can be automated with bash script.

---

>password = my db password  
username = my db username  
host = my db host   
port = postgresql port (by default 5432)

* Bellow I will show an example of how I migrate data from **"my_db_production"** to **"my_db_dev"** and make backup.

## DROP DATABASE 

* First I want to delete my backup **"my_db_dev"** database if exists.

```bash
PGPASSWORD=$password dropdb --host $host --port $port \
--username $username --no-password -e --if-exists my_db_dev
```

## CREATE DATABASE 

* Now I want to create my **"my_db_dev"** database.

```bash
PGPASSWORD=$password createdb --host $host --port $port \
--username $username --no-password --encoding=UTF8 --template=postgres --lc-collate=en_US.UTF-8 \
--lc-ctype=en_US.UTF-8 --owner=postgres -e my_db_dev
```

## DUMP DATABASE 

* After I created my dev database I want to make backup of my **"my_db_production"** database.

```bash
PGPASSWORD=$password pg_dump --host $host --port $port \
--username $username --no-password --verbose --role postgres --format=c --blobs \
my_db_production > /home/example/postgreSQL/my_db_production.sql
```

## RESTORE DATABASE 

* Last step is to migrate my backup of **"my_db_production"** to my created **"my_db_dev"** database.

```bash
PGPASSWORD=$password pg_restore --host $host --port $port \
--username $username --no-password --role postgres --verbose -n public --dbname my_db_dev \
/home/example/postgreSQL/my_db_production.sql
```

## AWS S3 migration 

* Last but not least I want to show how I migrate data between S3 Bucket which database uses.

```bash
aws s3 cp s3://my-production/ s3://my-development/ --recursive
```