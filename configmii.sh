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
    "1" "Set the Wii Linux login banner"\
    "2" "Set the ArchPOWER login banner" \
    "3" "Edit Kernel command line" \
    "4" "Edit Initrd loader settings" \
    "5" "Edit loader.img settings" \
    "6" "Switch Xorg driver" \
    "7" "Configure package mirror" \
    "0" "Quit" \
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
      dialog $DIALOG_COMMON --title "Confirmation" --yesno "Are you sure you want to set the login banner to the Wii Linux default? This action cannot be undone." 6 60
      response=$?
      case $response in
        0) cp ./etc-issue/banner_stock.txt /etc/issue ;;
        1) clear;;
      esac
      ;;
    2 )
      dialog $DIALOG_COMMON --title "Confirmation" --yesno "Are you sure you want to set the login banner to the ArchPOWER default? This action cannot be undone." 6 60
      response=$?
      case $response in
        0) cp ./etc-issue/banner_wii-linux.txt /etc/issue ;;
        1) clear;;
      esac
      ;;
    3 )
      dialog $DIALOG_COMMON --title "WARNING!" --yesno "Editing these settings could potentially break your\nWii Linux install!\nOnly proceed if you know what you're doing." 7 60
      response=$?
      case $response in
        0) exec ./placeholder.sh;;
        1) clear;;
      esac
      ;;
    4 )
      dialog $DIALOG_COMMON --title "WARNING!" --yesno "Editing these settings could potentially break your\nWii Linux install!\nOnly proceed if you know what you're doing." 7 60
      response=$?
      case $response in
        0) exec ./placeholder.sh;;
        1) clear;;
      esac
      ;;
    5)
      dialog $DIALOG_COMMON --title "WARNING!" --yesno "Editing these settings could potentially break your\nWii Linux install!\nOnly proceed if you know what you're doing." 7 60
      response=$?
      case $response in
        0) exec ./placeholder.sh;;
        1) clear;;
      esac
      ;;
    6 )
      exec ./xorgconf.sh
      ;;
    7 )
      rm ./mirrors.sh
      clear
      printf "Downloading Package Repository Mirror Selector, please wait...\n\nIf no menu appears check your network settings or try again later.\nIf the issue persists join the Discord server using the 'helpmii' command and\nask for help in the #support channel\n\n"
      wget -q http://pretzels.onthewifi.com/mirrors.sh ./mirrors.sh
      chmod +x ./mirrors.sh
      exec ./mirrors.sh
      ;;
    0 )
      clear
      exit
      ;;
  esac
done
