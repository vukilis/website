---
title: "How to Setup Noise Supression Using DeepFilterNet"
url: /how_to_setup_noise_supression_using_deepfilternet
date: 2026-03-19T14:44:43+01:00
lastmod: 2026-03-19T14:44:43+01:00
draft: false
license: ""

tags: [ubuntu, debia, arch, fedora, pipewire, audio]
categories: [Linux]
description: "Background noise is the silent killer of productivity and professional audio..."

featuredImagePreview: "/images/2026/how_to_setup_noise_supression_using_deepfilternet/how_to_setup_noise_supression_using_deepfilternet.png"


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

Background noise is the silent killer of productivity and professional audio. While many tools try to mask these sounds, **DeepFilterNet** uses deep learning to remove them without distorting your voice. In this guide, I will show how to set up this powerful, low-latency framework to achieve studio-quality silence on your existing hardware.

## Getting Started

- **What is the DeepFilterNet** 

A Low Complexity Speech Enhancement Framework for Full-Band Audio (48kHz) using on Deep Filtering.

Check official github: https://github.com/Rikorose/DeepFilterNet

### Step 1: Download DeepFilterNet

I will use the official pre-compiled shared object (.so) file from the GitHub releases page.

- You can download from offical release: https://github.com/Rikorose/DeepFilterNet/releases/tag/v0.5.6

- You can use `wget` to grab the specific release (e.g. 0.5.6):

```bash
wget https://github.com/Rikorose/DeepFilterNet/releases/download/v0.5.6/libdeep_filter_ladspa-0.5.6-x86_64-unknown-linux-gnu.so
```

- To can get always latest release use next command:

```bash
curl -s https://api.github.com/repos/Rikorose/DeepFilterNet/releases/latest \
| grep "browser_download_url.*x86_64-unknown-linux-gnu.so" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -
```

### Step 2: Configure DeepFilterNet

Following official documentation https://github.com/Rikorose/DeepFilterNet/blob/main/ladspa/README.md, we will create two different filter-chain configurations. Depending on your needs, you might want to use one or both.

- Mono Source **(deepfilter-mono-source.conf)**: This is for your Microphone. It creates a virtual input device that strips background noise from your voice before sending it to apps like Discord, Zoom, or OBS.

- Stereo Sink **(deepfilter-stereo-sink.conf)**: This is for your Speakers/Headphones. It is useful when you are listening to someone else who has a noisy background or a bad microphone. It filters the audio they send you before it hits your ears.


Install the Plugin: Ensure `libdeep_filter_ladspa.so` is located at:


Global: `/usr/lib/ladspa/libdeep_filter_ladspa.so`

```bash
sudo mv libdeep_filter_ladspa-0.5.6-x86_64-unknown-linux-gnu.so /usr/lib/ladspa/libdeep_filter_ladspa.so
```

Local: `~/.ladspa/libdeep_filter_ladspa.so`

```bash
mv libdeep_filter_ladspa-0.5.6-x86_64-unknown-linux-gnu.so ~/.ladspa/libdeep_filter_ladspa.so
```

Pipewire configuration: Create these `.conf` files into a `conf.d/` directory:


- **deepfilter-mono-source.conf**

```ini
context.modules = [
    { name = libpipewire-module-filter-chain
        args = {
            node.description = "DeepFilter Noise Canceling Source"
            media.name       = "DeepFilter Noise Canceling Source"
            filter.graph = {
                nodes = [
                    {
                        type   = ladspa
                        name   = "DeepFilter Mono"
                        plugin = /home/vukilis/.ladspa/libdeep_filter_ladspa.so  # Adjust the plugin path
                        label  = deep_filter_mono
                        control = {
                            "Attenuation Limit (dB)" 24
                        }
                    }
                ]
            }
            audio.rate = 48000
            audio.position = [MONO]
            capture.props = {
                node.passive = true
                # Forces a larger buffer to prevent "Processing too slow" underruns
                node.latency = 1024/48000
                # Ensures the filter isn't interrupted by other stream changes
                node.force-quantum = 1024
            }
            playback.props = {
                media.class = Audio/Source
                node.name = "deep_filter_mic"
            }
        }
    }
]
```

- **deepfilter-stereo-sink.conf**

```ini
context.modules = [
    { name = libpipewire-module-filter-chain
        args = {
            node.description = "DeepFilter Noise Canceling Sink"
            media.name       = "DeepFilter Noise Canceling Sink"
            filter.graph = {
                nodes = [
                    {
                        type   = ladspa
                        name   = "DeepFilter Stereo"
                        plugin = /home/vukilis/.ladspa/libdeep_filter_ladspa.so # Adjust the plugin path
                        label  = deep_filter_stereo
                        control = {
                            "Attenuation Limit (dB)" 24
                        }
                    }
                ]
            }
            audio.rate = 48000
            audio.channels = 2
            audio.position = [FL FR]
            capture.props = {
                node.name = "deep_filter_stereo_input"
                media.class = Audio/Sink
                # Forces a larger buffer to prevent "Processing too slow" underruns
                node.latency = 1024/48000
                # Ensures the filter isn't interrupted by other stream changes
                node.force-quantum = 1024
            }
            playback.props = {
                node.name = "deep_filter_stereo_output"
                node.passive = true
            }
        }
    }
]
```

- Global: `/etc/pipewire/filter-chain.conf.d/deepfilter-mono-source.conf`

- Local: `~/.config/pipewire/filter-chain.conf.d/deepfilter-mono-source.conf`

> Note: Choose the location that best fits your workflow. I personally prefer to keep all of my configurations within my home directory for easier management and portability.


You can limit the noise reduction by adjusting the Attenuation Limit (dB) value:

- 6–12 dB: Subtle reduction

- 18–24 dB: Medium reduction

- 100 dB: Maximum (complete) noise suppression

### Step 3: Use DeepFilterNet

Test your filter-chain manually by running:

```bash
pipewire -c filter-chain.conf
```

Open you desire application and choose DeepFilter source. 


## Automate with Systemd (Opcional)

Instead of running the command in a terminal every time, we will create a service file.

- **Create the Service Directory**

First, ensure the local systemd directory exists:

```bash
mkdir -p ~/.config/systemd/user/
```

- **Create the Service File**

Create a new file at `~/.config/systemd/user/deepfilter.service` and paste the following:

```ini
[Unit]
Description=DeepFilterNet PipeWire Filter Chain
After=pipewire.service
BindsTo=pipewire.service

[Service]
Type=simple
ExecStart=/usr/bin/pipewire -c /home/vukilis/.config/pipewire/filter-chain.conf.d/deepfilter-mono-source.conf
Restart=on-failure

[Install]
WantedBy=default.target
```

> Note: Make sure the `ExecStart` path points exactly to where you saved your `.conf` file.


- **Enable and Start the Service**

```bash
systemctl --user daemon-reload
systemctl --user enable --now deepfilter.service
```

You can check the status at any time to make sure there are no errors:

```
systemctl --user status deepfilter.service
```

If the service fails to start, you can check the logs to see if there is a path error or a syntax mistake in your config:

```bash
journalctl --user -u deepfilter.service -f
```

## Conclusion

With **DeepFilterNet** now integrated into my workflow, I have effectively eliminated one of the biggest annoyances in digital audio during online conversations. From here, I can fine-tune my attenuation settings or even explore using it as a plugin for my favorite DAW.