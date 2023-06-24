#!/bin/bash

createPost(){
    echo -e "\e[1;35m"
    echo "----------------------------------------------------------------------------"
    echo "---------------------------       CREATE POST      -------------------------"
    echo "----------------------------------------------------------------------------"

    dirName=$title
    titleConvert=$(echo $dirName | sed 's/-/_/g')
    hugo new posts/$subfolder/$title.md
    mkdir static/images/$subfolder/$titleConvert
    echo -e "\e[1;36m"
}

deletePost(){
    echo -e "\e[1;35m"
    echo "----------------------------------------------------------------------------"
    echo "---------------------------       DELETE POST      -------------------------"
    echo "----------------------------------------------------------------------------"

    dirName=$title
    titleConvert=$(echo $dirName | sed 's/-/_/g')
    rm -rf content/posts/$subfolder/$title.md
    rm -rf static/images/$subfolder/$titleConvert
    echo -e "\e[1;36m"
}

echo -ne "\e[1;35m
----------------------------------------------------------------------------
---------------------------       MAIN MENU      ---------------------------
----------------------------------------------------------------------------
\e[1;36m"

PS3="Choose your option: "
menu=("Create Post" "Delete Post")

select option in "${menu[@]}" "Quit"; do 
    case "$REPLY" in
    1) echo -e "\033[1;32mYou chose $option\n\033[1;36m" 
        read -p "Enter subfolder name: " subfolder 
        read -p "Enter post name: " title 
        createPost
        REPLY=
        continue;;
    2) echo -e "\033[1;32mYou chose $option\n\033[1;36m" 
        read -p "Enter subfolder name: " subfolder 
        read -p "Enter post name: " title 
        deletePost
        REPLY=
        continue;;
    $((${#menu[@]}+1))) echo -e "\033[1;31mGoodbye!"; break;;
    *) echo -e "\033[1;31m- $REPLY is invalid option. Try another one. -\033[1;36m";;
    esac
    REPLY=
done