---
title: "My HeSuVi Configuration on Linux With JamesDSP"
url: /my_hesuvi_configuration_on_linux_with_jamesdsp
date: 2026-03-10T20:35:49+01:00
lastmod: 2026-03-10T20:35:49+01:00
draft: false
license: ""

tags: [arch, audio, surround]
categories: [Linux]
description: "In this article I will show how to setup HeSuVi (Virtual 7.1 Surround Sound) in Linux using JamesDSP..."

featuredImagePreview: "/images/2026/my_hesuvi_configuration_on_linux_with_jamesdsp/my_hesuvi_configuration_on_linux_with_jamesdsp.png"


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

In this guide I will show how to setup HeSuVi (Virtual 7.1 Surround Sound) in Linux using **JamesDSP**. On Linux, we can achieve the same or better results using **JamesDSP**, a powerful, low latency audio processing engine.

For this setup to work, **PipeWire** is necessary. It is a modern audio engine, allowing us to create "virtual sinks" and route complex 7.1 audio streams between your application and JamesDSP. If you are still using legacy PulseAudio, you will need to migrate to PipeWire first.

## Getting Started

Run this command to install PipeWire if you don't already have it:

```bash
yay -S pipewire pipewire-audio pipewire-pulse pipewire-alsa pipewire-jack lib32-pipewire lib32-pipewire-jack
```

To verify that your audio engine is set up correctly, run next command:

```bash
pactl info | grep "Server Name"
```

### Step 1. Install JamesDSP

Open your terminal and run:

```bash
flatpak install flathub me.timschneeberger.jdsp4linux
```

> Note: I prefer the Flatpak version, but it can be installed with the package manager too. `sudo pacman -S jamesdsp`

### Step 2. Download HeSuVi HRIRs and AutoEQ presets

Download HRIRs:

* Download from database

    1. Check HRTF Database  
    https://airtable.com/appayGNkn3nSuXkaz/shruimhjdSakUPg2m/tbloLjoZKWJDnLtTc  
    2. Choose your favourite sound profile and download `.wav`
    3. Move it to a permanent location, like `~/.config/jamesdsp/hrir/`

* Download from **SourceForge**

    1. Download the HeSuVi ZIP from https://sourceforge.net/projects/hesuvi/
    2. Extract the ZIP and look for the hrir folder
    3. Choose your favourite sound profile `.wav`
    3. Move it to a permanent location, like `~/.config/jamesdsp/hrir/`

> For flatpak version `~/.var/app/me.timschneeberger.jdsp4linux/config/jamesdsp/irs/`

Download AutoEQ

1. Go to AutoEq App https://autoeq.app/
2. Select your prefered headphones
3. Select equalizer app, I am suggesting to use `EqualizerAPO GraphicEq`
4. Download preset and move it to a permanent location, it can be the same location as the HRIR `~/.config/jamesdsp/hrir/`

My setup: 

HRIR: `ooyh0.wav`  
AutoEq: `Sennheiser HD 600 GraphicEq.txt`

### Step 3. Configure JamesDSP

* Activate HRIR

    1. Open JamesDSP
    2. Go to the Convolver tab
    3. Enable the Convolver and select tree dots `...`
    4. Navigate to the .wav (HRIR) file you saved earlier

* Activate AutoEQ

    1. Open JamesDSP
    2. Go to the Graphic EQ
    3. Enable the Graphic EQ and select the 'Import' icon located in the bottom right
    4. Navigate to the .txt (AutoEQ) file you saved earlier


## Usage


### Start Using JamesDSP

I suggest installing `pavucontrol` and `helvum` if you don't already have them.

```bash
yay -S pavucontrol helvum
```

Open `pavucontrol` and check `playback` device.  

{{< image src="JamesDSP Playback" src_s="/images/2026/my_hesuvi_configuration_on_linux_with_jamesdsp/jamesdsp_playback.png" src_l="/images/2026/my_hesuvi_configuration_on_linux_with_jamesdsp/jamesdsp_playback.png" width="100%">}}

{{< image src="JamesDSP Output Devices" src_s="/images/2026/my_hesuvi_configuration_on_linux_with_jamesdsp/jamesdsp_output.png" src_l="/images/2026/my_hesuvi_configuration_on_linux_with_jamesdsp/jamesdsp_output.png" width="100%">}}

Open terminal and run `helvum` and check your audio map, it allows creating and removing connections between applications and/or devices to reroute flow of audio, video and MIDI data to where it is needed.

{{< image src="Helvum" src_s="/images/2026/my_hesuvi_configuration_on_linux_with_jamesdsp/helvum.png" src_l="/images/2026/my_hesuvi_configuration_on_linux_with_jamesdsp/helvum.png" width="100%">}}

> Virtual 8-Channel Sink is not necessary, JamesDSP can apply HeSuVi virtualization directly to your standard stereo output.

### Visualizing the Channels (Optional Step)

For those who want to see a dedicated 7.1 device in their system volume mixer, you can manually create a "Null Sink." This acts as a bridge that tells your applications you have 8 speakers available.

**You can run these commands in your terminal to set it up:**

```bash
pactl load-module module-null-sink \
    sink_name=Surround_Master \
    sink_properties='device.description="Surround_Master_7.1"' \
    channels=8 \
    rate=48000 \
    channel_map=front-left,front-right,front-center,lfe,rear-left,rear-right,side-left,side-right

pactl load-module module-loopback \
    source_dont_move=true \
    sink_dont_move=true \
    source_output_properties="media.name='7.1_to_JamesDSP_Bridge'" \
    sink_input_properties="media.name='7.1_to_JamesDSP_Bridge'" \
    source=Surround_Master.monitor
```

**Making the 7.1 Sink Permanent:**

1. Create the config directory

```bash
mkdir -p ~/.config/pipewire/pipewire.conf.d/
```

2. Create the HeSuVi configuration file

```bash
nano ~/.config/pipewire/pipewire.conf.d/99-hesuvi.conf
```

3. Paste the following block

```bash
context.modules = [
    # Create the 7.1 Virtual Sink
    { name = libpipewire-module-loopback
      args = {
        node.description = "Surround_Master_7.1"
        node.name = "Surround_Master"
        media.class = Audio/Sink
        audio.position = [ FL FR FC LFE RL RR SL SR ]
      }
    }

    # Create the Bridge (Loopback) to your physical output
    { name = libpipewire-module-loopback
      args = {
        node.description = "7.1_to_JamesDSP_Bridge"
        node.name = "hesuvi_bridge"
        capture.props = {
            node.target = "Surround_Master"
            stream.dont-remix = true
            node.passive = true
        }
        playback.props = {
            node.passive = true
            media.role = "Multimedia"
        }
      }
    }
]
```

4. Restart PipeWire to apply

```bash
systemctl --user restart pipewire
```

**The Switching Workflow**

Once permanent, you can easily toggle between **Clean Stereo** and **HeSuVi Surround** by simply changing your **Output Device** in `pavucontrol`.

**Why this is usually NOT necessary**

* *While the commands above will "visually" show 8 channels in your audio settings, it is important to understand that this does not change the final sound quality.*

* *Whether you use this complex 8-channel bridge or just let JamesDSP process your standard 2-channel stereo output, the HeSuVi effect remains the same. * The Magic is in the HRIR: The spatial depth comes from the Impulse Response (.wav) file you loaded in JamesDSP, not from the number of virtual "cables" you create in PipeWire.*


## Conclusion

The beauty of using JamesDSP on Linux is the modularity, you can swap HRIR profiles on the fly to find the one that fits your ears best.