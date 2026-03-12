---
title: "About Vuk1lis"
date: 2023-06-20T02:49:39+02:00
lastmod: 2023-06-20T02:49:39+02:00
draft: false
license: ""
layout: "about"

description: ""

hiddenFromHomePage: true
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
    enable: false
code:
    copy: true
    maxShownLines: 50
math:
    enable: false
share:
    enable: false
---
<!-- more -->

<div style="text-align: center;">
    <img src="/images/logo.png" alt="Vuk1lis Logo" width="150" height="auto">
</div>

<div class="gradient-border left teal" style="font-size: large; margin:50px auto;">
    I love Information Technology, especially playing with Linux and learn about Networking. You can usually find me deep in my homelab, where I spend my time practicing DevOps skills and experimenting with the many open source tools I integrate into my daily life. My ultimate goal is to become an amazing and reliable DevOps Engineer. I am fully dedicated to mastering automation, CI/CD pipelines and infrastructure management. In my free time, I like to play video games, basketball with friends, and write songs.
</div>

<div id="github-readme">Loading my profile...</div>

<script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>

<script>
  const readmeUrl = 'https://raw.githubusercontent.com/vukilis/vukilis/main/README.md';
  const container = document.getElementById('github-readme');

  async function loadProfile() {
    try {
      const response = await fetch(readmeUrl);
      if (!response.ok) throw new Error('Failed to fetch');
      
      let text = await response.text();

      // Simple emoji fix for common GitHub icons
      const emojiMap = {
        ':fire:': '🔥',
        ':rocket:': '🚀',
        ':zap:': '⚡',
        ':desktop_computer:': '🖥️',
        ':gear:': '⚙️',
        ':star:': '⭐'
      };
      
      Object.keys(emojiMap).forEach(key => {
        text = text.replaceAll(key, emojiMap[key]);
      });

      // Render the markdown
      container.innerHTML = marked.parse(text);
    } catch (err) {
      container.innerHTML = '<p style="color:red;">Error: Could not connect to GitHub. Check your internet or the link.</p>';
      console.error(err);
    }
  }

  loadProfile();
</script>