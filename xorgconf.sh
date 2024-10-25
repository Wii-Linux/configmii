#!/bin/bash

DIALOG_COMMON="--no-mouse"
DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0



while true; do
  exec 3>&1
  selection=$(dialog $DIALOG_COMMON \
    --title "Xorg Driver Selection" \
    --clear \
    --cancel-label "Cancel" \
    --menu "Please select your prefferred driver for X11" $HEIGHT $WIDTH 4 \
    "1" "fbdev (More compatible, no hardware acceleration)" \
    "2" "Flipper/Hollywood Driver (Less compatible, w/ hardware accel)" \
    "3" "Go back to ConfigMii" \
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
      exec ./placeholder.sh
      ;;
    2 )
      exec ./placeholder.sh
      ;;
    3 )
      exec ./configmii.sh
      ;;
  esac
done
