#!/bin/bash

main() {

  [[ -t 2  ]] \
    || ERX "this script must be executed in a terminal"

  [[ -f ${deckfile:=$*} ]] \
    || ERX "not a valid deck file: $*"
  
  _tw=$(tput cols)   # terminal width
  _th=$(tput lines)  # terminal height
  _fg="$(tput sgr0)" # default foreground

  _tmpdir=$(mktemp -d)
  mapfile -t slides <<< "$(formatfile "$deckfile")"
  
  while :; do for slide in "${slides[@]}"; do
    
    if [[ $slide =~ ^(@@(.+)@@[[:space:]]+)?(<[[:space:]]+)?(.+)$ ]]
    then

      page=""

      options=${BASH_REMATCH[2]:-}
      fromfile=${BASH_REMATCH[3]:-}
      text=${BASH_REMATCH[4]:-}
      
      [[ -n $fromfile ]] && [[ $text =~ ^~ ]] \
        && text="$HOME${text:1}"

      parse_options "$options"

      if [[ -z $fromfile ]]; then
        mapfile -d _ -t lines <<< "$text"
        for line in "${lines[@]}"; do
          block=$(figlet ${font:+-f ${font}} -w "$_tw" "$line")
          block=$(h_center "$block")
          page+=$(printf "\n%s" "$block")
        done

      elif [[ -f ${text} ]]; then
        page=$(< "$text")
        page=$(h_center "${page}")

      else
        continue
      fi
      
    fi

    if ((lolcat==1)); then
      v_center "$page" | lolcat -f
    else
      v_center "$page"
    fi
    
  done done | less -r
}

formatfile() {

  local file=$1
  
  awk -v tmpdir="$_tmpdir" '
    { skip = 0 }
    /^@@[^@]+@@\s*$/ || /_$/ {
      if (lastline ~ /@$/)
        lastline=lastline " "
      lastline=lastline $0 ; skip = 1
    }
    
    blockread {
      if (/^```$/) {
        $0 = "< " blockfile
        blockread = !blockread
      }
      else
        print >> blockfile
    }

    /^```$/ { 
      blockread = !blockread
      blockfile = tmpdir "/" i++ 
    }

    skip != 1 && /^[^#]/ && !/@@$/ && !blockread {
      
      if (lastline ~ /@$/)
        lastline=lastline " "

      print lastline $0
      lastline=""
      skip = 0
    }
  '  "$file"
}

parse_options() {

  local optstr="$1"

  foreground="$_fg"
  font=""
  lolcat=0

  [[ -n $optstr ]] && {
    mapfile -d : -t ao <<< "$optstr"
    for o in "${ao[@]}"; do
      k="${o%=*}" v="${o#*=}"
      case "$k" in
        c|color  ) foreground="$(tput setaf ${v})" ;;
        f|font   ) font="${v}"                     ;;
        l|lolcat ) lolcat=1                        ;;
        * ) continue                               ;;
      esac
    done
  }
}

h_center() {
  local block="$1"
  local block_width blank_columns indentation

  block_width=$(wc -L <<< "$block")

  blank_columns=$((_tw - block_width))
  indentation=$(printf "%$((blank_columns/2))s" " ")

  sed "s/^/${indentation}/g" <<< "$block"
}

v_center() {
  local block="$1"
  local block_height blank_lines vpad1 vpad2

  block_height=$(wc -l <<< "$block")

  blank_lines=$((_th - block_height))
  vpad1=$((blank_lines/2))
  vpad2=$((_th - (block_height + vpad1) ))

  vpad1=$(printf "%${vpad1}s" " ")
  vpad2=$(printf "%${vpad2}s" " ")

  vpad1=${vpad1// /$'\n'}
  vpad2=${vpad2// /$'\n'}

  printf '%s' \
    "$vpad1" "$foreground" "$block" "$foreground" "$vpad2"
}

set -E
trap '[ "$?" -ne 77 ] || exit 77' ERR

ERM(){

  local mode

  getopts xr mode
  case "$mode" in
    x ) urg=critical ; prefix='[ERROR]: '   ;;
    r ) urg=low      ; prefix='[WARNING]: ' ;;
    * ) urg=normal   ; mode=m ;;
  esac
  shift $((OPTIND-1))

  msg="${prefix}$*"

  if [[ -t 2 ]]; then
    echo "$msg" >&2
  else
    notify-send -u "$urg" "$msg"
  fi

  [[ $mode = x ]] && exit 77
}

ERX() { ERM -x "$*" ;}
ERR() { ERM -r "$*" ;}

function DEATH {
  rm -rf "$_tmpdir"
}

trap DEATH EXIT

main "$@"
