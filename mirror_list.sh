#!/bin/bash

VERSION=""
DIALOG_COMMON="--no-mouse"
DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0

left_text="Repository Selection       Last updated: XX/XX/XXXX"
right_text="$VERSION"

text_len=$((${#left_text} + ${#right_text}))
# dialog has 2 blank chars on the left and right
padding_length=$((COLUMNS - text_len - 2))
padding=$(printf "%${padding_length}s")

BACKTITLE="$left_text$padding$right_text"
unset text_len padding_length padding left_text right_text



while true; do
  exec 3>&1
  selection=$(dialog $DIALOG_COMMON \
    --backtitle "$BACKTITLE" \
    --title "Main Menu" \
    --clear \
    --cancel-label "Cancel" \
    --menu "Select an option:" $HEIGHT $WIDTH 4 \
    "1" "(US) Official Wii Linux Repo [wii-linux.org]" \
    "2" "(EX) Billy's Repo Mirror [example.com]" \
    "3" "(EX) Bob's Repo Mirror [example_butcooler.com]" \
    "4" "Quit" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      exit
      ;;
    $DIALOG_ESC)
      clear
      exit 1
      ;;
  esac
  case $selection in
    1 )
      clear
      printf "Please insert cash or select payment type\nAhem, sorry, Insert repo changer code here\n"
      read -n 1 -s -r -p "Press any key to continue...";printf "\n"
      ;;
    2 )
      clear
      printf "Please insert cash or select payment type\nAhem, sorry, Insert repo changer code here\n"
      read -n 1 -s -r -p "Press any key to continue...";printf "\n"
      ;;
    3 )
      clear
      printf "Please insert cash or select payment type\nAhem, sorry, Insert repo changer code here\n"
      read -n 1 -s -r -p "Press any key to continue...";printf "\n"
      ;;
    4 )
      clear
      exit
      ;;
  esac
done
