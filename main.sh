#!/bin/bash

# Define colors
DFC='\e[38;2;229;181;102m'
DFC_BOLD='\e[38;2;237;165;47m'
PURPLE='\e[38;2;189;75;132m'
RED='\e[38;2;224;102;102m'
GREEN='\e[38;2;64;191;68m'
BOLD_GREEN='\033[1m\033[38;2;182;215;168m'
BLUE='\e[38;2;61;133;198m'
CYAN='\033[38;2;0;255;255m'
NC='\e[0m' # No color (reset)

# Define output
print_output() {
    local title="$1"
    local color="$2" 
    local total_width=76 
    
    local title_length=${#title}
    local dash_count=$(( (total_width - title_length - 2) / 2 ))  
    
    local dash_string=$(printf "%-${dash_count}s" "-" | tr ' ' '-')
    
    printf "${color}%s %s %s${NC}\n" "$dash_string" "$title" "$dash_string"
}

createPost(){
    print_output "CREATE POST" "$GREEN"
    dirName=$title
    titleConvert=$(echo $dirName | sed 's/-/_/g')
    
    if ! hugo new "posts/$subfolder/$title.md" 2>/dev/null; then
        echo -e "${RED}❌ Error: 'hugo' command not found or failed to create post!${DFC}"
        return 1
    fi
    
    if ! mkdir "static/images/$subfolder/$titleConvert"; then
        echo -e "${RED}❌ Failed to create directory: static/images/$year/$subfolder${DFC}"
        return 1
    fi
}

deletePost() {
    print_output "DELETE POST" "$RED"
    
    dirName=$title
    titleConvert=$(echo $dirName | sed 's/-/_/g')  # Convert hyphens to underscores for folder name

    if ! [ -f "content/posts/$subfolder/$title.md" ]; then
        echo -e "${RED}❌ Error: Post content/posts/$subfolder/$title.md does not exist!${DFC}"
        return 1
    fi

    if ! rm -rf "content/posts/$subfolder/$title.md"; then
        echo -e "${RED}❌ Error: Failed to delete post content/posts/$subfolder/$title.md!${DFC}"
        return 1  
    fi

    image_dir="static/images/$subfolder/$titleConvert"
    if ! [ -d "$image_dir" ]; then
        echo -e "${RED}❌ Error: Image directory $image_dir does not exist!${DFC}"
        return 1  
    fi

    if ! rm -rf "$image_dir"; then
        echo -e "${RED}❌ Error: Failed to delete image directory $image_dir!${DFC}"
        return 1  
    fi
}

print_output "MAIN MENU" "$PURPLE"

PS3="Choose your option: "
menu=("Create Post" "Delete Post")

select option in "${menu[@]}" "Quit"; do 
    case "$REPLY" in
    1) echo -e "${BOLD_GREEN}You chose $option${DFC_BOLD}" 
        read -p "Enter subfolder name: " subfolder 
        read -p "Enter post name: " title 
        createPost
        if [ $? -ne 0 ]; then
            echo -e "${RED}❌ Error: Failed to create post!${DFC}"
        else
            echo -e "${GREEN}✅ Post created successfully!${DFC}"
        fi
        REPLY=
        continue;;
    2) echo -e "${BOLD_GREEN}You chose $option${DFC_BOLD}" 
        read -p "Enter subfolder name: " subfolder 
        read -p "Enter post name: " title 
        deletePost
        if [ $? -ne 0 ]; then
            echo -e "${RED}❌ Error: Failed to delete post${DFC}"
        else
            echo -e "${GREEN}✅ Post deleted successfully${DFC}"
        fi
        REPLY=
        continue;;
    $((${#menu[@]}+1))) echo -e "${RED}Goodbye!"; break;;
    *) echo -e "${RED}- $REPLY is invalid option. Try another one. -${DFC}";;
    esac
    REPLY=
done