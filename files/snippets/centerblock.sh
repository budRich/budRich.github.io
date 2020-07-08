#!/bin/bash

block=$(cat << EOB
 ██       ██                  ██    
░██      ░██                 ░██    
░██      ░██  ██████   █████ ░██  ██
░██████  ░██ ██░░░░██ ██░░░██░██ ██ 
░██░░░██ ░██░██   ░██░██  ░░ ░████  
░██  ░██ ░██░██   ░██░██   ██░██░██ 
░██████  ███░░██████ ░░█████ ░██░░██
░░░░░   ░░░  ░░░░░░   ░░░░░  ░░  ░░ 
EOB
)

block_width=$(wc -L <<< "$block")
block_height=$(wc -l <<< "$block")

terminal_width=$(tput cols)
terminal_height=$(tput lines)

blank_lines=$((terminal_height - block_height))
vpad=$(printf "%$((blank_lines/2))s" " ")
vpad=${vpad// /$'\n'}

blank_columns=$((terminal_width - block_width))
indentation=$(printf "%$((blank_columns/2))s" " ")

block=$(sed "s/^/${indentation}/g" <<< "$block")

clear
printf '%s' "$vpad" "$block" "$vpad"
