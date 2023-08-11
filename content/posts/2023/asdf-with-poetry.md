---
title: "Asdf With Poetry"
url: /asdf-with-poetry
date: 2023-08-08T19:56:02+02:00
lastmod: 2023-08-08T19:56:02+02:00
draft: false
license: ""

tags: [ubuntu, asdf, poetry, python]
categories: [Linux]
description: "In this guide I will show how to setup asdf tool with python poetry..."

featuredImagePreview: "/images/2023/asdf_with_poetry/asdf_with_poetry.png"


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

In this guide I will show how to setup asdf tool with python poetry. ASDF is a tool version manager and very useful tool for many other language and tools like go, node, terraform, docker...

---

## Install prerequirements

* First we need install dependencies. This dependencies are important to prevent installation failed when we install our language or tool version.

```bash
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl \
git
```

## Install asdf

* We want to download from official repository.

```bash
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0
```

* After we download we need to install/configure.
* Configure depends what the shell you are using, I will show for bash and zsh. 

**BASH**

```bash
echo '# asdf #' >> ~/.zshrc
echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
source ~/.bashrc
```

**ZSH**

```bash
echo '# asdf #' >> ~/.zshrc
echo '. $HOME/.asdf/asdf.sh' >> ~/.zshrc
echo 'fpath=(${ASDF_DIR}/completions $fpath)' >> ~/.zshrc
echo 'autoload -Uz compinit && compinit' >> ~/.zshrc
source ~/.zshrc
```

* Here is my installation script for zsh users whoes using ubuntu and fedora.  
https://github.com/vukilis/asdf-easy

## install python

* First we need to add asdf plugin for python.

```bash
asdf plugin add python
```

* After we added a plugin we can now install python version we want.

```bash
asdf install python 3.10.8
```

* If you want check all available version you can do with next command:

```bash
asdf list all python
```

* Our python version is now installed, with **asdf list** command we can list installed plugins and versions.

* Now we need to set our python version to global or local einvorment.

**GLOBAL**

Global defaults are managed in **$HOME/.tool-versions**. Set a global version with:

```bash
asdf global python 3.10.8
```

**LOCAL**

Local versions are defined in the **$PWD/.tool-versions** file (your current working directory). Usually, this will be the Git repository for a project. When in your desired directory execute:

```bash
asdf local python 3.10.8
```

## Install poetry

To install poetry run next command:

```bash
curl -sSL https://install.python-poetry.org | python3 -
```

* Add Poetry to your PATH 

**BASH**
```bash
echo 'export PATH="/home/linuxmint/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```
**ZSH**
```bash
echo 'export PATH="/home/linuxmint/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

* IF you want to create the virtualenv inside the project’s root directory run next command:

```bash
poetry config virtualenvs.in-project true
```

## Activate poetry

* To activate poetry virtualenv execute:

```bash
poetry init
poetry install
```