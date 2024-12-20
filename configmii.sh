#!/bin/bash

export VERSION="v1.2"

export left_text="ConfigMii Wii Linux Configuration Program"
export right_text="$VERSION"

if [ -f ../util-dialog.sh ]; then
	. ../util-dialog.sh
elif [ -f ../common-util-scripts/util-dialog.sh ]; then
	. ../common-util-scripts/util-dialog.sh
else
	echo "failed to load util-dialog.sh"
	exit 1
fi

while true; do
	menu "Main Menu" \
	"OK" "Cancel" \
	"Select an option:" \
	"1" "Login banner settings" \
	"2" "Boot settings" \
	"3" "ArchPOWER settings" \
	"4" "Xorg settings" \
	"5" "Install a DE" \
	"9" "About ConfigMii" \
	"0" "Quit"
	case $? in
		1) ./loginbanner.sh ;;
		2) ./boot-settings.sh ;;
		3) ./archpower-settings.sh ;;
		4) ./xorgconf.sh ;;
		5) ./de-installer.sh ;;
		9) info "About" "ConfigMii - The Wii Linux Configuration Program.\n\nConfigMii Version $VERSION\nUsing $UTIL_VER_STR\n\nConfigMii was made by Techflash, Tech64, and other contributors.\nThis program is licensed under the terms of the GNU General Public License, version 2.\nYou may find these terms under the ConfigMii install directory, under the LICENSE file." 15 70 ;;
		0|255)
			clear
			exit 0;;
	esac
done
