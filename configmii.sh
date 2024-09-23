#!/bin/bash

VERSION="v1.0"
DIALOG_COMMON="--no-mouse"
DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0

left_text="ConfigMii Wii Linux Configuration Program"
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
    "1" "Edit Kernel command line" \
    "2" "Edit Initrd loader settings" \
    "3" "Edit loader.img settings" \
    "4" "Switch Xorg driver" \
    "5" "Configure package mirror" \
    "6" "Quit" \
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
      dialog $DIALOG_COMMON --title "WARNING!" --yesno "Editing these settings could potentially break your Wii Linux install!\nOnly proceed if you know what you're doing." 12 60
      response=$?
      case $response in
        0) exec ./placeholder.sh;;
        1) clear;;
      esac
      ;;
    2 )
      dialog $DIALOG_COMMON --title "WARNING!" --yesno "Editing these settings could potentially break your Wii Linux install!\nOnly proceed if you know what you're doing." 12 60
      response=$?
      case $response in
        0) exec ./placeholder.sh;;
        1) clear;;
      esac
      ;;
    3 )
      dialog $DIALOG_COMMON --title "WARNING!" --yesno "Editing these settings could potentially break your Wii Linux install!\nOnly proceed if you know what you're doing." 12 60
      response=$?
      case $response in
        0) exec ./placeholder.sh;;
        1) clear;;
      esac
      ;;
    4 )
      exec ./xorgconf.sh
      ;;
    5 )
      rm Chooser.sh
      clear
      printf "Downloading Package Repository Mirror Selector, please wait...\n\nIf no menu appears check your network settingsor try again later.\nIf the issue persists join the Discord using the 'helpmii' command and\nask for help in the #support channel\n\n"
      wget -q https://files.thecheese.io/Mirrors%20for%20archpower-wii/Chooser.sh
      chmod +x Chooser.sh
      exec ./Chooser.sh
      ;;
    6 )
      clear
      exit
      ;;
  esac
done