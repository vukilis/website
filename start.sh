#!/bin/bash

ip=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | fzf --prompt="Select IP: ")
hugo server --noHTTPCache --disableFastRender --bind "$ip" --baseURL "http://$ip"