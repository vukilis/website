---
title: "Deploy Docker With Ansible on Ubuntu"
url: /deploy-docker-with-ansible-on-ubuntu
date: 2023-07-22T18:19:15+02:00
lastmod: 2023-07-22T18:19:15+02:00
draft: false
license: ""

tags: [ubuntu, ansible]
categories: [Linux]
description: "In this guide I want to show how to install and deploy docker container..."

featuredImagePreview: "/images/2023/deploy_docker_with_ansible_on_ubuntu/deploy_docker_with_ansible_on_ubuntu.png"


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

In this guide I want to show how to install and deploy docker container on remote Ubuntu machine using Ansible tool. 

---

## Install Ansible

* First you need to install ansible. We will use **pip** to install ansible, so you can use virtual environment and choose specific version.

* In this example you will install latest version and use global environment.

```bash
pip install ansible
export PATH=$PATH:~/.local/bin
```

* After you install ansible and set **env** you can check version.

```bash
ansible --version
```

## Setup your project 

* First you want to make a directory for your project.
* The default Ansible **configuration** file is located under **/etc/ansible/ansible.cfg** and the default **inventory** file is found inside **/etc/ansible/hosts**. You need to change that and point to your configuration files.

```bash
mkdir ansible-project && cd ansible-project
echo "[defaults]
#inventory      = /etc/ansible/hosts
inventory       = hosts" > ansible.cfg
```

**ansible.cfg**

```ini
[defaults]
#inventory      = /etc/ansible/hosts
inventory       = hosts
```

## Preparing your Playbook

* Now let's make your playbook file.
* In this file, you are going to define all tasks, make sure that file is in a format that follows the YAML standards.

**playbook.yml**

```yaml
---
- hosts: '{{ hosts }}'
  become: true

  tasks:
    - name: package update
      ansible.builtin.package:
        update_cache: true

    - name: Install required system packages
      ansible.builtin.package:
        name:
          - apt-transport-https
          - ca-certificates
          - curl
          - gnupg
          - software-properties-common
          - python3-pip
          - virtualenv
          - python3-setuptools
        state: latest
        update_cache: true

    - name: Add Docker GPG apt Key
      apt_key:
        url: https://download.docker.com/linux/ubuntu/gpg
        state: present

    - name: Add Docker Repository
      apt_repository:
        repo: deb https://download.docker.com/linux/ubuntu bionic stable
        state: present

    - name: Update apt and install docker-ce
      ansible.builtin.package:
        name: 
          - docker-ce
        state: latest
        update_cache: true

    - name: Install Docker Module for Python
      pip:
        name: 
          - docker
          - docker-compose

    - name: Install docker-compose Module for Python
      shell: |
        docker_compose_ver_check=$(git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oE "(v?)[0-9]+\.[0-9][0-9]+\.[0-9]+$" | sort --version-sort | tail -n 1) 
        echo $docker_compose_ver_check is latest version; curl -SL https://github.com/docker/compose/releases/download/$docker_compose_ver_check/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose 
        chmod +x /usr/local/bin/docker-compose 
        echo $docker_compose_ver_check is installed
      
    - name: test
      shell: check=$(docker-compose --version) && echo $check
      register: check
    - name: Print uptime of managed node
      debug:
        msg: "{{ check }}"

    # Create Portainer Volume
    # --
    # 
    - name: Create new Volume
      community.docker.docker_volume:
        name: portainer-data
    
    # Deploy Portainer
    # --
    #   
    - name: Deploy Portainer
      community.docker.docker_container:
        name: portainer
        image: portainer/portainer-ce:latest
        ports:
          - "9000:9000"
        volumes:
          - /var/run/docker.sock:/var/run/docker.sock
          - portainer-data:/data
        restart_policy: always
```

## Preparing your Hosts

* Now you need to setup hosts file.
* Host files are those files that are used for storing information about remote nodes information.

**hosts**

```ini
[docker]
192.168.0.193 ansible_ssh_pass=ubuntu ansible_ssh_user=ubuntu

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

* In above example we will access to remote machine with **192.168.0.193** ip address via ssh with **ubuntu** password and username.

## Execute The Ansible Playbook 

* Now, execute the playbook you created previously.

```bash
ansible-playbook playbook.yml -e 'hosts=docker'
```

## Check configuration on my github

https://github.com/vukilis/configurations/tree/main/ansible

```bash
git clone https://github.com/vukilis/configurations.git
cd configurations/ansible
ansible-playbook -i config/hosts docker/ansible_ubuntu_docker.yml -e 'hosts=docker'
```