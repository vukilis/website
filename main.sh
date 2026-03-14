#!/bin/bash

# --- Color Palette ---
CLR_GOLD='\e[38;2;229;181;102m'
CLR_PINK='\e[38;2;189;75;132m'
CLR_RED='\e[38;2;224;102;102m'
CLR_GREEN='\e[38;2;106;190;131m'
CLR_BLUE='\e[38;2;97;175;239m'
CLR_CYAN='\033[38;2;0;255;255m'
CLR_DIM='\e[2m'
NC='\e[0m'

# --- UI Components ---
hr() {
    printf "${CLR_DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_header() {
    clear
    # Define the box width
    local width=68

    # Helper function to center text
    center_text() {
        local text="$1"
        local color="$2"
        local text_len=${#text}
        local padding=$(( (width - text_len) / 2 ))
        local rest=$(( width - text_len - padding ))
        
        printf "${CLR_GOLD}┃${NC}"
        printf "%${padding}s" ""
        printf "${color}%s${NC}" "$text"
        printf "%${rest}s" ""
        printf "${CLR_GOLD}┃${NC}\n"
    }

    echo -e "${CLR_GOLD}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${NC}"
    center_text "HUGO WEBSITE MANAGER" "$CLR_CYAN"
    echo -e "${CLR_GOLD}┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫${NC}"
    center_text "vukilis" "$CLR_GOLD"
    center_text "https://vukilis.com" "$CLR_GOLD"
    center_text "https://github.com/vukilis" "$CLR_GOLD"
    echo -e "${CLR_GOLD}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${NC}"
}

# --- Logic ---

exists() {
    command -v "$1" >/dev/null 2>&1
}

check_dependencies() {
    if ! exists hugo; then
        echo -e "${CLR_RED}❌ Error: 'hugo' is not installed.${NC}"
        exit 1
    fi

    if [[ ! -f "config.toml" && ! -f "hugo.toml" && ! -f "hugo.yaml" ]]; then
        echo -e "${CLR_RED}❌ Error: No Hugo config found in $(pwd)${NC}"
        exit 1
    fi
}

sanitize() {
    echo "$1" | sed -e 's/[[:space:]]/-/g' -e 's/-/_/g' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_]//g'
}

create_post() {
    hr
    echo -e "${CLR_BLUE}❯ Creating New Post${NC} ${CLR_DIM}(Leave empty to go back)${NC}"
    
    read -e -p "  Subfolder: " sub
    [[ -z "$sub" ]] && return
    
    read -e -p "  Post Title: " title
    [[ -z "$title" ]] && return

    local clean_sub=$(sanitize "$sub")
    local clean_title=$(sanitize "$title")
    local file_path="content/posts/$clean_sub/$clean_title.md"
    
    if hugo new "posts/$clean_sub/$clean_title.md" > /dev/null 2>&1; then
        mkdir -p "static/images/$clean_sub/$clean_title"
        echo -e "\n${CLR_GREEN}✔ Created:${NC} $file_path"
        
        read -p "  Open in editor? (y/N): " open_edit
        if [[ $open_edit == [yY] ]]; then
            ${EDITOR:-nano} "$file_path"
        fi
    else
        echo -e "${CLR_RED}❌ Hugo failed to create the post.${NC}"
    fi
    hr
}

live_preview() {
    hr
    local ip=""

    if exists fzf; then
        echo -e "${CLR_BLUE}❯ Select Network Interface (fzf)${NC}"
        ip=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | fzf --height 10% --reverse --prompt="Select IP: ")
    else
        echo -e "${CLR_GOLD}❯ 'fzf' not found. Manual IP selection:${NC}"
        local ips=($(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}'))
        for i in "${!ips[@]}"; do
            echo -e "  ${CLR_GREEN}$((i+1)).${NC} ${ips[$i]}"
        done
        read -p "  Select number (default 1): " ip_choice
        ip_choice=${ip_choice:-1}
        ip=${ips[$((ip_choice-1))]}
    fi
    
    [[ -z "$ip" ]] && return

    echo -e "${CLR_GREEN}❯ Starting Server on http://$ip:1313...${NC}"
    hugo server --noHTTPCache --disableFastRender --bind "$ip" --baseURL "http://$ip" -D & 
    HUGO_PID=$!
    
    sleep 2
    if exists xdg-open; then xdg-open "http://$ip:1313" 2>/dev/null
    elif exists open; then open "http://$ip:1313" 2>/dev/null
    fi
    
    wait $HUGO_PID
    echo -e "\n${CLR_GOLD}❯ Server stopped.${NC}"
    hr
}

delete_post() {
    hr
    echo -e "${CLR_RED}❯ Delete Post${NC} ${CLR_DIM}(Leave empty to go back)${NC}"
    
    read -e -p "  Subfolder: " sub
    [[ -z "$sub" ]] && return
    
    read -e -p "  Post Title: " title
    [[ -z "$title" ]] && return
    
    local clean_sub=$(sanitize "$sub")
    local clean_title=$(sanitize "$title")
    local file="content/posts/$clean_sub/$clean_title.md"
    local img="static/images/$clean_sub/$clean_title"

    if [[ -f "$file" ]]; then
        echo -e "${CLR_GOLD}Target:${NC} $file"
        read -p "  Confirm delete? (y/N): " confirm
        if [[ $confirm == [yY] ]]; then
            rm "$file" && [ -d "$img" ] && rm -rf "$img"
            echo -e "${CLR_GREEN}✔ Deleted.${NC}"
        else
            echo -e "${CLR_DIM}Aborted.${NC}"
        fi
    else
        echo -e "${CLR_RED}❌ Post not found.${NC}"
    fi
    hr
}

# --- Main ---
check_dependencies

while true; do
    print_header
    echo -e "  ${CLR_GREEN}1.${NC} Create New Post"
    echo -e "  ${CLR_BLUE}2.${NC} Live Preview"
    echo -e "  ${CLR_RED}3.${NC} Delete Post"
    echo -e "  ${CLR_DIM}4. Exit${NC}"
    echo
    echo -ne "  ${CLR_GOLD}Selection: ${NC}"
    read choice

    case $choice in
        1) create_post ;;
        2) live_preview ;;
        3) delete_post ;;
        4) echo -e "${CLR_PINK}Goodbye!${NC}"; exit 0 ;;
        *) continue ;; # Just refresh on invalid input
    esac
    
    echo -e "${CLR_DIM}Press any key to return to menu...${NC}"
    read -n 1 -s -r
done