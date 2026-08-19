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
    local width=68

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
    center_text "ASTRO WEBSITE MANAGER" "$CLR_CYAN"
    echo -e "${CLR_GOLD}┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫${NC}"
    center_text "vukilis" "$CLR_GOLD"
    center_text "https://vukilis.com" "$CLR_GOLD"
    center_text "https://github.com/vukilis" "$CLR_GOLD"
    echo -e "${CLR_GOLD}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${NC}"
}

# --- Helpers ---

sanitize() {
    echo "$1" | sed -e 's/[[:space:]]/-/g' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_-]//g'
}

slugify() {
    echo "$1" | sed -e 's/[[:space:]]/-/g' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]//g'
}

exists() {
    command -v "$1" >/dev/null 2>&1
}

now_iso() {
    date +"%Y-%m-%dT%H:%M:%S%:z"
}

# --- Create Functions ---

create_blog_post() {
    hr
    echo -e "${CLR_BLUE}❯ Creating New Blog Post${NC} ${CLR_DIM}(Leave empty to go back)${NC}"
    
    read -e -p "  Year (e.g. 2026): " year
    [[ -z "$year" ]] && return
    
    read -e -p "  Post Title: " title
    [[ -z "$title" ]] && return

    local clean_slug=$(slugify "$title")
    local file_path="src/content/blog/$year/$clean_slug.mdx"
    local now
    now=$(now_iso)
    
    mkdir -p "src/content/blog/$year"
    
    if [[ ! -f "$file_path" ]]; then
        cat > "$file_path" << EOF
---
title: "$title"
url: /$clean_slug
pubDate: $now
lastmod: $now
share:
  enable: true
  link: true
  twitter: true
  reddit: true

draft: false
license: "MIT"

tags: []
categories: []
description: ""
---

# 
EOF
        echo -e "\n${CLR_GREEN}✔ Created:${NC} $file_path"
        
        read -p "  Open in editor? (y/N): " open_edit
        if [[ $open_edit == [yY] ]]; then
            ${EDITOR:-nano} "$file_path"
        fi
    else
        echo -e "${CLR_RED}❌ Post already exists: $file_path${NC}"
    fi
    hr
}

create_it_project() {
    hr
    echo -e "${CLR_BLUE}❯ Creating New IT Project${NC} ${CLR_DIM}(Leave empty to go back)${NC}"
    
    read -e -p "  Project Title: " title
    [[ -z "$title" ]] && return

    local clean_slug=$(slugify "$title")
    local file_path="src/content/projects/it/$clean_slug.mdx"
    local now
    now=$(now_iso)
    
    mkdir -p "src/content/projects/it"
    
    if [[ ! -f "$file_path" ]]; then
        cat > "$file_path" << EOF
---
title: "$title"
description: ""
image: ""
github: ""
blog: ""
link: ""
tags: []
categories: []
featured: false
status: normal
draft: false
license: "MIT"
---

EOF
        echo -e "\n${CLR_GREEN}✔ Created:${NC} $file_path"
        
        read -p "  Open in editor? (y/N): " open_edit
        if [[ $open_edit == [yY] ]]; then
            ${EDITOR:-nano} "$file_path"
        fi
    else
        echo -e "${CLR_RED}❌ Project already exists: $file_path${NC}"
    fi
    hr
}

create_design_project() {
    hr
    echo -e "${CLR_BLUE}❯ Creating New Design Project${NC} ${CLR_DIM}(Leave empty to go back)${NC}"
    
    read -e -p "  Project Title: " title
    [[ -z "$title" ]] && return
    
    read -e -p "  Year (e.g. 2026): " year
    [[ -z "$year" ]] && return

    local clean_slug=$(slugify "$title")
    local file_path="src/content/projects/design/$clean_slug.mdx"
    local now
    now=$(now_iso)
    
    mkdir -p "src/content/projects/design"
    
    if [[ ! -f "$file_path" ]]; then
        cat > "$file_path" << EOF
---
cat: []
type: "WEBP"
year: $year
pubDate: $now
src: ""
id: ""
cover: ""
title: "$title"
draft: false
---

EOF
        echo -e "\n${CLR_GREEN}✔ Created:${NC} $file_path"
        
        read -p "  Open in editor? (y/N): " open_edit
        if [[ $open_edit == [yY] ]]; then
            ${EDITOR:-nano} "$file_path"
        fi
    else
        echo -e "${CLR_RED}❌ Project already exists: $file_path${NC}"
    fi
    hr
}

create_music_project() {
    hr
    echo -e "${CLR_BLUE}❯ Creating New Music Project${NC} ${CLR_DIM}(Leave empty to go back)${NC}"
    
    read -e -p "  Project Title: " title
    [[ -z "$title" ]] && return
    
    read -e -p "  Year (e.g. 2026): " year
    [[ -z "$year" ]] && return

    local clean_slug=$(slugify "$title")
    local file_path="src/content/projects/music/$clean_slug.mdx"
    local now
    now=$(now_iso)
    
    mkdir -p "src/content/projects/music"
    
    if [[ ! -f "$file_path" ]]; then
        cat > "$file_path" << EOF
---
cat: []
type: "VIDEO"
year: $year
pubDate: $now
id: ""
cover: ""
title: "$title"
description: ""
tags: []
duration: ""
lyrics: |
---

EOF
        echo -e "\n${CLR_GREEN}✔ Created:${NC} $file_path"
        
        read -p "  Open in editor? (y/N): " open_edit
        if [[ $open_edit == [yY] ]]; then
            ${EDITOR:-nano} "$file_path"
        fi
    else
        echo -e "${CLR_RED}❌ Project already exists: $file_path${NC}"
    fi
    hr
}

create_menu() {
    while true; do
        print_header
        echo -e "  ${CLR_GREEN}1.${NC} New Post"
        echo -e "  ${CLR_BLUE}2.${NC} New IT Project"
        echo -e "  ${CLR_PINK}3.${NC} New Design Project"
        echo -e "  ${CLR_CYAN}4.${NC} New Music Project"
        echo -e "  ${CLR_DIM}5. Back${NC}"
        echo
        echo -ne "  ${CLR_GOLD}Selection: ${NC}"
        read choice

        case $choice in
            1) create_blog_post ;;
            2) create_it_project ;;
            3) create_design_project ;;
            4) create_music_project ;;
            5) return ;;
            *) continue ;;
        esac
    done
}

live_preview() {
    hr
    echo -e "${CLR_GREEN}❯ Starting Dev Server on http://localhost:4321/"
    pnpm dev --host 0.0.0.0 &
    ASTRO_PID=$!
    
    sleep 3
    if exists xdg-open; then xdg-open "http://localhost:4321" 2>/dev/null
    elif exists open; then open "http://localhost:4321" 2>/dev/null
    fi
    
    wait $ASTRO_PID
    echo -e "\n${CLR_GOLD}❯ Server stopped.${NC}"
    hr
}

delete_post() {
    hr
    echo -e "${CLR_RED}❯ Delete Blog Post${NC} ${CLR_DIM}(Leave empty to go back)${NC}"
    
    read -e -p "  Year: " year
    [[ -z "$year" ]] && return
    
    read -e -p "  Post Slug or Title: " slug
    [[ -z "$slug" ]] && return
    
    local clean_slug=$(slugify "$slug")
    local file="src/content/blog/$year/$clean_slug.mdx"

    if [[ -f "$file" ]]; then
        echo -e "${CLR_GOLD}Target:${NC} $file"
        read -p "  Confirm delete? (y/N): " confirm
        if [[ $confirm == [yY] ]]; then
            rm "$file"
            echo -e "${CLR_GREEN}✔ Deleted.${NC}"
        else
            echo -e "${CLR_DIM}Aborted.${NC}"
        fi
    else
        echo -e "${CLR_RED}❌ Post not found.${NC}"
    fi
    hr
}

build_site() {
    hr
    echo -e "${CLR_BLUE}❯ Building Site${NC}"
    pnpm build
    echo -e "${CLR_GREEN}✔ Build complete.${NC}"
    
    read -p "  Preview build? (y/N): " preview_choice
    if [[ $preview_choice == [yY] ]]; then
        hr
        echo -e "${CLR_GREEN}❯ Starting Preview Server on http://localhost:4321/"
        pnpm preview --host 0.0.0.0 &
        PREVIEW_PID=$!
        
        sleep 2
        if exists xdg-open; then xdg-open "http://localhost:4321" 2>/dev/null
        elif exists open; then open "http://localhost:4321" 2>/dev/null
        fi
        
        wait $PREVIEW_PID
        echo -e "\n${CLR_GOLD}❯ Preview server stopped.${NC}"
    fi
    hr
}

# --- Main ---

while true; do
    print_header
    echo -e "  ${CLR_GREEN}1.${NC} Create..."
    echo -e "  ${CLR_BLUE}2.${NC} Live Preview"
    echo -e "  ${CLR_RED}3.${NC} Delete Post"
    echo -e "  ${CLR_CYAN}4.${NC} Build + Preview Site"
    echo -e "  ${CLR_DIM}5. Exit${NC}"
    echo
    echo -ne "  ${CLR_GOLD}Selection: ${NC}"
    read choice

    case $choice in
        1) create_menu ;;
        2) live_preview ;;
        3) delete_post ;;
        4) build_site ;;
        5) echo -e "${CLR_PINK}Goodbye!${NC}"; exit 0 ;;
        *) continue ;;
    esac
    
    echo -e "${CLR_DIM}Press any key to return to menu...${NC}"
    read -n 1 -s -r
done
