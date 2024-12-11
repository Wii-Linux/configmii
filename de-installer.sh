#!/bin/bash

if [ -f ../util-dialog.sh ]; then
	. ../util-dialog.sh
elif [ -f ../common-util-scripts/util-dialog.sh ]; then
	. ../common-util-scripts/util-dialog.sh
else
	echo "failed to load util-dialog.sh"
	exit 1
fi


while true; do
	menu "DE Installer" \
		"OK" "Cancel" \
		"Select an option:" \
		"1" "Install Xorg (no desktop)" \
		"2" "Install Xorg with icewm (reccommended)"
	case "$?" in
		1)
			script -c 'pacman -S xorg-server xorg-xinit xf86-video-fbdev; echo $? > /tmp/pacman-ret' /tmp/pacman-log.txt
			ret="$(cat /tmp/pacman-ret)"
			if [ "$ret" != "0" ]; then
				cat /tmp/pacman-log.txt | head -n -1 | tail -n +2 > ~/pacman-log.txt
				info "Error" "pacman exited with a non-zero status code ($ret)!\nAn error report has been saved to ~/pacman-log.txt.\nIf you need help, please contact support!" 9 60
			else
				info "Success" "Xorg installed succesfully!\nRemember to install a WM or DE and add it to .xinitrc." 6 30
			fi
			rm -f /tmp/pacman-{log.txt,ret} ;;

		2)
			script -c 'pacman -S xorg-server xorg-xinit xf86-video-fbdev icewm ttf-dejavu xterm; echo $? > /tmp/pacman-ret' /tmp/pacman-log.txt
			ret="$(cat /tmp/pacman-ret)"
			if [ "$ret" != "0" ]; then
				cat /tmp/pacman-log.txt | head -n -1 | tail -n +2 > ~/pacman-log.txt
				info "Error" "pacman exited with a non-zero status code ($ret)!\nAn error report has been saved to ~/pacman-log.txt.\nIf you need help, please contact support!" 9 60
			else
				printf "exec icewm" > ~/.xinitrc
				info "Success" "Xorg installed succesfully!\nTo start icewm, use the 'startx' command." 6 30
			fi
			rm -f /tmp/pacman-{log.txt,ret} ;;
		255)
			exit 0 ;;
	esac
done
