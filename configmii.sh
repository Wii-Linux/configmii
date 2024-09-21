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
    "5" "Install Secondary package mirror server (this can only run on archlinux not power)" \
    "6" "Configure which mirror to use for pacman" \
    "7" "Quit" \
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
      rm Mirror_Secondary.sh
      clear
      printf "Downloading Secondary mirror server installer, please wait...\n\nIf no menu appears and errors show up after this message,\nplease check your network configuration.\nIf problem persists please join the Wii Linux Discord\nusing the 'helpmii' command.\n\n"
      wget -q https://files.thecheese.io/Mirrors%20for%20archpower-wii/Mirror_Secondary.sh
      chmod +x Mirror_Secondary.sh
      exec ./Mirror_Secondary.sh
      ;;
    6 )
      rm Chooser.sh
      clear
      printf "Downloading Package Repo Mirror Selector, please wait...\n\nIf no menu appears check ur wifi or get a better wii/j try to restart the configmii.sh if the error persists join the Discord and ask for help\n\n"
      sudo su
      wget -q https://files.thecheese.io/Mirrors%20for%20archpower-wii/Chooser.sh
      chmod +x Chooser.sh
      exec ./Chooser.sh
    7 )
      clear
      exit
      ;;
  esac
done